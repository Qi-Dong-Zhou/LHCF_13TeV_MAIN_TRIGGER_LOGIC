-- ========================================================================
-- ****************************************************************************
-- Model:           V1495 -  Multipurpose Programmable Trigger Unit
-- FPGA Proj. Name: LHCf main trigger logic for 13 TeV operation
-- Device:          ALTERA EP1C20F400C6
-- Date:            Mar, 2014
-- ----------------------------------------------------------------------------
-- Module:          LHCF_SC_SCALER
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

entity LHCF_FC_SCALER is
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

END LHCF_FC_SCALER;


architecture rtl of LHCF_FC_SCALER is

	--------------------------
	------- SIGNALS ----------
	--------------------------
	
	constant VERSION                    : std_logic_vector(15 downto 0) := x"0500";
	constant PULSEWIDTH                 : std_logic_vector(3 downto 0) := "0100";
	
	signal	LHCCLK                     : std_logic;
	-- CLK generate by PLL
	signal	CLK                        : std_logic;
	signal	CLK80                      : std_logic;
	
	-- Expansion for Slot D,E,F
	signal   D_Expan     		         : std_logic_vector(31 downto 0) := (others => '0');
	signal   E_Expan     		         : std_logic_vector(31 downto 0) := (others => '0');
	signal   F_Expan     		         : std_logic_vector(31 downto 0) := (others => '0');
	
	-- Module LB_INT for VME access		
	signal	REG_BUF_DL1T_DL3T_P        : std_logic_vector(31 downto 0) := (others => 'Z');
 
	signal	REG_BUF_TESTOUT1_MASK      : std_logic_vector(31 downto 0) := (others => 'Z');
	signal	REG_BUF_TESTOUT2_MASK      : std_logic_vector(31 downto 0) := (others => 'Z');

	-------- Main logic signals ------------
	
	--A1_L1T
	signal   BPTX1_1                    : std_logic := '0';  -- INPUT
	signal   BPTX1_2                    : std_logic := '0';  -- SYNCHRONIZED WITH CLK
	signal   BPTX1_3                    : std_logic := '0';  -- WIDTH 1 CLK
	signal   BPTX2_1                    : std_logic := '0';  -- INPUT
	signal   BPTX2_2                    : std_logic := '0';  -- SYNCHRONIZED WITH CLK	
	signal   BPTX2_3                    : std_logic := '0';  -- WIDTH 1 CLK
		
	signal   NCLK_DL1T                  : std_logic_vector(6 downto 0) := "0111111";
	signal   NCLK_DELAY_BPTX1				: std_logic_vector(6 downto 0);
	signal   NCLK_DELAY_BPTX2				: std_logic_vector(6 downto 0);	
	signal   LD_BPTX1                   : std_logic;
	signal   LD_BPTX2                   : std_logic;
		
	
	--A1_SHOWER TRIGGER
	signal   A1_SDSC                    : std_logic_vector(15 downto 0); 
	signal   A1_LDSC                    : std_logic_vector(15 downto 0);
	signal   A1_SDSC2                   : std_logic_vector(15 downto 0); 
	signal   A1_LDSC2                   : std_logic_vector(15 downto 0);
	signal   A1_SLOGIC                  : std_logic;
	signal   A1_LLOGIC                  : std_logic; 
	signal   A1_SHOWER_TRG1             : std_logic;
	signal   A1_SHOWER_LOGIC 				: std_logic := '0';
	
	--A2_SHOWER TRIGGER
	signal   A2_SDSC                    : std_logic_vector(15 downto 0); 
	signal   A2_LDSC                    : std_logic_vector(15 downto 0);
	signal   A2_SDSC2                   : std_logic_vector(15 downto 0); 
	signal   A2_LDSC2                   : std_logic_vector(15 downto 0);
	signal   A2_SLOGIC                  : std_logic;
	signal   A2_LLOGIC                  : std_logic; 
	signal   A2_SHOWER_TRG1             : std_logic;
	signal   A2_SHOWER_LOGIC 				: std_logic := '0';


	--FRONT COUNTER
	signal   A1_FC                      : std_logic_vector(3 downto 0);
	signal   A1_FC2                     : std_logic_vector(3 downto 0);
	signal   A2_FC                      : std_logic_vector(3 downto 0);
	signal   A2_FC2                     : std_logic_vector(3 downto 0);
	signal   A1_FCL                     : std_logic_vector(3 downto 0);
	signal   A2_FCL                     : std_logic_vector(3 downto 0);
	signal   A1_FCL_OR                  : std_logic := '0';
	signal   A2_FCL_OR                  : std_logic := '0';
	signal   A1_FC_TRG1                 : std_logic := '0';
	signal   A2_FC_TRG1                 : std_logic := '0';
	signal   A1_FC_TRG                  : std_logic := '0';
	signal   A2_FC_TRG                  : std_logic := '0';
	signal   FC_TRG_AND						: std_logic := '0'; 
	signal 	FCL_AND							: std_logic := '0';
	signal   FCL_OR							: std_logic := '0';
	signal	FC_TRG							: std_logic := '0';
	
	--OUTPUT SIGNALS
	signal   OUT_BPTX1						: std_logic := '0';
	signal   OUT_BPTX2						: std_logic := '0';
	signal   OUT_A1_FCL_OR					: std_logic := '0'; -- not used
	signal   OUT_A2_FCL_OR					: std_logic := '0'; -- not used
	signal   OUT_FCL_OR						: std_logic := '0'; -- A1_FCL_OR "OR" A2_FCL_OR
	signal   OUT_A1_FC_TRG					: std_logic := '0'; -- not used
	signal   OUT_A2_FC_TRG					: std_logic := '0'; -- not used 
	signal   OUT_FC_TRG						: std_logic := '0'; -- A1_FC_TRG "OR" A2_FC_TRG
	signal   OUT_FCL_AND						: std_logic := '0'; -- A1_FC_TRG "AND" A2_FC_TRG
	
	signal   OUT_A1_SHOWER_LOGIC			: std_logic := '0';
	signal   OUT_A1_SHOWER_TRG				: std_logic := '0';
	signal   OUT_A2_SHOWER_LOGIC			: std_logic := '0';
	signal   OUT_A2_SHOWER_TRG				: std_logic := '0'; 
	
	-- 1MHz Clock 
	signal   CLK1MHz							: std_logic := '0';
	
	signal   DUMMY_SIGNAL               : std_logic;
	signal   PULSES                     : std_logic_vector(51 downto 0);
	signal   TESTOUT1                   : std_logic;
	signal   TESTOUT2                   : std_logic;

	signal   TESTOUT1_MASK              : std_logic_vector(7 downto 0);
	signal   TESTOUT2_MASK              : std_logic_vector(7 downto 0);
		
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
	GOUT (1) <= '0';
	
	------- SLOT A CONNECTION(IN) --------
	A1_SDSC                <= A (15 downto 0);
	A1_LDSC                <= A (31 downto 16);
	
	------- SLOT B CONNECTION(IN) --------
	A2_SDSC                <= B (15 downto 0);
	A2_LDSC                <= B (31 downto 16);
	
	------- SLOT C CONNECTION(OUT) --------
	C(31 downto 0) <= (others => '0');

	------- SLOT D CONNECTION(IN) --------
	A1_FC(0)                <= D_Expan(0);
	A1_FC(1)                <= D_Expan(1);
	A1_FC(2)                <= D_Expan(2);
	A1_FC(3)                <= D_Expan(3);
	A2_FC(0)                <= D_Expan(4);
	A2_FC(1)                <= D_Expan(5);
	A2_FC(2)                <= D_Expan(6);
	A2_FC(3)                <= D_Expan(7);
	
	------- SLOT E CONNECTION(6IN/2OUT) --------
	-- SLOT E was used as individually ports, NEED set mode to OUTPUT (nOEE  <=  '0';)
	-- For INPUT channels: OUTPUT bus internal channels set to '0', 50Ohm termination ON
	--IN
	BPTX1_1                 <= not E_Expan(2);
	E(0)  <= '0';
	BPTX2_1                 <= not E_Expan(18);
	E(16) <= '0';										 
	--ORBIT                   <= not E_Expan(3);
	E(1)  <= '0';						 
	--ATLAS_L1A               <= not E_Expan(19);
	E(17) <= '0';
	--ATLAS_ECR               <= not E_Expan(14);
	E(12) <= '0';
	--LASER_IN                <= not E_Expan(30);
	E(28) <= '0';
	
	--OUT
	E(13)                   <= TESTOUT1;
	E(29)                   <= TESTOUT2;
	
	------- SLOT F CONNECTION(OUT) --------
	F_Expan(0)              <= CLK1MHz;
	F_Expan(16)             <= OUT_BPTX1;
	F_Expan(1)              <= OUT_BPTX2;
	F_Expan(17)             <= '0';         -- Broken channel of NIM RPN-032
	F_Expan(12)             <= OUT_FCL_OR;
	F_Expan(28)             <= OUT_FC_TRG;
	F_Expan(13)             <= '0';         -- Broken channel of NIM RPN-032
	F_Expan(29)             <= OUT_FCL_AND;
	
	--------- END CONNECTION ---------------

   --************************************************************  
	--***                       CLOCK                          ***
	--************************************************************
	
	CLK_40to80 : PLL PORT MAP (
		areset       => '0',
		inclk0       => LHCCLK,   
		c0	          => CLK80,
		c1	          => CLK,
		locked       => open
	);
	
	L_CLK1MHz : CLKMHz port map  (
		CLK 			 => CLK,
		MHZ			 => CLK1MHz
	);
	
   --************************************************************  
	--***                        BPTX                          ***
	--************************************************************
		
	
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
	
	NCLK_DELAY_BPTX1 <= NCLK_DL1T ;
	NCLK_DELAY_BPTX2 <= NCLK_DL1T ;
	
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
	
	-- *******************************************************************
	-- ******                        LOGIC FOR FC                  *******
	-- *******************************************************************
	
 	ARM1_FC : FC_MODULE port map(
		CLK          => CLK,
		CLK80        => CLK80,
		DBPTX        => LD_BPTX2, 
		CLEAR        => '0', 
		FC_MASK      => x"F0",
		FC           => A1_FC,        -- INPUT
		FC2          => A1_FC2,       -- OUTPUT AFTER SYNC AND WIDTH 
		PATTERN      => open,         -- FLAG
		FCL          => A1_FCL,       -- LOGIC OUT (4)
		FCL_OR       => A1_FCL_OR,    -- WITHOUT COINCIDENCE WITH DBPTX
		FC_TRG1      => A1_FC_TRG1,	-- COINCIDENCE WITH DBPTX (1 CLK)
		FC_TRG2      => A1_FC_TRG     -- COINCIDENCE WITH DBPTX (6 CLK)
	);                               
	
	
	ARM2_FC : FC_MODULE port map(
		CLK          => CLK,
		CLK80        => CLK80,
		DBPTX        => LD_BPTX1,
		CLEAR        => '0',
		FC_MASK      => x"F0",		
		FC           => A2_FC,
		FC2          => A2_FC2,
		PATTERN      => open,
		FCL          => A2_FCL,
		FCL_OR       => A2_FCL_OR,   
		FC_TRG1      => A2_FC_TRG1,
		FC_TRG2      => A2_FC_TRG           
	);                                  
	
	FC_TRG_AND <= A1_FC_TRG and A2_FC_TRG;
	FC_TRG	  <= A1_FC_TRG or  A2_FC_TRG;
	FCL_OR     <= A1_FCL_OR or  A2_FCL_OR;
	FCL_AND	  <= A1_FCL_OR and A2_FCL_OR;
	
	-- *******************************************************************
	-- ******                    LOGIC FOR SHOWER                  *******
	-- *******************************************************************
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
		DL1T                      => LD_BPTX2,
		LD_BPTX                   => '0',
		BEAMFLAG                  => '1',
		SEL_SLOGIC_SOURCE         => '1',
		SEL_LLOGIC_SOURCE         => '1',
		SDSC                      => A1_SDSC2,
		LDSC                      => A1_LDSC2,
		FLAG_CLEAR                => '0',
		NSTEP_SHOWER_TRG_PRESET   => "000000",
		SHOWER_SOURCE_MASK        => "11",
		SHOWER_MASK               => "11",
		
		STRIG1                    => A1_SLOGIC,   -- logic out of small tower 
		LTRIG1                    => A1_LLOGIC,   -- logic out of large tower
		STRG   					     => open,     -- coincidence with bptx 
		LTRG   					     => open,     -- coincidence with bptx
		SPATTERN                  => open,        -- discriminator pattern of s 
		LPATTERN                  => open,        -- discriminator pattern of s
		SHOWER_BPTX_X             => open,
		SHOWER_TRG1               => A1_SHOWER_TRG1,
		SHOWER_TRG2               => open,
		SHOWER_TRG3               => open,
		L2T_SHOWER                => open                       
	); 
	
	-- Synchronization of discriminator signals with "80MHz" Clock --
	A2_DSC_WIDTH : SYC_WIDTH port map(
		CLK          => CLK80,
		SDSC_IN      => A2_SDSC,
		LDSC_IN      => A2_LDSC,
		SDSC2        => A2_SDSC2, 
		LDSC2        => A2_LDSC2 
	); 
	
	A1_SHOWER_LOGIC <= A1_SLOGIC OR A1_LLOGIC;
	
	
	A2_SHOWER_TRG : SHOWER_MODULE02 port map(
		CLK                       => CLK,
		CLK80                     => CLK80,
		DL1T                      => LD_BPTX1,
		LD_BPTX                   => '0',
		BEAMFLAG                  => '1',
		SEL_SLOGIC_SOURCE         => '1',
		SEL_LLOGIC_SOURCE         => '1',
		SDSC                      => A2_SDSC2,
		LDSC                      => A2_LDSC2,
		FLAG_CLEAR                => '0',
		NSTEP_SHOWER_TRG_PRESET   => "000000",
		SHOWER_SOURCE_MASK        => "11",
		SHOWER_MASK               => "11",
		
		STRIG1                    => A2_SLOGIC,   -- logic out of small tower 
		LTRIG1                    => A2_LLOGIC,   -- logic out of large tower
		STRG   					     => open,     -- coincidence with bptx 
		LTRG   					     => open,     -- coincidence with bptx
		SPATTERN                  => open,        -- discriminator pattern of s 
		LPATTERN                  => open,        -- discriminator pattern of s
		SHOWER_BPTX_X             => open,
		SHOWER_TRG1               => A2_SHOWER_TRG1,
		SHOWER_TRG2               => open,
		SHOWER_TRG3               => open,
		L2T_SHOWER                => open                       
	); 
	
	A2_SHOWER_LOGIC <= A2_SLOGIC OR A2_LLOGIC;
	
	
	------------- PULSE WIDTH ------------
	WIDHT_OUT_BPTX1 : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  BPTX1_3,
		PRESET       =>  "0100",
		STAT         =>  open,
		ENDMARK      =>  OUT_BPTX1
	);
	
	WIDHT_OUT_BPTX2 : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  BPTX2_3,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_BPTX2
	);

	WIDHT_OUT_A1_FCL_OR : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A1_FCL_OR,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_A1_FCL_OR
	);

	WIDHT_OUT_A2_FCL_OR : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A2_FCL_OR,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_A2_FCL_OR
	);
	
	
	WIDHT_OUT_FCL_OR : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  FCL_OR,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_FCL_OR
	);
	
	WIDHT_OUT_A1_FC_TRG : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A1_FC_TRG,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_A1_FC_TRG
	);	

	WIDHT_OUT_A2_FC_TRG : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A2_FC_TRG,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_A2_FC_TRG
	);		
	
	WIDHT_OUT_FC_TRG : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  FC_TRG,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_FC_TRG
	);	
	
	WIDHT_OUT_FC_AND : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  FCL_AND,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_FCL_AND
	);		

	WIDHT_OUT_A1_SHOWER_LOGIC : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A1_SHOWER_LOGIC,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_A1_SHOWER_LOGIC
	);		

	WIDHT_OUT_A1_SHOWER_TRG : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A1_SHOWER_TRG1,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_A1_SHOWER_TRG
	);		

	WIDHT_OUT_A2_SHOWER_LOGIC : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A2_SHOWER_LOGIC,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_A2_SHOWER_LOGIC
	);		

	WIDHT_OUT_A2_SHOWER_TRG : INTERNALCOUNTER generic map(4) port map (
		CLK          =>  CLK,
		START        =>  A2_SHOWER_TRG1,
		PRESET       =>  PULSEWIDTH,
		STAT         =>  open,
		ENDMARK      =>  OUT_A2_SHOWER_TRG
	);		
	
	-- ********************************************************
	-- *******               VME ACCESS                 *******
	-- ********************************************************

	
	------------------- VME ACCESS -----------------------
	VME_LB_INT: LB_INT_FC_SCALER port map (
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
		VERSION        			 => x"0000"&VERSION,
		REG_DL1T_DL3T_P          => REG_BUF_DL1T_DL3T_P,
		REG_TESTOUT1_MASK        => REG_BUF_TESTOUT1_MASK,
		REG_TESTOUT2_MASK        => REG_BUF_TESTOUT2_MASK
	);
	
	
	NCLK_DL1T                            <= REG_BUF_DL1T_DL3T_P(6 downto 0);
	TESTOUT1_MASK                        <= REG_BUF_TESTOUT1_MASK(7 downto 0);
	TESTOUT2_MASK                        <= REG_BUF_TESTOUT2_MASK(7 downto 0);


--	------ TEST OUTPUT ------------
	
	PULSES(0) <= LCLK;
   PULSES(1) <= LHCCLK;
	PULSES(2) <= CLK;
   PULSES(3) <= CLK80;
   PULSES(4) <= BPTX1_1;
   PULSES(5) <= BPTX1_3;
   PULSES(6) <= BPTX2_1;
   PULSES(7) <= BPTX2_3;
   PULSES(8) <= LD_BPTX1;
   PULSES(9) <= LD_BPTX2;
   PULSES(10)<= A1_FC(0);	
   PULSES(11)<= A1_FC(1);	
   PULSES(12)<= A1_FC(2);	
   PULSES(13)<= A1_FC(3);	
   PULSES(14)<= A2_FC(0);
   PULSES(15)<= A2_FC(1);	
   PULSES(16)<= A2_FC(2);
   PULSES(17)<= A2_FC(3);
   PULSES(18)<= A1_FC2(0);	
   PULSES(19)<= A1_FC2(1);	
   PULSES(20)<= A1_FC2(2);	
   PULSES(21)<= A1_FC2(3);	
   PULSES(22)<= A2_FC2(0);
   PULSES(23)<= A2_FC2(1);	
   PULSES(24)<= A2_FC2(2);
   PULSES(25)<= A2_FC2(3);
   PULSES(26)<= A1_FCL_OR; 
   PULSES(27)<= A2_FCL_OR;
   PULSES(28)<= A1_FC_TRG;
   PULSES(29)<= A2_FC_TRG;
   PULSES(30)<= FCL_OR;
	PULSES(31)<= FCL_AND;
	PULSES(32)<= FC_TRG;
	PULSES(33)<= '0';
	PULSES(34)<= '0';
	PULSES(35)<= '0';
	PULSES(36)<= '0';
	PULSES(37)<= '0';
	PULSES(38)<= OUT_FCL_OR;
	PULSES(39)<= OUT_FC_TRG;	
	PULSES(40)<= OUT_BPTX1;
	PULSES(41)<= OUT_BPTX2;
	PULSES(42)<= OUT_A1_FCL_OR;
	PULSES(43)<= OUT_A2_FCL_OR;
	PULSES(44)<= OUT_A1_FC_TRG;
	PULSES(45)<= OUT_A2_FC_TRG;
	PULSES(46)<= OUT_FCL_AND;
	PULSES(47)<= CLK1MHz;
	PULSES(48)<= OUT_A1_SHOWER_LOGIC;
	PULSES(49)<= OUT_A2_SHOWER_LOGIC;
	PULSES(50)<= OUT_A1_SHOWER_TRG;
	PULSES(51)<= OUT_A2_SHOWER_TRG;

	LTESTOUT1: TESTOUT_FC_SCALER port map(
		input  => PULSES,
		mask   => TESTOUT1_MASK,
		output => TESTOUT1
	);
	
	LTESTOUT2: TESTOUT_FC_SCALER port map(
		input  => PULSES,
		mask   => TESTOUT2_MASK,
		output => TESTOUT2
	);


end rtl;
