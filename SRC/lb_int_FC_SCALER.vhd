-- ========================================================================
-- ****************************************************************************
-- Group:           LHCf
-- Model:           V1495 -  Multipurpose Programmable Trigger Unit
-- Device:          ALTERA EP1C4F400C6
-- Author:          Qidong ZHOU (Base on fireware edited by Carlo Tintori)
-- Date:            Nov 21th, 2014
-- ----------------------------------------------------------------------------
-- Module:          lb_int
-- Description:     Local Bus interface
-- ****************************************************************************

-- NOTE: this is just an example of interface between the user FPGA and the
-- local bus on the V1495. In this example, there are 5 registers called REG_R1,
-- REG_R2, REG_R3, REG_R4 and REG_R5 that can be only read and there are 5 registers 
-- called REG_RW1, REG_RW2, REG_RW3, REG_RW4 and REG_RW5 that can be written and 
-- read from the VME (through the local bus). The registers are 32 bit wide and can
-- be accessed in single mode.
-- There is also a FIFO for the data readout; this is also 32 bit wide and can
-- be read in either single D32 read or Block Transfer Read.

library ieee;
use IEEE.Std_Logic_1164.all;
use IEEE.Std_Logic_arith.all;
use IEEE.Std_Logic_unsigned.all;
use work.components.all;

ENTITY LB_INT_FC_SCALER is
	port(
		-- Local Bus in/out signals
		nLBRES     : in   	std_logic;
		nBLAST     : in   	std_logic;
		WnR        : in   	std_logic;
		nADS       : in   	std_logic;
		LCLK       : in   	std_logic;
		nREADY     : out 	 	std_logic;
		nINT       : out	   std_logic;
		LAD        : inout   std_logic_vector(15 DOWNTO 0);
		
		-- Write/Read signals
		REG_DL1T_DL3T_P           : buffer std_logic_vector(31 downto 0);
		REG_TESTOUT1_MASK         : buffer std_logic_vector(31 downto 0);
		REG_TESTOUT2_MASK         : buffer std_logic_vector(31 downto 0); 
		VERSION                   : in std_logic_vector(31 downto 0)
	);

END LB_INT_FC_SCALER ;


ARCHITECTURE rtl of LB_INT_FC_SCALER is

	-- States of the finite state machine
	type   LBSTATE_type is (LBIDLE, LBWRITEL, LBWRITEH, LBREADL, LBREADH);
	signal LBSTATE   : LBSTATE_type;
	
	-- Output Enable of the LAD bus (from User to Vme)
	signal LADoe     : std_logic;
	-- Data Output to the local bus
	signal LADout    : std_logic_vector(15 downto 0);
	-- Lower 16 bits of the 32 bit data
	signal DTL       : std_logic_vector(15 downto 0);
	-- Address latched from the LAD bus
	signal ADDR      : std_logic_vector(15 downto 0);	
	signal SUB_nREADY: std_logic :='0';
	
begin
	nREADY   <= SUB_nREADY;
	LAD	                        <= LADout when LADoe = '1' else (others => 'Z');
  -- Local bus FSM
  process(LCLK, nLBRES)
		variable rreg, wreg   : std_logic_vector(31 downto 0);
  begin
    if (nLBRES = '0') then
      SUB_nREADY      <= '1';
      LADoe       <= '0';
      ADDR        <= (others => '0');
      DTL         <= (others => '0');
      LADout      <= (others => '0');
      rreg        := (others => '0');
      wreg        := (others => '0');
      LBSTATE     <= LBIDLE;
    elsif rising_edge(LCLK) then
      
--      REG_RW3(5) <= '0'; -- generate the software clear pulse

      case LBSTATE is
      
        when LBIDLE  =>  
          LADoe   <= '0';
			 SUB_nREADY  <= '1';
          if (nADS = '0') then        -- start cycle
            ADDR <= LAD;              -- Address Sampling
				

            if (WnR = '1') then       -- Write Access to the registers
              SUB_nREADY   <= '0';
              LBSTATE  <= LBWRITEL;     
            else                      -- Read Access to the registers
              SUB_nREADY    <= '1';
              LBSTATE   <= LBREADL;
            end if;
          end if;

        when LBWRITEL => 
			 
          DTL <= LAD;  -- Save the lower 16 bits of the data
			 
          if (nBLAST = '0') then
            LBSTATE  <= LBIDLE;
            SUB_nREADY   <= '1';
          else
            LBSTATE  <= LBWRITEH;
          end if;


        when LBWRITEH =>  
          wreg  := LAD & DTL;  -- Get the higher 16 bits and create the 32 bit data
          case ADDR is
				   ------  WRITE -------
					when ADD_REG_DL1T_DL3T_P            => REG_DL1T_DL3T_P           <= wreg;
					when ADD_REG_TESTOUT1_MASK        	=> REG_TESTOUT1_MASK         <= wreg;
					when ADD_REG_TESTOUT2_MASK        	=> REG_TESTOUT2_MASK         <= wreg;

            when others          => null;
          end case;
          SUB_nREADY   <= '1';
          LBSTATE  <= LBIDLE;
			 			 
        when LBREADL =>  
          SUB_nREADY    <= '0';  -- Assuming that the register is ready for reading
          case ADDR is
				   ------  READ -------
					when ADD_REG_LOGIC_VERSION          => rreg := VERSION;
					when ADD_REG_DL1T_DL3T_P            => rreg := REG_DL1T_DL3T_P;
					when ADD_REG_TESTOUT1_MASK          => rreg := REG_TESTOUT1_MASK;
					when ADD_REG_TESTOUT2_MASK          => rreg := REG_TESTOUT2_MASK;	

            when others          => null;
          end case;
          LBSTATE  <= LBREADH;
          LADout <= rreg(15 downto 0);    -- Save the lower 16 bits of the data
          LADoe  <= '1';                  -- Enable the output on the Local Bus
          
        when LBREADH =>  
          LADout  <= rreg(31 downto 16);  -- Put the higher 16 bits
          LBSTATE <= LBIDLE;
     
		 end case;

    end if;

	
  end process;
    
END rtl;

