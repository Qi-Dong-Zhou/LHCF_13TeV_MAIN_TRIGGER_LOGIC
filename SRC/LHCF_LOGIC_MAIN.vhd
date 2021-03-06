-- ========================================================================
-- ****************************************************************************
-- Model:           V1495 -  Multipurpose Programmable Trigger Unit
-- FPGA Proj. Name: LHCf main trigger logic for 13 TeV operation
-- Device:          ALTERA EP1C20F400C6
-- Date:            Mar, 2014
-- ----------------------------------------------------------------------------
-- Module:          LHCF_LOGIC_MAIN
-- Description:     Top design
-- ****************************************************************************

-- ############################################################################
-- Revision History:
-- ############################################################################


library IEEE;
use IEEE.std_Logic_1164.all;
use IEEE.std_Logic_arith.all;
use IEEE.std_Logic_unsigned.all;
use work.components.all;

entity LHCF_LOGIC_MAIN is
	port(
    -- Front Panel Ports
    A          : IN     std_logic_vector (31 DOWNTO 0);  -- In A (32 x LVDS/ECL)
    B          : IN     std_logic_vector (31 DOWNTO 0);  -- In B (32 x LVDS/ECL)
    C          : OUT    std_logic_vector (31 DOWNTO 0);  -- Out C (32 x LVDS)
    D          : IN     std_logic_vector (31 DOWNTO 0);  -- In/Out D (I/O Expansion)
    E          : INOUT  std_logic_vector (31 DOWNTO 0);  -- In/Out E (I/O Expansion)
    F          : INOUT  std_logic_vector (31 DOWNTO 0);  -- In/Out F (I/O Expansion)
    GIN        : IN     std_logic_vector ( 1 DOWNTO 0);   -- In G - LEMO (2 x NIM/TTL)
    GOUT       : OUT    std_logic_vector ( 1 DOWNTO 0);   -- Out G - LEMO (2 x NIM/TTL)
    -- Port Output Enable (0=Output, 1=Input)
    nOED       : OUT    std_logic;                       -- Output Enable Port D (only for A395D)
    nOEE       : OUT    std_logic;                       -- Output Enable Port E (only for A395D)
    nOEF       : OUT    std_logic;                       -- Output Enable Port F (only for A395D)
    nOEG       : OUT    std_logic;                       -- Output Enable Port G
    -- Port Level Select (0=NIM, 1=TTL)
    SELD       : OUT    std_logic;                       -- Output Level Select Port D (only for A395D)
    SELE       : OUT    std_logic;                       -- Output Level Select Port E (only for A395D)
    SELF       : OUT    std_logic;                       -- Output Level Select Port F (only for A395D)
    SELG       : OUT    std_logic;                       -- Output Level Select Port G

    -- Expansion Mezzanine Identifier:
    -- 000 : A395A (32 x IN LVDS/ECL)
    -- 001 : A395B (32 x OUT LVDS)
    -- 010 : A395C (32 x OUT ECL)
    -- 011 : A395D (8  x IN/OUT NIM/TTL)
    IDD        : IN     std_logic_vector (2 DOWNTO 0);   -- Slot D
    IDE        : IN     std_logic_vector (2 DOWNTO 0);   -- Slot E
    IDF        : IN     std_logic_vector (2 DOWNTO 0);   -- Slot F

    -- Delay Lines
    -- 0:1 => PDL (Programmable Delay Line): Step = 0.25ns / FSR = 64ns
    -- 2:3 => FDL (Free Running Delay Line with fixed delay)
    PULSE      : IN     std_logic_vector (3 DOWNTO 0);   -- Output of the delay line (0:1 => PDL; 2:3 => FDL)
    nSTART     : OUT    std_logic_vector (3 DOWNTO 2);   -- Start of FDL (active low)
    START      : OUT    std_logic_vector (1 DOWNTO 0);   -- Input of PDL (active high)
    DDLY       : INOUT  std_logic_vector (7 DOWNTO 0);   -- R/W Data for the PDL
    WR_DLY0    : OUT    std_logic;                       -- Write signal for the PDL0
    WR_DLY1    : OUT    std_logic;                       -- Write signal for the PDL1
    DIRDDLY    : OUT    std_logic;                       -- Direction of PDL data (0 => Read Dip Switches)
                                                         --                       (1 => Write from FPGA)
    nOEDDLY0   : OUT    std_logic;                       -- Output Enable for PDL0 (active low)
    nOEDDLY1   : OUT    std_logic;                       -- Output Enable for PDL1 (active low)

    -- LED drivers
    nLEDG      : OUT    std_logic;                       -- Green (active low)
    nLEDR      : OUT    std_logic;                       -- Red (active low)

    -- Spare
    --SPARE    : INOUT  std_logic_vector (11 DOWNTO 0);
	 
    -- Local Bus in/out signals
    nLBRES     : IN     std_logic;
    nBLAST     : IN     std_logic;
    WnR        : IN     std_logic;
    nADS       : IN     std_logic;
    LCLK       : IN     std_logic;
    nREADY     : OUT    std_logic;
    nINT       : OUT    std_logic;
    LAD        : INOUT  std_logic_vector (15 DOWNTO 0)
	);

END LHCF_LOGIC_MAIN;


architecture rtl of LHCF_LOGIC_MAIN is

	--------------------------
	------- SIGNALS ----------
	--------------------------
	
	constant VERSION                    : std_logic_vector(15 downto 0) := x"0203";
		
	subtype	count32_type               is std_logic_vector(31 downto 0);
	subtype	count24_type               is std_logic_vector(23 downto 0);
	subtype	count16_type               is std_logic_vector(15 downto 0);
	subtype	count8_type                is std_logic_vector(7  downto 0);
	
	signal	LHCCLK                     : std_logic := '0';
	-- CLK generate by PLL
	signal	CLK                        : std_logic := '0';
	signal	CLK80                      : std_logic := '0';
	
	-- Expansion for Slot D,E,F
	signal   D_Expan     		         : std_logic_vector(31 downto 0) := (others => '0');
	signal   E_Expan     		         : std_logic_vector(31 downto 0) := (others => '0');
	signal   F_Expan     		         : std_logic_vector(31 downto 0) := (others => '0');
	
	-- Module LB_INT for VME access		
	signal	REG_BUF_A1_L1T_MASK        : std_logic_vector(31 downto 0) := x"03030302";
	signal	REG_BUF_A1_SHOWER_MASK     : std_logic_vector(31 downto 0) := x"00000303";
	signal	REG_BUF_A1_FC_MASK         : std_logic_vector(31 downto 0) := x"0001F000";
	signal	REG_BUF_A1_L3T_MASK        : std_logic_vector(31 downto 0) := x"00070307";
	
	signal	REG_BUF_A1_SHOWER_P        : std_logic_vector(31 downto 0) := x"00000000";
	signal	REG_BUF_A1_L2T_L1T_P       : std_logic_vector(31 downto 0) := x"00030D40";
	signal	REG_BUF_A1_SELFVETO_P      : std_logic_vector(31 downto 0) := x"44000FA0";
	signal	REG_BUF_A1_LATCH_STOP_P    : std_logic_vector(31 downto 0) := x"00009C40";
	
	signal	REG_BUF_A2_L1T_MASK        : std_logic_vector(31 downto 0) := x"03030301";
	signal	REG_BUF_A2_SHOWER_MASK     : std_logic_vector(31 downto 0) := x"00000303";
	signal	REG_BUF_A2_FC_MASK         : std_logic_vector(31 downto 0) := x"0003F001";
	signal	REG_BUF_A2_L3T_MASK        : std_logic_vector(31 downto 0) := x"00070307";
	
	signal	REG_BUF_A2_SHOWER_P        : std_logic_vector(31 downto 0) := x"00000000";
	signal	REG_BUF_A2_L2T_L1T_P       : std_logic_vector(31 downto 0) := x"00030D40";
	signal	REG_BUF_A2_SELFVETO_P      : std_logic_vector(31 downto 0) := x"44000FA0";
	signal	REG_BUF_A2_LATCH_STOP_P    : std_logic_vector(31 downto 0) := x"00009C40";
	
	signal	REG_BUF_COMMON_MASK        : std_logic_vector(31 downto 0) := x"00000300";
	signal   REG_BUF_ATLAS_MASK         : std_logic_vector(31 downto 0) := x"03003333";
	signal	REG_BUF_SEL_ECR            : std_logic_vector(31 downto 0) := x"00000000";	
	signal	REG_BUF_DL1T_DL3T_P        : std_logic_vector(31 downto 0) := x"00004341";
   signal	REG_BUF_LASER_PEDE_P       : std_logic_vector(31 downto 0) := x"00140D48";
	signal	REG_BUF_LASER_GEN_P        : std_logic_vector(31 downto 0) := x"16130D48";
	signal	REG_BUF_LASER_GEN_ENABLE   : std_logic_vector(31 downto 0) := x"00000000";
	signal	REG_BUF_ATLAS_P            : std_logic_vector(31 downto 0) := x"C31E061E";

	signal	REG_BUF_TESTOUT1_MASK      : std_logic_vector(31 downto 0) := (others => 'Z');
	signal	REG_BUF_TESTOUT2_MASK      : std_logic_vector(31 downto 0) := (others => 'Z');
	signal	REG_BUF_TESTOUT3_MASK      : std_logic_vector(31 downto 0) := (others => 'Z');
	signal	REG_BUF_TESTOUT4_MASK      : std_logic_vector(31 downto 0) := (others => 'Z');
	
	signal   REG_STATUS                 : std_logic_vector(15 downto 0) := (others => 'Z');
	-- Clear signal generate by VME access	
	signal	A1_LATCH_STOP_INTERNAL1    : std_logic := '0';    
	signal	ECR_INTERNAL1              : std_logic := '0';    
	signal	A1_COUNTER_LATCH_INTERNAL1 : std_logic := '0';

	signal	A2_LATCH_STOP_INTERNAL1    : std_logic := '0';       
	signal	A2_COUNTER_LATCH_INTERNAL1 : std_logic := '0'; 	
	signal	DSC_SCALER_STOP            : std_logic := '0'; 
	signal	DSC_SCALER_CLEAR           : std_logic := '0'; 
	signal	DSC_SCALER_CLEAR1          : std_logic := '0';
	
	-- Shift register
	signal   A1_TRANSFER_START          : std_logic := '0';
	signal   A1_WR                      : std_logic := '0';
	signal   A1_DATA_ENABLE             : std_logic := '0';
	signal   A1_SHIFT_EN                : std_logic := '0';
	signal   A1_COUNT                   : std_logic_vector(3 downto 0)  := (others => '0');
	signal   A1_SHIFT_IN			         : std_logic_vector(31 downto 0) := (others => '0');
	
	signal   A2_TRANSFER_START          : std_logic := '0';
	signal   A2_WR                      : std_logic := '0';
	signal   A2_DATA_ENABLE             : std_logic := '0';
	signal   A2_SHIFT_EN                : std_logic := '0';
	signal   A2_COUNT                   : std_logic_vector(3 downto 0)  := (others => '0');
	signal   A2_SHIFT_IN			         : std_logic_vector(31 downto 0) := (others => '0');
	
	-------- Main logic signals ------------
	-- LASER
	signal	LASER_GEN_1	               : std_logic := '0';
	signal	LASER_GEN_2	               : std_logic := '0';
	signal	LASER_GEN_3	               : std_logic := '0';
	signal	LASER_GEN    	            : std_logic := '0';
	signal	LASER_GEN_ENABLE    	      : std_logic := '0';
	signal	GEN_LASER    	            : std_logic := '0';
	signal	GEN_LASER_VETO             : std_logic := '0';
	signal	LASER_IN	                  : std_logic := '0';
	signal	LASER_SYC	               : std_logic := '0';
	signal	LASER_1	                  : std_logic := '0';
	signal	LASER_2	                  : std_logic := '0';
	signal	LASER_2_W	               : std_logic := '0';
	signal	LASER_3	                  : std_logic := '0';
	signal	LASER_4	                  : std_logic := '0';
	signal	LASER	                     : std_logic := '0';
	signal	LASER_SELFVETO	            : std_logic := '0';
	signal	LASER_PEDE_1	            : std_logic := '0';
	signal	LASER_PEDE	               : std_logic := '0';
	signal   DELAY_GEN_LASER            : std_logic_vector(7 downto 0)  := (others => '0');
	signal   DELAY_LASER_PEDE           : std_logic_vector(11 downto 0) := (others => '0');
	signal   PRESET_LASER_GEN           : std_logic_vector(11 downto 0) := (others => '0');
   signal   DELAY_LASER_GEN            : std_logic_vector(11 downto 0) := (others => '0');
	signal   WIDTH_LASER_GEN            : std_logic_vector(7 downto 0)  := (others => '0');
	
	--A1_L1T
	signal   BPTX1_1                    : std_logic := '0';  -- INPUT
	signal   BPTX1_2                    : std_logic := '0';  -- SYNCHRONIZED WITH CLK
	signal   BPTX1_3                    : std_logic := '0';  -- WIDTH 1 CLK
	signal   BPTX2_1                    : std_logic := '0';  -- INPUT
	signal   BPTX2_2                    : std_logic := '0';  -- SYNCHRONIZED WITH CLK	
	signal   BPTX2_3                    : std_logic := '0';  -- WIDTH 1 CLK
	signal   A1_L1T                     : STD_LOGIC := '0';
	signal   A1_L1T2                    : STD_LOGIC := '0';
	signal   A1_L1T_VETO                : STD_LOGIC := '0';
   signal   A1_L1T_W                   : STD_LOGIC := '0';
   signal   A1_L1T_GPIO                : STD_LOGIC := '0';	
	--A1_SHOWER TRIGGER & SPECIAL TRIGGER
	signal   A1_DL1T                    : STD_LOGIC := '0';
	signal   A1_SDSC                    : std_logic_vector(15 downto 0) := (others => '0'); 
	signal   A1_LDSC                    : std_logic_vector(15 downto 0) := (others => '0');
	signal   A1_SDSC2                   : std_logic_vector(15 downto 0) := (others => '0'); 
	signal   A1_LDSC2                   : std_logic_vector(15 downto 0) := (others => '0');
	signal   A1_SLOGIC                  : std_logic := '0';
	signal   A1_LLOGIC                  : std_logic := '0'; 
	signal   A1_STRG                    : std_logic := '0';
	signal   A1_LTRG                    : std_logic := '0'; 	
	signal   A1_SPATTERN                : std_logic_vector(15 downto 0) := (others => '0');
	signal   A1_LPATTERN                : std_logic_vector(15 downto 0) := (others => '0');
	signal   A1_SHOWER_BPTXX            : std_logic := '0';
	signal   A1_SHOWER_TRG1             : std_logic := '0';
	signal   A1_SHOWER_TRG2             : std_logic := '0';
	signal   A1_SHOWER_TRG3             : std_logic := '0';
	signal   A1_SPECIAL_BPTXX           : std_logic := '0';
	signal   A1_SPECIAL_TRG1            : std_logic := '0';
	signal   A1_SPECIAL_TRG2            : std_logic := '0';
	signal   A1_SPECIAL_TRG3            : std_logic := '0';
	signal   A1_L2T_SHOWER              : std_logic := '0';  
	signal   A1_L2T_SPECIAL             : std_logic := '0';  
	signal   SEL_A1_SLOGIC_SOURCE       : std_logic := '0';
	signal   SEL_A1_LLOGIC_SOURCE       : std_logic := '0';
	
	signal   A1_SHOWER_TRIGGER          : std_logic := '0';
	--A1_PEDESTAL
	signal   A1_PEDE_TRG1               : std_logic := '0';
	signal   A1_PEDE_TRG1_W             : std_logic := '0';
	signal   A1_L2T_PEDE                : std_logic := '0';  
	--A1_L2T_L1T
	signal   A1_LD_BPTX                 : std_logic := '0';
	signal   A1_L2T_L1T1                : std_logic := '0';  -- SELECTED SIGNAL
	signal   A1_L2T_L1T2                : std_logic := '0';
	signal   A1_L2T_L1T3                : std_logic := '0';
	signal   A1_L2T_L1T_W               : std_logic := '0';
	signal   A1_L2T_L1T                 : std_logic := '0';
	--FRONT COUNTER
	signal   LD_A1_L1T                  : std_logic := '0';
	signal   LD_A2_L1T                  : std_logic := '0';
	signal   A1_FC                      : std_logic_vector(3 downto 0) := (others => '0');
	signal   A1_FC2                     : std_logic_vector(3 downto 0) := (others => '0');
	signal   A2_FC                      : std_logic_vector(3 downto 0) := (others => '0');
	signal   A2_FC2                     : std_logic_vector(3 downto 0) := (others => '0');
	signal   A1_FC_PATTERN              : std_logic_vector(3 downto 0) := (others => '0');
	signal   A2_FC_PATTERN              : std_logic_vector(3 downto 0) := (others => '0');
	signal   A1_FCL                     : std_logic_vector(3 downto 0) := (others => '0');
	signal   A2_FCL                     : std_logic_vector(3 downto 0) := (others => '0');
	signal   A1_FCL_OR                  : std_logic := '0';
	signal   A2_FCL_OR                  : std_logic := '0';
	signal   A1_FC_BPTXX                : std_logic := '0';
	signal   A2_FC_BPTXX                : std_logic := '0';
	signal   A1_FC_TRG1                 : std_logic := '0';
	signal   A2_FC_TRG1                 : std_logic := '0';
	signal   A1_FC_TRG                  : std_logic := '0';
	signal   A2_FC_TRG                  : std_logic := '0';
	signal   A1_L2T_FC                  : std_logic := '0';  -- 200nsec width
	--A1_L3T
	signal   A1_L3T0                    : std_logic := '0';
	signal   A1_L3T1                    : std_logic := '0';  -- or 
	signal   A1_L3TT                    : std_logic := '0';  -- L3T Timing mark
	signal   A1_L3T2                    : std_logic := '0';  -- and L3T Timing mark
	signal   A1_L3T                     : std_logic := '0';
	signal   A1_L3T_W                   : STD_LOGIC := '0';
	signal   A1_L3T_GPIO                : std_logic := '0';
	signal   A1_L3T_DELAY               : std_logic := '0';
	
	--A1_LATCH
	signal   A1_LATCH_STOP              : std_logic := '0';	
	signal   A1_LATCH_STOP_INTERNAL     : std_logic := '0';
	signal   A1_LATCH_STOP_EXTERNAL     : std_logic := '0';	
	signal   A1_LATCH_STOP_FIXED        : std_logic := '0';
	signal   A1_LATCH                   : std_logic := '0';
	
	--A1_PARAMETER
	signal   A1_SEL_L1T                 : std_logic_vector(2 downto 0)  := (others => '0');
	signal   A1_L2T_L1T_MASK            : std_logic_vector(1 downto 0)  := (others => '0');
	signal   A1_SEL_L2T_FC              : std_logic_vector(3 downto 0)  := (others => '0');
	signal   A1_LD_BPTX_MASK            : std_logic_vector(1 downto 0)  := (others => '0');
	signal   A1_FC_MASK                 : std_logic_vector(7 downto 0)  := (others => '0');
	signal   A1_SHOWER_MASK             : std_logic_vector(1 downto 0)  := (others => '0');
	signal   A1_SHOWER_SOURCE_MASK      : std_logic_vector(1 downto 0)  := (others => '0');
	signal   A1_SPECIAL_TRG_MASK        : std_logic_vector(1 downto 0)  := (others => '0');
	signal   A1_SPECIAL_SOURCE_MASK     : std_logic_vector(1 downto 0)  := (others => '0');
	signal   A1_PEDE_MASK               : std_logic_vector(1 downto 0)  := (others => '0');
	signal   A1_L3T_MASK                : std_logic_vector(4 downto 0)  := (others => '0');
	signal   A1_NSTEP_SHOWER_TRG_PRESET : std_logic_vector(5 downto 0)  := (others => '0');
	signal   A1_NSTEP_SPECIAL_TRG_PRESET: std_logic_vector(5 downto 0)  := (others => '0');
	signal   A1_NSTEP_L2T_L1T_PRESET    : std_logic_vector(23 downto 0) := (others => '0');
	signal   A1_LATCH_STOP_MASK         : std_logic_vector(2 downto 0)  := "001";
	signal   A1_NCLK_LATCH_STOP_WIDTH   : std_logic_vector(23 downto 0) := (others => '0');
	signal   NCLK_DELAY_BPTX1           : std_logic_vector(6 downto 0)  := (others => '0');
	signal   NCLK_DELAY_BPTX2           : std_logic_vector(6 downto 0)  := (others => '0');
	signal   A1_NCLK_SELFVETO           : std_logic_vector(19 downto 0) := (others => '0');
	signal   A1_ENABLE_MASK             : std_logic_vector(2 downto 0)  := (others => '0');
	-- A1_SELF VETO 
	signal   A1_SELFVETO                : std_logic := '0';
	signal   A1_SELFVETO0               : std_logic := '0';   
	signal   A1_SELFVETO1               : std_logic := '0';
	signal   A1_SELFVETO2               : std_logic := '1';
	
   -- A1_ENABLE SIGNAL
	signal   A1_SHOWER_TRG_OR           : std_logic := '0';
	signal   A1_NOTLATCH                : std_logic := '0';  -- not latch
	signal   A1_ENABLE                  : std_logic := '0';
	signal   A1_ENABLE1                 : std_logic := '0';
	signal   A1_ENABLE2                 : std_logic := '0';  -- Latched by BPTX
	signal   A1_ENABLE3                 : std_logic := '0';  -- ENALBE1 and ENABLE2
		
	--A1_INTERNAL SIGNALS FOR I/O EXPANSION
	signal   A1_DAQ_MODE0               : std_logic  := '0';
	signal   A1_DAQ_MODE1               : std_logic  := '0';
	signal   A1_BEAM_FLAG1              : std_logic  := '0';
	signal   A1_BEAM_FLAG               : std_logic  := '0';  -- Beam data takeing Flag
	signal   A1_PEDE_FLAG1              : std_logic  := '0';
	signal   A1_PEDE_FLAG               : std_logic  := '0';  -- Pedestal data takeing Flag
	signal   A1_LATCH_STOP_EXTERNAL1    : std_logic  := '0';  
	signal   A1_PC_ENABLE               : std_logic  := '0';
	signal   A1_ENABLE_FLAG             : std_logic  := '0';	
	signal   A1_RUN_STATUS              : std_logic  := '0';	
	signal   A1_RUN_STATUS_SYC          : std_logic  := '0';	
	signal   A1_DAQ_MODE                : std_logic_vector(1 downto 0) := (others => '0');
	
	--****************** END OF ARM1 LOGIC SIGNAL ******************* 
	signal   A2_L1T                     : STD_LOGIC := '0'; 
	signal   A2_L1T2                    : STD_LOGIC := '0';
	signal   A2_L1T_VETO                : STD_LOGIC := '0';
	signal   A2_L1T_W                   : STD_LOGIC := '0';
   signal   A2_L1T_GPIO                : STD_LOGIC := '0';
	--A2_SHOWER TRIGGER & SPECIAL TRIGGER
	signal   A2_DL1T                    : STD_LOGIC := '0';
	signal   A2_SDSC                    : std_logic_vector(15 downto 0) := (others => '0'); 
	signal   A2_LDSC                    : std_logic_vector(15 downto 0) := (others => '0');
	signal   A2_SDSC2                   : std_logic_vector(15 downto 0) := (others => '0'); 
	signal   A2_LDSC2                   : std_logic_vector(15 downto 0) := (others => '0');
	signal   A2_SLOGIC                  : std_logic := '0';
	signal   A2_LLOGIC                  : std_logic := '0'; 
	signal   A2_STRG                    : std_logic := '0';
	signal   A2_LTRG                    : std_logic := '0'; 	
	signal   A2_SPATTERN                : std_logic_vector(15 downto 0) := (others => '0');
	signal   A2_LPATTERN                : std_logic_vector(15 downto 0) := (others => '0');
	signal   A2_SHOWER_BPTXX            : std_logic := '0';
	signal   A2_SHOWER_TRG1             : std_logic := '0';
	signal   A2_SHOWER_TRG2             : std_logic := '0';
	signal   A2_SHOWER_TRG3             : std_logic := '0';
	signal   A2_SPECIAL_BPTXX           : std_logic := '0';
	signal   A2_SPECIAL_TRG1            : std_logic := '0';
	signal   A2_SPECIAL_TRG2            : std_logic := '0';
	signal   A2_SPECIAL_TRG3            : std_logic := '0';
	signal   A2_L2T_SHOWER              : std_logic := '0';  
	signal   A2_L2T_SPECIAL             : std_logic := '0';  
	signal   SEL_A2_SLOGIC_SOURCE       : std_logic := '0';
	signal   SEL_A2_LLOGIC_SOURCE       : std_logic := '0';
	
	signal   A2_SHOWER_TRIGGER          : std_logic := '0';
	--A2_PEDESTAL
	signal   A2_PEDE_TRG1               : std_logic := '0';
	signal   A2_PEDE_TRG1_W             : std_logic := '0';
	signal   A2_L2T_PEDE                : std_logic;  
	--A2_L2T_L1T
	signal   A2_LD_BPTX                 : std_logic := '0';
	signal   A2_L2T_L1T2                : std_logic := '0';
	signal   A2_L2T_L1T3                : std_logic := '0';
	signal   A2_L2T_L1T_W               : std_logic := '0';
	signal   A2_L2T_L1T1                : std_logic := '0';  -- SELECTED SIGNAL
	signal   A2_L2T_L1T                 : std_logic := '0';
	--A2_L2T_FC
	signal   A2_L2T_FC                  : std_logic := '0';  
	--A2_L3T
	signal   A2_L3T0                    : std_logic := '0';
	signal   A2_L3T1                    : std_logic := '0';  -- or 
	signal   A2_L3TT                    : std_logic := '0';  -- L3T Timing mark
	signal   A2_L3T2                    : std_logic := '0';  -- and L3T Timing mark
	signal   A2_L3T                     : std_logic := '0';
	signal   A2_L3T_W                   : STD_LOGIC := '0';
	signal   A2_L3T_GPIO                : std_logic := '0';
	signal   A2_L3T_DELAY               : std_logic := '0';
	
	--A2_LATCH
	signal   A2_LATCH_STOP              : std_logic := '0';	
	signal   A2_LATCH_STOP_INTERNAL     : std_logic := '0';
	signal   A2_LATCH_STOP_EXTERNAL     : std_logic := '0';	
	signal   A2_LATCH_STOP_FIXED        : std_logic := '0';
	signal   A2_LATCH                   : std_logic := '0';
	
	--A2_PARAMETER
	signal   A2_SEL_L1T                 : std_logic_vector(2 downto 0) := (others => '0');
	signal   A2_L2T_L1T_MASK            : std_logic_vector(1 downto 0) := (others => '0');
	signal   A2_LD_BPTX_MASK            : std_logic_vector(1 downto 0) := (others => '0');
	signal   A2_SEL_L2T_FC              : std_logic_vector(3 downto 0) := (others => '0');
	signal   A2_FC_MASK                 : std_logic_vector(7 downto 0) := (others => '0');
	signal   A2_SHOWER_MASK             : std_logic_vector(1 downto 0) := (others => '0');
	signal   A2_SHOWER_SOURCE_MASK      : std_logic_vector(1 downto 0) := (others => '0');
	signal   A2_SPECIAL_TRG_MASK        : std_logic_vector(1 downto 0) := (others => '0');
	signal   A2_SPECIAL_SOURCE_MASK     : std_logic_vector(1 downto 0) := (others => '0');
	signal   A2_PEDE_MASK               : std_logic_vector(1 downto 0) := (others => '0');
	signal   A2_L3T_MASK                : std_logic_vector(4 downto 0) := (others => '0');
	signal   A2_NSTEP_SHOWER_TRG_PRESET : std_logic_vector(5 downto 0) := (others => '0');
	signal   A2_NSTEP_SPECIAL_TRG_PRESET: std_logic_vector(5 downto 0) := (others => '0');
	signal   A2_NSTEP_L2T_L1T_PRESET    : std_logic_vector(23 downto 0):= (others => '0');
	signal   A2_LATCH_STOP_MASK         : std_logic_vector(2 downto 0) := "001";
	signal   A2_NCLK_LATCH_STOP_WIDTH   : std_logic_vector(23 downto 0):= (others => '0');
	signal   A2_NCLK_SELFVETO           : std_logic_vector(19 downto 0):= (others => '0');
	signal   A2_ENABLE_MASK             : std_logic_vector(2 downto 0) := (others => '0');
	-- A2_SELF VETO 
	signal   A2_SELFVETO                : std_logic := '0'; 
	signal   A2_SELFVETO0               : std_logic := '0';	
	signal   A2_SELFVETO1               : std_logic := '0';
	signal   A2_SELFVETO2               : std_logic := '1';
	
   -- A2_ENABLE SIGNAL
	signal   A2_SHOWER_TRG_OR           : std_logic := '0';
	signal   A2_NOTLATCH                : std_logic := '0';  -- not latch
	signal   A2_ENABLE                  : std_logic := '0';
	signal   A2_ENABLE1                 : std_logic := '0';
	signal   A2_ENABLE2                 : std_logic := '0';  -- Latched by BPTX
	signal   A2_ENABLE3                 : std_logic := '0';         -- ENALBE1 and ENABLE2
		
	--A2_INTERNAL SIGNALS FOR I/O EXPANSION
	signal   A2_DAQ_MODE0               : std_logic  := '0';
	signal   A2_DAQ_MODE1               : std_logic  := '0';
	signal   A2_BEAM_FLAG1              : std_logic  := '0';
	signal   A2_BEAM_FLAG               : std_logic  := '0';  -- Beam data takeing Flag
	signal   A2_PEDE_FLAG1              : std_logic  := '0';
	signal   A2_PEDE_FLAG               : std_logic  := '0';  -- Pedestal data takeing Flag
	signal   A2_LATCH_STOP_EXTERNAL1    : std_logic  := '0';  
	signal   A2_PC_ENABLE               : std_logic  := '0';
	signal   A2_ENABLE_FLAG             : std_logic  := '0';	
	signal   A2_RUN_STATUS              : std_logic  := '0';	
	signal   A2_RUN_STATUS_SYC          : std_logic  := '0';
	signal   A2_DAQ_MODE                : std_logic_vector(1 downto 0) := (others => '0');
	
	--****************** END OF ARM2 LOGIC SIGNAL ******************* 
	--****************** COMMON OPERATION ***************************
	
	signal   NCLK_DL1T                  : std_logic_vector(6 downto 0) := (others => '0');
	signal   NCLK_L3TT                  : std_logic_vector(6 downto 0) := (others => '0');
	
	signal   COMMON_FLAG1               : std_logic  := '0';
	signal   COMMON_FLAG                : std_logic  := '0';
	signal   SEL_COMMON_A1A2            : std_logic  := '0';
	signal   COMMON_BEAM_FLAG           : std_logic  := '0';
	signal   COMMON_PEDE_FLAG           : std_logic  := '0';	
	signal   SEL_COMMON_L1T             : std_logic_vector(2 downto 0) := (others => '0');
	signal   A1_L1T1                    : std_logic  := '0';
	signal   A2_L1T1                    : std_logic  := '0';
	signal   L1T                        : std_logic  := '0';
	signal   ENABLE1_AND                : std_logic  := '0';
	signal   L3T0_OR                    : std_logic  := '0';
	signal   L3T0_AND                   : std_logic  := '0';
	signal   COMMON_L3T_MASK            : std_logic_vector(3 downto 0) := (others => '0');
	signal   COMMON_L3T1                : std_logic := '0';
	signal   L3T_DELAY_OR               : std_logic := '0';
	signal   ATLAS_L1_LHCF1             : std_logic := '0';
	signal   ATLAS_L1_LHCF2             : std_logic := '0';
	signal   ATLAS_L1_LHCF3             : std_logic := '0';
	signal   ATLAS_L1_LHCF              : std_logic := '0';
	signal   A1_ATLAS                   : std_logic := '0';
	signal   A2_ATLAS                   : std_logic := '0';
	signal   A1_SHOWER                  : std_logic := '0';
	signal   A2_SHOWER                  : std_logic := '0';
	signal   A1_ATLAS_OR_MASK           : std_logic_vector(1 downto 0) := (others => '0');
	signal   A2_ATLAS_OR_MASK           : std_logic_vector(1 downto 0) := (others => '0');
	signal   A1_ATLAS_AND_MASK          : std_logic_vector(1 downto 0) := (others => '0');
	signal   A2_ATLAS_AND_MASK          : std_logic_vector(1 downto 0) := (others => '0');
	signal   NCLK_L3T_ATLAS             : std_logic_vector(7 downto 0) := (others => '0');
	signal   EN_COUNTER_MAX             : std_logic_vector(15 downto 0) := (others => '0');
	signal   ENABLE_ATLAS_L1_LHCF			: std_logic := '0';
	signal   ATLAS_COUNTER_ENABLE			: std_logic := '0';
	signal   ATLAS_COUNTER_ENABLE_MASK  : std_logic_vector(1 downto 0) := (others => '0');
	signal   PRESET_CLEAR1              : std_logic := '0';
	signal   PRESET_CLEAR               : std_logic := '0';
	--****************** EXTERNAL INPUT FROM ATLAS LTP *******************
	signal   ORBIT                      : std_logic := '0';
	signal   ATLAS_L1A                  : std_logic := '0';
	signal   ATLAS_ECR                  : std_logic := '0';
	signal   ORBIT_SYC                  : std_logic := '0';
	signal   ATLAS_L1A_SYC              : std_logic := '0';
	signal   ATLAS_ECR_SYC              : std_logic := '0';
	signal   ATLAS_BUSY                 : std_logic := '0';
	--*******************************************************************
	--***************************** COUNTER  ****************************
	--*******************************************************************
	signal   ECR_EXTERNAL_IND           : std_logic := '0';
	signal   ECR_EXTERNAL_COM           : std_logic := '0';
	signal   ECR_EXTERNAL1              : std_logic := '0';
	signal   ECR_EXTERNAL               : std_logic := '0';
	signal   ECR_INTERNAL               : std_logic := '0';
	signal   ECR1                       : std_logic := '0';	
	signal   ECR                        : std_logic := '0';
   signal   SEL_ECR                    : std_logic := '0';
	
	signal	A1_COUNTER_LATCH_INTERNAL  : std_logic := '0';
	signal	A1_COUNTER_LATCH_EVENT     : std_logic := '0';
	signal   A1_COUNTER_LATCH           : std_logic := '0';
	signal   A1_COUNTER_LATCH1          : std_logic := '0';
	signal   A1_COUNTER_LATCH2          : std_logic := '0';  	 -- DELAYED FOR ATLAS L1A
	
	signal	A2_COUNTER_LATCH_INTERNAL  : std_logic := '0';
	signal	A2_COUNTER_LATCH_EVENT     : std_logic := '0';
	signal   A2_COUNTER_LATCH           : std_logic := '0';
	signal   A2_COUNTER_LATCH1          : std_logic := '0';
	signal   A2_COUNTER_LATCH2          : std_logic := '0';  	 -- DELAYED FOR ATLAS L1A
	signal   NCLK_COUNTER_LATCH2        : std_logic_vector(5 downto 0) := "000000";
	--*************
	signal   A1_SEL_SFC                 : std_logic_vector(1 downto 0) := (others => '0');
	signal   A2_SEL_SFC                 : std_logic_vector(1 downto 0) := (others => '0');
	signal   A1_SFC                     : std_logic_vector(3 downto 0) := (others => '0');
	signal   A2_SFC                     : std_logic_vector(3 downto 0) := (others => '0');
	signal   FC_TRG_AND                 : std_logic := '0';
	signal   A1_FC_SHOWER               : std_logic := '0';
	signal   A2_FC_SHOWER               : std_logic := '0';
	
	signal   LD_BPTX_AND                : std_logic := '0';	
	signal   LD_BPTX1                   : std_logic := '0';
	signal   LD_BPTX2                   : std_logic := '0';
	signal   BPTX_AND                   : std_logic := '0';
	signal   OR_L3T                     : std_logic := '0';
	signal   SHOWER_BPTXX_AND           : std_logic := '0';
	
	signal   A1_SHOWER_L3T              : std_logic := '0'; 
	signal   A1_SPECIAL_L3T             : std_logic := '0'; 
	signal   A1_PEDE_L3T                : std_logic := '0';
	signal   A1_BPTX_L3T                : std_logic := '0';
	signal   A1_L1T_ENABLE              : std_logic := '0';
	signal   A1_LOGIC_OR1               : std_logic := '0';
	signal   A1_LOGIC_OR                : std_logic := '0';
	signal   ATLAS_L1A_W                : std_logic := '0';
	
	signal   FIFO_0_COUNT               : count32_type := (others => '0');
	signal   FIFO_1_COUNT               : count32_type := (others => '0');
	
	signal   A1_FIFO_0_0                : count32_type := (others => '0');
	signal   A1_FIFO_0_1                : count32_type := (others => '0');
	signal   A1_FIFO_0_2                : count32_type := (others => '0');
	signal   A1_FIFO_0_3                : count32_type := (others => '0');
	signal   A1_FIFO_1_0                : count32_type := (others => '0');
	signal   A1_FIFO_1_1                : count32_type := (others => '0');
	signal   A1_FIFO_1_2                : count32_type := (others => '0');
	signal   A1_FIFO_1_3                : count32_type := (others => '0');
	--INDEPENDENT
	signal   B_EC_A1_L1T                : count32_type := (others => '0');
	signal   B_EC_A1_L1T_ENABLE         : count32_type := (others => '0');
	signal   B_EC_A1_STRG               : count24_type := (others => '0');
	signal   B_EC_A1_LTRG               : count24_type := (others => '0');
	signal   B_EC_A1_SLOGIC             : count24_type := (others => '0');
	signal   B_EC_A1_LLOGIC             : count24_type := (others => '0');	
	signal   B_EC_A1_SHOWER_TRG1        : count24_type := (others => '0');
	signal   B_EC_A1_SHOWER_BPTXX       : count24_type := (others => '0');
	signal   B_EC_A1_SPECIAL_TRG1       : count24_type := (others => '0');
	signal   B_EC_A1_SPECIAL_BPTXX      : count24_type := (others => '0');
	signal   B_EC_A1_SHOWER_L3T         : count16_type := (others => '0');
	signal   B_EC_A1_SPECIAL_L3T        : count16_type := (others => '0');
	signal   B_EC_A1_PEDE_L3T           : count16_type := (others => '0');
	signal   B_EC_A1_BPTX_L3T           : count16_type := (others => '0');
	signal   B_EC_A1_L3T                : count16_type := (others => '0');
	signal   B_EC_A1_SFC_0              : count24_type := (others => '0');
	signal   B_EC_A1_SFC_1              : count24_type := (others => '0');	
	signal   B_EC_A1_SFC_2              : count24_type := (others => '0');
	signal   B_EC_A1_SFC_3              : count24_type := (others => '0');
	signal   B_EC_A1_FCL_OR             : count24_type := (others => '0');
	signal   B_EC_A1_FC_BPTXX           : count24_type := (others => '0');
	signal   B_EC_A1_FC_SHOWER          : count24_type := (others => '0');
	--COMMON
	signal   B_EC_A1_CLK                : count32_type := (others => '0');
	signal   B_EC_A1_BPTX1              : count32_type := (others => '0');
	signal   B_EC_A1_BPTX2              : count32_type := (others => '0');
	signal   B_EC_A1_BPTX_AND           : count32_type := (others => '0');
	signal   B_EC_A1_ORBIT              : count24_type := (others => '0');
	signal   B_EC_A1_OR_L3T             : count16_type := (others => '0');
	signal   B_EC_A1_SHOWER_BPTXX_AND   : count16_type := (others => '0');
	signal   B_EC_A1_ATLAS_L1_LHCF      : count16_type := (others => '0');
	signal   B_EC_A1_FC_TRG_AND         : count24_type := (others => '0');
	-- OC
	signal   B_OC_A1_CLK                : count16_type := (others => '0');
	signal   B_OC_A1_BPTX1              : count8_type  := (others => '0');
	signal   B_OC_A1_BPTX2              : count8_type  := (others => '0');
	-- AC
	signal   B_AC_A1_CLK                : count32_type := (others => '0');
	signal   B_AC_A1_ATLAS_L1A          : count32_type := (others => '0');	
	--COUNTER32_TYPE
	signal   BUF_EC_A1_ORBIT            : count32_type := (others => '0'); -- A1_ORBIT(23 downto 0)   -> A1_ORBIT
	signal   BUF_EC_A1_LL_STRG          : count32_type := (others => '0'); -- A1_LLOGIC(7 downto 0)   -> A1_LL_STRG(31 downto 28)
	signal   BUF_EC_A1_LL_LTRG          : count32_type := (others => '0'); -- A1_LLOGIC(15 downto 8)  -> A1_LL_LTRG(31 downto 28)
	signal   BUF_EC_A1_LL_SLOGIC        : count32_type := (others => '0'); -- A1_LLOGIC(23 downto 15) -> A1_LL_SLOGIC(31 downto 28)		
	signal   BUF_EC_A1_SP_SHOWER_TRG1   : count32_type := (others => '0'); -- A1_SPECIAL_BPTXX(7 downto 0)  -> A1_SP_SHOWER_TRG1(31 downto 28)
	signal   BUF_EC_A1_SP_SHOWER_BPTXX  : count32_type := (others => '0'); -- A1_SPECIAL_BPTXX(15 downto 8) -> A1_SP_SHOWER_BPTXX(31 downto 28)
	signal   BUF_EC_A1_SP_SPECIAL_TRG1  : count32_type := (others => '0'); -- A1_SPECIAL_BPTXX(23 downto 16)-> A1_SP_SPECIAL_TRG1(31 downto 28)
	signal   BUF_EC_A1_SP_SHOWER_L3T    : count32_type := (others => '0'); -- A1_SPECIAL_L3T(15 downto 0)  -> A1_SP_SHOWER_L3T(31 downto 16)
	signal   BUF_EC_A1_LHCF_SHOWER_AND  : count32_type := (others => '0'); -- A1_ATLAS_L1_LHCF(15 downto 0)-> A1_SHOWER_BPTXX_AND(31 downto 16)
	signal   BUF_EC_A1_BP_PEDE_L3T      : count32_type := (others => '0'); -- A1_BPTX_L3T(15 downto 0)     -> A1_BP_PEDE_L3T(31 downto 16)
	
	signal   BUF_EC_A1_OR_L3T           : count32_type := (others => '0'); -- A1_OR_L3T(15 downto 0)-> A1_OR_L3T(31 downto 16)
	signal   BUF_EC_A1_SFC_03           : count32_type := (others => '0'); -- A1_SFC_3(7 downto 0)  -> A1_SFC_0 (31 downto 28)
	signal   BUF_EC_A1_SFC_13           : count32_type := (others => '0'); -- A1_SFC_3(15 downto 8) -> A1_SFC_1 (31 downto 28)	
	signal   BUF_EC_A1_SFC_23           : count32_type := (others => '0'); -- A1_SFC_3(23 downto 16)-> A1_SFC_2 (31 downto 28)
	signal   BUF_EC_A1_FCL_OR           : count32_type := (others => '0'); -- A1_FC_TRG_AND(7 downto 0)   -> A1_FCL_OR     (31 downto 28)
	signal   BUF_EC_A1_FC_TRG           : count32_type := (others => '0'); -- A1_FC_TRG_AND(15 downto 8)  -> A1_FCL_TRG    (31 downto 28)
	signal   BUF_EC_A1_FC_SHOWER        : count32_type := (others => '0'); -- A1_FC_TRG_AND(23 downto 16) -> A1_FCL_SHOWER (31 downto 28)
	
	signal   BUF_OC_A1                  : count32_type := (others => '0'); -- A1_OC_A1(16 downto 0)  -> A1_OC_CLK
																		                    -- A1_OC_A1(23 downto 16) -> A1_OC_BPTX1
																		                    -- A1_OC_A1(31 downto 24) -> A1_OC_BPTX2
	--********** Arm2 ************ 
	signal   A2_SHOWER_L3T              : std_logic := '0'; 
	signal   A2_SPECIAL_L3T             : std_logic := '0'; 
	signal   A2_PEDE_L3T                : std_logic := '0';
	signal   A2_BPTX_L3T                : std_logic := '0';
	signal   A2_L1T_ENABLE              : std_logic := '0';	
	signal   A2_LOGIC_OR1               : std_logic := '0';
	signal   A2_LOGIC_OR                : std_logic := '0';
	
	signal   A2_FIFO_0_0                : count32_type := (others => '0');
	signal   A2_FIFO_0_1                : count32_type := (others => '0');
	signal   A2_FIFO_0_2                : count32_type := (others => '0');
	signal   A2_FIFO_0_3                : count32_type := (others => '0');
	signal   A2_FIFO_1_0                : count32_type := (others => '0');
	signal   A2_FIFO_1_1                : count32_type := (others => '0');
	signal   A2_FIFO_1_2                : count32_type := (others => '0');
	signal   A2_FIFO_1_3                : count32_type := (others => '0');
	--INDEPENDENT
	signal   B_EC_A2_L1T                : count32_type := (others => '0');
	signal   B_EC_A2_L1T_ENABLE         : count32_type := (others => '0');
	signal   B_EC_A2_STRG               : count24_type := (others => '0');
	signal   B_EC_A2_LTRG               : count24_type := (others => '0');
	signal   B_EC_A2_SLOGIC             : count24_type := (others => '0');
	signal   B_EC_A2_LLOGIC             : count24_type := (others => '0');	
	signal   B_EC_A2_SHOWER_TRG1        : count24_type := (others => '0');
	signal   B_EC_A2_SHOWER_BPTXX       : count24_type := (others => '0');
	signal   B_EC_A2_SPECIAL_TRG1       : count24_type := (others => '0');
	signal   B_EC_A2_SPECIAL_BPTXX      : count24_type := (others => '0');
	signal   B_EC_A2_SHOWER_L3T         : count16_type := (others => '0');
	signal   B_EC_A2_SPECIAL_L3T        : count16_type := (others => '0');
	signal   B_EC_A2_PEDE_L3T           : count16_type := (others => '0');
	signal   B_EC_A2_BPTX_L3T           : count16_type := (others => '0');
	signal   B_EC_A2_L3T                : count16_type := (others => '0');
	signal   B_EC_A2_SFC_0              : count24_type := (others => '0');
	signal   B_EC_A2_SFC_1              : count24_type := (others => '0');	
	signal   B_EC_A2_SFC_2              : count24_type := (others => '0');
	signal   B_EC_A2_SFC_3              : count24_type := (others => '0');
	signal   B_EC_A2_FCL_OR             : count24_type := (others => '0');
	signal   B_EC_A2_FC_BPTXX           : count24_type := (others => '0');
	signal   B_EC_A2_FC_SHOWER          : count24_type := (others => '0');
	--COMMON
	signal   B_EC_A2_CLK                : count32_type := (others => '0');
	signal   B_EC_A2_BPTX1              : count32_type := (others => '0');
	signal   B_EC_A2_BPTX2              : count32_type := (others => '0');
	signal   B_EC_A2_BPTX_AND           : count32_type := (others => '0');
	signal   B_EC_A2_ORBIT              : count24_type := (others => '0');
	signal   B_EC_A2_OR_L3T             : count16_type := (others => '0');
	signal   B_EC_A2_SHOWER_BPTXX_AND   : count16_type := (others => '0');
	signal   B_EC_A2_ATLAS_L1_LHCF      : count16_type := (others => '0');
	signal   B_EC_A2_FC_TRG_AND         : count24_type := (others => '0');
	-- OC
	signal   B_OC_A2_CLK                : count16_type := (others => '0');
	signal   B_OC_A2_BPTX1              : count8_type  := (others => '0');
	signal   B_OC_A2_BPTX2              : count8_type  := (others => '0');
	-- AC
	signal   B_AC_A2_CLK                : count32_type := (others => '0');
	signal   B_AC_A2_ATLAS_L1A          : count32_type := (others => '0');
	
	--COUNTER32_TYPE
	signal   BUF_EC_A2_ORBIT            : count32_type := (others => '0'); -- A1_ORBIT(23 downto 0)           -> A1_ORBIT
	signal   BUF_EC_A2_LL_STRG          : count32_type := (others => '0'); -- A1_LLOGIC(7 downto 0)           -> A1_LL_STRG(31 downto 28)
	signal   BUF_EC_A2_LL_LTRG          : count32_type := (others => '0'); -- A1_LLOGIC(15 downto 8)          -> A1_LL_LTRG(31 downto 28)
	signal   BUF_EC_A2_LL_SLOGIC        : count32_type := (others => '0'); -- A1_LLOGIC(23 downto 15)         -> A1_LL_SLOGIC(31 downto 28)		
	signal   BUF_EC_A2_SP_SHOWER_TRG1   : count32_type := (others => '0'); -- A1_SPECIAL_BPTXX(7 downto 0)    -> A1_SP_SHOWER_TRG1(31 downto 28)
	signal   BUF_EC_A2_SP_SHOWER_BPTXX  : count32_type := (others => '0'); -- A1_SPECIAL_BPTXX(15 downto 8)   -> A1_SP_SHOWER_BPTXX(31 downto 28)
	signal   BUF_EC_A2_SP_SPECIAL_TRG1  : count32_type := (others => '0'); -- A1_SPECIAL_BPTXX(23 downto 16)  -> A1_SP_SPECIAL_TRG1(31 downto 28)
	signal   BUF_EC_A2_SP_SHOWER_L3T    : count32_type := (others => '0'); -- A1_SPECIAL_L3T(15 downto 0)     -> A1_SP_SHOWER_L3T(31 downto 16)
	signal   BUF_EC_A2_LHCF_SHOWER_AND  : count32_type := (others => '0'); -- A1_ATLAS_L1_LHCF(15 downto 0)   -> A1_SHOWER_TRG1_AND(31 downto 16)
	signal   BUF_EC_A2_BP_PEDE_L3T      : count32_type := (others => '0'); -- A1_BPTX_L3T(15 downto 0)        -> A1_BP_PEDE_L3T(31 downto 16)
	
	signal   BUF_EC_A2_OR_L3T           : count32_type := (others => '0'); -- A1_OR_L3T(15 downto 0)          -> A1_OR_L3T(31 downto 16)
	signal   BUF_EC_A2_SFC_03           : count32_type := (others => '0'); -- A1_SFC_3(7 downto 0)            -> A1_SFC_0 (31 downto 28)
	signal   BUF_EC_A2_SFC_13           : count32_type := (others => '0'); -- A1_SFC_3(15 downto 8)           -> A1_SFC_1 (31 downto 28)	
	signal   BUF_EC_A2_SFC_23           : count32_type := (others => '0'); -- A1_SFC_3(23 downto 16)          -> A1_SFC_2 (31 downto 28)
	signal   BUF_EC_A2_FCL_OR           : count32_type := (others => '0'); -- A1_FC_TRG_AND(7 downto 0)       -> A1_FCL_OR     (31 downto 28)
	signal   BUF_EC_A2_FC_TRG           : count32_type := (others => '0'); -- A1_FC_TRG_AND(15 downto 8)      -> A1_FCL_TRG    (31 downto 28)
	signal   BUF_EC_A2_FC_SHOWER        : count32_type := (others => '0'); -- A1_FC_TRG_AND(23 downto 16)     -> A1_FCL_SHOWER (31 downto 28)
	
	signal   BUF_OC_A2                  : count32_type := (others => '0'); -- A1_OC_A1(16 downto 0)           -> A1_OC_CLK
																		                    -- A1_OC_A1(23 downto 16)          -> A1_OC_BPTX1
																		                    -- A1_OC_A1(31 downto 24)          -> A1_OC_BPTX2
	
	signal   B_EC_LASER                 : count32_type := (others => '0');
	signal   B_EC_SPECIAL               : count32_type := (others => '0');
	--********************* END OF COUNTER ********************
	--********************* EVENT FLAG ********************
	signal   ATLAS_L1A_LONG             : std_logic := '0';
	signal   A1_FLAG_LATCH              : std_logic := '0';
	
	signal   F_A1_LD_BPTX1              : std_logic := '0';
	signal   F_A1_LD_BPTX2              : std_logic := '0';
	signal   F_A1_LD_BPTX_AND           : std_logic := '0';
	signal   F_A1_LASER                 : std_logic := '0';
	signal   F_A1_L2T_SHOWER            : std_logic := '0';
	signal   F_A1_L2T_SPECIAL           : std_logic := '0';
	signal   F_A1_L2T_PEDE              : std_logic := '0';	
	signal   F_A1_L2T_L1T               : std_logic := '0';	
	signal   F_A1_L2T_FC                : std_logic := '0';	
	signal   F_A1_STRG                  : std_logic := '0';
	signal   F_A1_LTRG                  : std_logic := '0';
	signal   F_A1_BEAM_FLAG             : std_logic := '0';
	signal   F_A1_PEDE_FLAG             : std_logic := '0';
	signal   F_A1_ATLAS_L1A             : std_logic := '0';	
	signal   F_A1_L1T                   : std_logic := '0';
	signal   F_A1_L3T                   : std_logic := '0';
	signal   F_A1_ENABLE                : std_logic := '0';
	signal   F_A1_SHOWER_BPTXX          : std_logic := '0';
	signal   F_A1_A2_L1T                : std_logic := '0';
	signal   F_A1_A2_L3T                : std_logic := '0';
	signal   F_A1_A2_ENABLE             : std_logic := '0';	
	signal   F_A1_A2_SHOWER_BPTXX       : std_logic := '0';	
	signal   F_A1_FC2                   : std_logic_vector(3 downto 0) := (others => '0');	
	signal   F_A1_A2_FC2                : std_logic_vector(3 downto 0) := (others => '0');
	
	signal   F_A1_SDSC2                 : std_logic_vector(15 downto 0) := (others => '0');	
	signal   F_A1_LDSC2                 : std_logic_vector(15 downto 0) := (others => '0');
	signal   F_A1_A2_SDSC2              : std_logic_vector(15 downto 0) := (others => '0');	
	signal   F_A1_A2_LDSC2              : std_logic_vector(15 downto 0) := (others => '0');
	
	signal   A1_EVENT_FLAGS1            : std_logic_vector(31 downto 0) := (others => '0');
	signal   A1_EVENT_FLAGS2            : std_logic_vector(31 downto 0) := (others => '0');
	signal   A1_EVENT_FLAGS3            : std_logic_vector(31 downto 0) := (others => '0');
	signal   REG_A1_EVENT_FLAGS1        : std_logic_vector(31 downto 0) := (others => '0');
	signal   REG_A1_EVENT_FLAGS2        : std_logic_vector(31 downto 0) := (others => '0');
	signal   REG_A1_EVENT_FLAGS3        : std_logic_vector(31 downto 0) := (others => '0');
	---***********Arm2**********
--	signal   A2_DDL1T                   : std_logic := '0';
	signal   A2_FLAG_LATCH              : std_logic := '0';
	
	signal   F_A2_LD_BPTX1              : std_logic := '0';
	signal   F_A2_LD_BPTX2              : std_logic := '0';
	signal   F_A2_LD_BPTX_AND           : std_logic := '0';
	signal   F_A2_LASER                 : std_logic := '0';
	signal   F_A2_L2T_SHOWER            : std_logic := '0';
	signal   F_A2_L2T_SPECIAL           : std_logic := '0';
	signal   F_A2_L2T_PEDE              : std_logic := '0';	
	signal   F_A2_L2T_L1T               : std_logic := '0';	
	signal   F_A2_L2T_FC                : std_logic := '0';	
	signal   F_A2_STRG                  : std_logic := '0';
	signal   F_A2_LTRG                  : std_logic := '0';
	signal   F_A2_BEAM_FLAG             : std_logic := '0';
	signal   F_A2_PEDE_FLAG             : std_logic := '0';
	signal   F_A2_ATLAS_L1A             : std_logic := '0';	
	signal   F_A2_L1T                   : std_logic := '0';
	signal   F_A2_L3T                   : std_logic := '0';
	signal   F_A2_ENABLE                : std_logic := '0';
	signal   F_A2_SHOWER_BPTXX          : std_logic := '0';
	signal   F_A2_A1_L1T                : std_logic := '0';
	signal   F_A2_A1_L3T                : std_logic := '0';
	signal   F_A2_A1_ENABLE             : std_logic := '0';	
	signal   F_A2_A1_SHOWER_BPTXX       : std_logic := '0';	
	signal   F_A2_FC2                   : std_logic_vector(3 downto 0) := (others => '0');	
	signal   F_A2_A1_FC2                : std_logic_vector(3 downto 0) := (others => '0');
	
	signal   F_A2_SDSC2                 : std_logic_vector(15 downto 0) := (others => '0');	
	signal   F_A2_LDSC2                 : std_logic_vector(15 downto 0) := (others => '0');
	signal   F_A2_A1_SDSC2              : std_logic_vector(15 downto 0) := (others => '0');	
	signal   F_A2_A1_LDSC2              : std_logic_vector(15 downto 0) := (others => '0');
	
	signal   A2_EVENT_FLAGS1            : std_logic_vector(31 downto 0) := (others => '0');
	signal   A2_EVENT_FLAGS2            : std_logic_vector(31 downto 0) := (others => '0');
	signal   A2_EVENT_FLAGS3            : std_logic_vector(31 downto 0) := (others => '0');
	signal   REG_A2_EVENT_FLAGS1        : std_logic_vector(31 downto 0) := (others => '0');
	signal   REG_A2_EVENT_FLAGS2        : std_logic_vector(31 downto 0) := (others => '0');
	signal   REG_A2_EVENT_FLAGS3        : std_logic_vector(31 downto 0) := (others => '0');

	signal   DUMMY_SIGNAL               : std_logic := '0';
	signal   PULSES                     : std_logic_vector(385 downto 0) := (others => '0');
	signal   TESTOUT1                   : std_logic := '0';
	signal   TESTOUT2                   : std_logic := '0';
	signal   TESTOUT3                   : std_logic := '0';
	signal   TESTOUT4                   : std_logic := '0';
	signal   TESTOUT1_MASK              : std_logic_vector(11 downto 0) := (others => '0');
	signal   TESTOUT2_MASK              : std_logic_vector(11 downto 0) := (others => '0');
	signal   TESTOUT3_MASK              : std_logic_vector(11 downto 0) := (others => '0');
	signal   TESTOUT4_MASK              : std_logic_vector(11 downto 0) := (others => '0');
	
	signal   A1_L2T_PEDE_WIDTH          : std_logic_vector(3 downto 0) := "0101";
	signal   A1_SELFVETO_WIDTH          : std_logic_vector(3 downto 0) := x"F";
	
	signal   A2_L2T_PEDE_WIDTH          : std_logic_vector(3 downto 0) := "0101";
	signal   A2_SELFVETO_WIDTH          : std_logic_vector(3 downto 0) := x"F";
	
	-- SIGNALS FOR RAM_COUNTER added by MENJO 2015/03/15
	signal   RC_BPTX1							: std_logic := '0';
	signal   RC_BPTX2							: std_logic := '0';
	signal   RC_SIGNAL1						: std_logic := '0';
	signal   RC_SIGNAL2						: std_logic := '0';
	signal   RC_SIGNAL3						: std_logic := '0';
	signal   RC_SIGNAL4						: std_logic := '0';
	signal   RC_READ_RESET					: std_logic := '0'; 
	signal   RC_READ_INC1					: std_logic := '0'; 
	signal   RC_READ_INC2					: std_logic := '0'; 
	signal   RC_READ_INC3					: std_logic := '0'; 	
	signal   RC_READ_INC4					: std_logic := '0'; 	
	signal   RC_COUNTS1						: std_logic_vector (31 downto 0) := (others => '0');
	signal   RC_COUNTS2						: std_logic_vector (31 downto 0) := (others => '0');
	signal   RC_COUNTS3						: std_logic_vector (31 downto 0) := (others => '0');	
	signal   RC_COUNTS4						: std_logic_vector (31 downto 0) := (others => '0');	
	--SCLEAR FOR DISCRIMINATOR
   -- Arm1
	signal   COUNT_A1_S00               : count32_type := (others => '0');
	signal   COUNT_A1_S01               : count32_type := (others => '0');
	signal   COUNT_A1_S02               : count32_type := (others => '0');
	signal   COUNT_A1_S03               : count32_type := (others => '0');	
	signal   COUNT_A1_S04               : count32_type := (others => '0');
	signal   COUNT_A1_S05               : count32_type := (others => '0');
	signal   COUNT_A1_S06               : count32_type := (others => '0');
	signal   COUNT_A1_S07               : count32_type := (others => '0');
	signal   COUNT_A1_S08               : count32_type := (others => '0');
	signal   COUNT_A1_S09               : count32_type := (others => '0');
	signal   COUNT_A1_S10               : count32_type := (others => '0');
	signal   COUNT_A1_S11               : count32_type := (others => '0');	
	signal   COUNT_A1_S12               : count32_type := (others => '0');
	signal   COUNT_A1_S13               : count32_type := (others => '0');
	signal   COUNT_A1_S14               : count32_type := (others => '0');
	signal   COUNT_A1_S15               : count32_type := (others => '0');
	--
	signal   COUNT_A1_L00               : count32_type := (others => '0');
	signal   COUNT_A1_L01               : count32_type := (others => '0');
	signal   COUNT_A1_L02               : count32_type := (others => '0');
	signal   COUNT_A1_L03               : count32_type := (others => '0');	
	signal   COUNT_A1_L04               : count32_type := (others => '0');
	signal   COUNT_A1_L05               : count32_type := (others => '0');
	signal   COUNT_A1_L06               : count32_type := (others => '0');
	signal   COUNT_A1_L07               : count32_type := (others => '0');
	signal   COUNT_A1_L08               : count32_type := (others => '0');
	signal   COUNT_A1_L09               : count32_type := (others => '0');
	signal   COUNT_A1_L10               : count32_type := (others => '0');
	signal   COUNT_A1_L11               : count32_type := (others => '0');	
	signal   COUNT_A1_L12               : count32_type := (others => '0');
	signal   COUNT_A1_L13               : count32_type := (others => '0');
	signal   COUNT_A1_L14               : count32_type := (others => '0');
	signal   COUNT_A1_L15               : count32_type := (others => '0');
	
	-- Arm2
	signal   COUNT_A2_S00               : count32_type := (others => '0');
	signal   COUNT_A2_S01               : count32_type := (others => '0');
	signal   COUNT_A2_S02               : count32_type := (others => '0');
	signal   COUNT_A2_S03               : count32_type := (others => '0');	
	signal   COUNT_A2_S04               : count32_type := (others => '0');
	signal   COUNT_A2_S05               : count32_type := (others => '0');
	signal   COUNT_A2_S06               : count32_type := (others => '0');
	signal   COUNT_A2_S07               : count32_type := (others => '0');
	signal   COUNT_A2_S08               : count32_type := (others => '0');
	signal   COUNT_A2_S09               : count32_type := (others => '0');
	signal   COUNT_A2_S10               : count32_type := (others => '0');
	signal   COUNT_A2_S11               : count32_type := (others => '0');	
	signal   COUNT_A2_S12               : count32_type := (others => '0');
	signal   COUNT_A2_S13               : count32_type := (others => '0');
	signal   COUNT_A2_S14               : count32_type := (others => '0');
	signal   COUNT_A2_S15               : count32_type := (others => '0');
	--
	signal   COUNT_A2_L00               : count32_type := (others => '0');
	signal   COUNT_A2_L01               : count32_type := (others => '0');
	signal   COUNT_A2_L02               : count32_type := (others => '0');
	signal   COUNT_A2_L03               : count32_type := (others => '0');	
	signal   COUNT_A2_L04               : count32_type := (others => '0');
	signal   COUNT_A2_L05               : count32_type := (others => '0');
	signal   COUNT_A2_L06               : count32_type := (others => '0');
	signal   COUNT_A2_L07               : count32_type := (others => '0');
	signal   COUNT_A2_L08               : count32_type := (others => '0');
	signal   COUNT_A2_L09               : count32_type := (others => '0');
	signal   COUNT_A2_L10               : count32_type := (others => '0');
	signal   COUNT_A2_L11               : count32_type := (others => '0');	
	signal   COUNT_A2_L12               : count32_type := (others => '0');
	signal   COUNT_A2_L13               : count32_type := (others => '0');
	signal   COUNT_A2_L14               : count32_type := (others => '0');
	signal   COUNT_A2_L15               : count32_type := (others => '0');
begin
	-- Port Output Enable (0=Output, 1=Input)
	nOEE  <=  '0';
	nOEF  <=  '0';
	nOEG  <=  '0';
	-- Port Level Select (0=NIM, 1=TTL)
	SELE  <=  '0';
	SELF  <=  '0';
	SELG  <=  '0';
	
	D_Expan  <=  D 	      when IDD = "000"  else (others => '0');
	E_Expan  <=  E          when IDE = "011"  else (others => '0');
	F        <=  F_Expan    when IDF = "011"  else (others => '0');
	
	LHCCLK   <= GIN(0);
	GOUT (0) <= '0';
	GOUT (1) <= ECR;
	
	------- SLOT A CONNECTION(IN) --------
	A1_SDSC                <= A (15 downto 0);
	A1_LDSC                <= A (31 downto 16);
	
	------- SLOT B CONNECTION(IN) --------
	A2_SDSC                <= B (15 downto 0);
	A2_LDSC                <= B (31 downto 16);
	
	------- SLOT C CONNECTION(OUT) --------
	C(0)                   <= BPTX1_3;  -- Change from BPTX1_1 @ 4/30 MENJO
 	C(1)                   <= BPTX2_3;  -- Change from BPTX1_1 @ 4/30 MENJO
	C(2)                   <= ORBIT;
	C(3)                   <= A1_ENABLE;
   C(4)                   <= A1_L1T_GPIO;
	C(5)                   <= A1_L3T_GPIO;
	C(6)                   <= A1_PEDE_FLAG;
--	C(7)                   <= A1_TRIGGER_CLEAR;
	C(8)                   <= ECR;
	C(9)                   <= A1_SHOWER_TRIGGER;
	
	C(11)                  <= A1_DATA_ENABLE;
	C(12)                  <= A1_COUNT (0);
	C(13)                  <= A1_COUNT (1);
	C(14)                  <= A1_COUNT (2);
	C(15)                  <= A1_COUNT (3);

	C(16)                  <= BPTX1_3;  -- Change from BPTX1_1 @ 4/30 MENJO
	C(17)                  <= BPTX2_3;  -- Change from BPTX1_1 @ 4/30 MENJO
	C(18)                  <= ORBIT;
   C(19)                  <= A2_ENABLE;
   C(20)                  <= A2_L1T_GPIO;
	C(21)                  <= A2_L3T_GPIO;
	C(22)                  <= A2_PEDE_FLAG; 
--	C(23)                  <= A2_TRIGGER_CLEAR;
	C(24)                  <= ECR;
	C(25)                  <= A2_SHOWER_TRIGGER;

	C(27)                  <= A2_DATA_ENABLE;
	C(28)                  <= A2_COUNT (0);
	C(29)                  <= A2_COUNT (1);
	C(30)                  <= A2_COUNT (2);
	C(31)                  <= A2_COUNT (3);
	
	------- SLOT D CONNECTION(IN) --------
	A1_FC(0)                <= D_Expan(0);
	A1_FC(1)                <= D_Expan(1);
	A1_FC(2)                <= D_Expan(2);
	A1_FC(3)                <= D_Expan(3);
	A2_FC(0)                <= D_Expan(4);
	A2_FC(1)                <= D_Expan(5);
	A2_FC(2)                <= D_Expan(6);
	A2_FC(3)                <= D_Expan(7);
	
	A1_PC_ENABLE            <= D_Expan(8);
	A1_LATCH_STOP_EXTERNAL1 <= D_Expan(9);
	A1_DAQ_MODE(0)          <= D_Expan(10);
	A1_DAQ_MODE(1)          <= D_Expan(11);
	A1_RUN_STATUS           <= D_Expan(12);
	
	A2_PC_ENABLE            <= D_Expan(24);
	A2_LATCH_STOP_EXTERNAL1 <= D_Expan(25);
	A2_DAQ_MODE(0)          <= D_Expan(26);
	A2_DAQ_MODE(1)          <= D_Expan(27);
	A2_RUN_STATUS           <= D_Expan(28);
	
	------- SLOT E CONNECTION(6IN/2OUT) --------
	-- SLOT E was used as individually ports, NEED set mode to OUTPUT (nOEE  <=  '0';)
	-- For INPUT channels: OUTPUT bus internal channels set to '0', 50Ohm termination ON
	--IN
	BPTX1_1                 <= not E_Expan(2);
											 E(0)  <= '0';
	BPTX2_1                 <= not E_Expan(18);
											 E(16) <= '0';
											 
	ORBIT                   <= not E_Expan(3);
											 E(1)  <= '0';
	ATLAS_L1A               <= not E_Expan(19);
										    E(17) <= '0';
	ATLAS_ECR               <= not E_Expan(14);
										    E(12) <= '0';
	LASER_IN                <= not E_Expan(30);
										    E(28) <= '0';								 
	--OUT
	E(13)             <= ATLAS_L1_LHCF;
	E(29)             <= LASER_GEN;
	
	------- SLOT F CONNECTION(OUT) --------
	F_Expan(0)              <= TESTOUT1;
	F_Expan(16)             <= TESTOUT2;
	F_Expan(1)              <= TESTOUT3;
	F_Expan(17)             <= TESTOUT4;
	F_Expan(12)             <= D(14);
--	F_Expan(28)             <= DUMMY_SIGNAL;
	F_Expan(13)             <= A1_FCL_OR;
	F_Expan(29)             <= A2_FCL_OR;
	
	--------- END CONNECTION ---------------
	
	--------- SIGNAL CONNECTION ---------------
	A1_SHOWER_TRIGGER <= A1_LOGIC_OR;
	A2_SHOWER_TRIGGER <= A2_LOGIC_OR;
	--------- SIGNAL CONNECTION ---------------

   --************************************************************  
	--***                    STRAT LOGIC                       ***
	--************************************************************
	
	CLK_40to80 : PLL PORT MAP (
		areset       => '0',
		inclk0       => LHCCLK,   
		c0	          => CLK80,
		c1	          => CLK,
		locked       => open
	);
	--**************** COMMON MODE IDENTIFICATION, BEAM MODE OR PEDE MODE ********************
	
--	COMMON_FLAG1                         <= REG_BUF_COMMON_MASK(0);
	
	SYC_COMMON_FLAG_INTER : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => COMMON_FLAG1,
		OUTPUT       => COMMON_FLAG
	); 
	
	-- DAQ_MODE0:=0, DAQ_MODE1:=0    BEAM_FLAG <= '1'   PEDE_FLAG <= '0'  
	-- DAQ_MODE0:=1, DAQ_MODE1:=0    BEAM_FLAG <= '0'   PEDE_FLAG <= '1'  
	-- WHEN COMMON VIALDED A2_DAQ_MODE WILL USELESS, 
	
	SYC_A1_DAQ_MODE0 : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => A1_DAQ_MODE(0),
		OUTPUT       => A1_DAQ_MODE0
	);
	
	SYC_A1_DAQ_MODE1 : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => A1_DAQ_MODE(1),
		OUTPUT       => A1_DAQ_MODE1
	);
	
	A1_BEAM_FLAG1    <= ( not A1_DAQ_MODE0 ) and ( not A1_DAQ_MODE1 );
	A1_PEDE_FLAG1    <= (     A1_DAQ_MODE0 ) and ( not A1_DAQ_MODE1 );
	
	SYC_A2_DAQ_MODE0 : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => A2_DAQ_MODE(0),
		OUTPUT       => A2_DAQ_MODE0
	);
	
	SYC_A2_DAQ_MODE1 : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => A2_DAQ_MODE(1),
		OUTPUT       => A2_DAQ_MODE1
	);
	
	A2_BEAM_FLAG1   <= ( not A2_DAQ_MODE0 ) and ( not A2_DAQ_MODE1 );
	A2_PEDE_FLAG1   <= (     A2_DAQ_MODE0 ) and ( not A2_DAQ_MODE1 );
	
	MUX_COMMON_BEAM_FLAG : MUX port map(
		SOURCE_IN1   => A1_BEAM_FLAG1,
		SOURCE_IN2   => A2_BEAM_FLAG1,
		FLAG         => SEL_COMMON_A1A2,
		SOURCE_OUT   => COMMON_BEAM_FLAG
	);
	
	MUX_COMMON_PEDE_FLAG : MUX port map(
		SOURCE_IN1   => A1_PEDE_FLAG1,
		SOURCE_IN2   => A2_PEDE_FLAG1,
		FLAG         => SEL_COMMON_A1A2,
		SOURCE_OUT   => COMMON_PEDE_FLAG
	);
	
	MUX_A1_BEAM_FLAG : MUX port map(
		SOURCE_IN1   => A1_BEAM_FLAG1,
		SOURCE_IN2   => COMMON_BEAM_FLAG,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => A1_BEAM_FLAG
	);
	
	MUX_A1_PEDE_FLAG : MUX port map(
		SOURCE_IN1   => A1_PEDE_FLAG1,
		SOURCE_IN2   => COMMON_PEDE_FLAG,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => A1_PEDE_FLAG
	);
	
	MUX_A2_BEAM_FLAG : MUX port map(
		SOURCE_IN1   => A2_BEAM_FLAG1,
		SOURCE_IN2   => COMMON_BEAM_FLAG,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => A2_BEAM_FLAG
	);
	
	MUX_A2_PEDE_FLAG : MUX port map(
		SOURCE_IN1   => A2_PEDE_FLAG1,
		SOURCE_IN2   => COMMON_PEDE_FLAG,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => A2_PEDE_FLAG
	);
	
	----------------------------------------------------------------------------
	----------------------------- LASER LOGIC ----------------------------------
	----------------------------------------------------------------------------
	
	PRESET_CLEAR_PULSE : CLK_PULSE generic map (4) port map(
		CLK          => CLK,
		INPUT        => PRESET_CLEAR1,
		PRESET       => "0001",
		OUTPUT       => PRESET_CLEAR
	);
	
	PERSET_LASER: PRESETCOUNTER generic map(12) port map(
		CLK          => CLK,
		INPUT        => ORBIT_SYC,
		PRESET       => PRESET_LASER_GEN,   --11.5kHz->500Hz
		CLEAR        => PRESET_CLEAR,
		STAT         => LASER_GEN_1
	);
	
	LASER_GEN_DELAY : INTERNALCOUNTER generic map(12) port map (
		CLK          =>  CLK,
		START        =>  LASER_GEN_1,
		PRESET       =>  DELAY_LASER_GEN,
		STAT         =>  open,
		ENDMARK      =>  LASER_GEN_2
	);
	
	LASER_GEN_3   <= LASER_GEN_2 and COMMON_BEAM_FLAG and ENABLE1_AND and LASER_GEN_ENABLE;
	
	
	LASER_GEN_WIDTH : INTERNALCOUNTER generic map(8) port map (
		CLK          =>  CLK,
		START        =>  LASER_GEN_3,
		PRESET       =>  WIDTH_LASER_GEN,  --500nsec
		STAT         =>  LASER_GEN,
		ENDMARK      =>  open
	);

	
	------------ END LOGIC OF LASER_GEN ---------------------
	DELAY_FOR_GEN_LASER : INTERNALCOUNTER generic map(8) port map (
		CLK          =>  CLK,
		START        =>  LASER_GEN,
		PRESET       =>  DELAY_GEN_LASER,
		STAT         =>  open,
		ENDMARK      =>  GEN_LASER
	);	
	
	WIDTH_GEN_LASER : INTERNALCOUNTER generic map(8) port map (
		CLK          =>  CLK,
		START        =>  LASER_GEN,
		PRESET       =>  x"C7",
		STAT         =>  GEN_LASER_VETO,
		ENDMARK      =>  open
	);	
	
	
	SYC_LASER : SYNCHRONIZE port map(
		CLK          => CLK80,
		INPUT        => LASER_IN,
		OUTPUT       => LASER_SYC
	);
	
	LASER_WIDTH : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK80,
		START        =>  LASER_SYC,
		PRESET       =>  "0000",
		STAT         =>  open,
		ENDMARK      =>  LASER_1
	);
	
	LASER_2 <= LASER_1 and ( not GEN_LASER_VETO ) and ( not LASER_SELFVETO);
	
	LASER_2_WIDTH : INTERNALCOUNTER generic map(16) port map (
		CLK          =>  CLK80,
		START        =>  LASER_2,
		PRESET       =>  x"1F3F", -- 100usec WIDTH
		STAT         =>  LASER_SELFVETO,
		ENDMARK      =>  open
	);
	
	LASER_2_DELAY : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK80,
		START        =>  LASER_2,
		PRESET       =>  "0000",
		STAT         =>  LASER_2_W,
		ENDMARK      =>  open
	);
	
	LASER_3 <= LASER_2 or LASER_2_W;
	
	LASER_4 <= LASER_3 or GEN_LASER; 
	
	LASER   <= LASER_4 and COMMON_BEAM_FLAG;

	
	LASER_PEDE_DELAY : INTERNALCOUNTER generic map(12) port map (
		CLK          =>  CLK,
		START        =>  ORBIT_SYC,
		PRESET       =>  DELAY_LASER_PEDE,
		STAT         =>  open,
		ENDMARK      =>  LASER_PEDE_1
	);
	
	LASER_PEDE  <= LASER_PEDE_1 and COMMON_PEDE_FLAG and ENABLE1_AND;
	
	
	--------- START BLOCK OF L1T LOGIC ---------------
	SYC_BPTX1 : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => BPTX1_1,
		OUTPUT       => BPTX1_2
	);
	
	BPTX1_WIDTH : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  BPTX1_2,
		PRESET       =>  "0000",
		STAT         =>  open,
		ENDMARK      =>  BPTX1_3
	);
	
	SYC_BPTX2 : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => BPTX2_1,
		OUTPUT       => BPTX2_2
	);
	
	BPTX2_WIDTH : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  BPTX2_2,
		PRESET       =>  "0000",
		STAT         =>  open,
		ENDMARK      =>  BPTX2_3
	);
			
	A1_LL1T: LOGIC_BPTX01 port map(
		bptx1        => BPTX1_3,
		bptx2        => BPTX2_3,
		laser        => LASER,
		laser_pede   => LASER_PEDE,
		sellogic     => A1_SEL_L1T,                                          --************
		bptx         => A1_L1T1                                              --** A1_L1T **
	);                                                                      --************
	
	A2_LL1T: LOGIC_BPTX01 port map(
		bptx1        => BPTX1_3,
		bptx2        => BPTX2_3,
		laser        => LASER,
		laser_pede   => LASER_PEDE,
		sellogic     => A2_SEL_L1T,                                          --************
		bptx         => A2_L1T1                                              --** A2_L1T **
	);                                                                      --************
	
	LL1T: LOGIC_BPTX01 port map(
		bptx1        => BPTX1_3,
		bptx2        => BPTX2_3,
		laser        => LASER,
		laser_pede   => LASER_PEDE,
		sellogic     => SEL_COMMON_L1T,                                      --****************
		bptx         => L1T                                                  --** COMMON_L1T **
	);                                                                      --****************

--	SEL_COMMON_L1T                       <= REG_BUF_COMMON_MASK(10 downto 8);
	
	MUX_A1_L1T : MUX port map(
		SOURCE_IN1   => A1_L1T1,
		SOURCE_IN2   => L1T,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => A1_L1T2
	);
	
	A1_L1T_SELFVETO : INTERNALCOUNTER generic map(8) port map (
		CLK          =>  CLK,
		START        =>  A1_L1T,
		PRESET       =>  x"4E",  -- 1.9usec
		STAT         =>  A1_L1T_VETO,
		ENDMARK      =>  open
	);
		
	A1_L1T <= A1_L1T2 and (not A1_L1T_VETO);
	
	A1_L1T_WIDTH : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A1_L1T,
		PRESET       =>  "0001",
		STAT         =>  A1_L1T_W,
		ENDMARK      =>  open
	);
	
	A1_L1T_GPIO     <= A1_L1T or A1_L1T_W;
 	
	MUX_A2_L1T : MUX port map(
		SOURCE_IN1   => A2_L1T1,
		SOURCE_IN2   => L1T,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => A2_L1T2
	);
	
	A2_L1T_SELFVETO : INTERNALCOUNTER generic map(8) port map (
		CLK          =>  CLK,
		START        =>  A2_L1T,
		PRESET       =>  x"4E",  -- 1.9usec
		STAT         =>  A2_L1T_VETO,
		ENDMARK      =>  open
	);
	  
	A2_L1T <= A2_L1T2 and (not A2_L1T_VETO);
	
	A2_L1T_WIDTH : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A2_L1T,
		PRESET       =>  "0001",
		STAT         =>  A2_L1T_W,
		ENDMARK      =>  open
	);
	
	A2_L1T_GPIO     <= A2_L1T or A2_L1T_W;
	--------- END BLOCK OF L1T LOGIC ---------------
	
	--------- START BLOCK OF A1_L1T LOGIC ---------------
	-- DELAY FOR A1_DL1T
	A1_DELAYL1T: INTERNALCOUNTER generic map(7) port map(
		-- in
		CLK          => CLK80,
		START        => A1_L1T,
		PRESET       => NCLK_DL1T,
		-- out
		STAT         => open,
		ENDMARK      => A1_DL1T
	);
	
	--------- START BLOCK OF SHOWER LOGIC ---------------	
	-- Synchronization of discriminator signals with "80MHz" Clock --
	A1_DSC_WIDTH : SYC_WIDTH port map(
		CLK          => CLK80,
		SDSC_IN      => A1_SDSC,
		LDSC_IN      => A1_LDSC,
		SDSC2        => A1_SDSC2, 
		LDSC2        => A1_LDSC2 
	); 
	
	A1_SHOWER_TRG : SHOWER_MODULE02 port map(
		CLK                       => CLK,
		CLK80                     => CLK80,
		DL1T                      => A1_DL1T,
		LD_BPTX                   => LD_BPTX_AND,
		BEAMFLAG                  => A1_BEAM_FLAG,
		SEL_SLOGIC_SOURCE         => SEL_A1_SLOGIC_SOURCE,
		SEL_LLOGIC_SOURCE         => SEL_A1_LLOGIC_SOURCE,
		SDSC                      => A1_SDSC2,
		LDSC                      => A1_LDSC2,
		FLAG_CLEAR                => A1_L1T,
		NSTEP_SHOWER_TRG_PRESET   => A1_NSTEP_SHOWER_TRG_PRESET,
		SHOWER_SOURCE_MASK        => A1_SHOWER_SOURCE_MASK,
		SHOWER_MASK               => A1_SHOWER_MASK,
		
		STRIG1                    => A1_SLOGIC,   -- logic out of small tower 
		LTRIG1                    => A1_LLOGIC,   -- logic out of large tower
		STRG   					     => A1_STRG,     -- coincidence with bptx 
		LTRG   					     => A1_LTRG,     -- coincidence with bptx
		SPATTERN                  => A1_SPATTERN, -- discriminator pattern of s 
		LPATTERN                  => A1_LPATTERN, -- discriminator pattern of s
		SHOWER_BPTX_X             => A1_SHOWER_BPTXX,
		SHOWER_TRG1               => A1_SHOWER_TRG1,
		SHOWER_TRG2               => A1_SHOWER_TRG2,
		SHOWER_TRG3               => A1_SHOWER_TRG3,
		L2T_SHOWER                => A1_L2T_SHOWER                        
	); 
	
	--------- START BLOCK OF SPECIAL TRIGGER LOGIC ---------------
	
	A1_SPECIAL_TRG : SPECIAL_TRG_MODULE02 port map(
		CLK                       => CLK, 
		CLK80                     => CLK80,
		DL1T                      => A1_DL1T, 
		LD_BPTX                   => LD_BPTX_AND,
		BEAMFLAG                  => A1_BEAM_FLAG,
		SEL_SLOGIC_SOURCE         => SEL_A1_SLOGIC_SOURCE,
		SEL_LLOGIC_SOURCE         => SEL_A1_LLOGIC_SOURCE,
		SDSC                      => A1_SDSC2,
		LDSC                      => A1_LDSC2,
		NSTEP_SPECIAL_TRG_PRESET  => A1_NSTEP_SPECIAL_TRG_PRESET,
		SPECIAL_SOURCE_MASK       => A1_SPECIAL_SOURCE_MASK,
		SPECIAL_TRG_MASK          => A1_SPECIAL_TRG_MASK,
		SPECIAL_TRG_BPTX          => A1_SPECIAL_BPTXX,
		SPECIAL_TRG1				  => A1_SPECIAL_TRG1,
		SPECIAL_TRG2				  => A1_SPECIAL_TRG2,
		SPECIAL_TRG3				  => A1_SPECIAL_TRG3,		               --******************** 
		L2T_SPECIAL               => A1_L2T_SPECIAL                       --*** L2T_SPECIAL ***
	);                                                                   --********************

   --------- END BLOCK OF SPECIAL TRIGGER LOGIC ---------------	
	
	--------- START BLOCK OF PEDESTAL TRIGGER LOGIC ---------------
	
	A1_PEDE_TRG1 <= AND_WITH_MASK2( A1_DL1T,
										    A1_PEDE_FLAG,
										    A1_PEDE_MASK);
										 
	A1_L_L2T_PEDE : INTERNALCOUNTER generic map (4) port map(
		CLK          => CLK80,
		START        => A1_PEDE_TRG1,
		PRESET       => A1_L2T_PEDE_WIDTH,                                --*****************
		STAT         => A1_PEDE_TRG1_W,                                   --** A1_L2T_PEDE **
		ENDMARK      => open                                              --*****************
	);
	
	A1_L2T_PEDE  <= A1_PEDE_TRG1 or A1_PEDE_TRG1_W;
	
	--------- END BLOCK OF PEDESTAL TRIGGER LOGIC ---------------
	
	--------- START BLOCK OF A1_L2T_L1T LOGIC ---------------
	
	A1_LD_BPTX <= AND_WITH_MASK2( LD_BPTX1,
										   LD_BPTX2,
										   A1_LD_BPTX_MASK);
											
	A1_L2T_L1T1<= A1_DL1T and A1_LD_BPTX;
	
	PERSET_A1_L2T_L1T: PRESETCOUNTER generic map(24) port map(
		CLK =>    CLK80,
		INPUT =>  A1_L2T_L1T1,
		PRESET => A1_NSTEP_L2T_L1T_PRESET,
		CLEAR =>  PRESET_CLEAR,
		STAT =>   A1_L2T_L1T2
	);
	
	A1_L2T_L1T3 <= AND_WITH_MASK2( A1_L2T_L1T2,
											 A1_BEAM_FLAG,
											 A1_L2T_L1T_MASK);
	
	A1_L2T_L1T_WIDTH : INTERNALCOUNTER generic map (4) port map(
		CLK          => CLK80,
		START        => A1_L2T_L1T3,
		PRESET       => "0101", 
		STAT         => A1_L2T_L1T_W,                                      
		ENDMARK      => open                                              
	);
																							  --******************
																							  --*** A1_L2T_L1T ***
	A1_L2T_L1T  <= A1_L2T_L1T3 or A1_L2T_L1T_W;                         --******************
	
	--------- END BLOCK OF A1_L2T_L1T LOGIC ---------------
	
	--------- START BLOCK OF FRONT COUNTER LOGIC ---------------
		
   LDELAY_A1_L1T: LINEDELAY 
	  generic map (
		 NMAX   => 87,
		 NBITS  => 7
	  )
	port map(
		CLK          => CLK80,
		INPUT        => A1_L1T,
		DSELECT      => NCLK_DELAY_BPTX1,    -- for Arm1
		OUTPUT       => LD_A1_L1T
	);
	
 	ARM1_FC : FC_MODULE port map(
		CLK          => CLK,
		CLK80        => CLK80,
		DBPTX        => LD_A1_L1T, 
		CLEAR        => A1_L1T, 
		FC_MASK      => A1_FC_MASK,
		FC           => A1_FC,
		FC2          => A1_FC2,
		PATTERN      => A1_FC_PATTERN,
		FCL          => A1_FCL,
		FCL_OR       => A1_FCL_OR,
		FC_TRG1      => A1_FC_TRG1,		                              --***************
		FC_TRG2      => A1_FC_TRG                                      --** A1_FC_TRG **
	);                                                                --***************
	
	A1_FC_BPTXX <= A1_FCL_OR and LD_BPTX2;
	
	LDELAY_A2_L1T: LINEDELAY
	 generic map (
		NMAX   => 87,
		NBITS  => 7
	 )
	port map(
		CLK          => CLK80,
		INPUT        => A2_L1T,
		DSELECT      => NCLK_DELAY_BPTX2,    -- for Arm2
		OUTPUT       => LD_A2_L1T
	);

		
	ARM2_FC : FC_MODULE port map(
		CLK          => CLK,
		CLK80        => CLK80,
		DBPTX        => LD_A2_L1T,
		CLEAR        => A2_L1T,
		FC_MASK      => A2_FC_MASK,		
		FC           => A2_FC,
		FC2          => A2_FC2,
		PATTERN      => A2_FC_PATTERN,
		FCL          => A2_FCL,
		FCL_OR       => A2_FCL_OR,                                   --RETUEN SEL TO "F0"
		FC_TRG1      => A2_FC_TRG1,	                               --***************
		FC_TRG2      => A2_FC_TRG                                    --** A2_FC_TRG **
	);                                                              --***************
	
	A2_FC_BPTXX <= A2_FCL_OR and LD_BPTX1;	
	
	--------- END BLOCK OF FRONT COUNTER LOGIC ---------------
	
	--------- START BLOCK OF A1_L3T LOGIC ---------------
	
	A1_L2T_FC   <=    A1_FC_TRG                      when A1_SEL_L2T_FC = "0000" else
					      A2_FC_TRG                      when A1_SEL_L2T_FC = "0001" else
					      A1_FC_TRG and A2_L2T_SHOWER    when A1_SEL_L2T_FC = "0010" else
					      A2_FC_TRG and A1_L2T_SHOWER    when A1_SEL_L2T_FC = "0011" else
					      '0';
	
	A1_L3T0 <= OR_WITH_MASK5( A1_L2T_SHOWER,
						  	        A1_L2T_PEDE,
								     A1_L2T_SPECIAL,
								     A1_L2T_L1T,
								     A1_L2T_FC,
							        A1_L3T_MASK);
								
	A1_L_L3TT : INTERNALCOUNTER generic map (7) port map(
		CLK          =>  CLK80,
		START        =>  A1_L1T,
		PRESET       =>  NCLK_L3TT,
		STAT         =>  open,
		ENDMARK      =>  A1_L3TT
	);	

	A1_SYC_DAQ_ENABLE : SYNCHRONIZE port map(        
		CLK          => CLK,
		INPUT        => A1_PC_ENABLE,
		OUTPUT       => A1_ENABLE_FLAG
	);	
	
	--The A1_L3T1, A1_ENABLE was generate below at common mode logic 
	
	A1_L3T2 <= A1_L3T1 and A1_L3TT and A1_ENABLE;
	
	A1_LATCH_STOP_INTER_PULSE : CLK_PULSE generic map (4) port map(
		CLK          => CLK,
		INPUT        => A1_LATCH_STOP_INTERNAL1,
		PRESET       => "0001",
		OUTPUT       => A1_LATCH_STOP_INTERNAL
	);
	
	A1_LATCH_STOP_EXTER_PULSE : CLK_PULSE generic map (4) port map(
		CLK          => CLK,
		INPUT        => A1_LATCH_STOP_EXTERNAL1,
		PRESET       => "0001",
		OUTPUT       => A1_LATCH_STOP_EXTERNAL
	);
	
	A1_LMAINLATCH : LATCH_M port map (
		CLK          =>  CLK80,
		START        =>  A1_L3T2,
		STOP         =>  A1_LATCH_STOP,
		OUTPUT       =>  A1_LATCH,
		STARTMARK    =>  A1_L3T,
		ENDMARK      =>  open
	);
	
	A1_L3T_WIDTH : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK80,
		START        =>  A1_L3T,
		PRESET       =>  "0100",
		STAT         =>  A1_L3T_W,
		ENDMARK      =>  open
	);
	
	A1_L3T_GPIO     <= A1_L3T or A1_L3T_W;
	
	A1_L3T_DELAYED : INTERNALCOUNTER generic map(8) port map (
		CLK          =>  CLK,
		START        =>  A1_L3T_GPIO,
		PRESET       =>  x"0A",
		STAT         =>  open,
		ENDMARK      =>  A1_L3T_DELAY
	);	
	
	A1_LFIXEDLATCHWIDTH : INTERNALCOUNTER generic map(24) port map (
		CLK          =>  CLK,
		START        =>  A1_L3T_GPIO,
		PRESET       =>  A1_NCLK_LATCH_STOP_WIDTH,
		STAT         =>  open,
		ENDMARK      =>  A1_LATCH_STOP_FIXED
	);
	
	A1_LATCH_STOP <= OR_WITH_MASK3( A1_LATCH_STOP_INTERNAL,
										     A1_LATCH_STOP_EXTERNAL,
										     A1_LATCH_STOP_FIXED,
										     A1_LATCH_STOP_MASK);
	
	--------- END BLOCK OF A1_L3T LOGIC ---------------
	
	--------- START BLOCK OF SELFVETO LOGIC ---------------
	
	A1_SHOWER_TRG_OR <= A1_SLOGIC or A1_LLOGIC;
	
	A1_SELFVETO0     <= A1_SHOWER_TRG_OR and LD_BPTX2;

	A1_LSELFVETO1: INTERNALCOUNTER generic map(4) port map(
		CLK          =>  CLK80,
		START        =>  A1_SELFVETO0,
		PRESET       =>  A1_SELFVETO_WIDTH,  --250nsec delay
		STAT         =>  open,
		ENDMARK      =>  A1_SELFVETO1
	);
	
	A1_LSELFVETO2: INTERNALCOUNTER3 generic map(20) port map(
		CLK          =>  CLK80,
		START        =>  A1_SELFVETO1,
		PRESET       =>  A1_NCLK_SELFVETO,
		STAT         =>  A1_SELFVETO2,
		ENDMARK      =>  open
	);
		                                                             --*******************
	A1_SELFVETO <= not A1_SELFVETO2;                                --*** A1_SELFVETO ***
	A1_NOTLATCH <= not A1_LATCH;                                    --*******************
	
	--------- END BLOCK OF SELFVETO LOGIC ---------------
	

--***************************************************************************************************************
--****                                              LOGIC FOR ARM2		                                     ****
--***************************************************************************************************************
	-- DELAY FOR A2_DL1T
	A2_DELAYL1T: INTERNALCOUNTER generic map(7) port map(
		-- in
		CLK          => CLK80,
		START        => A2_L1T,
		PRESET       => NCLK_DL1T,
		-- out
		STAT         => open,
		ENDMARK      => A2_DL1T
	);
	
		--------- START BLOCK OF SHOWER LOGIC ---------------	
	-- Synchronization of discriminator signals with "80MHz" Clock --
	A2_DSC_WIDTH : SYC_WIDTH port map(
		CLK          => CLK80,
		SDSC_IN      => A2_SDSC,
		LDSC_IN      => A2_LDSC,
		SDSC2        => A2_SDSC2, 
		LDSC2        => A2_LDSC2 
	); 
	
	A2_SHOWER_TRG : SHOWER_MODULE02 port map(
		CLK                       => CLK,
		CLK80                     => CLK80,
		DL1T                      => A2_DL1T,
		LD_BPTX                   => LD_BPTX_AND,
		BEAMFLAG                  => A2_BEAM_FLAG,
		SEL_SLOGIC_SOURCE         => SEL_A2_SLOGIC_SOURCE,
		SEL_LLOGIC_SOURCE         => SEL_A2_LLOGIC_SOURCE,
		SDSC                      => A2_SDSC2,
		LDSC                      => A2_LDSC2,
		FLAG_CLEAR                => A2_L1T,
		NSTEP_SHOWER_TRG_PRESET   => A2_NSTEP_SHOWER_TRG_PRESET,
		SHOWER_SOURCE_MASK        => A2_SHOWER_SOURCE_MASK,
		SHOWER_MASK               => A2_SHOWER_MASK,
		
		STRIG1                    => A2_SLOGIC,   -- logic out of small tower 
		LTRIG1                    => A2_LLOGIC,   -- logic out of large tower
		STRG   					     => A2_STRG,     -- coincidence with bptx 
		LTRG   					     => A2_LTRG,     -- coincidence with bptx
		SPATTERN                  => A2_SPATTERN, -- discriminator pattern of s 
		LPATTERN                  => A2_LPATTERN, -- discriminator pattern of s
		SHOWER_BPTX_X             => A2_SHOWER_BPTXX,
		SHOWER_TRG1               => A2_SHOWER_TRG1,
		SHOWER_TRG2               => A2_SHOWER_TRG2,
		SHOWER_TRG3               => A2_SHOWER_TRG3,
		L2T_SHOWER                => A2_L2T_SHOWER                        
	); 
	
	--------- START BLOCK OF SPECIAL TRIGGER LOGIC ---------------
	
	A2_SPECIAL_TRG : SPECIAL_TRG_MODULE02 port map(
		CLK                       => CLK, 
		CLK80                     => CLK80,
		DL1T                      => A2_DL1T, 
		LD_BPTX                   => LD_BPTX_AND,
		BEAMFLAG                  => A2_BEAM_FLAG,
		SEL_SLOGIC_SOURCE         => SEL_A2_SLOGIC_SOURCE,
		SEL_LLOGIC_SOURCE         => SEL_A2_LLOGIC_SOURCE,
		SDSC                      => A2_SDSC2,
		LDSC                      => A2_LDSC2,
		NSTEP_SPECIAL_TRG_PRESET  => A2_NSTEP_SPECIAL_TRG_PRESET,
		SPECIAL_SOURCE_MASK       => A2_SPECIAL_SOURCE_MASK,
		SPECIAL_TRG_MASK          => A2_SPECIAL_TRG_MASK,
		SPECIAL_TRG_BPTX          => A2_SPECIAL_BPTXX, 
		SPECIAL_TRG1				  => A2_SPECIAL_TRG1,
		SPECIAL_TRG2				  => A2_SPECIAL_TRG2,
		SPECIAL_TRG3				  => A2_SPECIAL_TRG3,		               --********************** 
		L2T_SPECIAL               => A2_L2T_SPECIAL                       --*** A2_L2T_SPECIAL ***
	);                                                                   --**********************

   --------- END BLOCK OF SPECIAL TRIGGER LOGIC ---------------	
	
	--------- START BLOCK OF PEDESTAL TRIGGER LOGIC ---------------
	
	A2_PEDE_TRG1 <= AND_WITH_MASK2( A2_DL1T,
										     A2_PEDE_FLAG,
										     A2_PEDE_MASK);
										 
	A2_L_L2T_PEDE : INTERNALCOUNTER generic map (4) port map(
		CLK          => CLK80,
		START        => A2_PEDE_TRG1,
		PRESET       => A2_L2T_PEDE_WIDTH,                                --*****************
		STAT         => A2_PEDE_TRG1_W,                                   --** A2_L2T_PEDE **
		ENDMARK      => open                                              --*****************
	);
	
	A2_L2T_PEDE  <= A2_PEDE_TRG1 or A2_PEDE_TRG1_W;
	
	--------- END BLOCK OF PEDESTAL TRIGGER LOGIC ---------------	
	
	--------- START BLOCK OF A2_L2T_L1T LOGIC ---------------
	
	A2_LD_BPTX <= AND_WITH_MASK2( LD_BPTX1,
										   LD_BPTX2,
										   A2_LD_BPTX_MASK);
											
	A2_L2T_L1T1<= A2_DL1T and A2_LD_BPTX;
	
	PERSET_A2_L2T_L1T: PRESETCOUNTER generic map(24) port map(
		CLK =>    CLK80,
		INPUT =>  A2_L2T_L1T1,
		PRESET => A2_NSTEP_L2T_L1T_PRESET,
		CLEAR =>  PRESET_CLEAR,
		STAT =>   A2_L2T_L1T2
	);
	
	A2_L2T_L1T3 <= AND_WITH_MASK2( A2_L2T_L1T2,
										    A2_BEAM_FLAG,
										    A2_L2T_L1T_MASK);
	
	A2_L2T_L1T_WIDTH : INTERNALCOUNTER generic map (4) port map(
		CLK          => CLK80,
		START        => A2_L2T_L1T3,
		PRESET       => "0101", 
		STAT         => A2_L2T_L1T_W,                                      
		ENDMARK      => open                                              
	);
	                                                                 --******************
                                                                    --*** A2_L2T_L1T ***                                          
	A2_L2T_L1T  <= A2_L2T_L1T3 or A2_L2T_L1T_W;                      --******************
	
	--------- END BLOCK OF A2_L2T_L1T LOGIC ---------------
	
	--------- START BLOCK OF A1_L3T LOGIC ---------------
	
	A2_L2T_FC   <=    A1_FC_TRG                      when A2_SEL_L2T_FC = "0000" else
					      A2_FC_TRG                      when A2_SEL_L2T_FC = "0001" else
					      A1_FC_TRG and A2_L2T_SHOWER    when A2_SEL_L2T_FC = "0010" else
					      A2_FC_TRG and A1_L2T_SHOWER    when A2_SEL_L2T_FC = "0011" else
					      '0';
	
	A2_L3T0 <= OR_WITH_MASK5( A2_L2T_SHOWER,
						  	        A2_L2T_PEDE,
								     A2_L2T_SPECIAL,
								     A2_L2T_L1T,
								     A2_L2T_FC,
							        A2_L3T_MASK);
								
	A2_L_L3TT : INTERNALCOUNTER generic map (7) port map(
		CLK          =>  CLK80,
		START        =>  A2_L1T,
		PRESET       =>  NCLK_L3TT,
		STAT         =>  open,
		ENDMARK      =>  A2_L3TT
	);	

	A2_SYC_DAQ_ENABLE : SYNCHRONIZE port map(     --Be careful A2_ENABLE_FLAG--
		CLK          => CLK,
		INPUT        => A2_PC_ENABLE,
		OUTPUT       => A2_ENABLE_FLAG
	);	
	
	--The A2_L3T1, A2_ENABLE was generate below at common mode logic 
	
	A2_L3T2 <= A2_L3T1 and A2_L3TT and A2_ENABLE;
	
	A2_LATCH_STOP_INTER_PULSE : CLK_PULSE generic map (4) port map(
		CLK          => CLK,
		INPUT        => A2_LATCH_STOP_INTERNAL1,
		PRESET       => "0001",
		OUTPUT       => A2_LATCH_STOP_INTERNAL
	);
	
	A2_LATCH_STOP_EXTER_PULSE : CLK_PULSE generic map (4) port map(
		CLK          => CLK,
		INPUT        => A2_LATCH_STOP_EXTERNAL1,
		PRESET       => "0001",
		OUTPUT       => A2_LATCH_STOP_EXTERNAL
	);
	
	A2_LMAINLATCH : LATCH_M port map (
		CLK          =>  CLK80,
		START        =>  A2_L3T2,
		STOP         =>  A2_LATCH_STOP,
		OUTPUT       =>  A2_LATCH,
		STARTMARK    =>  A2_L3T,
		ENDMARK      =>  open
	);
	
	A2_L3T_WIDTH : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK80,
		START        =>  A2_L3T,
		PRESET       =>  "0100",
		STAT         =>  A2_L3T_W,
		ENDMARK      =>  open
	);
	
	A2_L3T_GPIO     <= A2_L3T or A2_L3T_W;
	
	A2_L3T_DELAYED : INTERNALCOUNTER generic map(8) port map (
		CLK          =>  CLK,
		START        =>  A2_L3T_GPIO,
		PRESET       =>  x"0E",
		STAT         =>  open,
		ENDMARK      =>  A2_L3T_DELAY
	);	
	
	A2_LFIXEDLATCHWIDTH : INTERNALCOUNTER generic map(24) port map (
		CLK          =>  CLK,
		START        =>  A2_L3T_GPIO,
		PRESET       =>  A2_NCLK_LATCH_STOP_WIDTH,
		STAT         =>  open,
		ENDMARK      =>  A2_LATCH_STOP_FIXED
	);
	
	A2_LATCH_STOP <= OR_WITH_MASK3( A2_LATCH_STOP_INTERNAL,
										     A2_LATCH_STOP_EXTERNAL,
										     A2_LATCH_STOP_FIXED,
										     A2_LATCH_STOP_MASK);
	
	--------- END BLOCK OF A2_L3T LOGIC ---------------
	
   --------- START BLOCK OF SELFVETO LOGIC ---------------
	
	A2_SHOWER_TRG_OR <= A2_SLOGIC or A2_LLOGIC;
	
	A2_SELFVETO0     <= A2_SHOWER_TRG_OR and LD_BPTX1;

	A2_LSELFVETO1: INTERNALCOUNTER generic map(4) port map(
		CLK          =>  CLK80,
		START        =>  A2_SELFVETO0,
		PRESET       =>  A2_SELFVETO_WIDTH,  
		STAT         =>  open,
		ENDMARK      =>  A2_SELFVETO1
	);
	
	A2_LSELFVETO2: INTERNALCOUNTER3 generic map(20) port map(
		CLK          =>  CLK80,
		START        =>  A2_SELFVETO1,
		PRESET       =>  A2_NCLK_SELFVETO,
		STAT         =>  A2_SELFVETO2,
		ENDMARK      =>  open
	);
		                                                             --*******************
	A2_SELFVETO <= not A2_SELFVETO2;                                --*** A2_SELFVETO ***
	A2_NOTLATCH <= not A2_LATCH;                                    --*******************
	
	--------- END BLOCK OF SELFVETO LOGIC ---------------
	
	--***********************************START COMMON MODE LOGIC ***********************************
	
	--------- START BLOCK OF ENABLE LOGIC ---------------
	A1_ENABLE1 <= AND_WITH_MASK3( A1_ENABLE_FLAG,
									   A1_NOTLATCH,
									   A1_SELFVETO,
									   A1_ENABLE_MASK);
										
	A2_ENABLE1 <= AND_WITH_MASK3( A2_ENABLE_FLAG,
									   A2_NOTLATCH,
									   A2_SELFVETO,
									   A2_ENABLE_MASK);
										
	ENABLE1_AND <= A1_ENABLE1 and A2_ENABLE1;
	
	MUX_A1_ENABLE : MUX port map(
		SOURCE_IN1   => A1_ENABLE1,
		SOURCE_IN2   => ENABLE1_AND,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => A1_ENABLE2
	);
									  
	A1_L_ENABLE : BUFFER_SIGNAL port map(
		CLK          =>  CLK,
		LATCH        =>  A1_L1T,
		CLR          =>  '0',
		INPUT        =>  A1_ENABLE2,
		OUTPUT       =>  A1_ENABLE3
	);								  
	
	A1_ENABLE <= A1_ENABLE2 and A1_ENABLE3;                        --*****************
                                                                  --*** A1_ENABLE ***
	                                                               --*****************
	
	MUX_A2_ENABLE : MUX port map(
		SOURCE_IN1   => A2_ENABLE1,
		SOURCE_IN2   => ENABLE1_AND,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => A2_ENABLE2
	);
	
	A2_L_ENABLE : BUFFER_SIGNAL port map(
		CLK          =>  CLK,
		LATCH        =>  A2_L1T,
		CLR          =>  '0',
		INPUT        =>  A2_ENABLE2,
		OUTPUT       =>  A2_ENABLE3
	);								  
	
	A2_ENABLE <= A2_ENABLE2 and A2_ENABLE3;                        --*****************
                                                                  --*** A2_ENABLE ***
	                                                               --*****************
	--------- END BLOCK OF ENABLE LOGIC ---------------
	
	L3T0_OR  <= A1_L3T0 or A2_L3T0;
	L3T0_AND <= A1_L3T0 and A2_L3T0;
	
--	COMMON_L3T_MASK                      <= REG_BUF_COMMON_MASK(19 downto 16);
	
	COMMON_L3T1 <= OR_WITH_MASK(  A1_L3T0,
	                              A2_L3T0,
											L3T0_OR,
											L3T0_AND,
											COMMON_L3T_MASK);
											
	MUX_A1_L3T1 : MUX port map(
		SOURCE_IN1   => A1_L3T0,
		SOURCE_IN2   => COMMON_L3T1,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => A1_L3T1
	);
	
	MUX_A2_L3T1 : MUX port map(
		SOURCE_IN1   => A2_L3T0,
		SOURCE_IN2   => COMMON_L3T1,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => A2_L3T1
	);
	
	A1_SHOWER <= OR_WITH_MASK2( A1_L2T_SHOWER,
										 A1_L2T_SPECIAL,
										 A1_ATLAS_OR_MASK);
										 
	A2_SHOWER <= OR_WITH_MASK2( A2_L2T_SHOWER,
										 A2_L2T_SPECIAL,
										 A2_ATLAS_OR_MASK);

	A1_ATLAS <= AND_WITH_MASK2( A1_L3T,
										 A1_SHOWER,
										 A1_ATLAS_AND_MASK);
										 
	A2_ATLAS <= AND_WITH_MASK2( A2_L3T,
										 A2_SHOWER,
										 A2_ATLAS_AND_MASK);
	
	ATLAS_L1_LHCF1 <= A1_ATLAS or A2_ATLAS;
	
----	NCLK_L3T_ATLAS <= REG_BUF_L3T_ATLAS(7 downto 0);
--	NCLK_L3T_ATLAS                       <= REG_BUF_ATLAS_P(15 downto 8);
	
	L_GD_L3T_ATLAS : GATEandDELAY port map (
		CLK      =>  CLK80,
		START    =>  ATLAS_L1_LHCF1,
		DELAY    =>  NCLK_L3T_ATLAS,
		WIDTH    =>  x"01",
		STAT     =>  open,
		OUTPUT   =>  ATLAS_L1_LHCF2,
		ENDMARK  =>  open
	);
	
	L3T_DELAY_OR  <= A1_L3T_DELAY or A2_L3T_DELAY;
	
	EN_COUNTER_L3T_OR : EN_COUNTER port map (
		CLK       =>  CLK,
		INPUT     =>  L3T_DELAY_OR,
		CLR       =>  ECR,
		INHIBIT   =>  '0',
		COUNT_MAX =>  EN_COUNTER_MAX,
		ENABLE    =>  ATLAS_COUNTER_ENABLE
	);
	
	ATLAS_L1_LHCF3 <= AND_WITH_MASK2( ATLAS_L1_LHCF2,
										       ATLAS_COUNTER_ENABLE,
										       ATLAS_COUNTER_ENABLE_MASK);
	
	ATLAS_L1_LHCF <= ATLAS_L1_LHCF3 and ENABLE_ATLAS_L1_LHCF;
	
	--******************************************************************************************************
	--********************************* COUNTER LOGIC ******************************************************
	--******************************************************************************************************
	
	--------- START SYNCHRONIZE SIGNALS FROM LTP ---------------
	SYC_ATLAS_L1A : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => ATLAS_L1A,
		OUTPUT       => ATLAS_L1A_SYC
	);
	
	SYC_ATLAS_ECR : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => ATLAS_ECR,
		OUTPUT       => ATLAS_ECR_SYC
	);
		
	SYC_ORBIT : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => ORBIT,
		OUTPUT       => ORBIT_SYC
	);	
	--------- END SYNCHRONIZE SIGNALS FROM LTP -----------------------
	
	--------- EVENT COUNTER RESET START -------------------------------------

--	SEL_ECR                              <= REG_BUF_SEL_ECR(0);

	SYC_A1_RUN_STATUS : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => A1_RUN_STATUS,
		OUTPUT       => A1_RUN_STATUS_SYC
	);	
	
	SYC_A2_RUN_STATUS : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => A2_RUN_STATUS,
		OUTPUT       => A2_RUN_STATUS_SYC
	);
	
	ECR_EXTERNAL_IND <= A1_RUN_STATUS_SYC or A2_RUN_STATUS_SYC;
	ECR_EXTERNAL_COM <= A1_RUN_STATUS_SYC and A2_RUN_STATUS_SYC;
	
	MUX_ECR_EXTERNAL : MUX port map(
		SOURCE_IN1   => ECR_EXTERNAL_IND,
		SOURCE_IN2   => ECR_EXTERNAL_COM,
		FLAG         => COMMON_FLAG,
		SOURCE_OUT   => ECR_EXTERNAL1
	);
	
	ECR_INTER_PULSE : CLK_PULSE generic map (4) port map(
		CLK          => CLK,
		INPUT        => ECR_INTERNAL1,
		PRESET       => "0001",
		OUTPUT       => ECR_INTERNAL
	);
	
	ECR_EXTER_PULSE : CLK_PULSE generic map (4) port map(
		CLK          => CLK,
		INPUT        => ECR_EXTERNAL1,
		PRESET       => "0001",
		OUTPUT       => ECR_EXTERNAL
	);	
	
	ECR1   <=   ECR_EXTERNAL when SEL_ECR = '0' else
	            ECR_INTERNAL when SEL_ECR = '1' else
               '0';
					
	L_ECR : INTERNALCOUNTER generic map(1) port map(
		CLK     => CLK,
		START   => ECR1,
		PRESET  => "0",
		STAT    => open,
		ENDMARK => ECR
	);

	--------- EVENT COUNTER RESET END -------------------------------------
	
	--------- COUNTER LATCH -------------------------------------
	
	-- G&D FOR COUNTER_LATCH_EVENT
	-- LINE DELAY FOR ENABLE
	
	---- FOR SMALL DELAY OF L3T
	A1_L_COUNTER_LATCH_EVENT : GATEandDELAY port map (
		CLK      =>  CLK80,
		START    =>  A1_L3T,                               
		DELAY    =>  x"04",
		WIDTH    =>  x"04",
		STAT     =>  open,
		OUTPUT   =>  A1_COUNTER_LATCH_EVENT,
		ENDMARK  =>  open
	);
	
	---- SYNCHRONIZE INTERNAL SIGNAL OF COUNTER LATCH (VIA VME BUS)
	A1_COUNTER_LATCH_INTER_PULSE : CLK_PULSE generic map (4) port map(
		CLK          => CLK,
		INPUT        => A1_COUNTER_LATCH_INTERNAL1,
		PRESET       => "0001",
		OUTPUT       => A1_COUNTER_LATCH_INTERNAL
	);
	
	A1_COUNTER_LATCH1 <= A1_COUNTER_LATCH_EVENT or A1_COUNTER_LATCH_INTERNAL; 

	A1_COUNTER_LATCH_W : INTERNALCOUNTER generic map(1) port map(
		CLK     => CLK,
		START   => A1_COUNTER_LATCH1,
		PRESET  => "0",
		STAT    => open,
		ENDMARK => A1_COUNTER_LATCH
	);	
	
	-- DELAYED LATCH FOR ATLAS L1A 
	DELAY_A1_COUNTER_LATCH2 : INTERNALCOUNTER generic map(6) port map(
		CLK     => CLK,
		START   => A1_COUNTER_LATCH,
		PRESET  => NCLK_COUNTER_LATCH2,
		STAT    => open,
		ENDMARK => A1_COUNTER_LATCH2
	);
	
		---- FOR SMALL DELAY OF L3T
	A2_L_COUNTER_LATCH_EVENT : GATEandDELAY port map (
		CLK      =>  CLK80,
		START    =>  A2_L3T,                             
		DELAY    =>  x"04",
		WIDTH    =>  x"04",
		STAT     =>  open,
		OUTPUT   =>  A2_COUNTER_LATCH_EVENT,
		ENDMARK  =>  open
	);
	
	---- SYNCHRONIZE INTERNAL SIGNAL OF COUNTER LATCH (VIA VME BUS)
	
	A2_COUNTER_LATCH_INTER_PULSE : CLK_PULSE generic map (4) port map(
		CLK          => CLK,
		INPUT        => A2_COUNTER_LATCH_INTERNAL1,
		PRESET       => "0001",
		OUTPUT       => A2_COUNTER_LATCH_INTERNAL
	);
	
	A2_COUNTER_LATCH1 <= A2_COUNTER_LATCH_EVENT or A2_COUNTER_LATCH_INTERNAL;   
	
	A2_COUNTER_LATCH_W : INTERNALCOUNTER generic map(1) port map(
		CLK     => CLK,
		START   => A2_COUNTER_LATCH1,
		PRESET  => "0",
		STAT    => open,
		ENDMARK => A2_COUNTER_LATCH
	);
	
	-- DELAYED LATCH FOR ATLAS L1A 
	DELAY_A2_COUNTER_LATCH2 : INTERNALCOUNTER generic map(6) port map(
		CLK     => CLK,
		START   => A2_COUNTER_LATCH,
		PRESET  => NCLK_COUNTER_LATCH2,
		STAT    => open,
		ENDMARK => A2_COUNTER_LATCH2
	);

----	NCLK_COUNTER_LATCH2 <= REG_BUF_COUNTER_LATCH(5 downto 0);
--	NCLK_COUNTER_LATCH2                  <= REG_BUF_ATLAS_P(5 downto 0);
	
	--*****************-------COUNTER Arm1 ----------*************************
	
	L_EC_A1_L1T : SCOUNTER3 generic map(32) port map(
		CLK      => CLK,
		INPUT    => A1_L1T,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH    => A1_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT   => B_EC_A1_L1T
	);
	
	A1_L1T_ENABLE <= A1_L1T and A1_BEAM_FLAG and A1_ENABLE;
	
	L_EC_A1_L1T_ENABLE : SCOUNTER3 generic map(32) port map(
		CLK      => CLK,
		INPUT    => A1_L1T_ENABLE,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH    => A1_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT   => B_EC_A1_L1T_ENABLE
	);	
	
	L_EC_A1_STRG : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A1_STRG,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_STRG
	);
	
	L_EC_A1_LTRG : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A1_LTRG,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_LTRG
	);
	
	L_EC_A1_SLOGIC : SCOUNTER3 generic map(24) port map(
		CLK     => CLK,
		INPUT   => A1_SLOGIC,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_SLOGIC
	);
	
	L_EC_A1_LLOGIC : SCOUNTER3 generic map(24) port map(
		CLK     => CLK,
		INPUT   => A1_LLOGIC,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_LLOGIC
	);
	
	L_EC_A1_SHOWER_TRG1 : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A1_SHOWER_TRG1,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_SHOWER_TRG1
	);
	
	L_EC_A1_SHOWER_BPTXX : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A1_SHOWER_BPTXX,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_SHOWER_BPTXX
	);
	
	L_EC_A1_SPECIAL_TRG1 : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A1_SPECIAL_TRG1,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_SPECIAL_TRG1
	);
	
	L_EC_A1_SPECIAL_BPTXX : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A1_SPECIAL_BPTXX,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_SPECIAL_BPTXX
	);
	
	A1_SHOWER_L3T <= A1_L2T_SHOWER and A1_L3T;
	
	L_EC_A1_SHOWER_L3T : SCOUNTER3 generic map(16) port map(
		CLK     => CLK80,
		INPUT   => A1_SHOWER_L3T,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_SHOWER_L3T
	);
	
	A1_PEDE_L3T <= A1_L2T_PEDE and A1_L3T;
	
	L_EC_A1_PEDE_L3T : SCOUNTER3 generic map(16) port map(
		CLK     => CLK80,
		INPUT   => A1_PEDE_L3T,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_PEDE_L3T
	);
	
	A1_SPECIAL_L3T <= A1_L2T_SPECIAL and A1_L3T;
	
	L_EC_A1_SPECIAL_L3T : SCOUNTER3 generic map(16) port map(
		CLK     => CLK80,
		INPUT   => A1_SPECIAL_L3T,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_SPECIAL_L3T
	);
	
	A1_BPTX_L3T <= A1_L2T_L1T and A1_L3T;
	
	L_EC_A1_BPTX_L3T : SCOUNTER3 generic map(16) port map(
		CLK     => CLK80,
		INPUT   => A1_BPTX_L3T,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_BPTX_L3T
	);
	
	L_EC_A1_L3T : SCOUNTER3 generic map(16) port map(
		CLK     => CLK80,
		INPUT   => A1_L3T,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A1_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A1_L3T
	);
	
----	A1_SEL_SFC  <= REG_BUF_SEL_SFC(1 downto 0);  --(1 downto 0)	
--	A1_SEL_SFC                           <= REG_BUF_A1_FC_MASK(17 downto 16);  --(1 downto 0)
	
	A1_SFC   <= A1_FC2 when A1_SEL_SFC = "00" else
				   A1_FCL when A1_SEL_SFC = "01" else
				   A2_FC2 when A1_SEL_SFC = "10" else
				   A2_FCL when A1_SEL_SFC = "11" else
			      "0000";

	L_EC_A1_SFC_0 : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A1_SFC(0),
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A1_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A1_SFC_0 
	);

	L_EC_A1_SFC_1 : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A1_SFC(1),
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A1_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A1_SFC_1 
	);
	
	L_EC_A1_SFC_2 : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A1_SFC(2),
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A1_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A1_SFC_2
	);

	L_EC_A1_SFC_3 : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A1_SFC(3),
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A1_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A1_SFC_3
	);
	
	L_EC_A1_FCL_OR : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A1_FCL_OR,
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A1_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A1_FCL_OR
	);

	L_EC_A1_FC_BPTXX : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A1_FC_BPTXX,
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A1_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A1_FC_BPTXX
	);
	
	A1_FC_SHOWER <= A1_SHOWER_BPTXX and A2_FC_TRG; 
	
	L_EC_A1_FC_SHOWER : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A1_FC_SHOWER,
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A1_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A1_FC_SHOWER
	);	
	
	
	L_FIFO_0_COUNTER : CLK_COUNTER2 port map(
		CLK     =>  CLK ,
		CLR     =>  ECR,
		INHIBIT =>  '0',
		COUNT   =>  FIFO_0_COUNT
	);
	
	A1_LOGIC_OR1 <= A1_SLOGIC or A1_LLOGIC;
	
	A1_LOGIC_OR_W : INTERNALCOUNTER generic map (4) port map(
		CLK          =>  CLK,
		START        =>  A1_LOGIC_OR1,
		PRESET       =>  "0000",
		STAT         =>  open,
		ENDMARK      =>  A1_LOGIC_OR
	);
	
	L_A1_FIFO_0 : FIFO_COUNTER port map (
		CLK      => CLK,
		COUNT    => FIFO_0_COUNT,
		WR       => A1_LOGIC_OR,
		LATCH    => A1_COUNTER_LATCH,
		OUTPUT0  => A1_FIFO_0_3,
		OUTPUT1  => A1_FIFO_0_2,
		OUTPUT2  => A1_FIFO_0_1,
		OUTPUT3  => A1_FIFO_0_0
	);
	
	A2_LOGIC_OR1 <= A2_SLOGIC or A2_LLOGIC;
	
	A2_LOGIC_OR_W : INTERNALCOUNTER generic map (4) port map(
		CLK          =>  CLK,
		START        =>  A2_LOGIC_OR1,
		PRESET       =>  "0000",
		STAT         =>  open,
		ENDMARK      =>  A2_LOGIC_OR
	);
	
	L_A2_FIFO_0 : FIFO_COUNTER port map (
		CLK      => CLK,
		COUNT    => FIFO_0_COUNT,
		WR       => A2_LOGIC_OR,
		LATCH    => A2_COUNTER_LATCH,
		OUTPUT0  => A2_FIFO_0_3,
		OUTPUT1  => A2_FIFO_0_2,
		OUTPUT2  => A2_FIFO_0_1,
		OUTPUT3  => A2_FIFO_0_0
	);
	
	L_FIFO_1_COUNTER : CLK_COUNTER2 port map(
		CLK     =>  CLK ,
		CLR     =>  ATLAS_ECR_SYC,
		INHIBIT =>  '0',
		COUNT   =>  FIFO_1_COUNT
	);
	
	ATLAS_L1A_WIDTH : INTERNALCOUNTER generic map (4) port map(
		CLK          =>  CLK,
		START        =>  ATLAS_L1A_SYC,
		PRESET       =>  "0000",
		STAT         =>  open,
		ENDMARK      =>  ATLAS_L1A_W
	);
	
	L_A1_FIFO_1 : FIFO_COUNTER port map (
		CLK      => CLK,
		COUNT    => FIFO_1_COUNT,
		WR       => ATLAS_L1A_W,
		LATCH    => A1_COUNTER_LATCH2,
		OUTPUT0  => A1_FIFO_1_3,
		OUTPUT1  => A1_FIFO_1_2,
		OUTPUT2  => A1_FIFO_1_1,
		OUTPUT3  => A1_FIFO_1_0
	);
	
	L_A2_FIFO_1 : FIFO_COUNTER port map (
		CLK      => CLK,
		COUNT    => FIFO_1_COUNT,
		WR       => ATLAS_L1A_W,
		LATCH    => A2_COUNTER_LATCH2,
		OUTPUT0  => A2_FIFO_1_3,
		OUTPUT1  => A2_FIFO_1_2,
		OUTPUT2  => A2_FIFO_1_1,
		OUTPUT3  => A2_FIFO_1_0
	);
	--*******************-----COUNTER Arm2 ----------***********************
	L_EC_A2_L1T : SCOUNTER3 generic map(32) port map(
		CLK      => CLK,
		INPUT    => A2_L1T,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH    => A2_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT   => B_EC_A2_L1T
	);
	
	A2_L1T_ENABLE <= A2_L1T and A2_BEAM_FLAG and A2_ENABLE;
	
	L_EC_A2_L1T_ENABLE : SCOUNTER3 generic map(32) port map(
		CLK      => CLK,
		INPUT    => A2_L1T_ENABLE,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH    => A2_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT   => B_EC_A2_L1T_ENABLE
	);

	L_EC_A2_STRG : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A2_STRG,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_STRG
	);
	
	L_EC_A2_LTRG : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A2_LTRG,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_LTRG
	);
	
	L_EC_A2_SLOGIC : SCOUNTER3 generic map(24) port map(
		CLK     => CLK,
		INPUT   => A2_SLOGIC,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_SLOGIC
	);
	
	L_EC_A2_LLOGIC : SCOUNTER3 generic map(24) port map(
		CLK     => CLK,
		INPUT   => A2_LLOGIC,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_LLOGIC
	);
	
	L_EC_A2_SHOWER_BPTXX : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A2_SHOWER_BPTXX,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_SHOWER_BPTXX
	);
	
	L_EC_A2_SHOWER_TRG1 : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A2_SHOWER_TRG1,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_SHOWER_TRG1
	);
	
	L_EC_A2_SPECIAL_BPTXX : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A2_SPECIAL_BPTXX,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_SPECIAL_BPTXX
	);
	
	L_EC_A2_SPECIAL_TRG1 : SCOUNTER3 generic map(24) port map(
		CLK     => CLK80,
		INPUT   => A2_SPECIAL_TRG1,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_SPECIAL_TRG1
	);
	
	A2_SHOWER_L3T <= A2_L2T_SHOWER and A2_L3T;
	
	L_EC_A2_SHOWER_L3T : SCOUNTER3 generic map(16) port map(
		CLK     => CLK80,
		INPUT   => A2_SHOWER_L3T,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_SHOWER_L3T
	);
	
	A2_PEDE_L3T <= A2_L2T_PEDE and A2_L3T;
	
	L_EC_A2_PEDE_L3T : SCOUNTER3 generic map(16) port map(
		CLK     => CLK80,
		INPUT   => A2_PEDE_L3T,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_PEDE_L3T
	);
	
	A2_SPECIAL_L3T <= A2_L2T_SPECIAL and A2_L3T;
	
	L_EC_A2_SPECIAL_L3T : SCOUNTER3 generic map(16) port map(
		CLK     => CLK80,
		INPUT   => A2_SPECIAL_L3T,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_SPECIAL_L3T
	);
	
	A2_BPTX_L3T <= A2_L2T_L1T and A2_L3T;
	
	L_EC_A2_BPTX_L3T : SCOUNTER3 generic map(16) port map(
		CLK     => CLK80,
		INPUT   => A2_BPTX_L3T,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_BPTX_L3T
	);
	
	L_EC_A2_L3T : SCOUNTER3 generic map(16) port map(
		CLK     => CLK80,
		INPUT   => A2_L3T,
		CLR     => ECR,
		INHIBIT => '0',
		LATCH   => A2_COUNTER_LATCH,
		CLEAR   => '0',
		BCOUNT  => B_EC_A2_L3T
	);	
	
----	A2_SEL_SFC  <= REG_BUF_SEL_SFC(9 downto 8);  --(1 downto 0)
--	A2_SEL_SFC                           <= REG_BUF_A2_FC_MASK(17 downto 16);  --(1 downto 0)

	A2_SFC   <= A1_FC2 when A2_SEL_SFC = "00" else
		         A1_FCL when A2_SEL_SFC = "01" else
		         A2_FC2 when A2_SEL_SFC = "10" else
		         A2_FCL when A2_SEL_SFC = "11" else
			      "0000";	
	
	L_EC_A2_SFC_0 : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A2_SFC(0),
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A2_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A2_SFC_0 
	);

	L_EC_A2_SFC_1 : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A2_SFC(1),
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A2_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A2_SFC_1 
	);
	
	L_EC_A2_SFC_2 : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A2_SFC(2),
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A2_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A2_SFC_2
	);

	L_EC_A2_SFC_3 : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A2_SFC(3),
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A2_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A2_SFC_3
	);
	
	L_EC_A2_FCL_OR : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A2_FCL_OR,
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A2_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A2_FCL_OR
	);

	L_EC_A2_FC_BPTXX : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A2_FC_BPTXX,
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A2_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A2_FC_BPTXX
	);
	
	A2_FC_SHOWER <= A2_SHOWER_BPTXX and A1_FC_TRG;
	
	L_EC_A2_FC_SHOWER : SCOUNTER3 generic map(24) port map(
		CLK     =>  CLK80,
		INPUT   =>  A2_FC_SHOWER,
		CLR     =>  ECR,
		INHIBIT =>  '0',
		LATCH   =>  A2_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT  =>  B_EC_A2_FC_SHOWER
	);
	
	--******************-----COUNTER GLOBAL ----------*********************
	
	NCLK_DELAY_BPTX1 <= NCLK_DL1T + "0000001";
	NCLK_DELAY_BPTX2 <= NCLK_DL1T + "0000001";
	
	LDELAYBPTX1: LINEDELAY
	 generic map (
		NMAX   => 87,
		NBITS  => 7
	 )
	port map(
		CLK          => CLK80,
		INPUT        => BPTX1_3,
		DSELECT      => NCLK_DELAY_BPTX1,    -- for Arm1
		OUTPUT       => LD_BPTX1
	);
	
	LDELAYBPTX2: LINEDELAY
	 generic map (
		NMAX   => 87,
		NBITS  => 7
	 )
	port map(
		CLK          => CLK80,
		INPUT        => BPTX2_3,
		DSELECT      => NCLK_DELAY_BPTX2,    -- for Arm2
		OUTPUT       => LD_BPTX2
	);
	
	L_EC_CLK : CLK_COUNTER3 generic map(32) port map(
		CLK      => CLK,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH1   => A1_COUNTER_LATCH,
		LATCH2   => A2_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT1  => B_EC_A1_CLK,
		BCOUNT2  => B_EC_A2_CLK
	);
	
	L_EC_LDBPTX1 : SCOUNTER_2LATCH generic map(32) port map(
		CLK      => CLK80,
		INPUT    => LD_BPTX1,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH1   => A1_COUNTER_LATCH,
		LATCH2   => A2_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT1  => B_EC_A1_BPTX1,
		BCOUNT2  => B_EC_A2_BPTX1
	);
	
	L_EC_LDBPTX2 : SCOUNTER_2LATCH generic map(32) port map(
		CLK      => CLK80,
		INPUT    => LD_BPTX2,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH1   => A1_COUNTER_LATCH,
		LATCH2   => A2_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT1  => B_EC_A1_BPTX2,
		BCOUNT2  => B_EC_A2_BPTX2
	);
	
	LD_BPTX_AND <= LD_BPTX1 and LD_BPTX2;
	
	L_EC_LDBPTX_AND : SCOUNTER_2LATCH generic map(32) port map(
		CLK      => CLK80,
		INPUT    => LD_BPTX_AND,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH1   => A1_COUNTER_LATCH,
		LATCH2   => A2_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT1  => B_EC_A1_BPTX_AND,
		BCOUNT2  => B_EC_A2_BPTX_AND
	);
	
	L_EC_ORBIT : SCOUNTER_2LATCH generic map(24) port map(
		CLK      => CLK,
		INPUT    => ORBIT_SYC,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH1   => A1_COUNTER_LATCH,
		LATCH2   => A2_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT1  => B_EC_A1_ORBIT,
		BCOUNT2  => B_EC_A2_ORBIT
	);
	
	OR_L3T      <= A1_L3T or A2_L3T;
	
	L_EC_OR_L3T : SCOUNTER_2LATCH  generic map(16) port map(
		CLK      => CLK80,                                -- CLOCK: 80MHz
		INPUT    => OR_L3T,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH1   => A1_COUNTER_LATCH,
		LATCH2   => A2_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT1  => B_EC_A1_OR_L3T,
		BCOUNT2  => B_EC_A2_OR_L3T
	);
	
	L_EC_ATLAS_L1_LHCF : SCOUNTER_2LATCH  generic map(16) port map(
		CLK      => CLK80,                                -- CLOCK: 80MHz
		INPUT    => ATLAS_L1_LHCF,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH1   => A1_COUNTER_LATCH2,
		LATCH2   => A2_COUNTER_LATCH2,
		CLEAR    => '0',
		BCOUNT1  => B_EC_A1_ATLAS_L1_LHCF,
		BCOUNT2  => B_EC_A2_ATLAS_L1_LHCF
	);
	
	SHOWER_BPTXX_AND   <= A1_SHOWER_BPTXX or A2_SHOWER_BPTXX;
	
	L_EC_SHOWER_BPTXX_AND : SCOUNTER_2LATCH generic map(16) port map(
		CLK      => CLK80,
		INPUT    => SHOWER_BPTXX_AND,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH1   => A1_COUNTER_LATCH,
		LATCH2   => A2_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT1  => B_EC_A1_SHOWER_BPTXX_AND,
		BCOUNT2  => B_EC_A2_SHOWER_BPTXX_AND
	);
	
	FC_TRG_AND <= A1_FCL_OR and A2_FCL_OR;
	
	L_EC_FC_TRG_AND : SCOUNTER_2LATCH generic map(24) port map(
		CLK      => CLK80,
		INPUT    => FC_TRG_AND,
		CLR      => ECR,
		INHIBIT  => '0',
		LATCH1   => A1_COUNTER_LATCH,
		LATCH2   => A2_COUNTER_LATCH,
		CLEAR    => '0',
		BCOUNT1  => B_EC_A1_FC_TRG_AND,
		BCOUNT2  => B_EC_A2_FC_TRG_AND
	);	

	
	---------------- COUNTER CLEAR WITH ORBIT ------------------------------------------
	L_OC_CLK : CLK_COUNTER3 generic map(16) port map(
		CLK     =>  CLK ,
		CLR     =>  ORBIT_SYC,
		INHIBIT =>  '0',
		LATCH1  =>  A1_COUNTER_LATCH,
		LATCH2  =>  A2_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT1 =>  B_OC_A1_CLK,
		BCOUNT2 =>  B_OC_A2_CLK
	);
	
	L_OC_LDBPTX1 : SCOUNTER_2LATCH generic map(8) port map(
		CLK     =>  CLK80,
		INPUT   =>  LD_BPTX1,
		CLR     =>  ORBIT_SYC,
		INHIBIT =>  '0',
		LATCH1  =>  A1_COUNTER_LATCH,
		LATCH2  =>  A2_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT1 =>  B_OC_A1_BPTX1,
		BCOUNT2 =>  B_OC_A2_BPTX1
	);
	
	L_OC_LDBPTX2 : SCOUNTER_2LATCH generic map(8) port map(
		CLK     =>  CLK80,
		INPUT   =>  LD_BPTX2,
		CLR     =>  ORBIT_SYC,
		INHIBIT =>  '0',
		LATCH1  =>  A1_COUNTER_LATCH,
		LATCH2  =>  A2_COUNTER_LATCH,
		CLEAR   =>  '0',	
		BCOUNT1 =>  B_OC_A1_BPTX2,
		BCOUNT2 =>  B_OC_A2_BPTX2
	);

	
	---------------- COUNTER CLEAR WITH ATLAS_ECR -----------------------------------------
	L_AC_CLK : CLK_COUNTER3  generic map(32) port map(
		CLK     =>  CLK ,
		CLR     =>  ATLAS_ECR_SYC,
		INHIBIT =>  '0',
		LATCH1  =>  A1_COUNTER_LATCH2,
		LATCH2  =>  A2_COUNTER_LATCH2,
		CLEAR   =>  '0',	
		BCOUNT1 =>  B_AC_A1_CLK,
		BCOUNT2 =>  B_AC_A2_CLK
	);

	L_AC_ATLAS_L1A : SCOUNTER_2LATCH generic map(32) port map(
		CLK     =>  CLK,
		INPUT   =>  ATLAS_L1A_SYC,
		CLR     =>  ATLAS_ECR_SYC,
		INHIBIT =>  '0',
		LATCH1  =>  A1_COUNTER_LATCH2,
		LATCH2  =>  A2_COUNTER_LATCH2,
		CLEAR   =>  '0',	
		BCOUNT1 =>  B_AC_A1_ATLAS_L1A,
		BCOUNT2 =>  B_AC_A2_ATLAS_L1A
	);
	
	--***************************************************************************************
	--*************************************** END COUNTER LOGIC *****************************
	--***************************************************************************************
	
	--***************************************************************************************
	--*************************************** START FLAG LOGIC ******************************
	--***************************************************************************************
	
--	A1_DELAY_DL1T: INTERNALCOUNTER generic map(4) port map(
--		-- in
--		CLK          => CLK80,
--		START        => A1_DL1T,
--		PRESET       => "0000",
--		-- out
--		STAT         => open,
--		ENDMARK      => A1_DDL1T
--	);
	
	FL_A1_LD_BPTX_1 : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_DL1T,
	  CLR		=> '0',
	  INPUT	=> LD_BPTX1,
	  OUTPUT => F_A1_LD_BPTX1
	);
	
	FL_A1_LD_BPTX_2 : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_DL1T,
	  CLR		=> '0',
	  INPUT	=> LD_BPTX2,
	  OUTPUT => F_A1_LD_BPTX2
	);
	
	FL_A1_LD_BPTXAND : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_DL1T,
	  CLR		=> '0',
	  INPUT	=> LD_BPTX_AND,
	  OUTPUT => F_A1_LD_BPTX_AND
	);
	
	FL_A1_LASER_SYC : BUFFER_SIGNAL port map (
	  CLK		=> CLK,
	  LATCH	=> A1_L1T,
	  CLR		=> '0',
	  INPUT	=> LASER,
	  OUTPUT => F_A1_LASER
	);
	
	FL_A1_L2T_SHOWER : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_L3T,
	  CLR		=> '0',
	  INPUT	=> A1_L2T_SHOWER,
	  OUTPUT => F_A1_L2T_SHOWER
	);
	
	FL_A1_L2T_SPECIAL : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_L3T,
	  CLR		=> '0',
	  INPUT	=> A1_L2T_SPECIAL,
	  OUTPUT => F_A1_L2T_SPECIAL
	);
	
	FL_A1_L2T_PEDE : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_L3T,
	  CLR		=> '0',
	  INPUT	=> A1_L2T_PEDE,
	  OUTPUT => F_A1_L2T_PEDE
	);
	
	FL_A1_L2T_L1T : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_L3T,
	  CLR		=> '0',
	  INPUT	=> A1_L2T_L1T,
	  OUTPUT => F_A1_L2T_L1T
	);
	
	FL_A1_L2T_FC : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_L3T,
	  CLR		=> '0',
	  INPUT	=> A1_L2T_FC,
	  OUTPUT => F_A1_L2T_FC
	);
	
	FL_A1_STRG : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_DL1T,
	  CLR		=> '0',
	  INPUT	=> A1_STRG,
	  OUTPUT => F_A1_STRG
	);
	
	FL_A1_LTRG : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_DL1T,
	  CLR		=> '0',
	  INPUT	=> A1_LTRG,
	  OUTPUT => F_A1_LTRG
	);
	
	FL_A1_BEAM_FLAG : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_L3T,
	  CLR		=> '0',
	  INPUT	=> A1_BEAM_FLAG,
	  OUTPUT => F_A1_BEAM_FLAG
	);
	
	FL_A1_PEDE_FLAG : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_L3T,
	  CLR		=> '0',
	  INPUT	=> A1_PEDE_FLAG,
	  OUTPUT => F_A1_PEDE_FLAG
	);
	
	ATLAS_L1T_WIDTH : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  ATLAS_L1A_SYC,
		PRESET       =>  "0101",
		STAT         =>  ATLAS_L1A_LONG,
		ENDMARK      =>  open
	);
	
	FL_A1_ATLAS_L1A : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_COUNTER_LATCH2,
	  CLR		=> '0',
	  INPUT	=> ATLAS_L1A_LONG,
	  OUTPUT => F_A1_ATLAS_L1A
	);
	
	FL_A1_L1T : BUFFER_SIGNAL port map (
	  CLK		=> CLK,
	  LATCH	=> A1_L1T,
	  CLR		=> '0',
	  INPUT	=> A1_L1T,
	  OUTPUT => F_A1_L1T
	);
	
	FL_A1_L3T : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_L3T,
	  CLR		=> '0',
	  INPUT	=> A1_L3T,
	  OUTPUT => F_A1_L3T
	);
	
	FL_A1_ENABLE : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_DL1T,
	  CLR		=> '0',
	  INPUT	=> A1_ENABLE,
	  OUTPUT => F_A1_ENABLE
	);
	
	FL_A1_SHOWER_BPTXX : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_DL1T,
	  CLR		=> '0',
	  INPUT	=> A1_SHOWER_BPTXX,
	  OUTPUT => F_A1_SHOWER_BPTXX
	);
	
	FL_A1_A2_L1T : BUFFER_SIGNAL port map (
	  CLK		=> CLK,
	  LATCH	=> A1_L1T,
	  CLR		=> '0',
	  INPUT	=> A2_L1T,
	  OUTPUT => F_A1_A2_L1T
	);
	
	FL_A1_A2_L3T : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_L3T,
	  CLR		=> '0',
	  INPUT	=> A2_L3T,
	  OUTPUT => F_A1_A2_L3T
	);
	
	FL_A1_A2_ENABLE : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_DL1T,
	  CLR		=> '0',
	  INPUT	=> A2_ENABLE,
	  OUTPUT => F_A1_A2_ENABLE
	);
	
	FL_A1_A2_SHOWER_BPTXX : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A1_DL1T,
	  CLR		=> '0',
	  INPUT	=> A2_SHOWER_BPTXX,
	  OUTPUT => F_A1_A2_SHOWER_BPTXX
	);
	
	FLAG_A1_FC : for i in 0 to 3 generate 
		FL_A1_FC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A1_DL1T,
		  CLR		=> '0',
		  INPUT	=> A1_FC2(i),
		  OUTPUT => F_A1_FC2(i)
		);
	end generate;
	
	FLAG_A1_A2_FC : for i in 0 to 3 generate 
		FL_A1_A2_FC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A1_DL1T,
		  CLR		=> '0',
		  INPUT	=> A2_FC2(i),
		  OUTPUT => F_A1_A2_FC2(i)
		);
	end generate;
	
	FLAG_A1_SDSC : for i in 0 to 15 generate 
		FL_A1_SDSC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A1_DL1T,
		  CLR		=> '0',
		  INPUT	=> A1_SDSC2(i),
		  OUTPUT => F_A1_SDSC2(i)
		);
	end generate;
	
	FLAG_A1_LDSC : for i in 0 to 15 generate 
		FL_A1_LDSC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A1_DL1T,
		  CLR		=> '0',
		  INPUT	=> A1_LDSC2(i),
		  OUTPUT => F_A1_LDSC2(i)
		);
	end generate;
	
	FLAG_A1_A2_SDSC : for i in 0 to 15 generate 
		FL_A1_A2_SDSC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A1_DL1T,
		  CLR		=> '0',
		  INPUT	=> A2_SDSC2(i),
		  OUTPUT => F_A1_A2_SDSC2(i)
		);
	end generate;
	
	FLAG_A1_A2_LDSC : for i in 0 to 15 generate 
		FL_A1_A2_LDSC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A1_DL1T,
		  CLR		=> '0',
		  INPUT	=> A2_LDSC2(i),
		  OUTPUT => F_A1_A2_LDSC2(i)
		);
	end generate;
	
	A1_EVENT_FLAGS1(0)  <=  F_A1_LD_BPTX1;
	A1_EVENT_FLAGS1(1)  <=  F_A1_LD_BPTX2;
	A1_EVENT_FLAGS1(2)  <=  F_A1_LD_BPTX_AND;
	A1_EVENT_FLAGS1(3)  <=  F_A1_LASER;
	A1_EVENT_FLAGS1(4)  <=  F_A1_L2T_SHOWER;
	A1_EVENT_FLAGS1(5)  <=  F_A1_L2T_SPECIAL;
	A1_EVENT_FLAGS1(6)  <=  F_A1_L2T_PEDE;	
	A1_EVENT_FLAGS1(7)  <=  F_A1_L2T_L1T;	
	A1_EVENT_FLAGS1(8)  <=  F_A1_L2T_FC;	
	A1_EVENT_FLAGS1(9)  <=  '0';
	A1_EVENT_FLAGS1(10) <=  F_A1_STRG;
	A1_EVENT_FLAGS1(11) <=  F_A1_LTRG;
	A1_EVENT_FLAGS1(12) <=  F_A1_BEAM_FLAG;
	A1_EVENT_FLAGS1(13) <=  F_A1_PEDE_FLAG;
	A1_EVENT_FLAGS1(14) <=  '0';
	A1_EVENT_FLAGS1(15) <=  F_A1_ATLAS_L1A;
	
	A1_EVENT_FLAGS1(16)  <=  F_A1_L1T;
	A1_EVENT_FLAGS1(17)  <=  F_A1_L3T;
	A1_EVENT_FLAGS1(18)  <=  F_A1_ENABLE;
	A1_EVENT_FLAGS1(19)  <=  F_A1_SHOWER_BPTXX;
	A1_EVENT_FLAGS1(20)  <=  F_A1_A2_L1T;
	A1_EVENT_FLAGS1(21)  <=  F_A1_A2_L3T;
	A1_EVENT_FLAGS1(22)  <=  F_A1_A2_ENABLE;	
	A1_EVENT_FLAGS1(23)  <=  F_A1_A2_SHOWER_BPTXX;	
	A1_EVENT_FLAGS1(24)  <=  F_A1_FC2(0);	
	A1_EVENT_FLAGS1(25)  <=  F_A1_FC2(1);
	A1_EVENT_FLAGS1(26)  <=  F_A1_FC2(2);
	A1_EVENT_FLAGS1(27)  <=  F_A1_FC2(3);
	A1_EVENT_FLAGS1(28)  <=  F_A1_A2_FC2(0);
	A1_EVENT_FLAGS1(29)  <=  F_A1_A2_FC2(1);
	A1_EVENT_FLAGS1(30)  <=  F_A1_A2_FC2(2);
	A1_EVENT_FLAGS1(31)  <=  F_A1_A2_FC2(3);
	
	A1_EVENT_FLAGS2(15 downto 0)  <= F_A1_SDSC2;
	A1_EVENT_FLAGS2(31 downto 16) <= F_A1_LDSC2;
	
	A1_EVENT_FLAGS3(15 downto 0)  <= F_A1_A2_SDSC2;
	A1_EVENT_FLAGS3(31 downto 16) <= F_A1_A2_LDSC2;
	
	A1_BC_LATCH : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A1_COUNTER_LATCH2,
		PRESET       =>  "0001",          -- To change this parameter, confirm A1_TRANSFER_START timing.
		STAT         =>  open,
		ENDMARK      =>  A1_FLAG_LATCH
	);
	
	A1_B_EVENT_FLAG1 : BUFFER_COUNTER generic map(32) port map(
		CLK     => CLK80,
		LATCH   => A1_FLAG_LATCH,
		CLEAR   => '0',
		COUNT   => A1_EVENT_FLAGS1,
		BCOUNT  => REG_A1_EVENT_FLAGS1
	);
	
	A1_B_EVENT_FLAG2 : BUFFER_COUNTER generic map(32) port map(
		CLK     => CLK80,
		LATCH   => A1_FLAG_LATCH,
		CLEAR   => '0',
		COUNT   => A1_EVENT_FLAGS2,
		BCOUNT  => REG_A1_EVENT_FLAGS2
	);
	
	A1_B_EVENT_FLAG3 : BUFFER_COUNTER generic map(32) port map(
		CLK     => CLK80,
		LATCH   => A1_FLAG_LATCH,
		CLEAR   => '0',
		COUNT   => A1_EVENT_FLAGS3,
		BCOUNT  => REG_A1_EVENT_FLAGS3
	);
	
	--************************************ Arm2 *****************************************
	
--	A2_DELAY_DL1T: INTERNALCOUNTER generic map(4) port map(
--		-- in
--		CLK          => CLK80,
--		START        => A2_DL1T,
--		PRESET       => "0000",
--		-- out
--		STAT         => open,
--		ENDMARK      => A2_DDL1T
--	);
	
	FL_A2_LD_BPTX_1 : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_DL1T,
	  CLR		=> '0',
	  INPUT	=> LD_BPTX1,
	  OUTPUT => F_A2_LD_BPTX1
	);
	
	FL_A2_LD_BPTX_2 : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_DL1T,
	  CLR		=> '0',
	  INPUT	=> LD_BPTX2,
	  OUTPUT => F_A2_LD_BPTX2
	);
	
	FL_A2_LD_BPTXAND : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_DL1T,
	  CLR		=> '0',
	  INPUT	=> LD_BPTX_AND,
	  OUTPUT => F_A2_LD_BPTX_AND
	);
	
	FL_A2_LASER_SYC : BUFFER_SIGNAL port map (
	  CLK		=> CLK,
	  LATCH	=> A2_L1T,
	  CLR		=> '0',
	  INPUT	=> LASER,
	  OUTPUT => F_A2_LASER
	);
	
	FL_A2_L2T_SHOWER : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_L3T,
	  CLR		=> '0',
	  INPUT	=> A2_L2T_SHOWER,
	  OUTPUT => F_A2_L2T_SHOWER
	);
	
	FL_A2_L2T_SPECIAL : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_L3T,
	  CLR		=> '0',
	  INPUT	=> A2_L2T_SPECIAL,
	  OUTPUT => F_A2_L2T_SPECIAL
	);
	
	FL_A2_L2T_PEDE : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_L3T,
	  CLR		=> '0',
	  INPUT	=> A2_L2T_PEDE,
	  OUTPUT => F_A2_L2T_PEDE
	);
	
	FL_A2_L2T_L1T : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_L3T,
	  CLR		=> '0',
	  INPUT	=> A2_L2T_L1T,
	  OUTPUT => F_A2_L2T_L1T
	);
	
	FL_A2_L2T_FC : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_L3T,
	  CLR		=> '0',
	  INPUT	=> A2_L2T_FC,
	  OUTPUT => F_A2_L2T_FC
	);
	
	FL_A2_STRG : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_DL1T,
	  CLR		=> '0',
	  INPUT	=> A2_STRG,
	  OUTPUT => F_A2_STRG
	);
	
	FL_A2_LTRG : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_DL1T,
	  CLR		=> '0',
	  INPUT	=> A2_LTRG,
	  OUTPUT => F_A2_LTRG
	);
	
	FL_A2_BEAM_FLAG : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_L3T,
	  CLR		=> '0',
	  INPUT	=> A2_BEAM_FLAG,
	  OUTPUT => F_A2_BEAM_FLAG
	);
	
	FL_A2_PEDE_FLAG : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_L3T,
	  CLR		=> '0',
	  INPUT	=> A2_PEDE_FLAG,
	  OUTPUT => F_A2_PEDE_FLAG
	);
	
	FL_A2_ATLAS_L1A : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_COUNTER_LATCH2,
	  CLR		=> '0',
	  INPUT	=> ATLAS_L1A_LONG,
	  OUTPUT => F_A2_ATLAS_L1A
	);
	
	FL_A2_L1T : BUFFER_SIGNAL port map (
	  CLK		=> CLK,
	  LATCH	=> A2_L1T,
	  CLR		=> '0',
	  INPUT	=> A2_L1T,
	  OUTPUT => F_A2_L1T
	);
	
	FL_A2_L3T : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_L3T,
	  CLR		=> '0',
	  INPUT	=> A2_L3T,
	  OUTPUT => F_A2_L3T
	);
	
	FL_A2_ENABLE : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_DL1T,
	  CLR		=> '0',
	  INPUT	=> A2_ENABLE,
	  OUTPUT => F_A2_ENABLE
	);
	
	FL_A2_SHOWER_BPTXX : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_DL1T,
	  CLR		=> '0',
	  INPUT	=> A2_SHOWER_BPTXX,
	  OUTPUT => F_A2_SHOWER_BPTXX
	);
	
	FL_A2_A1_L1T : BUFFER_SIGNAL port map (
	  CLK		=> CLK,
	  LATCH	=> A2_L1T,
	  CLR		=> '0',
	  INPUT	=> A1_L1T,
	  OUTPUT => F_A2_A1_L1T
	);
	
	FL_A2_A1_L3T : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_L3T,
	  CLR		=> '0',
	  INPUT	=> A1_L3T,
	  OUTPUT => F_A2_A1_L3T
	);
	
	FL_A2_A1_ENABLE : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_DL1T,
	  CLR		=> '0',
	  INPUT	=> A1_ENABLE,
	  OUTPUT => F_A2_A1_ENABLE
	);
	
	FL_A2_A1_SHOWER_BPTXX : BUFFER_SIGNAL port map (
	  CLK		=> CLK80,
	  LATCH	=> A2_DL1T,
	  CLR		=> '0',
	  INPUT	=> A1_SHOWER_BPTXX,
	  OUTPUT => F_A2_A1_SHOWER_BPTXX
	);
	
	FLAG_A2_FC : for i in 0 to 3 generate 
		FL_A2_FC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A2_DL1T,
		  CLR		=> '0',
		  INPUT	=> A2_FC2(i),
		  OUTPUT => F_A2_FC2(i)
		);
	end generate;
	
	FLAG_A2_A1_FC : for i in 0 to 3 generate 
		FL_A2_A1_FC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A2_DL1T,
		  CLR		=> '0',
		  INPUT	=> A1_FC2(i),
		  OUTPUT => F_A2_A1_FC2(i)
		);
	end generate;
	
	FLAG_A2_SDSC : for i in 0 to 15 generate 
		FL_A2_SDSC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A2_DL1T,
		  CLR		=> '0',
		  INPUT	=> A2_SDSC2(i),
		  OUTPUT => F_A2_SDSC2(i)
		);
	end generate;
	
	FLAG_A2_LDSC : for i in 0 to 15 generate 
		FL_A2_LDSC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A2_DL1T,
		  CLR		=> '0',
		  INPUT	=> A2_LDSC2(i),
		  OUTPUT => F_A2_LDSC2(i)
		);
	end generate;
	
	FLAG_A2_A1_SDSC : for i in 0 to 15 generate 
		FL_A2_A1_SDSC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A2_DL1T,
		  CLR		=> '0',
		  INPUT	=> A1_SDSC2(i),
		  OUTPUT => F_A2_A1_SDSC2(i)
		);
	end generate;
	
	FLAG_A2_A1_LDSC : for i in 0 to 15 generate 
		FL_A2_A1_LDSC : BUFFER_SIGNAL port map (
		  CLK		=> CLK80,
		  LATCH	=> A2_DL1T,
		  CLR		=> '0',
		  INPUT	=> A1_LDSC2(i),
		  OUTPUT => F_A2_A1_LDSC2(i)
		);
	end generate;	
	
	A2_EVENT_FLAGS1(0)  <=  F_A2_LD_BPTX1;
	A2_EVENT_FLAGS1(1)  <=  F_A2_LD_BPTX2;
	A2_EVENT_FLAGS1(2)  <=  F_A2_LD_BPTX_AND;
	A2_EVENT_FLAGS1(3)  <=  F_A2_LASER;
	A2_EVENT_FLAGS1(4)  <=  F_A2_L2T_SHOWER;
	A2_EVENT_FLAGS1(5)  <=  F_A2_L2T_SPECIAL;
	A2_EVENT_FLAGS1(6)  <=  F_A2_L2T_PEDE;	
	A2_EVENT_FLAGS1(7)  <=  F_A2_L2T_L1T;	
	A2_EVENT_FLAGS1(8)  <=  F_A2_L2T_FC;	
	A2_EVENT_FLAGS1(9)  <=  '0';
	A2_EVENT_FLAGS1(10) <=  F_A2_STRG;
	A2_EVENT_FLAGS1(11) <=  F_A2_LTRG;
	A2_EVENT_FLAGS1(12) <=  F_A2_BEAM_FLAG;
	A2_EVENT_FLAGS1(13) <=  F_A2_PEDE_FLAG;
	A2_EVENT_FLAGS1(14) <=  '0';
	A2_EVENT_FLAGS1(15) <=  F_A2_ATLAS_L1A;
	
	A2_EVENT_FLAGS1(16)  <=  F_A2_L1T;
	A2_EVENT_FLAGS1(17)  <=  F_A2_L3T;
	A2_EVENT_FLAGS1(18)  <=  F_A2_ENABLE;
	A2_EVENT_FLAGS1(19)  <=  F_A2_SHOWER_BPTXX;
	A2_EVENT_FLAGS1(20)  <=  F_A2_A1_L1T;
	A2_EVENT_FLAGS1(21)  <=  F_A2_A1_L3T;
	A2_EVENT_FLAGS1(22)  <=  F_A2_A1_ENABLE;	
	A2_EVENT_FLAGS1(23)  <=  F_A2_A1_SHOWER_BPTXX;	
	A2_EVENT_FLAGS1(24)  <=  F_A2_FC2(0);	
	A2_EVENT_FLAGS1(25)  <=  F_A2_FC2(1);
	A2_EVENT_FLAGS1(26)  <=  F_A2_FC2(2);
	A2_EVENT_FLAGS1(27)  <=  F_A2_FC2(3);
	A2_EVENT_FLAGS1(28)  <=  F_A2_A1_FC2(0);
	A2_EVENT_FLAGS1(29)  <=  F_A2_A1_FC2(1);
	A2_EVENT_FLAGS1(30)  <=  F_A2_A1_FC2(2);
	A2_EVENT_FLAGS1(31)  <=  F_A2_A1_FC2(3);
	
	A2_EVENT_FLAGS2(15 downto 0)  <= F_A2_SDSC2;
	A2_EVENT_FLAGS2(31 downto 16) <= F_A2_LDSC2;

	A2_EVENT_FLAGS3(15 downto 0)  <= F_A2_A1_SDSC2;
	A2_EVENT_FLAGS3(31 downto 16) <= F_A2_A1_LDSC2;
	
	A2_BC_LATCH : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A2_COUNTER_LATCH2,
		PRESET       =>  "0001",                 -- To change this parameter, confirm A2_TRANSFER_START timing.
		STAT         =>  open,
		ENDMARK      =>  A2_FLAG_LATCH
	);
	
	A2_B_EVENT_FLAG1 : BUFFER_COUNTER generic map(32) port map(
		CLK     => CLK80,
		LATCH   => A2_FLAG_LATCH,
		CLEAR   => '0',
		COUNT   => A2_EVENT_FLAGS1,
		BCOUNT  => REG_A2_EVENT_FLAGS1
	);
	
	A2_B_EVENT_FLAG2 : BUFFER_COUNTER generic map(32) port map(
		CLK     => CLK80,
		LATCH   => A2_FLAG_LATCH,
		CLEAR   => '0',
		COUNT   => A2_EVENT_FLAGS2,
		BCOUNT  => REG_A2_EVENT_FLAGS2
	);
	
	A2_B_EVENT_FLAG3 : BUFFER_COUNTER generic map(32) port map(
		CLK     => CLK80,
		LATCH   => A2_FLAG_LATCH,
		CLEAR   => '0',
		COUNT   => A2_EVENT_FLAGS3,
		BCOUNT  => REG_A2_EVENT_FLAGS3
	);

	
	--***************************************************************************************
	--*************************************** END FLAG LOGIC ********************************
	--***************************************************************************************
	
	
	--========================================================================================
	--      
	--                                     RAM COUNTER
	--                             Added by Menjo at 2015/03/15
	-- 
	--                            
	--========================================================================================
	
	LOGIC_RC_BPTX1 : LINEDELAY_FIX generic map(20) port map (
		CLK		=> CLK,
		INPUT		=> BPTX1_3,
		OUTPUT	=> RC_BPTX1
	);
	
	LOGIC_RC_BPTX2 : LINEDELAY_FIX generic map(20) port map (
		CLK		=> CLK,
		INPUT		=> BPTX2_3,
		OUTPUT	=> RC_BPTX2
	);
		
	-- SELECT SOURCES OF RAM COUNTERS
	
	RC_SIGNAL1 <= A1_FCL_OR  and LD_BPTX2;
	RC_SIGNAL2 <= A2_FCL_OR  and LD_BPTX1;
	RC_SIGNAL3 <= (A1_SLOGIC or A1_LLOGIC ) and LD_BPTX2;
	RC_SIGNAL4 <= (A2_SLOGIC or A2_LLOGIC ) and LD_BPTX1;
		
	RAM_COUNTER_1 : RAM_COUNTER port map (
		CLK1					=> CLK,
		CLK2					=> LCLK,
		COUNTER_SIGNAL		=> RC_SIGNAL1,
		BUF_INC				=> RC_BPTX2,
		BUF_RESET			=> ORBIT_SYC,
		CLEAR					=> ECR,
		READ_RESET			=> RC_READ_RESET,
		READ_INC				=> RC_READ_INC1,
		DATA_OUT				=> RC_COUNTS1
	);
		
	RAM_COUNTER_2 : RAM_COUNTER port map (
		CLK1					=> CLK,
		CLK2					=> LCLK,
		COUNTER_SIGNAL		=> RC_SIGNAL2,
		BUF_INC				=> RC_BPTX1,
		BUF_RESET			=> ORBIT_SYC,
		CLEAR					=> ECR,
		READ_RESET			=> RC_READ_RESET,
		READ_INC				=> RC_READ_INC2,
		DATA_OUT				=> RC_COUNTS2
	);	
		
	RAM_COUNTER_3 : RAM_COUNTER port map (
		CLK1					=> CLK,
		CLK2					=> LCLK,
		COUNTER_SIGNAL		=> RC_SIGNAL3,
		BUF_INC				=> RC_BPTX2,
		BUF_RESET			=> ORBIT_SYC,
		CLEAR					=> ECR,
		READ_RESET			=> RC_READ_RESET,
		READ_INC				=> RC_READ_INC3,
		DATA_OUT				=> RC_COUNTS3
	);
		
	RAM_COUNTER_4 : RAM_COUNTER port map (
		CLK1					=> CLK,
		CLK2					=> LCLK,
		COUNTER_SIGNAL		=> RC_SIGNAL4,
		BUF_INC				=> RC_BPTX1,
		BUF_RESET			=> ORBIT_SYC,
		CLEAR					=> ECR,
		READ_RESET			=> RC_READ_RESET,
		READ_INC				=> RC_READ_INC4,
		DATA_OUT				=> RC_COUNTS4
	);	
		
	--***************************************************************************************
	--*************************************** DATA TARNSFER  ********************************
	--***************************************************************************************
	

	A1_TRANSF_START : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A1_FLAG_LATCH,
		PRESET       =>  "0011",             -- It must be later than A1_FLAG_LATCH
		STAT         =>  open,
		ENDMARK      =>  A1_TRANSFER_START
	);

	------------------- DATA TRANSFER -----------------------
	A1_SHIFT_A : SHIFT_REG_A port map (
		CLK          => CLK,
		START        => A1_TRANSFER_START,
		SHIFT_EN     => A1_SHIFT_EN,
		COUNT_00     => REG_A1_EVENT_FLAGS1,
		COUNT_01     => REG_A1_EVENT_FLAGS2,
		COUNT_02     => REG_A1_EVENT_FLAGS3,
		COUNT_03     => B_EC_A1_CLK,
		COUNT_04     => B_EC_A1_BPTX1,
		COUNT_05     => B_EC_A1_BPTX2,
		COUNT_06     => B_EC_A1_BPTX_AND,
		COUNT_07     => x"00"&B_EC_A1_ORBIT,
		COUNT_08     => B_EC_A1_L1T,
		COUNT_09     => B_EC_A1_L1T_ENABLE,
		COUNT_10     => BUF_EC_A1_LL_STRG,
		COUNT_11     => BUF_EC_A1_LL_LTRG,
		COUNT_12     => BUF_EC_A1_LL_SLOGIC,
		COUNT_13     => BUF_EC_A1_SP_SHOWER_TRG1,
		COUNT_14     => BUF_EC_A1_SP_SHOWER_BPTXX,
		COUNT_15     => BUF_EC_A1_SP_SPECIAL_TRG1,
		COUNT_16     => BUF_EC_A1_SP_SHOWER_L3T,
		COUNT_17     => BUF_EC_A1_BP_PEDE_L3T,
		COUNT_18	    => BUF_EC_A1_OR_L3T,
		COUNT_19     => BUF_EC_A1_LHCF_SHOWER_AND,
		COUNT_20     => BUF_OC_A1,
		COUNT_21     => B_AC_A1_CLK,
		COUNT_22     => B_AC_A1_ATLAS_L1A,
		COUNT_23     => BUF_EC_A1_SFC_03,
		COUNT_24     => BUF_EC_A1_SFC_13,
		COUNT_25     => BUF_EC_A1_SFC_23,
		COUNT_26     => BUF_EC_A1_FCL_OR,
		COUNT_27     => BUF_EC_A1_FC_TRG,
		COUNT_28     => BUF_EC_A1_FC_SHOWER,
		COUNT_29     => A1_FIFO_0_1,
		COUNT_30     => A1_FIFO_0_2,
		COUNT_31     => A1_FIFO_0_3,
		COUNT_32     => A1_FIFO_1_1,
		COUNT_33     => A1_FIFO_1_2,
		COUNT_34     => A1_FIFO_1_3,
		WR_EN        => A1_WR,
		SHIFT_COUNT  => A1_SHIFT_IN
	);
	
	A1_SHIFT_B : SHIFT_REG_B port map (
		CLK          => CLK,
		WR           => A1_WR,
		SHIFT_EN     => A1_DATA_ENABLE,
		EXTER_EN     => A1_SHIFT_EN,
		INPUT        => A1_SHIFT_IN,
		OUTPUT       => A1_COUNT
	);
	
	A2_TRANSF_START : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A2_FLAG_LATCH,
		PRESET       =>  "0011",             -- It must be later than A2_FLAG_LATCH
		STAT         =>  open,
		ENDMARK      =>  A2_TRANSFER_START
	);
	
	A2_SHIFT_A : SHIFT_REG_A port map (
		CLK          => CLK,
		START        => A2_TRANSFER_START,
		SHIFT_EN     => A2_SHIFT_EN,
		COUNT_00     => REG_A2_EVENT_FLAGS1,
		COUNT_01     => REG_A2_EVENT_FLAGS2,
		COUNT_02     => REG_A2_EVENT_FLAGS3,
		COUNT_03     => B_EC_A2_CLK,
		COUNT_04     => B_EC_A2_BPTX1,
		COUNT_05     => B_EC_A2_BPTX2,
		COUNT_06     => B_EC_A2_BPTX_AND,
		COUNT_07     => x"00"&B_EC_A2_ORBIT,
		COUNT_08     => B_EC_A2_L1T,
		COUNT_09     => B_EC_A2_L1T_ENABLE,
		COUNT_10     => BUF_EC_A2_LL_STRG,
		COUNT_11     => BUF_EC_A2_LL_LTRG,
		COUNT_12     => BUF_EC_A2_LL_SLOGIC,
		COUNT_13     => BUF_EC_A2_SP_SHOWER_TRG1,
		COUNT_14     => BUF_EC_A2_SP_SHOWER_BPTXX,
		COUNT_15     => BUF_EC_A2_SP_SPECIAL_TRG1,
		COUNT_16     => BUF_EC_A2_SP_SHOWER_L3T,
		COUNT_17     => BUF_EC_A2_BP_PEDE_L3T,
		COUNT_18	    => BUF_EC_A2_OR_L3T,
		COUNT_19     => BUF_EC_A2_LHCF_SHOWER_AND,
		COUNT_20     => BUF_OC_A2,
		COUNT_21     => B_AC_A2_CLK,
		COUNT_22     => B_AC_A2_ATLAS_L1A,
		COUNT_23     => BUF_EC_A2_SFC_03,
		COUNT_24     => BUF_EC_A2_SFC_13,
		COUNT_25     => BUF_EC_A2_SFC_23,
		COUNT_26     => BUF_EC_A2_FCL_OR,
		COUNT_27     => BUF_EC_A2_FC_TRG,
		COUNT_28     => BUF_EC_A2_FC_SHOWER,
		COUNT_29     => A2_FIFO_0_1,
		COUNT_30     => A2_FIFO_0_2,
		COUNT_31     => A2_FIFO_0_3,
		COUNT_32     => A2_FIFO_1_1,
		COUNT_33     => A2_FIFO_1_2,
		COUNT_34     => A2_FIFO_1_3,
		WR_EN        => A2_WR,
		SHIFT_COUNT  => A2_SHIFT_IN
	);
	
	A2_SHIFT_B : SHIFT_REG_B port map (
		CLK          => CLK,
		WR           => A2_WR,
		SHIFT_EN     => A2_DATA_ENABLE,
		EXTER_EN     => A2_SHIFT_EN,
		INPUT        => A2_SHIFT_IN,
		OUTPUT       => A2_COUNT
	);
	
	DSC_SCALER_CLEAR_PULSE : CLK_PULSE generic map (4) port map(
		CLK          => CLK,
		INPUT        => DSC_SCALER_CLEAR1,
		PRESET       => "0001",
		OUTPUT       => DSC_SCALER_CLEAR
	);
	
	A1_DSC_COUNTER : DSC_COUNTER port map (
		CLK          => CLK,
		ECR          => DSC_SCALER_CLEAR,
		LATCH        => DSC_SCALER_STOP,
		SDSC2_IN     => A1_SDSC2,
		LDSC2_IN     => A1_LDSC2,
		COUNT_S00    => COUNT_A1_S00,
		COUNT_S01    => COUNT_A1_S01,
		COUNT_S02    => COUNT_A1_S02,
		COUNT_S03    => COUNT_A1_S03,
		COUNT_S04    => COUNT_A1_S04,
		COUNT_S05    => COUNT_A1_S05,
		COUNT_S06    => COUNT_A1_S06,
		COUNT_S07    => COUNT_A1_S07,
		COUNT_S08    => COUNT_A1_S08,
		COUNT_S09    => COUNT_A1_S09,
		COUNT_S10    => COUNT_A1_S10,
		COUNT_S11    => COUNT_A1_S11,
		COUNT_S12    => COUNT_A1_S12,
		COUNT_S13    => COUNT_A1_S13,
		COUNT_S14    => COUNT_A1_S14,
		COUNT_S15    => COUNT_A1_S15,
		
		COUNT_L00    => COUNT_A1_L00,
		COUNT_L01    => COUNT_A1_L01,
		COUNT_L02    => COUNT_A1_L02,
		COUNT_L03    => COUNT_A1_L03,
		COUNT_L04    => COUNT_A1_L04,
		COUNT_L05    => COUNT_A1_L05,
		COUNT_L06    => COUNT_A1_L06,
		COUNT_L07    => COUNT_A1_L07,
		COUNT_L08    => COUNT_A1_L08,
		COUNT_L09    => COUNT_A1_L09,
		COUNT_L10    => COUNT_A1_L10,
		COUNT_L11    => COUNT_A1_L11,
		COUNT_L12    => COUNT_A1_L12,
		COUNT_L13    => COUNT_A1_L13,
		COUNT_L14    => COUNT_A1_L14,
		COUNT_L15    => COUNT_A1_L15
	);
	
	
	A2_DSC_COUNTER : DSC_COUNTER port map (
		CLK          => CLK,
		ECR          => DSC_SCALER_CLEAR,
		LATCH        => DSC_SCALER_STOP,
		SDSC2_IN     => A2_SDSC2,
		LDSC2_IN     => A2_LDSC2,
		COUNT_S00    => COUNT_A2_S00,
		COUNT_S01    => COUNT_A2_S01,
		COUNT_S02    => COUNT_A2_S02,
		COUNT_S03    => COUNT_A2_S03,
		COUNT_S04    => COUNT_A2_S04,
		COUNT_S05    => COUNT_A2_S05,
		COUNT_S06    => COUNT_A2_S06,
		COUNT_S07    => COUNT_A2_S07,
		COUNT_S08    => COUNT_A2_S08,
		COUNT_S09    => COUNT_A2_S09,
		COUNT_S10    => COUNT_A2_S10,
		COUNT_S11    => COUNT_A2_S11,
		COUNT_S12    => COUNT_A2_S12,
		COUNT_S13    => COUNT_A2_S13,
		COUNT_S14    => COUNT_A2_S14,
		COUNT_S15    => COUNT_A2_S15,
		
		COUNT_L00    => COUNT_A2_L00,
		COUNT_L01    => COUNT_A2_L01,
		COUNT_L02    => COUNT_A2_L02,
		COUNT_L03    => COUNT_A2_L03,
		COUNT_L04    => COUNT_A2_L04,
		COUNT_L05    => COUNT_A2_L05,
		COUNT_L06    => COUNT_A2_L06,
		COUNT_L07    => COUNT_A2_L07,
		COUNT_L08    => COUNT_A2_L08,
		COUNT_L09    => COUNT_A2_L09,
		COUNT_L10    => COUNT_A2_L10,
		COUNT_L11    => COUNT_A2_L11,
		COUNT_L12    => COUNT_A2_L12,
		COUNT_L13    => COUNT_A2_L13,
		COUNT_L14    => COUNT_A2_L14,
		COUNT_L15    => COUNT_A2_L15
	);
	------------------- VME ACCESS -----------------------
	VME_LB_INT: LB_INT port map (
		-- Local Bus in/out signals
		nLBRES       => nLBRES,
		nBLAST       => nBLAST,   
		WnR          => WnR,      
		nADS         => nADS,     
		LCLK         => LCLK,      
		nREADY       => nREADY,   
		nINT         => nINT,		
		LAD          => LAD,

		-- Internal Registers
		-------------READ/WRITE---------------
		REG_A1_L1T_MASK               => REG_BUF_A1_L1T_MASK,
		REG_A1_SHOWER_MASK            => REG_BUF_A1_SHOWER_MASK,
		REG_A1_FC_MASK                => REG_BUF_A1_FC_MASK,
		REG_A1_L3T_MASK               => REG_BUF_A1_L3T_MASK,
		REG_A1_SHOWER_P               => REG_BUF_A1_SHOWER_P,
		REG_A1_L2T_L1T_P              => REG_BUF_A1_L2T_L1T_P,
		REG_A1_LATCH_STOP_P           => REG_BUF_A1_LATCH_STOP_P,	
		REG_A1_SELFVETO_P             => REG_BUF_A1_SELFVETO_P,
		
		REG_A2_L1T_MASK               => REG_BUF_A2_L1T_MASK,
		REG_A2_SHOWER_MASK            => REG_BUF_A2_SHOWER_MASK,
		REG_A2_FC_MASK                => REG_BUF_A2_FC_MASK,
		REG_A2_L3T_MASK               => REG_BUF_A2_L3T_MASK,
		REG_A2_SHOWER_P               => REG_BUF_A2_SHOWER_P,
		REG_A2_L2T_L1T_P              => REG_BUF_A2_L2T_L1T_P,
		REG_A2_LATCH_STOP_P           => REG_BUF_A2_LATCH_STOP_P,
		REG_A2_SELFVETO_P             => REG_BUF_A2_SELFVETO_P,
		
		REG_COMMON_MASK               => REG_BUF_COMMON_MASK,
		REG_ATLAS_MASK                => REG_BUF_ATLAS_MASK,
		REG_SEL_ECR                   => REG_BUF_SEL_ECR,
		REG_DL1T_DL3T_P               => REG_BUF_DL1T_DL3T_P,
		REG_ATLAS_P						   => REG_BUF_ATLAS_P,
		REG_LASER_PEDE_P              => REG_BUF_LASER_PEDE_P,
		REG_LASER_GEN_P               => REG_BUF_LASER_GEN_P,
		REG_LASER_GEN_ENABLE          => REG_BUF_LASER_GEN_ENABLE,

		REG_TESTOUT1_MASK          => REG_BUF_TESTOUT1_MASK,
		REG_TESTOUT2_MASK          => REG_BUF_TESTOUT2_MASK,
		REG_TESTOUT3_MASK          => REG_BUF_TESTOUT3_MASK,
		REG_TESTOUT4_MASK          => REG_BUF_TESTOUT4_MASK,
		-------------READ---------------			
		REG_STATUS                 => x"0000"&REG_STATUS,
		
		A1_COUNT_00     => REG_A1_EVENT_FLAGS1,
		A1_COUNT_01     => REG_A1_EVENT_FLAGS2,
		A1_COUNT_02     => REG_A1_EVENT_FLAGS3,
		A1_COUNT_03     => B_EC_A1_CLK,
		A1_COUNT_04     => B_EC_A1_BPTX1,
		A1_COUNT_05     => B_EC_A1_BPTX2,
		A1_COUNT_06     => B_EC_A1_BPTX_AND,
		A1_COUNT_07     => BUF_EC_A1_ORBIT,
		A1_COUNT_08     => B_EC_A1_L1T,
		A1_COUNT_09     => B_EC_A1_L1T_ENABLE,
		A1_COUNT_10     => BUF_EC_A1_LL_STRG,
		A1_COUNT_11     => BUF_EC_A1_LL_LTRG,
		A1_COUNT_12     => BUF_EC_A1_LL_SLOGIC,
		A1_COUNT_13     => BUF_EC_A1_SP_SHOWER_TRG1,
		A1_COUNT_14     => BUF_EC_A1_SP_SHOWER_BPTXX,
		A1_COUNT_15     => BUF_EC_A1_SP_SPECIAL_TRG1,
		A1_COUNT_16     => BUF_EC_A1_SP_SHOWER_L3T,
		A1_COUNT_17     => BUF_EC_A1_BP_PEDE_L3T,
		A1_COUNT_18	    => BUF_EC_A1_OR_L3T,
		A1_COUNT_19     => BUF_EC_A1_LHCF_SHOWER_AND,
		A1_COUNT_20     => BUF_OC_A1,
		A1_COUNT_21     => B_AC_A1_CLK,
		A1_COUNT_22     => B_AC_A1_ATLAS_L1A,
		A1_COUNT_23     => BUF_EC_A1_SFC_03,
		A1_COUNT_24     => BUF_EC_A1_SFC_13,
		A1_COUNT_25     => BUF_EC_A1_SFC_23,
		A1_COUNT_26     => BUF_EC_A1_FCL_OR,
		A1_COUNT_27     => BUF_EC_A1_FC_TRG,
		A1_COUNT_28     => BUF_EC_A1_FC_SHOWER,
		A1_COUNT_29     => A1_FIFO_0_0,
		A1_COUNT_30     => A1_FIFO_0_1,
		A1_COUNT_31     => A1_FIFO_0_2,
		A1_COUNT_32     => A1_FIFO_1_0,
		A1_COUNT_33     => A1_FIFO_1_1,
		A1_COUNT_34     => A1_FIFO_1_2,
		
		-------------
		A2_COUNT_00     => REG_A2_EVENT_FLAGS1,
		A2_COUNT_01     => REG_A2_EVENT_FLAGS2,
		A2_COUNT_02     => REG_A2_EVENT_FLAGS3,
		A2_COUNT_03     => B_EC_A2_CLK,
		A2_COUNT_04     => B_EC_A2_BPTX1,
		A2_COUNT_05     => B_EC_A2_BPTX2,
		A2_COUNT_06     => B_EC_A2_BPTX_AND,
		A2_COUNT_07     => BUF_EC_A2_ORBIT,
		A2_COUNT_08     => B_EC_A2_L1T,
		A2_COUNT_09     => B_EC_A2_L1T_ENABLE,
		A2_COUNT_10     => BUF_EC_A2_LL_STRG,
		A2_COUNT_11     => BUF_EC_A2_LL_LTRG,
		A2_COUNT_12     => BUF_EC_A2_LL_SLOGIC,
		A2_COUNT_13     => BUF_EC_A2_SP_SHOWER_TRG1,
		A2_COUNT_14     => BUF_EC_A2_SP_SHOWER_BPTXX,
		A2_COUNT_15     => BUF_EC_A2_SP_SPECIAL_TRG1,
		A2_COUNT_16     => BUF_EC_A2_SP_SHOWER_L3T,
		A2_COUNT_17     => BUF_EC_A2_BP_PEDE_L3T,
		A2_COUNT_18	    => BUF_EC_A2_OR_L3T,
		A2_COUNT_19     => BUF_EC_A2_LHCF_SHOWER_AND,
		A2_COUNT_20     => BUF_OC_A2,
		A2_COUNT_21     => B_AC_A2_CLK,
		A2_COUNT_22     => B_AC_A2_ATLAS_L1A,
		A2_COUNT_23     => BUF_EC_A2_SFC_03,
		A2_COUNT_24     => BUF_EC_A2_SFC_13,
		A2_COUNT_25     => BUF_EC_A2_SFC_23,
		A2_COUNT_26     => BUF_EC_A2_FCL_OR,
		A2_COUNT_27     => BUF_EC_A2_FC_TRG,
		A2_COUNT_28     => BUF_EC_A2_FC_SHOWER,
		A2_COUNT_29     => A2_FIFO_0_0,
		A2_COUNT_30     => A2_FIFO_0_1,
		A2_COUNT_31     => A2_FIFO_0_2,
		A2_COUNT_32     => A2_FIFO_1_0,
		A2_COUNT_33     => A2_FIFO_1_1,
		A2_COUNT_34     => A2_FIFO_1_2,
		VERSION         => x"0000"&VERSION,
		----------- PLUSE GENERATE BY VME ACCESS -------------- 
		A1_LATCH_STOP_INTERNAL1    =>  A1_LATCH_STOP_INTERNAL1,
		PRESET_CLEAR               =>  PRESET_CLEAR1,
		ECR_INTERNAL1              =>  ECR_INTERNAL1,  --SYC WITH need
		A1_COUNTER_LATCH_INTERNAL1 =>  A1_COUNTER_LATCH_INTERNAL1,  --SYC WIDTH need
		--
		A2_LATCH_STOP_INTERNAL1    =>  A2_LATCH_STOP_INTERNAL1,
		A2_COUNTER_LATCH_INTERNAL1 =>  A2_COUNTER_LATCH_INTERNAL1,  --SYC WIDTH need
		DSC_SCALER_STOP            =>  DSC_SCALER_STOP,
		DSC_SCALER_CLEAR           =>  DSC_SCALER_CLEAR1,
		------------------ FOR RAM_COUNTERS	----------------------	
		RC_COUNTS1		 => RC_COUNTS1,
		RC_COUNTS2		 => RC_COUNTS2,		
		RC_COUNTS3		 => RC_COUNTS3,
		RC_COUNTS4		 => RC_COUNTS4,
		RC_READ_RESET	 => RC_READ_RESET,
		RC_READ_INC1	 => RC_READ_INC1,
		RC_READ_INC2	 => RC_READ_INC2,		
		RC_READ_INC3	 => RC_READ_INC3,
		RC_READ_INC4	 => RC_READ_INC4,	
		
		------------- FOR DISCRIMINATOR SCLEAR	------------
		--Arm1
		A1_COUNT_S00    => COUNT_A1_S00,
		A1_COUNT_S01    => COUNT_A1_S01,
		A1_COUNT_S02    => COUNT_A1_S02,
		A1_COUNT_S03    => COUNT_A1_S03,
		A1_COUNT_S04    => COUNT_A1_S04,
		A1_COUNT_S05    => COUNT_A1_S05,
		A1_COUNT_S06    => COUNT_A1_S06,
		A1_COUNT_S07    => COUNT_A1_S07,
		A1_COUNT_S08    => COUNT_A1_S08,
		A1_COUNT_S09    => COUNT_A1_S09,
		A1_COUNT_S10    => COUNT_A1_S10,
		A1_COUNT_S11    => COUNT_A1_S11,
		A1_COUNT_S12    => COUNT_A1_S12,
		A1_COUNT_S13    => COUNT_A1_S13,
		A1_COUNT_S14    => COUNT_A1_S14,
		A1_COUNT_S15    => COUNT_A1_S15,
		
		A1_COUNT_L00    => COUNT_A1_L00,
		A1_COUNT_L01    => COUNT_A1_L01,
		A1_COUNT_L02    => COUNT_A1_L02,
		A1_COUNT_L03    => COUNT_A1_L03,
		A1_COUNT_L04    => COUNT_A1_L04,
		A1_COUNT_L05    => COUNT_A1_L05,
		A1_COUNT_L06    => COUNT_A1_L06,
		A1_COUNT_L07    => COUNT_A1_L07,
		A1_COUNT_L08    => COUNT_A1_L08,
		A1_COUNT_L09    => COUNT_A1_L09,
		A1_COUNT_L10    => COUNT_A1_L10,
		A1_COUNT_L11    => COUNT_A1_L11,
		A1_COUNT_L12    => COUNT_A1_L12,
		A1_COUNT_L13    => COUNT_A1_L13,
		A1_COUNT_L14    => COUNT_A1_L14,
		A1_COUNT_L15    => COUNT_A1_L15,
		--Arm2
	   A2_COUNT_S00    => COUNT_A2_S00,
		A2_COUNT_S01    => COUNT_A2_S01,
		A2_COUNT_S02    => COUNT_A2_S02,
		A2_COUNT_S03    => COUNT_A2_S03,
		A2_COUNT_S04    => COUNT_A2_S04,
		A2_COUNT_S05    => COUNT_A2_S05,
		A2_COUNT_S06    => COUNT_A2_S06,
		A2_COUNT_S07    => COUNT_A2_S07,
		A2_COUNT_S08    => COUNT_A2_S08,
		A2_COUNT_S09    => COUNT_A2_S09,
		A2_COUNT_S10    => COUNT_A2_S10,
		A2_COUNT_S11    => COUNT_A2_S11,
		A2_COUNT_S12    => COUNT_A2_S12,
		A2_COUNT_S13    => COUNT_A2_S13,
		A2_COUNT_S14    => COUNT_A2_S14,
		A2_COUNT_S15    => COUNT_A2_S15,
	
		A2_COUNT_L00    => COUNT_A2_L00,
		A2_COUNT_L01    => COUNT_A2_L01,
		A2_COUNT_L02    => COUNT_A2_L02,
		A2_COUNT_L03    => COUNT_A2_L03,
		A2_COUNT_L04    => COUNT_A2_L04,
		A2_COUNT_L05    => COUNT_A2_L05,
		A2_COUNT_L06    => COUNT_A2_L06,
		A2_COUNT_L07    => COUNT_A2_L07,
		A2_COUNT_L08    => COUNT_A2_L08,
		A2_COUNT_L09    => COUNT_A2_L09,
		A2_COUNT_L10    => COUNT_A2_L10,
		A2_COUNT_L11    => COUNT_A2_L11,
		A2_COUNT_L12    => COUNT_A2_L12,
		A2_COUNT_L13    => COUNT_A2_L13,
		A2_COUNT_L14    => COUNT_A2_L14,
		A2_COUNT_L15    => COUNT_A2_L15
		
	);
	
	----------- WRITE TO REGISTER ----------------------------
	A1_SEL_L1T                           <= REG_BUF_A1_L1T_MASK(2 downto 0);
	A1_LD_BPTX_MASK                      <= REG_BUF_A1_L1T_MASK(9 downto 8);
	A1_L2T_L1T_MASK                      <= REG_BUF_A1_L1T_MASK(17 downto 16);
	A1_PEDE_MASK                         <= REG_BUF_A1_L1T_MASK(25 downto 24);
	
	A1_SHOWER_MASK                       <= REG_BUF_A1_SHOWER_MASK(1 downto 0);
	A1_SPECIAL_TRG_MASK                  <= REG_BUF_A1_SHOWER_MASK(9 downto 8);
	A1_SHOWER_SOURCE_MASK                <= REG_BUF_A1_SHOWER_MASK(17 downto 16);
	A1_SPECIAL_SOURCE_MASK               <= REG_BUF_A1_SHOWER_MASK(25 downto 24);
	SEL_A1_SLOGIC_SOURCE                 <= REG_BUF_A1_SHOWER_MASK(28);
	SEL_A1_LLOGIC_SOURCE                 <= REG_BUF_A1_SHOWER_MASK(29);
	
	A1_SEL_L2T_FC                        <= REG_BUF_A1_FC_MASK(3 downto 0);
	A1_FC_MASK                           <= REG_BUF_A1_FC_MASK(15 downto 8);
	A1_SEL_SFC                           <= REG_BUF_A1_FC_MASK(17 downto 16);  --(1 downto 0)
	
	A1_L3T_MASK                          <= REG_BUF_A1_L3T_MASK(4 downto 0);
	A1_LATCH_STOP_MASK                   <= REG_BUF_A1_L3T_MASK(10 downto 8);
	A1_ENABLE_MASK                       <= REG_BUF_A1_L3T_MASK(18 downto 16);
	
	A1_NSTEP_SHOWER_TRG_PRESET           <= REG_BUF_A1_SHOWER_P(5 downto 0);
   A1_NSTEP_SPECIAL_TRG_PRESET          <= REG_BUF_A1_SHOWER_P(13 downto 8);
	
	A1_NSTEP_L2T_L1T_PRESET              <= REG_BUF_A1_L2T_L1T_P(23 downto 0); 
	A1_NCLK_LATCH_STOP_WIDTH             <= REG_BUF_A1_LATCH_STOP_P(23 downto 0);
	A1_NCLK_SELFVETO                     <= REG_BUF_A1_SELFVETO_P(19 downto 0);
--	A1_NCLK_DL1T_PEDE                    <= REG_BUF_A1_SELFVETO_P(30 downto 24);

	-------Arm2----------------
	A2_SEL_L1T                           <= REG_BUF_A2_L1T_MASK(2 downto 0);
	A2_LD_BPTX_MASK                      <= REG_BUF_A2_L1T_MASK(9 downto 8);
	A2_L2T_L1T_MASK                      <= REG_BUF_A2_L1T_MASK(17 downto 16);
	A2_PEDE_MASK                         <= REG_BUF_A2_L1T_MASK(25 downto 24);
	
	A2_SHOWER_MASK                       <= REG_BUF_A2_SHOWER_MASK(1 downto 0);
	A2_SPECIAL_TRG_MASK                  <= REG_BUF_A2_SHOWER_MASK(9 downto 8);
	A2_SHOWER_SOURCE_MASK                <= REG_BUF_A2_SHOWER_MASK(17 downto 16);
	A2_SPECIAL_SOURCE_MASK               <= REG_BUF_A2_SHOWER_MASK(25 downto 24);
	SEL_A2_SLOGIC_SOURCE                 <= REG_BUF_A2_SHOWER_MASK(28);
	SEL_A2_LLOGIC_SOURCE                 <= REG_BUF_A2_SHOWER_MASK(29);
	
	A2_SEL_L2T_FC                        <= REG_BUF_A2_FC_MASK(3 downto 0);
	A2_FC_MASK                           <= REG_BUF_A2_FC_MASK(15 downto 8);
	A2_SEL_SFC                           <= REG_BUF_A2_FC_MASK(17 downto 16);  --(1 downto 0)
	
	A2_L3T_MASK                          <= REG_BUF_A2_L3T_MASK(4 downto 0);
	A2_LATCH_STOP_MASK                   <= REG_BUF_A2_L3T_MASK(10 downto 8);
	A2_ENABLE_MASK                       <= REG_BUF_A2_L3T_MASK(18 downto 16);
	
	A2_NSTEP_SHOWER_TRG_PRESET           <= REG_BUF_A2_SHOWER_P(5 downto 0);
   A2_NSTEP_SPECIAL_TRG_PRESET          <= REG_BUF_A2_SHOWER_P(13 downto 8);
	
	A2_NSTEP_L2T_L1T_PRESET              <= REG_BUF_A2_L2T_L1T_P(23 downto 0); 
	A2_NCLK_LATCH_STOP_WIDTH             <= REG_BUF_A2_LATCH_STOP_P(23 downto 0);
	A2_NCLK_SELFVETO                     <= REG_BUF_A2_SELFVETO_P(19 downto 0);
--	A2_NCLK_DL1T_PEDE                    <= REG_BUF_A2_SELFVETO_P(30 downto 24);
	
	COMMON_FLAG1                         <= REG_BUF_COMMON_MASK(0);
	SEL_COMMON_A1A2                      <= REG_BUF_COMMON_MASK(4);
	SEL_COMMON_L1T                       <= REG_BUF_COMMON_MASK(10 downto 8);
	COMMON_L3T_MASK                      <= REG_BUF_COMMON_MASK(19 downto 16);


	A1_ATLAS_OR_MASK                     <= REG_BUF_ATLAS_MASK(1 downto 0);
	A2_ATLAS_OR_MASK                     <= REG_BUF_ATLAS_MASK(5 downto 4);
	
	A1_ATLAS_AND_MASK                    <= REG_BUF_ATLAS_MASK(9 downto 8);
	A2_ATLAS_AND_MASK                    <= REG_BUF_ATLAS_MASK(13 downto 12);
	
	ENABLE_ATLAS_L1_LHCF						 <= REG_BUF_ATLAS_MASK(16);
   ATLAS_COUNTER_ENABLE_MASK	          <= REG_BUF_ATLAS_MASK(25 downto 24);

	SEL_ECR                              <= REG_BUF_SEL_ECR(0);
	
	NCLK_COUNTER_LATCH2                  <= REG_BUF_ATLAS_P(5 downto 0);
	NCLK_L3T_ATLAS                       <= REG_BUF_ATLAS_P(15 downto 8);
	EN_COUNTER_MAX                       <= REG_BUF_ATLAS_P(31 downto 16);
	
--	NCLK_DELAY_BPTX1                     <= REG_BUF_BPTX_P(6 downto 0);
--	NCLK_DELAY_BPTX2                     <= REG_BUF_BPTX_P(14 downto 8);
	
	NCLK_DL1T                            <= REG_BUF_DL1T_DL3T_P(6 downto 0);
	NCLK_L3TT                            <= REG_BUF_DL1T_DL3T_P(14 downto 8);

	DELAY_LASER_PEDE                     <= REG_BUF_LASER_PEDE_P(11 downto 0);
	PRESET_LASER_GEN                     <= REG_BUF_LASER_PEDE_P(27 downto 16);		
	DELAY_LASER_GEN                      <= REG_BUF_LASER_GEN_P(11 downto 0);
	WIDTH_LASER_GEN                      <= REG_BUF_LASER_GEN_P(23 downto 16);
	DELAY_GEN_LASER                      <= REG_BUF_LASER_GEN_P(31 downto 24);
	LASER_GEN_ENABLE                     <= REG_BUF_LASER_GEN_ENABLE(0);

	TESTOUT1_MASK                        <= REG_BUF_TESTOUT1_MASK(11 downto 0);
	TESTOUT2_MASK                        <= REG_BUF_TESTOUT2_MASK(11 downto 0);
	TESTOUT3_MASK                        <= REG_BUF_TESTOUT3_MASK(11 downto 0);
	TESTOUT4_MASK                        <= REG_BUF_TESTOUT4_MASK(11 downto 0);
	
--	
	REG_STATUS(0)                        <= A1_DAQ_MODE(0);
	REG_STATUS(1)                        <= A1_DAQ_MODE(1);
	REG_STATUS(2)                        <= A2_DAQ_MODE(0);
	REG_STATUS(3)                        <= A2_DAQ_MODE(1);
	REG_STATUS(4)                        <= A1_PC_ENABLE;
	REG_STATUS(5)                        <= A2_PC_ENABLE;
	REG_STATUS(6)                        <= A1_ENABLE;
	REG_STATUS(7)                        <= A2_ENABLE;
	REG_STATUS(8)                        <= A1_BEAM_FLAG;
	REG_STATUS(9)                        <= A2_BEAM_FLAG;
	REG_STATUS(10)                       <= A1_PEDE_FLAG;
	REG_STATUS(11)                       <= A2_PEDE_FLAG;
	REG_STATUS(12)                       <= COMMON_FLAG;
	REG_STATUS(13)                       <= LASER_GEN_ENABLE;
	REG_STATUS(15 downto 14)             <= "00";
	
	--------------- COUNTER VME CONNECTION -----------------
	
	--COUNTER24 TYPE to COUNTER32 TYPE  ------WRITE--------
	BUF_EC_A1_LL_STRG(23 downto 0)          <= B_EC_A1_STRG;                
	BUF_EC_A1_LL_LTRG(23 downto 0)          <= B_EC_A1_LTRG;
	BUF_EC_A1_LL_SLOGIC(23 downto 0)        <= B_EC_A1_SLOGIC;
	BUF_EC_A1_LL_STRG(31 downto 24)         <= B_EC_A1_LLOGIC(7 downto 0);
	BUF_EC_A1_LL_LTRG(31 downto 24)         <= B_EC_A1_LLOGIC(15 downto 8);
	BUF_EC_A1_LL_SLOGIC(31 downto 24)       <= B_EC_A1_LLOGIC(23 downto 16);
	
	BUF_EC_A1_SP_SHOWER_TRG1(23 downto 0)   <= B_EC_A1_SHOWER_TRG1 ;             
	BUF_EC_A1_SP_SHOWER_BPTXX(23 downto 0)  <= B_EC_A1_SHOWER_BPTXX;             
   BUF_EC_A1_SP_SPECIAL_TRG1(23 downto 0)  <= B_EC_A1_SPECIAL_TRG1;
	BUF_EC_A1_SP_SHOWER_TRG1(31 downto 24)  <= B_EC_A1_SPECIAL_BPTXX(7 downto 0);
	BUF_EC_A1_SP_SHOWER_BPTXX(31 downto 24) <= B_EC_A1_SPECIAL_BPTXX(15 downto 8);
	BUF_EC_A1_SP_SPECIAL_TRG1(31 downto 24) <= B_EC_A1_SPECIAL_BPTXX(23 downto 16);
	
	BUF_EC_A1_SP_SHOWER_L3T(15 downto 0)    <= B_EC_A1_SHOWER_L3T;
	BUF_EC_A1_SP_SHOWER_L3T(31 downto 16)   <= B_EC_A1_SPECIAL_L3T;
	
	BUF_EC_A1_LHCF_SHOWER_AND(15 downto 0)  <= B_EC_A1_SHOWER_BPTXX_AND;
	BUF_EC_A1_LHCF_SHOWER_AND(31 downto 16) <= B_EC_A1_ATLAS_L1_LHCF;	
	
	BUF_EC_A1_BP_PEDE_L3T(15 downto 0)      <= B_EC_A1_PEDE_L3T;                   
	BUF_EC_A1_BP_PEDE_L3T(31 downto 16)     <= B_EC_A1_BPTX_L3T; 
	
	BUF_EC_A1_OR_L3T(15 downto 0)           <= B_EC_A1_L3T;  
	BUF_EC_A1_OR_L3T(31 downto 16)          <= B_EC_A1_OR_L3T;
	
	BUF_EC_A1_SFC_03(23 downto 0)           <= B_EC_A1_SFC_0;                       
	BUF_EC_A1_SFC_13(23 downto 0)           <= B_EC_A1_SFC_1;                     
	BUF_EC_A1_SFC_23(23 downto 0)           <= B_EC_A1_SFC_2;

	BUF_EC_A1_SFC_03(31 downto 24)          <= B_EC_A1_SFC_3(7 downto 0);	
	BUF_EC_A1_SFC_13(31 downto 24)          <= B_EC_A1_SFC_3(15 downto 8);
	BUF_EC_A1_SFC_23(31 downto 24)          <= B_EC_A1_SFC_3(23 downto 16);
	
	BUF_EC_A1_FCL_OR(23 downto 0)           <= B_EC_A1_FCL_OR;                       
	BUF_EC_A1_FC_TRG(23 downto 0)           <= B_EC_A1_FC_BPTXX;                     
	BUF_EC_A1_FC_SHOWER(23 downto 0)        <= B_EC_A1_FC_SHOWER;

	BUF_EC_A1_FCL_OR(31 downto 24)          <= B_EC_A1_FC_TRG_AND(7 downto 0);	
	BUF_EC_A1_FC_TRG(31 downto 24)          <= B_EC_A1_FC_TRG_AND(15 downto 8);
	BUF_EC_A1_FC_SHOWER(31 downto 24)       <= B_EC_A1_FC_TRG_AND(23 downto 16);
	BUF_EC_A1_ORBIT(23 downto 0)            <= B_EC_A1_ORBIT;
	BUF_EC_A1_ORBIT(31 downto 24)           <= x"00";
	
	BUF_OC_A1(15 downto 0)                  <= B_OC_A1_CLK;
	BUF_OC_A1(23 downto 16)                 <= B_OC_A1_BPTX1;
	BUF_OC_A1(31 downto 24)                 <= B_OC_A1_BPTX2;
	
	--COUNTER24 TYPE to COUNTER32 TYPE --Arm2  ------WRITE--------
	BUF_EC_A2_LL_STRG(23 downto 0)          <= B_EC_A2_STRG;                
	BUF_EC_A2_LL_LTRG(23 downto 0)          <= B_EC_A2_LTRG;
	BUF_EC_A2_LL_SLOGIC(23 downto 0)        <= B_EC_A2_SLOGIC;
	BUF_EC_A2_LL_STRG(31 downto 24)         <= B_EC_A2_LLOGIC(7 downto 0);
	BUF_EC_A2_LL_LTRG(31 downto 24)         <= B_EC_A2_LLOGIC(15 downto 8);
	BUF_EC_A2_LL_SLOGIC(31 downto 24)       <= B_EC_A2_LLOGIC(23 downto 16);
	
	BUF_EC_A2_SP_SHOWER_TRG1(23 downto 0)   <= B_EC_A2_SHOWER_TRG1 ;             
	BUF_EC_A2_SP_SHOWER_BPTXX(23 downto 0)  <= B_EC_A2_SHOWER_BPTXX;             
   BUF_EC_A2_SP_SPECIAL_TRG1(23 downto 0)  <= B_EC_A2_SPECIAL_TRG1;
	BUF_EC_A2_SP_SHOWER_TRG1(31 downto 24)  <= B_EC_A2_SPECIAL_BPTXX(7 downto 0);
	BUF_EC_A2_SP_SHOWER_BPTXX(31 downto 24) <= B_EC_A2_SPECIAL_BPTXX(15 downto 8);
	BUF_EC_A2_SP_SPECIAL_TRG1(31 downto 24) <= B_EC_A2_SPECIAL_BPTXX(23 downto 16);
	
	BUF_EC_A2_SP_SHOWER_L3T(15 downto 0)    <= B_EC_A2_SHOWER_L3T;
	BUF_EC_A2_SP_SHOWER_L3T(31 downto 16)   <= B_EC_A2_SPECIAL_L3T;

	BUF_EC_A2_LHCF_SHOWER_AND(15 downto 0)  <= B_EC_A2_SHOWER_BPTXX_AND;
	BUF_EC_A2_LHCF_SHOWER_AND(31 downto 16) <= B_EC_A2_ATLAS_L1_LHCF;	
	
	BUF_EC_A2_BP_PEDE_L3T(15 downto 0)      <= B_EC_A2_PEDE_L3T;                   
	BUF_EC_A2_BP_PEDE_L3T(31 downto 16)     <= B_EC_A2_BPTX_L3T; 
	
	BUF_EC_A2_OR_L3T(15 downto 0)           <= B_EC_A2_L3T;  
	BUF_EC_A2_OR_L3T(31 downto 16)          <= B_EC_A2_OR_L3T;
	
	BUF_EC_A2_SFC_03(23 downto 0)           <= B_EC_A2_SFC_0;                       
	BUF_EC_A2_SFC_13(23 downto 0)           <= B_EC_A2_SFC_1;                     
	BUF_EC_A2_SFC_23(23 downto 0)           <= B_EC_A2_SFC_2;

	BUF_EC_A2_SFC_03(31 downto 24)          <= B_EC_A2_SFC_3(7 downto 0);	
	BUF_EC_A2_SFC_13(31 downto 24)          <= B_EC_A2_SFC_3(15 downto 8);
	BUF_EC_A2_SFC_23(31 downto 24)          <= B_EC_A2_SFC_3(23 downto 16);
	
	BUF_EC_A2_FCL_OR(23 downto 0)           <= B_EC_A2_FCL_OR;                       
	BUF_EC_A2_FC_TRG(23 downto 0)           <= B_EC_A2_FC_BPTXX;                     
	BUF_EC_A2_FC_SHOWER(23 downto 0)        <= B_EC_A2_FC_SHOWER;

	BUF_EC_A2_FCL_OR(31 downto 24)          <= B_EC_A2_FC_TRG_AND(7 downto 0);	
	BUF_EC_A2_FC_TRG(31 downto 24)          <= B_EC_A2_FC_TRG_AND(15 downto 8);
	BUF_EC_A2_FC_SHOWER(31 downto 24)       <= B_EC_A2_FC_TRG_AND(23 downto 16);
	BUF_EC_A2_ORBIT(23 downto 0)            <= B_EC_A2_ORBIT;
	BUF_EC_A2_ORBIT(31 downto 24)           <= x"00";
	
	BUF_OC_A2(15 downto 0)                  <= B_OC_A2_CLK;
	BUF_OC_A2(23 downto 16)                 <= B_OC_A2_BPTX1;
	BUF_OC_A2(31 downto 24)                 <= B_OC_A2_BPTX2;
	
--	------ TEST OUTPUT ------------
	
	PULSES(0) <= LCLK;
   PULSES(1) <= LHCCLK;
	PULSES(2) <= CLK;
   PULSES(3) <= CLK80;
   PULSES(4) <= BPTX1_1;
   PULSES(5) <= BPTX1_3;
   PULSES(6) <= BPTX2_1;
   PULSES(7) <= BPTX2_3;
	PULSES(8) <= A1_L1T;
   PULSES(9) <= A1_DL1T;
	PULSES(10) <= A1_SDSC(14);
   PULSES(11) <= A1_SDSC2(14);
   PULSES(12) <= A1_STRG;
   PULSES(13) <= A1_LTRG;
   PULSES(14) <= A1_SLOGIC;
   PULSES(15) <= A1_LLOGIC;
   PULSES(16) <= A1_SHOWER_TRG1;
   PULSES(17) <= A1_SHOWER_TRG2;
	PULSES(18) <= A1_SHOWER_TRG3;
	PULSES(19) <= A1_L2T_SHOWER;
	PULSES(20) <= A1_SPECIAL_TRG1;
   PULSES(21) <= A1_SPECIAL_TRG2;
	PULSES(22) <= A1_SPECIAL_TRG3;
   PULSES(23) <= A1_L2T_SPECIAL;
   PULSES(24) <= A1_PEDE_TRG1;
   PULSES(25) <= A1_L2T_PEDE;
   PULSES(26) <= A1_L2T_L1T1;
   PULSES(27) <= A1_L2T_L1T;
   PULSES(28) <= LD_BPTX1;
   PULSES(29) <= LD_BPTX2;
	PULSES(30) <= A1_FCL_OR;
	PULSES(31) <= A2_FCL_OR;
   PULSES(32) <= A1_FC_TRG1;
   PULSES(33) <= A1_FC_TRG;
   PULSES(34) <= A2_L2T_FC;
   PULSES(35) <= A2_FC_TRG;
   PULSES(36) <= A1_L2T_FC;
   PULSES(37) <= A1_L3T1;
   PULSES(38) <= A1_L3TT;
   PULSES(39) <= A1_L3T2;
   PULSES(40) <= A1_LATCH;
	PULSES(41) <= A1_LATCH_STOP_INTERNAL1;
   PULSES(42) <= A1_LATCH_STOP_INTERNAL;
   PULSES(43) <= A1_LATCH_STOP_FIXED;
	PULSES(44) <= A1_LATCH_STOP_EXTERNAL;
	PULSES(45) <= A1_L3T;
	PULSES(46) <= A1_SELFVETO;
	PULSES(47) <= A1_ENABLE_FLAG;
	PULSES(48) <= A1_ENABLE;
	PULSES(49) <= A1_BEAM_FLAG;
	PULSES(50) <= A1_PEDE_FLAG;
	PULSES(51) <= A1_ATLAS;

	PULSES(52) <= A2_L1T;
   PULSES(53) <= A2_DL1T;
	PULSES(54) <= A2_SDSC(15);
   PULSES(55) <= A2_SDSC2(15);
   PULSES(56) <= A2_STRG;
   PULSES(57) <= A2_LTRG;
   PULSES(58) <= A2_SLOGIC;
   PULSES(59) <= A2_LLOGIC;
   PULSES(60) <= A2_SHOWER_TRG1;
   PULSES(61) <= A2_SHOWER_TRG2;
	PULSES(62) <= A2_SHOWER_TRG3;
	PULSES(63) <= A2_L2T_SHOWER;
	PULSES(64) <= A2_SPECIAL_TRG1;
   PULSES(65) <= A2_SPECIAL_TRG2;
	PULSES(66) <= A2_SPECIAL_TRG3;
   PULSES(67) <= A2_L2T_SPECIAL;
   PULSES(68) <= A2_PEDE_TRG1;
   PULSES(69) <= A2_L2T_PEDE;
   PULSES(70) <= A2_L2T_L1T1;
   PULSES(71) <= A2_L2T_L1T;
   PULSES(72) <= A2_L3T1;
   PULSES(73) <= A2_L3TT;
   PULSES(74) <= A2_L3T2;
   PULSES(75) <= A2_LATCH;
	PULSES(76) <= A2_LATCH_STOP_INTERNAL1;
   PULSES(77) <= A2_LATCH_STOP_INTERNAL;
   PULSES(78) <= A2_LATCH_STOP_FIXED;
	PULSES(79) <= A2_LATCH_STOP_EXTERNAL;
	PULSES(80) <= A2_L3T;
	PULSES(81) <= A2_SELFVETO;
	PULSES(82) <= A2_ENABLE_FLAG;
	PULSES(83) <= A2_ENABLE;
	PULSES(84) <= A2_BEAM_FLAG;
	PULSES(85) <= A2_PEDE_FLAG;
	PULSES(86) <= A2_ATLAS;
	
	PULSES(87) <= ATLAS_L1A;
	PULSES(88) <= ATLAS_L1A_SYC;
   PULSES(89) <= ATLAS_ECR;
	PULSES(90) <= ATLAS_ECR_SYC;
	PULSES(91) <= ORBIT;
	PULSES(92) <= ORBIT_SYC;
	
   PULSES(93) <= A1_SDSC(2);
	PULSES(94) <= A1_SDSC2(2);
	PULSES(95) <= A1_SDSC(7);
	PULSES(96) <= A1_SDSC2(7);
	PULSES(97) <= A1_SDSC(13);
	PULSES(98) <= A1_SDSC2(13);
	PULSES(99) <= A1_LDSC(3);
	PULSES(100) <= A1_LDSC2(3);
	PULSES(101) <= A1_LDSC(7);
	PULSES(102) <= A1_LDSC2(7);
	PULSES(103) <= A1_LDSC(12);
	PULSES(104) <= A1_LDSC2(12);
	PULSES(105) <= A2_SDSC(2);
	PULSES(106) <= A2_SDSC2(2);
	PULSES(107) <= A2_SDSC(12);
	PULSES(108) <= A2_SDSC2(12);
	PULSES(109) <= A2_SDSC(14);
	PULSES(110) <= A2_SDSC2(14);
	PULSES(111) <= A2_LDSC(3);
	PULSES(112) <= A2_LDSC2(3);
	PULSES(113) <= A2_LDSC(10);
	PULSES(114) <= A2_LDSC2(10);
	PULSES(115) <= A2_LDSC(12);
	PULSES(116) <= A2_LDSC2(12);
	
	PULSES(117) <= A1_FC(0);
	PULSES(118) <= A1_FC2(0);
	PULSES(119) <= A1_FC(1);
	PULSES(120) <= A1_FC2(1);
	PULSES(121) <= A1_FC(2);
	PULSES(122) <= A1_FC2(2);
	PULSES(123) <= A1_FC(3);
	PULSES(124) <= A1_FC2(3);
	
	PULSES(125) <= A2_FC(0);
	PULSES(126) <= A2_FC2(0);
	PULSES(127) <= A2_FC(1);
	PULSES(128) <= A2_FC2(1);
	PULSES(129) <= A2_FC(2);
	PULSES(130) <= A2_FC2(2);
	PULSES(131) <= A2_FC(3);
	PULSES(132) <= A2_FC2(3);
	
	PULSES(133) <= A1_ENABLE1; 
	PULSES(134) <= A1_ENABLE3;
	PULSES(135) <= A2_ENABLE3 ;
	PULSES(136) <= A2_PEDE_FLAG1;
	PULSES(137) <= A2_ENABLE2;
	
	PULSES(138) <= A1_ENABLE2;
	PULSES(139) <= A1_SELFVETO2;
	PULSES(140) <= A1_RUN_STATUS;
	PULSES(141) <= A1_LATCH_STOP_EXTERNAL1;
	PULSES(142) <= A1_LATCH_STOP_EXTERNAL;
	
	PULSES(143) <= A2_SELFVETO1 ;
	PULSES(144) <= A2_SELFVETO2;
	PULSES(145) <= A2_LATCH_STOP_EXTERNAL1;
	PULSES(146) <= A2_LATCH_STOP_EXTERNAL;
	
	PULSES(147) <= A2_ENABLE1;
	PULSES(148) <= ECR_EXTERNAL1;
	PULSES(149) <= ECR_EXTERNAL;
	PULSES(150) <= ECR;
	
	PULSES(151) <= COMMON_FLAG;
	PULSES(152) <= L1T;
	PULSES(153) <= A1_L3T0;
	PULSES(154) <= A2_L3T0;
	PULSES(155) <= L3T0_OR;
	PULSES(156) <= L3T0_AND;
	PULSES(157) <= COMMON_L3T1;
	PULSES(158) <= ECR1;
	PULSES(159) <= ATLAS_L1_LHCF2;
	PULSES(160) <= ATLAS_L1_LHCF;
	PULSES(161) <= ENABLE1_AND;
	
	PULSES(162) <= A1_SHOWER_BPTXX;
	PULSES(163) <= A2_SHOWER_BPTXX;
	PULSES(164) <= A1_SPECIAL_BPTXX;
	PULSES(165) <= A2_SPECIAL_BPTXX;
	
	PULSES(166) <= A1_DAQ_MODE0;
	PULSES(167) <= A1_DAQ_MODE1;
	PULSES(168) <= A2_DAQ_MODE0;
	PULSES(169) <= A2_DAQ_MODE1;

	PULSES(170) <= A1_L2T_L1T2;
	PULSES(171) <= A1_L2T_L1T3;
	PULSES(172) <= A2_L2T_L1T2;
	PULSES(173) <= A2_L2T_L1T3;
	----
	PULSES(174) <= LASER_GEN_1;
	PULSES(175) <= LASER_GEN_2;
	PULSES(176) <= LASER_GEN_3;
	PULSES(177) <= LASER_GEN;
	PULSES(178) <= COMMON_BEAM_FLAG;
	PULSES(179) <= LASER_1;
	PULSES(180) <= LASER_2;
	PULSES(181) <= A2_RUN_STATUS;
	PULSES(182) <= LASER_PEDE_1;
	PULSES(183) <= LASER_PEDE;
	PULSES(184) <= LASER;
	PULSES(185) <= LASER_IN;
	PULSES(186) <= GEN_LASER;	
	PULSES(187) <= GEN_LASER_VETO;	
	PULSES(188) <= LASER_3;
	PULSES(189) <= LASER_4;
	
	PULSES(190) <= ATLAS_L1A_W;
	PULSES(191) <= ATLAS_L1A_LONG;
	PULSES(192) <= A1_COUNTER_LATCH;
	PULSES(193) <= A2_COUNTER_LATCH;	
	PULSES(194) <= A1_COUNTER_LATCH2;	
	PULSES(195) <= A2_COUNTER_LATCH2;
	PULSES(196) <= LD_A1_L1T;
	PULSES(197) <= LD_A2_L1T;
	PULSES(198) <= RC_READ_INC2;	
	PULSES(199) <= RC_READ_INC3;	
	PULSES(200) <= RC_READ_INC4;

	PULSES(201) <= ECR_INTERNAL1;	
	PULSES(202) <= A1_COUNTER_LATCH_INTERNAL1;
	PULSES(203) <= A2_COUNTER_LATCH_INTERNAL1;
	PULSES(204) <= BPTX1_2;
	PULSES(205) <= BPTX2_2;
	PULSES(206) <= A1_L1T2;
	PULSES(207) <= A2_L1T2;
	PULSES(208) <= A1_L1T_VETO;
	PULSES(209) <= A2_L1T_VETO;
	PULSES(210) <= A1_L1T_GPIO;
	PULSES(211) <= A2_L1T_GPIO;
	PULSES(212) <= A1_LD_BPTX;
	PULSES(213) <= A2_LD_BPTX;
	PULSES(214) <= A1_L3T_GPIO;
	PULSES(215) <= A2_L3T_GPIO;
	PULSES(216) <= A1_SELFVETO1;
	PULSES(217) <= A1_SHOWER_TRG_OR;
	PULSES(218) <= A2_SHOWER_TRG_OR;
	PULSES(219) <= A1_NOTLATCH;
	PULSES(220) <= A2_NOTLATCH;
	PULSES(221) <= A1_BEAM_FLAG1;
	PULSES(222) <= A2_BEAM_FLAG1;
	PULSES(223) <= A1_PEDE_FLAG1;
	PULSES(224) <= A2_PEDE_FLAG1;	
	PULSES(225) <= A1_PC_ENABLE;
	PULSES(226) <= A2_PC_ENABLE;
	PULSES(227) <= COMMON_FLAG1;
	PULSES(228) <= COMMON_PEDE_FLAG;
	PULSES(229) <= SEL_COMMON_A1A2;
	PULSES(230) <= ATLAS_L1_LHCF1;
	PULSES(231) <= A1_SHOWER;
	PULSES(232) <= A2_SHOWER;
	PULSES(233) <= ENABLE_ATLAS_L1_LHCF;
	PULSES(234) <= PRESET_CLEAR1;
	PULSES(235) <= PRESET_CLEAR;
	PULSES(236) <= A1_COUNTER_LATCH_EVENT;
	PULSES(237) <= A2_COUNTER_LATCH_EVENT;
	PULSES(238) <= A1_COUNTER_LATCH1;
	PULSES(239) <= A2_COUNTER_LATCH1;
	PULSES(240) <= FC_TRG_AND;
	PULSES(241) <= A1_FC_SHOWER;
	PULSES(242) <= A2_FC_SHOWER;
	PULSES(243) <= LD_BPTX_AND;
	PULSES(244) <= OR_L3T;
	PULSES(245) <= SHOWER_BPTXX_AND;
	PULSES(246) <= A1_SHOWER_L3T;
	PULSES(247) <= A2_SHOWER_L3T;
	PULSES(248) <= A1_SPECIAL_L3T;
	PULSES(249) <= A2_SPECIAL_L3T;
	PULSES(250) <= A1_BPTX_L3T;
	PULSES(251) <= A2_BPTX_L3T;
	PULSES(252) <= A1_L1T_ENABLE;
	PULSES(253) <= A2_L1T_ENABLE;
	PULSES(254) <= A1_LOGIC_OR;
	PULSES(255) <= A2_LOGIC_OR;
	PULSES(256) <= A1_FC_BPTXX;
	PULSES(257) <= A2_FC_BPTXX;
	PULSES(258) <= LASER_SYC;
	PULSES(259) <= A1_RUN_STATUS_SYC;
	PULSES(260) <= A2_RUN_STATUS_SYC;
	PULSES(261) <= A1_DAQ_MODE(0);
	PULSES(262) <= A1_DAQ_MODE(1);
	PULSES(263) <= A2_DAQ_MODE(0);
	PULSES(264) <= A2_DAQ_MODE(1);
	
	PULSES(265) <= A1_SDSC(0);
	PULSES(266) <= A1_SDSC2(0);
	PULSES(267) <= A1_SDSC(1);
	PULSES(268) <= A1_SDSC2(1);
	PULSES(269) <= A1_SDSC(3);
	PULSES(270) <= A1_SDSC2(3);
	PULSES(271) <= A1_SDSC(4);
	PULSES(272) <= A1_SDSC2(4);
	PULSES(273) <= A1_SDSC(5);
	PULSES(274) <= A1_SDSC2(5);
	PULSES(275) <= A1_SDSC(6);
	PULSES(276) <= A1_SDSC2(6);
	PULSES(277) <= A1_SDSC(8);
	PULSES(278) <= A1_SDSC2(8);
	PULSES(279) <= A1_SDSC(9);
	PULSES(280) <= A1_SDSC2(9);
	PULSES(281) <= A1_SDSC(10);
	PULSES(282) <= A1_SDSC2(10);
	PULSES(283) <= A1_SDSC(11);
	PULSES(284) <= A1_SDSC2(11);
	PULSES(285) <= A1_SDSC(12);
	PULSES(286) <= A1_SDSC2(12);
	PULSES(287) <= A1_SDSC(15);
	PULSES(288) <= A1_SDSC2(15);
	
	PULSES(289) <= A1_LDSC(0);
	PULSES(290) <= A1_LDSC2(0);
	PULSES(291) <= A1_LDSC(1);
	PULSES(292) <= A1_LDSC2(1);
	PULSES(293) <= A1_LDSC(2);
	PULSES(294) <= A1_LDSC2(2);
	PULSES(295) <= A1_LDSC(4);
	PULSES(296) <= A1_LDSC2(4);
	PULSES(297) <= A1_LDSC(5);
	PULSES(298) <= A1_LDSC2(5);
	PULSES(299) <= A1_LDSC(6);
	PULSES(300) <= A1_LDSC2(6);
	PULSES(301) <= A1_LDSC(8);
	PULSES(302) <= A1_LDSC2(8);
	PULSES(303) <= A1_LDSC(9);
	PULSES(304) <= A1_LDSC2(9);
	PULSES(305) <= A1_LDSC(10);
	PULSES(306) <= A1_LDSC2(10);
	PULSES(307) <= A1_LDSC(11);
	PULSES(308) <= A1_LDSC2(11);
	PULSES(309) <= A1_LDSC(13);
	PULSES(310) <= A1_LDSC2(13);
	PULSES(311) <= A1_LDSC(14);
	PULSES(312) <= A1_LDSC2(14);
	PULSES(313) <= A1_LDSC(15);
	PULSES(314) <= A1_LDSC2(15);
	
	PULSES(315) <= A2_SDSC(0);
	PULSES(316) <= A2_SDSC2(0);
	PULSES(317) <= A2_SDSC(1);
	PULSES(318) <= A2_SDSC2(1);
	PULSES(319) <= A2_SDSC(3);
	PULSES(320) <= A2_SDSC2(3);
	PULSES(321) <= A2_SDSC(4);
	PULSES(322) <= A2_SDSC2(4);
	PULSES(323) <= A2_SDSC(5);
	PULSES(324) <= A2_SDSC2(5);
	PULSES(325) <= A2_SDSC(6);
	PULSES(326) <= A2_SDSC2(6);
	PULSES(327) <= A2_SDSC(7);
	PULSES(328) <= A2_SDSC2(7);
	PULSES(329) <= A2_SDSC(8);
	PULSES(330) <= A2_SDSC2(8);
	PULSES(331) <= A2_SDSC(9);
	PULSES(332) <= A2_SDSC2(9);
	PULSES(333) <= A2_SDSC(10);
	PULSES(334) <= A2_SDSC2(10);
	PULSES(335) <= A2_SDSC(11);
	PULSES(336) <= A2_SDSC2(11);
	PULSES(337) <= A2_SDSC(13);
	PULSES(338) <= A2_SDSC2(13);
	
	PULSES(339) <= A2_LDSC(0);
	PULSES(340) <= A2_LDSC2(0);
	PULSES(341) <= A2_LDSC(1);
	PULSES(342) <= A2_LDSC2(1);
	PULSES(343) <= A2_LDSC(2);
	PULSES(344) <= A2_LDSC2(2);
	PULSES(345) <= A2_LDSC(4);
	PULSES(346) <= A2_LDSC2(4);
	PULSES(347) <= A2_LDSC(5);
	PULSES(348) <= A2_LDSC2(5);
	PULSES(349) <= A2_LDSC(6);
	PULSES(350) <= A2_LDSC2(6);
	PULSES(361) <= A2_LDSC(7);
	PULSES(362) <= A2_LDSC2(7);
	PULSES(363) <= A2_LDSC(8);
	PULSES(364) <= A2_LDSC2(8);
	PULSES(365) <= A2_LDSC(9);
	PULSES(366) <= A2_LDSC2(9);
	PULSES(367) <= A2_LDSC(11);
	PULSES(368) <= A2_LDSC2(11);
	PULSES(369) <= A2_LDSC(13);
	PULSES(370) <= A2_LDSC2(13);
	PULSES(371) <= A2_LDSC(14);
	PULSES(372) <= A2_LDSC2(14);
	PULSES(373) <= A2_LDSC(15);
	PULSES(374) <= A2_LDSC2(15);

	PULSES(375) <= A1_SELFVETO0;
	PULSES(376) <= A2_SELFVETO0;
	
	PULSES(377) <= A1_L3T_DELAY;
	PULSES(378) <= A2_L3T_DELAY;
	PULSES(379) <= L3T_DELAY_OR;
	PULSES(380) <= ATLAS_COUNTER_ENABLE;
	PULSES(381) <= ATLAS_L1_LHCF3;
	
	PULSES(382) <= A1_FLAG_LATCH;
	PULSES(383) <= A2_FLAG_LATCH;
	PULSES(384) <= A1_TRANSFER_START;
	PULSES(385) <= A2_TRANSFER_START;
	
	LTESTOUT1: TESTOUT port map(
		input  => PULSES,
		mask   => TESTOUT1_MASK,
		output => TESTOUT1
	);
	
	LTESTOUT2: TESTOUT port map(
		input  => PULSES,
		mask   => TESTOUT2_MASK,
		output => TESTOUT2
	);
	
	LTESTOUT3: TESTOUT port map(
		input  => PULSES,
		mask   => TESTOUT3_MASK,
		output => TESTOUT3
	);
	
	LTESTOUT4: TESTOUT port map(
		input  => PULSES,
		mask   => TESTOUT4_MASK,
		output => TESTOUT4
	);

end rtl;



--Note 
--2015/02/25: 1,The data transfer still use ECR as the START signal, later it must be replace by a signal generated 
--            by using L3T
--2015/03/04: A1_BEAM_FLAG and A2_BEAM_FLAG was change to defualt '1' for the test.    
--2015/03/06: Modified the trigger_logic05, some places were changed from and to or, changed use trigger_logic01 
--            instaed of trigger_logic02 
--            Change SELFVETO logic clock to 80MHz
--2015/04/23: Add a mask of ATLAS_L1_LHCF (ENABLE_ATLAS_L1_LHCF)
--2015/04/30: Replace BPTX1(2)_1 to BPTX1_3 in output of section E. `
