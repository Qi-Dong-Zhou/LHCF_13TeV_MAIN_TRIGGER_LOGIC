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

ENTITY LB_INT is
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

		-- Internal Registers
		-- PLUSE GENERATE BY VME ACCESS (use NOT)
		A1_LATCH_STOP_INTERNAL1   : out 	 	std_logic;
		PRESET_CLEAR              : out 	 	std_logic;
		ECR_INTERNAL1             : out 	 	std_logic;
		A1_COUNTER_LATCH_INTERNAL1: out 	 	std_logic;
		--
		A2_LATCH_STOP_INTERNAL1   : out 	 	std_logic;
		A2_COUNTER_LATCH_INTERNAL1: out 	 	std_logic;
		
		-- Write/Read signals

		REG_A1_L1T_MASK           : buffer std_logic_vector(31 downto 0);
		REG_A1_SHOWER_MASK        : buffer std_logic_vector(31 downto 0);
		REG_A1_FC_MASK            : buffer std_logic_vector(31 downto 0);
		REG_A1_L3T_MASK           : buffer std_logic_vector(31 downto 0);
		REG_A1_SHOWER_P           : buffer std_logic_vector(31 downto 0);
		REG_A1_LATCH_STOP_P       : buffer std_logic_vector(31 downto 0);
		REG_A1_SELFVETO_P         : buffer std_logic_vector(31 downto 0);
		REG_A1_L2T_L1T_P          : buffer std_logic_vector(31 downto 0);
		
		REG_A2_L1T_MASK           : buffer std_logic_vector(31 downto 0);
		REG_A2_SHOWER_MASK        : buffer std_logic_vector(31 downto 0);
		REG_A2_FC_MASK            : buffer std_logic_vector(31 downto 0);
		REG_A2_L3T_MASK           : buffer std_logic_vector(31 downto 0);
		REG_A2_SHOWER_P           : buffer std_logic_vector(31 downto 0);
		REG_A2_LATCH_STOP_P       : buffer std_logic_vector(31 downto 0);
		REG_A2_SELFVETO_P         : buffer std_logic_vector(31 downto 0);
		REG_A2_L2T_L1T_P          : buffer std_logic_vector(31 downto 0);
		
		REG_SEL_ECR               : buffer std_logic_vector(31 downto 0);
		REG_COMMON_MASK           : buffer std_logic_vector(31 downto 0);
		REG_ATLAS_MASK            : buffer std_logic_vector(31 downto 0);
		REG_DL1T_DL3T_P           : buffer std_logic_vector(31 downto 0);
		REG_ATLAS_P               : buffer std_logic_vector(31 downto 0);
		REG_LASER_PEDE_P          : buffer std_logic_vector(31 downto 0);
		REG_LASER_GEN_P           : buffer std_logic_vector(31 downto 0);
		REG_LASER_GEN_ENABLE      : buffer std_logic_vector(31 downto 0);
		
		REG_TESTOUT1_MASK         : buffer std_logic_vector(31 downto 0);
		REG_TESTOUT2_MASK         : buffer std_logic_vector(31 downto 0); 
		REG_TESTOUT3_MASK         : buffer std_logic_vector(31 downto 0);
		REG_TESTOUT4_MASK         : buffer std_logic_vector(31 downto 0);

		-- Read only signals
		A1_COUNT_00               : in std_logic_vector(31 downto 0);
		A1_COUNT_01               : in std_logic_vector(31 downto 0);
		A1_COUNT_02               : in std_logic_vector(31 downto 0);
		A1_COUNT_03               : in std_logic_vector(31 downto 0);
		A1_COUNT_04               : in std_logic_vector(31 downto 0);
		A1_COUNT_05               : in std_logic_vector(31 downto 0);
		A1_COUNT_06               : in std_logic_vector(31 downto 0);
		A1_COUNT_07               : in std_logic_vector(31 downto 0);
		A1_COUNT_08               : in std_logic_vector(31 downto 0);
		A1_COUNT_09               : in std_logic_vector(31 downto 0);
		A1_COUNT_10               : in std_logic_vector(31 downto 0);
		A1_COUNT_11               : in std_logic_vector(31 downto 0);
		A1_COUNT_12               : in std_logic_vector(31 downto 0);
		A1_COUNT_13               : in std_logic_vector(31 downto 0);
		A1_COUNT_14               : in std_logic_vector(31 downto 0);
		A1_COUNT_15               : in std_logic_vector(31 downto 0);
		A1_COUNT_16               : in std_logic_vector(31 downto 0);
		A1_COUNT_17               : in std_logic_vector(31 downto 0);
		A1_COUNT_18               : in std_logic_vector(31 downto 0);
		A1_COUNT_19               : in std_logic_vector(31 downto 0);
		A1_COUNT_20               : in std_logic_vector(31 downto 0);
		A1_COUNT_21               : in std_logic_vector(31 downto 0);
		A1_COUNT_22               : in std_logic_vector(31 downto 0);
		A1_COUNT_23               : in std_logic_vector(31 downto 0);
		A1_COUNT_24               : in std_logic_vector(31 downto 0);
		A1_COUNT_25               : in std_logic_vector(31 downto 0);
		A1_COUNT_26               : in std_logic_vector(31 downto 0);
		A1_COUNT_27               : in std_logic_vector(31 downto 0);
		A1_COUNT_28               : in std_logic_vector(31 downto 0);
		A1_COUNT_29               : in std_logic_vector(31 downto 0);
		A1_COUNT_30               : in std_logic_vector(31 downto 0);
		A1_COUNT_31               : in std_logic_vector(31 downto 0);
		A1_COUNT_32               : in std_logic_vector(31 downto 0);
		A1_COUNT_33               : in std_logic_vector(31 downto 0);
		A1_COUNT_34               : in std_logic_vector(31 downto 0);
	-------------
		A2_COUNT_00               : in std_logic_vector(31 downto 0);
		A2_COUNT_01               : in std_logic_vector(31 downto 0);
		A2_COUNT_02               : in std_logic_vector(31 downto 0);
		A2_COUNT_03               : in std_logic_vector(31 downto 0);
		A2_COUNT_04               : in std_logic_vector(31 downto 0);
		A2_COUNT_05               : in std_logic_vector(31 downto 0);
		A2_COUNT_06               : in std_logic_vector(31 downto 0);
		A2_COUNT_07               : in std_logic_vector(31 downto 0);
		A2_COUNT_08               : in std_logic_vector(31 downto 0);
		A2_COUNT_09               : in std_logic_vector(31 downto 0);
		A2_COUNT_10               : in std_logic_vector(31 downto 0);
		A2_COUNT_11               : in std_logic_vector(31 downto 0);
		A2_COUNT_12               : in std_logic_vector(31 downto 0);
		A2_COUNT_13               : in std_logic_vector(31 downto 0);
		A2_COUNT_14               : in std_logic_vector(31 downto 0);
		A2_COUNT_15               : in std_logic_vector(31 downto 0);
		A2_COUNT_16               : in std_logic_vector(31 downto 0);
		A2_COUNT_17               : in std_logic_vector(31 downto 0);
		A2_COUNT_18               : in std_logic_vector(31 downto 0);
		A2_COUNT_19               : in std_logic_vector(31 downto 0);
		A2_COUNT_20               : in std_logic_vector(31 downto 0);
		A2_COUNT_21               : in std_logic_vector(31 downto 0);
		A2_COUNT_22               : in std_logic_vector(31 downto 0);
		A2_COUNT_23               : in std_logic_vector(31 downto 0);
		A2_COUNT_24               : in std_logic_vector(31 downto 0);
		A2_COUNT_25               : in std_logic_vector(31 downto 0);
		A2_COUNT_26               : in std_logic_vector(31 downto 0);
		A2_COUNT_27               : in std_logic_vector(31 downto 0);
		A2_COUNT_28               : in std_logic_vector(31 downto 0);
		A2_COUNT_29               : in std_logic_vector(31 downto 0);
		A2_COUNT_30               : in std_logic_vector(31 downto 0);
		A2_COUNT_31               : in std_logic_vector(31 downto 0);
		A2_COUNT_32               : in std_logic_vector(31 downto 0);
		A2_COUNT_33               : in std_logic_vector(31 downto 0);
		A2_COUNT_34               : in std_logic_vector(31 downto 0);
		REG_EVENT_FLAGS1          : in std_logic_vector(31 downto 0);
		REG_EVENT_FLAGS2          : in std_logic_vector(31 downto 0);
		REG_STATUS                : in std_logic_vector(31 downto 0);
		VERSION                   : in std_logic_vector(31 downto 0);
		
		-- FOR RAM_COUNTERS
		RC_COUNTS1						: in std_logic_vector(31 downto 0);
		RC_COUNTS2						: in std_logic_vector(31 downto 0);		
		RC_COUNTS3						: in std_logic_vector(31 downto 0);		
		RC_COUNTS4						: in std_logic_vector(31 downto 0);	
		RC_READ_RESET					: out std_logic;
		RC_READ_INC1					: out std_logic;
		RC_READ_INC2					: out std_logic;
		RC_READ_INC3					: out std_logic;
		RC_READ_INC4					: out std_logic		
	);

END LB_INT ;


ARCHITECTURE rtl of LB_INT is

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
	signal A1_LATCH_STOP_INTERNAL           : std_logic :='0';
	signal PRESET_CLEAR1                    : std_logic :='0';
	signal ECR_INTERNAL                     : std_logic :='0';
	signal A1_COUNTER_LATCH_INTERNAL        : std_logic :='0';
	--	
	signal A2_LATCH_STOP_INTERNAL           : std_logic :='0';
	signal A2_COUNTER_LATCH_INTERNAL        : std_logic :='0';
	signal SUB_nREADY                       : std_logic :='0';
	
begin
	nREADY   <= SUB_nREADY;
	LAD	                        <= LADout when LADoe = '1' else (others => 'Z');
	A1_LATCH_STOP_INTERNAL1       <= A1_LATCH_STOP_INTERNAL;
	A1_COUNTER_LATCH_INTERNAL1    <= A1_COUNTER_LATCH_INTERNAL;
	ECR_INTERNAL1                 <= ECR_INTERNAL;
	PRESET_CLEAR                  <= PRESET_CLEAR1;
	--
	A2_LATCH_STOP_INTERNAL1       <= A2_LATCH_STOP_INTERNAL;
	A2_COUNTER_LATCH_INTERNAL1    <= A2_COUNTER_LATCH_INTERNAL;
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
				   ----------------------------------------------------

					when ADD_REG_A1_L1T_MASK            => REG_A1_L1T_MASK           <= wreg;
					when ADD_REG_A1_SHOWER_MASK         => REG_A1_SHOWER_MASK        <= wreg;
					when ADD_REG_A1_FC_MASK             => REG_A1_FC_MASK            <= wreg;
					when ADD_REG_A1_L3T_MASK            => REG_A1_L3T_MASK           <= wreg;
					when ADD_REG_A1_SHOWER_P            => REG_A1_SHOWER_P           <= wreg;
					when ADD_REG_A1_L2T_L1T_P           => REG_A1_L2T_L1T_P          <= wreg;
					when ADD_REG_A1_SELFVETO_P          => REG_A1_SELFVETO_P         <= wreg;
					when ADD_REG_A1_LATCH_STOP_P        => REG_A1_LATCH_STOP_P       <= wreg;

					when ADD_REG_A2_L1T_MASK            => REG_A2_L1T_MASK           <= wreg;
					when ADD_REG_A2_SHOWER_MASK         => REG_A2_SHOWER_MASK        <= wreg;
					when ADD_REG_A2_FC_MASK             => REG_A2_FC_MASK            <= wreg;
					when ADD_REG_A2_L3T_MASK            => REG_A2_L3T_MASK           <= wreg;
					when ADD_REG_A2_SHOWER_P            => REG_A2_SHOWER_P           <= wreg;
					when ADD_REG_A2_L2T_L1T_P           => REG_A2_L2T_L1T_P          <= wreg;
					when ADD_REG_A2_SELFVETO_P          => REG_A2_SELFVETO_P         <= wreg;
					when ADD_REG_A2_LATCH_STOP_P        => REG_A2_LATCH_STOP_P       <= wreg;

					when ADD_REG_SEL_ECR                => REG_SEL_ECR               <= wreg;					
					when ADD_REG_COMMON_MASK            => REG_COMMON_MASK           <= wreg;
					when ADD_REG_ATLAS_MASK             => REG_ATLAS_MASK            <= wreg;
					when ADD_REG_DL1T_DL3T_P            => REG_DL1T_DL3T_P           <= wreg;
					when ADD_REG_ATLAS_P                => REG_ATLAS_P               <= wreg;
					when ADD_REG_LASER_PEDE_P           => REG_LASER_PEDE_P          <= wreg;
					when ADD_REG_LASER_GEN_P            => REG_LASER_GEN_P           <= wreg;
					when ADD_REG_LASER_GEN_ENABLE       => REG_LASER_GEN_ENABLE      <= wreg;
					
					when ADD_REG_TESTOUT1_MASK        	=> REG_TESTOUT1_MASK         <= wreg;
					when ADD_REG_TESTOUT2_MASK        	=> REG_TESTOUT2_MASK         <= wreg;
					when ADD_REG_TESTOUT3_MASK        	=> REG_TESTOUT3_MASK         <= wreg;
					when ADD_REG_TESTOUT4_MASK        	=> REG_TESTOUT4_MASK         <= wreg;
            when others          => null;
          end case;
          SUB_nREADY   <= '1';
          LBSTATE  <= LBIDLE;
			 			 
        when LBREADL =>  
          SUB_nREADY    <= '0';  -- Assuming that the register is ready for reading
          case ADDR is
					----------------------------------------------------

					when ADD_REG_A1_L1T_MASK            => rreg := REG_A1_L1T_MASK;
					when ADD_REG_A1_SHOWER_MASK         => rreg := REG_A1_SHOWER_MASK;
					when ADD_REG_A1_FC_MASK             => rreg := REG_A1_FC_MASK;
					when ADD_REG_A1_L3T_MASK            => rreg := REG_A1_L3T_MASK;
					when ADD_REG_A1_SHOWER_P            => rreg := REG_A1_SHOWER_P;
					when ADD_REG_A1_L2T_L1T_P           => rreg := REG_A1_L2T_L1T_P;
					when ADD_REG_A1_SELFVETO_P          => rreg := REG_A1_SELFVETO_P;
					when ADD_REG_A1_LATCH_STOP_P        => rreg := REG_A1_LATCH_STOP_P;

					when ADD_REG_A2_L1T_MASK            => rreg := REG_A2_L1T_MASK;
					when ADD_REG_A2_SHOWER_MASK         => rreg := REG_A2_SHOWER_MASK;
					when ADD_REG_A2_FC_MASK             => rreg := REG_A2_FC_MASK;
					when ADD_REG_A2_L3T_MASK            => rreg := REG_A2_L3T_MASK;
					when ADD_REG_A2_SHOWER_P            => rreg := REG_A2_SHOWER_P;
					when ADD_REG_A2_L2T_L1T_P           => rreg := REG_A2_L2T_L1T_P;
					when ADD_REG_A2_SELFVETO_P          => rreg := REG_A2_SELFVETO_P;
					when ADD_REG_A2_LATCH_STOP_P        => rreg := REG_A2_LATCH_STOP_P;
					
					when ADD_REG_SEL_ECR                => rreg := REG_SEL_ECR;
					when ADD_REG_COMMON_MASK            => rreg := REG_COMMON_MASK;
					when ADD_REG_ATLAS_MASK             => rreg := REG_ATLAS_MASK;
					when ADD_REG_DL1T_DL3T_P            => rreg := REG_DL1T_DL3T_P;
					when ADD_REG_ATLAS_P                => rreg := REG_ATLAS_P;
					when ADD_REG_LASER_PEDE_P           => rreg := REG_LASER_PEDE_P;
					when ADD_REG_LASER_GEN_P            => rreg := REG_LASER_GEN_P;
					when ADD_REG_LASER_GEN_ENABLE       => rreg := REG_LASER_GEN_ENABLE;
					
					when ADD_REG_TESTOUT1_MASK          => rreg := REG_TESTOUT1_MASK;
					when ADD_REG_TESTOUT2_MASK          => rreg := REG_TESTOUT2_MASK;	
					when ADD_REG_TESTOUT3_MASK          => rreg := REG_TESTOUT3_MASK;
					when ADD_REG_TESTOUT4_MASK          => rreg := REG_TESTOUT4_MASK;
					when ADD_REG_STATUS                 => rreg := REG_STATUS;
					when ADD_A1_COUNT_00                => rreg := A1_COUNT_00;
					when ADD_A1_COUNT_01                => rreg := A1_COUNT_01;
					when ADD_A1_COUNT_02                => rreg := A1_COUNT_02;
					when ADD_A1_COUNT_03                => rreg := A1_COUNT_03;
					when ADD_A1_COUNT_04                => rreg := A1_COUNT_04;
					when ADD_A1_COUNT_05                => rreg := A1_COUNT_05;
					when ADD_A1_COUNT_06                => rreg := A1_COUNT_06;
					when ADD_A1_COUNT_07                => rreg := A1_COUNT_07;
					when ADD_A1_COUNT_08                => rreg := A1_COUNT_08;
					when ADD_A1_COUNT_09                => rreg := A1_COUNT_09;
					when ADD_A1_COUNT_10                => rreg := A1_COUNT_10;
					when ADD_A1_COUNT_11                => rreg := A1_COUNT_11;
					when ADD_A1_COUNT_12                => rreg := A1_COUNT_12;
					when ADD_A1_COUNT_13                => rreg := A1_COUNT_13;
					when ADD_A1_COUNT_14                => rreg := A1_COUNT_14;
					when ADD_A1_COUNT_15                => rreg := A1_COUNT_15;
					when ADD_A1_COUNT_16                => rreg := A1_COUNT_16;
					when ADD_A1_COUNT_17                => rreg := A1_COUNT_17;
					when ADD_A1_COUNT_18                => rreg := A1_COUNT_18;
					when ADD_A1_COUNT_19                => rreg := A1_COUNT_19;
					when ADD_A1_COUNT_20                => rreg := A1_COUNT_20;
					when ADD_A1_COUNT_21                => rreg := A1_COUNT_21;
					when ADD_A1_COUNT_22                => rreg := A1_COUNT_22;
					when ADD_A1_COUNT_23                => rreg := A1_COUNT_23;
					when ADD_A1_COUNT_24                => rreg := A1_COUNT_24;
					when ADD_A1_COUNT_25                => rreg := A1_COUNT_25;
					when ADD_A1_COUNT_26                => rreg := A1_COUNT_26;
					when ADD_A1_COUNT_27                => rreg := A1_COUNT_27;
					when ADD_A1_COUNT_28                => rreg := A1_COUNT_28;
					when ADD_A1_COUNT_29                => rreg := A1_COUNT_29;
					when ADD_A1_COUNT_30                => rreg := A1_COUNT_30;
					when ADD_A1_COUNT_31                => rreg := A1_COUNT_31;
					when ADD_A1_COUNT_32                => rreg := A1_COUNT_32;
					when ADD_A1_COUNT_33                => rreg := A1_COUNT_33;
					when ADD_A1_COUNT_34                => rreg := A1_COUNT_34;
					--------
					when ADD_A2_COUNT_00                => rreg := A2_COUNT_00;
					when ADD_A2_COUNT_01                => rreg := A2_COUNT_01;
					when ADD_A2_COUNT_02                => rreg := A2_COUNT_02;
					when ADD_A2_COUNT_03                => rreg := A2_COUNT_03;
					when ADD_A2_COUNT_04                => rreg := A2_COUNT_04;
					when ADD_A2_COUNT_05                => rreg := A2_COUNT_05;
					when ADD_A2_COUNT_06                => rreg := A2_COUNT_06;
					when ADD_A2_COUNT_07                => rreg := A2_COUNT_07;
					when ADD_A2_COUNT_08                => rreg := A2_COUNT_08;
					when ADD_A2_COUNT_09                => rreg := A2_COUNT_09;
					when ADD_A2_COUNT_10                => rreg := A2_COUNT_10;
					when ADD_A2_COUNT_11                => rreg := A2_COUNT_11;
					when ADD_A2_COUNT_12                => rreg := A2_COUNT_12;
					when ADD_A2_COUNT_13                => rreg := A2_COUNT_13;
					when ADD_A2_COUNT_14                => rreg := A2_COUNT_14;
					when ADD_A2_COUNT_15                => rreg := A2_COUNT_15;
					when ADD_A2_COUNT_16                => rreg := A2_COUNT_16;
					when ADD_A2_COUNT_17                => rreg := A2_COUNT_17;
					when ADD_A2_COUNT_18                => rreg := A2_COUNT_18;
					when ADD_A2_COUNT_19                => rreg := A2_COUNT_19;
					when ADD_A2_COUNT_20                => rreg := A2_COUNT_20;
					when ADD_A2_COUNT_21                => rreg := A2_COUNT_21;
					when ADD_A2_COUNT_22                => rreg := A2_COUNT_22;
					when ADD_A2_COUNT_23                => rreg := A2_COUNT_23;
					when ADD_A2_COUNT_24                => rreg := A2_COUNT_24;
					when ADD_A2_COUNT_25                => rreg := A2_COUNT_25;
					when ADD_A2_COUNT_26                => rreg := A2_COUNT_26;
					when ADD_A2_COUNT_27                => rreg := A2_COUNT_27;
					when ADD_A2_COUNT_28                => rreg := A2_COUNT_28;
					when ADD_A2_COUNT_29                => rreg := A2_COUNT_29;
					when ADD_A2_COUNT_30                => rreg := A2_COUNT_30;
					when ADD_A2_COUNT_31                => rreg := A2_COUNT_31;
					when ADD_A2_COUNT_32                => rreg := A2_COUNT_32;
					when ADD_A2_COUNT_33                => rreg := A2_COUNT_33;
					when ADD_A2_COUNT_34                => rreg := A2_COUNT_34;
					when ADD_REG_LOGIC_VERSION          => rreg := VERSION;
					---- FOR RAM_COUNTER
					when ADD_RC_COUNTS1						=> rreg := RC_COUNTS1;
					when ADD_RC_COUNTS2						=> rreg := RC_COUNTS2;
					when ADD_RC_COUNTS3						=> rreg := RC_COUNTS3;
					when ADD_RC_COUNTS4						=> rreg := RC_COUNTS4;
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
	---------- Generate 1 CLOCK CLEAR PULSE ---------------- 
	if(ADDR = ADD_A1_LATCH_STOP_INTERNAL and WnR = '1') then
	  A1_LATCH_STOP_INTERNAL      <= not SUB_nREADY;
   else
	  A1_LATCH_STOP_INTERNAL      <= '0';
   end if;
	
	if(ADDR = ADD_PRESET_CLEAR and WnR = '1') then
	  PRESET_CLEAR1               <= not SUB_nREADY;
   else
	  PRESET_CLEAR1               <= '0';
   end if;
	
	if(ADDR = ADD_ECR_L_INTERNAL and WnR = '1') then
	  ECR_INTERNAL             <= not SUB_nREADY;
   else
	  ECR_INTERNAL             <= '0';
   end if;
	
	if(ADDR = ADD_COUNTER_LATCH_INTERNAL and WnR = '1') then
	  A1_COUNTER_LATCH_INTERNAL    <= not SUB_nREADY;
   else
	  A1_COUNTER_LATCH_INTERNAL    <= '0';
   end if;
	--************
	if(ADDR = ADD_A2_LATCH_STOP_INTERNAL and WnR = '1') then
	  A2_LATCH_STOP_INTERNAL      <= not SUB_nREADY;
   else
	  A2_LATCH_STOP_INTERNAL      <= '0';
   end if;
	
	if(ADDR = ADD_COUNTER_LATCH_INTERNAL and WnR = '1') then
	  A2_COUNTER_LATCH_INTERNAL    <= not SUB_nREADY;
   else
	  A2_COUNTER_LATCH_INTERNAL    <= '0';
   end if;
	
	----------------
	--- FOR RAM_COUNTER
	if(ADDR = ADD_RC_READ_RESET and WnR = '1') then
		RC_READ_RESET  <= not SUB_nREADY;
   else
	   RC_READ_RESET  <= '0';
   end if;	
	
	if(ADDR = ADD_RC_COUNTS1 and WnR = '0') then
		RC_READ_INC1  <= not SUB_nREADY;
   else
	   RC_READ_INC1  <= '0';
   end if;
	
	if(ADDR = ADD_RC_COUNTS2 and WnR = '0') then
		RC_READ_INC2  <= not SUB_nREADY;
   else
	   RC_READ_INC2  <= '0';
   end if;
	
	if(ADDR = ADD_RC_COUNTS3 and WnR = '0') then
		RC_READ_INC3  <= not SUB_nREADY;
   else
	   RC_READ_INC3  <= '0';
   end if;
	
	if(ADDR = ADD_RC_COUNTS4 and WnR = '0') then
		RC_READ_INC4  <= not SUB_nREADY;
   else
	   RC_READ_INC4  <= '0';
   end if;	
	
  end process;
    
END rtl;

