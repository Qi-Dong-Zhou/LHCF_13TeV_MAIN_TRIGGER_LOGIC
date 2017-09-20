-- ========================================================================
-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1495 -  Multipurpose Programmable Trigger Unit
-- Device:          ALTERA EP1C4F400C6
-- Author:          Qidong ZHOU (Base on "UPACK" edited by H.MENJO)
-- Date:            Nov, 2014
-- ----------------------------------------------------------------------------
-- Module:          components
-- Description:     This file contains declarations header of all components
-- ****************************************************************************

-- NOTE: 
-- ****************************************************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

PACKAGE components is

	subtype vme_add_type is std_logic_vector(15 downto 0);

	-- VME ADDRESS FOR LOGIC MODULE
	constant ADD_REG_A1_L1T_MASK          : vme_add_type   := x"1000";--R/W
	constant ADD_REG_A1_SHOWER_MASK       : vme_add_type   := x"1004";--R/W
	constant ADD_REG_A1_FC_MASK           : vme_add_type   := x"1008";--R/W
	constant ADD_REG_A1_L3T_MASK          : vme_add_type   := x"100C";--R/W
   constant ADD_REG_A1_SHOWER_P          : vme_add_type   := x"1010";--R/W
   constant ADD_REG_A1_L2T_L1T_P         : vme_add_type   := x"1014";--R/W
	constant ADD_REG_A1_LATCH_STOP_P      : vme_add_type   := x"1018";--R/W
	constant ADD_REG_A1_SELFVETO_P        : vme_add_type   := x"101C";--R/W
	
	constant ADD_REG_A2_L1T_MASK          : vme_add_type   := x"1050";--R/W
	constant ADD_REG_A2_SHOWER_MASK       : vme_add_type   := x"1054";--R/W
	constant ADD_REG_A2_FC_MASK           : vme_add_type   := x"1058";--R/W
	constant ADD_REG_A2_L3T_MASK          : vme_add_type   := x"105C";--R/W
   constant ADD_REG_A2_SHOWER_P          : vme_add_type   := x"1060";--R/W
   constant ADD_REG_A2_L2T_L1T_P         : vme_add_type   := x"1064";--R/W
	constant ADD_REG_A2_LATCH_STOP_P      : vme_add_type   := x"1068";--R/W
	constant ADD_REG_A2_SELFVETO_P        : vme_add_type   := x"106C";--R/W
	
	constant ADD_REG_COMMON_MASK          : vme_add_type   := x"1400";--R/W
	constant ADD_REG_DL1T_DL3T_P          : vme_add_type   := x"1404";--R/W
	constant ADD_REG_BPTX_P               : vme_add_type   := x"1408";--R/W
	constant ADD_REG_ATLAS_P              : vme_add_type   := x"140C";--R/W
	constant ADD_REG_LASER_PEDE_P         : vme_add_type   := x"1410";--R/W	
	constant ADD_REG_LASER_GEN_P          : vme_add_type   := x"1414";--R/W
	constant ADD_REG_LASER_GEN_ENABLE     : vme_add_type   := x"1418";--R/W
	constant ADD_REG_SEL_ECR              : vme_add_type   := x"141C";--R/W
	constant ADD_REG_ATLAS_MASK           : vme_add_type   := x"1420";--R/W
	
	constant ADD_A1_LATCH_STOP_INTERNAL   : vme_add_type   := x"10B0";--R/W
	constant ADD_A2_LATCH_STOP_INTERNAL   : vme_add_type   := x"10B4";--R/W

	constant ADD_COUNTER_LATCH_INTERNAL   : vme_add_type   := x"10B8";--R/W
	constant ADD_ECR_L_INTERNAL           : vme_add_type   := x"10BC";--R/W
	
	constant ADD_PRESET_CLEAR             : vme_add_type   := x"10C0";--R/W
	constant ADD_DSC_SCALER_STOP          : vme_add_type   := x"10C4";--R/W
	constant ADD_DSC_SCALER_CLEAR         : vme_add_type   := x"10C8";--R/W
	
	constant ADD_REG_TESTOUT1_MASK        : vme_add_type   := x"24C0";--R/W
	constant ADD_REG_TESTOUT2_MASK        : vme_add_type   := x"24C4";--R/W
	constant ADD_REG_TESTOUT3_MASK        : vme_add_type   := x"24C8";--R/W
	constant ADD_REG_TESTOUT4_MASK        : vme_add_type   := x"24CC";--R/W
	


	constant ADD_REG_STATUS               : vme_add_type   := x"2C04";--R
	constant ADD_REG_LOGIC_VERSION        : vme_add_type   := x"2C00";--R

   -------------------------------------------------------------------
	constant ADD_A1_COUNT_00           : vme_add_type := x"2000";--R/W
	constant ADD_A1_COUNT_01           : vme_add_type := x"2004";--R/W
	constant ADD_A1_COUNT_02           : vme_add_type := x"2008";--R/W
	constant ADD_A1_COUNT_03           : vme_add_type := x"200C";--R/W
	constant ADD_A1_COUNT_04           : vme_add_type := x"2010";--R/W
	constant ADD_A1_COUNT_05           : vme_add_type := x"2014";--R/W
	constant ADD_A1_COUNT_06           : vme_add_type := x"2018";--R/W
	constant ADD_A1_COUNT_07           : vme_add_type := x"201C";--R/W
	constant ADD_A1_COUNT_08           : vme_add_type := x"2020";--R/W	
	constant ADD_A1_COUNT_09           : vme_add_type := x"2024";--R/W	
	constant ADD_A1_COUNT_10           : vme_add_type := x"2028";--R/W	
	constant ADD_A1_COUNT_11           : vme_add_type := x"202C";--R/W
	constant ADD_A1_COUNT_12           : vme_add_type := x"2030";--R/W	
	constant ADD_A1_COUNT_13           : vme_add_type := x"2034";--R/W	
	constant ADD_A1_COUNT_14           : vme_add_type := x"2038";--R/W
	constant ADD_A1_COUNT_15           : vme_add_type := x"203C";--R/W
	constant ADD_A1_COUNT_16           : vme_add_type := x"2040";--R/W
	constant ADD_A1_COUNT_17           : vme_add_type := x"2044";--R/W
	constant ADD_A1_COUNT_18           : vme_add_type := x"2048";--R/W
	constant ADD_A1_COUNT_19           : vme_add_type := x"204C";--R/W
	constant ADD_A1_COUNT_20           : vme_add_type := x"2050";--R/W
	constant ADD_A1_COUNT_21           : vme_add_type := x"2054";--R/W
	constant ADD_A1_COUNT_22           : vme_add_type := x"2058";--R/W
	constant ADD_A1_COUNT_23           : vme_add_type := x"205C";--R/W
	constant ADD_A1_COUNT_24           : vme_add_type := x"2060";--R/W
	constant ADD_A1_COUNT_25           : vme_add_type := x"2064";--R/W
	constant ADD_A1_COUNT_26           : vme_add_type := x"2068";--R/W
	constant ADD_A1_COUNT_27           : vme_add_type := x"206C";--R/W
	constant ADD_A1_COUNT_28           : vme_add_type := x"2070";--R/W
	constant ADD_A1_COUNT_29           : vme_add_type := x"2074";--R/W
	constant ADD_A1_COUNT_30           : vme_add_type := x"2078";--R/W
	constant ADD_A1_COUNT_31           : vme_add_type := x"207C";--R/W
	constant ADD_A1_COUNT_32           : vme_add_type := x"2080";--R/W
	constant ADD_A1_COUNT_33           : vme_add_type := x"2084";--R/W
	constant ADD_A1_COUNT_34           : vme_add_type := x"2088";--R/W	
	-------
	constant ADD_A2_COUNT_00           : vme_add_type := x"2800";--R/W
	constant ADD_A2_COUNT_01           : vme_add_type := x"2804";--R/W
	constant ADD_A2_COUNT_02           : vme_add_type := x"2808";--R/W
	constant ADD_A2_COUNT_03           : vme_add_type := x"280C";--R/W
	constant ADD_A2_COUNT_04           : vme_add_type := x"2810";--R/W
	constant ADD_A2_COUNT_05           : vme_add_type := x"2814";--R/W
	constant ADD_A2_COUNT_06           : vme_add_type := x"2818";--R/W
	constant ADD_A2_COUNT_07           : vme_add_type := x"281C";--R/W
	constant ADD_A2_COUNT_08           : vme_add_type := x"2820";--R/W	
	constant ADD_A2_COUNT_09           : vme_add_type := x"2824";--R/W	
	constant ADD_A2_COUNT_10           : vme_add_type := x"2828";--R/W	
	constant ADD_A2_COUNT_11           : vme_add_type := x"282C";--R/W
	constant ADD_A2_COUNT_12           : vme_add_type := x"2830";--R/W	
	constant ADD_A2_COUNT_13           : vme_add_type := x"2834";--R/W	
	constant ADD_A2_COUNT_14           : vme_add_type := x"2838";--R/W
	constant ADD_A2_COUNT_15           : vme_add_type := x"283C";--R/W
	constant ADD_A2_COUNT_16           : vme_add_type := x"2840";--R/W
	constant ADD_A2_COUNT_17           : vme_add_type := x"2844";--R/W
	constant ADD_A2_COUNT_18           : vme_add_type := x"2848";--R/W
	constant ADD_A2_COUNT_19           : vme_add_type := x"284C";--R/W
	constant ADD_A2_COUNT_20           : vme_add_type := x"2850";--R/W
	constant ADD_A2_COUNT_21           : vme_add_type := x"2854";--R/W
	constant ADD_A2_COUNT_22           : vme_add_type := x"2858";--R/W
	constant ADD_A2_COUNT_23           : vme_add_type := x"285C";--R/W
	constant ADD_A2_COUNT_24           : vme_add_type := x"2860";--R/W
	constant ADD_A2_COUNT_25           : vme_add_type := x"2864";--R/W
	constant ADD_A2_COUNT_26           : vme_add_type := x"2868";--R/W
	constant ADD_A2_COUNT_27           : vme_add_type := x"286C";--R/W
	constant ADD_A2_COUNT_28           : vme_add_type := x"2870";--R/W
	constant ADD_A2_COUNT_29           : vme_add_type := x"2874";--R/W
	constant ADD_A2_COUNT_30           : vme_add_type := x"2878";--R/W
	constant ADD_A2_COUNT_31           : vme_add_type := x"287C";--R/W
	constant ADD_A2_COUNT_32           : vme_add_type := x"2880";--R/W
	constant ADD_A2_COUNT_33           : vme_add_type := x"2884";--R/W
	constant ADD_A2_COUNT_34           : vme_add_type := x"2888";--R/W
	-------------------------------------------------------------------
	
	-- FOR RAM_COUNTER
	constant ADD_RC_READ_RESET			  : vme_add_type := x"1810";--W
	constant ADD_RC_COUNTS1				  : vme_add_type := x"1800";--R
	constant ADD_RC_COUNTS2			     : vme_add_type := x"1804";--R
	constant ADD_RC_COUNTS3				  : vme_add_type := x"1808";--R
	constant ADD_RC_COUNTS4				  : vme_add_type := x"180C";--R	

	-------------------------------------------------------------------
	constant ADD_A1_COUNT_S00          : vme_add_type := x"3000";--R
	constant ADD_A1_COUNT_S01          : vme_add_type := x"3004";--R
	constant ADD_A1_COUNT_S02          : vme_add_type := x"3008";--R
	constant ADD_A1_COUNT_S03          : vme_add_type := x"300C";--R
	constant ADD_A1_COUNT_S04          : vme_add_type := x"3010";--R
	constant ADD_A1_COUNT_S05          : vme_add_type := x"3014";--R
	constant ADD_A1_COUNT_S06          : vme_add_type := x"3018";--R
	constant ADD_A1_COUNT_S07          : vme_add_type := x"301C";--R
	constant ADD_A1_COUNT_S08          : vme_add_type := x"3020";--R	
	constant ADD_A1_COUNT_S09          : vme_add_type := x"3024";--R	
	constant ADD_A1_COUNT_S10          : vme_add_type := x"3028";--R	
	constant ADD_A1_COUNT_S11          : vme_add_type := x"302C";--R
	constant ADD_A1_COUNT_S12          : vme_add_type := x"3030";--R	
	constant ADD_A1_COUNT_S13          : vme_add_type := x"3034";--R	
	constant ADD_A1_COUNT_S14          : vme_add_type := x"3038";--R
	constant ADD_A1_COUNT_S15          : vme_add_type := x"303C";--R
	
	constant ADD_A1_COUNT_L00          : vme_add_type := x"3040";--R
	constant ADD_A1_COUNT_L01          : vme_add_type := x"3044";--R
	constant ADD_A1_COUNT_L02          : vme_add_type := x"3048";--R
	constant ADD_A1_COUNT_L03          : vme_add_type := x"304C";--R
	constant ADD_A1_COUNT_L04          : vme_add_type := x"3050";--R
	constant ADD_A1_COUNT_L05          : vme_add_type := x"3054";--R
	constant ADD_A1_COUNT_L06          : vme_add_type := x"3058";--R
	constant ADD_A1_COUNT_L07          : vme_add_type := x"305C";--R
	constant ADD_A1_COUNT_L08          : vme_add_type := x"3060";--R	
	constant ADD_A1_COUNT_L09          : vme_add_type := x"3064";--R	
	constant ADD_A1_COUNT_L10          : vme_add_type := x"3068";--R	
	constant ADD_A1_COUNT_L11          : vme_add_type := x"306C";--R
	constant ADD_A1_COUNT_L12          : vme_add_type := x"3070";--R	
	constant ADD_A1_COUNT_L13          : vme_add_type := x"3074";--R	
	constant ADD_A1_COUNT_L14          : vme_add_type := x"3078";--R
	constant ADD_A1_COUNT_L15          : vme_add_type := x"307C";--R
	
	constant ADD_A2_COUNT_S00          : vme_add_type := x"3400";--R
	constant ADD_A2_COUNT_S01          : vme_add_type := x"3404";--R
	constant ADD_A2_COUNT_S02          : vme_add_type := x"3408";--R
	constant ADD_A2_COUNT_S03          : vme_add_type := x"340C";--R
	constant ADD_A2_COUNT_S04          : vme_add_type := x"3410";--R
	constant ADD_A2_COUNT_S05          : vme_add_type := x"3414";--R
	constant ADD_A2_COUNT_S06          : vme_add_type := x"3418";--R
	constant ADD_A2_COUNT_S07          : vme_add_type := x"341C";--R
	constant ADD_A2_COUNT_S08          : vme_add_type := x"3420";--R	
	constant ADD_A2_COUNT_S09          : vme_add_type := x"3424";--R	
	constant ADD_A2_COUNT_S10          : vme_add_type := x"3428";--R	
	constant ADD_A2_COUNT_S11          : vme_add_type := x"342C";--R
	constant ADD_A2_COUNT_S12          : vme_add_type := x"3430";--R
	constant ADD_A2_COUNT_S13          : vme_add_type := x"3434";--R	
	constant ADD_A2_COUNT_S14          : vme_add_type := x"3438";--R
	constant ADD_A2_COUNT_S15          : vme_add_type := x"343C";--R
	
	constant ADD_A2_COUNT_L00          : vme_add_type := x"3440";--R
	constant ADD_A2_COUNT_L01          : vme_add_type := x"3444";--R
	constant ADD_A2_COUNT_L02          : vme_add_type := x"3448";--R
	constant ADD_A2_COUNT_L03          : vme_add_type := x"344C";--R
	constant ADD_A2_COUNT_L04          : vme_add_type := x"3450";--R
	constant ADD_A2_COUNT_L05          : vme_add_type := x"3454";--R
	constant ADD_A2_COUNT_L06          : vme_add_type := x"3458";--R
	constant ADD_A2_COUNT_L07          : vme_add_type := x"345C";--R
	constant ADD_A2_COUNT_L08          : vme_add_type := x"3460";--R	
	constant ADD_A2_COUNT_L09          : vme_add_type := x"3464";--R	
	constant ADD_A2_COUNT_L10          : vme_add_type := x"3468";--R	
	constant ADD_A2_COUNT_L11          : vme_add_type := x"346C";--R
	constant ADD_A2_COUNT_L12          : vme_add_type := x"3470";--R	
	constant ADD_A2_COUNT_L13          : vme_add_type := x"3474";--R	
	constant ADD_A2_COUNT_L14          : vme_add_type := x"3478";--R
	constant ADD_A2_COUNT_L15          : vme_add_type := x"347C";--R
	
	component PLL is
		PORT(
			areset         : in std_logic;	
			inclk0	      : in std_logic;
			c0	            : out std_logic;
			c1	            : out std_logic;
			locked	      : out std_logic
		);
	end component PLL;

	component clk_divi is 
		port(
			CLK            : in std_logic;
			WR             : out std_logic
		);
	end component clk_divi;

	component shift_register is 
		port(
			CLK            : in std_logic;
			WR             : in std_logic;
			SHIFT_EN       : out std_logic;
			OUTPUT         : out std_logic_vector(3 downto 0);
			INPUT          : in std_logic_vector(31 downto 0)
		);
	end component shift_register;
	
	component LB_INT is
		port(
			-- Local Bus in/out signals
			nLBRES         : in     std_logic;
			nBLAST         : in     std_logic;
			WnR            : in     std_logic;
			nADS           : in     std_logic;
			LCLK           : in     std_logic;
			nREADY         : out    std_logic;
			nINT           : out    std_logic;
			LAD            : inout  std_logic_vector(15 DOWNTO 0);
			--REG_STATUS : inout  std_logic_vector(31 DOWNTO 0);
			
			-- Internal Registers
			-------------READ/WRITE---------------
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

			-------------READ---------------
			
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
			REG_STATUS                : in std_logic_vector(31 downto 0);  
			VERSION                   : in std_logic_vector(31 downto 0); 
			----------- PLUSE GENERATE BY VME ACCESS -------------- 
			A1_LATCH_STOP_INTERNAL1      : out    std_logic;
			PRESET_CLEAR                 : out 	  std_logic;
			ECR_INTERNAL1                : out    std_logic;
			A1_COUNTER_LATCH_INTERNAL1   : out    std_logic;
			--			
			A2_LATCH_STOP_INTERNAL1      : out    std_logic;
			A2_COUNTER_LATCH_INTERNAL1   : out    std_logic;
			DSC_SCALER_STOP              : out 	  std_logic;
			DSC_SCALER_CLEAR             : out 	  std_logic;
			
			-- FOR RAM_COUNTERS
			RC_COUNTS1						: in std_logic_vector(31 downto 0);
			RC_COUNTS2						: in std_logic_vector(31 downto 0);		
			RC_COUNTS3						: in std_logic_vector(31 downto 0);		
			RC_COUNTS4						: in std_logic_vector(31 downto 0);	
			RC_READ_RESET					: out std_logic;
			RC_READ_INC1					: out std_logic;
			RC_READ_INC2					: out std_logic;
			RC_READ_INC3					: out std_logic;
			RC_READ_INC4					: out std_logic;
		
			-- FOR DISCRI SCLEAR
			A1_COUNT_S00              : in std_logic_vector(31 downto 0);
			A1_COUNT_S01              : in std_logic_vector(31 downto 0);
			A1_COUNT_S02              : in std_logic_vector(31 downto 0);
			A1_COUNT_S03              : in std_logic_vector(31 downto 0);
			A1_COUNT_S04              : in std_logic_vector(31 downto 0);
			A1_COUNT_S05              : in std_logic_vector(31 downto 0);
			A1_COUNT_S06              : in std_logic_vector(31 downto 0);
			A1_COUNT_S07              : in std_logic_vector(31 downto 0);
			A1_COUNT_S08              : in std_logic_vector(31 downto 0);
			A1_COUNT_S09              : in std_logic_vector(31 downto 0);
			A1_COUNT_S10              : in std_logic_vector(31 downto 0);
			A1_COUNT_S11              : in std_logic_vector(31 downto 0);
			A1_COUNT_S12              : in std_logic_vector(31 downto 0);
			A1_COUNT_S13              : in std_logic_vector(31 downto 0);
			A1_COUNT_S14              : in std_logic_vector(31 downto 0);
			A1_COUNT_S15              : in std_logic_vector(31 downto 0);	
		
			A1_COUNT_L00              : in std_logic_vector(31 downto 0);
			A1_COUNT_L01              : in std_logic_vector(31 downto 0);
			A1_COUNT_L02              : in std_logic_vector(31 downto 0);
			A1_COUNT_L03              : in std_logic_vector(31 downto 0);
			A1_COUNT_L04              : in std_logic_vector(31 downto 0);
			A1_COUNT_L05              : in std_logic_vector(31 downto 0);
			A1_COUNT_L06              : in std_logic_vector(31 downto 0);
			A1_COUNT_L07              : in std_logic_vector(31 downto 0);
			A1_COUNT_L08              : in std_logic_vector(31 downto 0);
			A1_COUNT_L09              : in std_logic_vector(31 downto 0);
			A1_COUNT_L10              : in std_logic_vector(31 downto 0);
			A1_COUNT_L11              : in std_logic_vector(31 downto 0);
			A1_COUNT_L12              : in std_logic_vector(31 downto 0);
			A1_COUNT_L13              : in std_logic_vector(31 downto 0);
			A1_COUNT_L14              : in std_logic_vector(31 downto 0);
			A1_COUNT_L15              : in std_logic_vector(31 downto 0);
		
			A2_COUNT_S00              : in std_logic_vector(31 downto 0);
			A2_COUNT_S01              : in std_logic_vector(31 downto 0);
			A2_COUNT_S02              : in std_logic_vector(31 downto 0);
			A2_COUNT_S03              : in std_logic_vector(31 downto 0);
			A2_COUNT_S04              : in std_logic_vector(31 downto 0);
			A2_COUNT_S05              : in std_logic_vector(31 downto 0);
			A2_COUNT_S06              : in std_logic_vector(31 downto 0);
			A2_COUNT_S07              : in std_logic_vector(31 downto 0);
			A2_COUNT_S08              : in std_logic_vector(31 downto 0);
			A2_COUNT_S09              : in std_logic_vector(31 downto 0);
			A2_COUNT_S10              : in std_logic_vector(31 downto 0);
			A2_COUNT_S11              : in std_logic_vector(31 downto 0);
			A2_COUNT_S12              : in std_logic_vector(31 downto 0);
			A2_COUNT_S13              : in std_logic_vector(31 downto 0);
			A2_COUNT_S14              : in std_logic_vector(31 downto 0);
			A2_COUNT_S15              : in std_logic_vector(31 downto 0);	
		
			A2_COUNT_L00              : in std_logic_vector(31 downto 0);
			A2_COUNT_L01              : in std_logic_vector(31 downto 0);
			A2_COUNT_L02              : in std_logic_vector(31 downto 0);
			A2_COUNT_L03              : in std_logic_vector(31 downto 0);
			A2_COUNT_L04              : in std_logic_vector(31 downto 0);
			A2_COUNT_L05              : in std_logic_vector(31 downto 0);
			A2_COUNT_L06              : in std_logic_vector(31 downto 0);
			A2_COUNT_L07              : in std_logic_vector(31 downto 0);
			A2_COUNT_L08              : in std_logic_vector(31 downto 0);
			A2_COUNT_L09              : in std_logic_vector(31 downto 0);
			A2_COUNT_L10              : in std_logic_vector(31 downto 0);
			A2_COUNT_L11              : in std_logic_vector(31 downto 0);
			A2_COUNT_L12              : in std_logic_vector(31 downto 0);
			A2_COUNT_L13              : in std_logic_vector(31 downto 0);
			A2_COUNT_L14              : in std_logic_vector(31 downto 0);
			A2_COUNT_L15              : in std_logic_vector(31 downto 0)	
		);
	end component LB_INT ;
	
	
	component LHCF_LOGIC_MAIN is
		port(
			-- Front Panel Ports
			A              : IN     std_logic_vector (31 DOWNTO 0);  -- In A (32 x LVDS/ECL)
			B              : IN     std_logic_vector (31 DOWNTO 0);  -- In B (32 x LVDS/ECL)
			C              : OUT    std_logic_vector (31 DOWNTO 0);  -- Out C (32 x LVDS)
			D              : INOUT  std_logic_vector (31 DOWNTO 0);  -- In/Out D (I/O Expansion)
			E              : INOUT  std_logic_vector (31 DOWNTO 0);  -- In/Out E (I/O Expansion)
			F              : INOUT  std_logic_vector (31 DOWNTO 0);  -- In/Out F (I/O Expansion)
			GIN            : IN     std_logic_vector ( 1 DOWNTO 0);   -- In G - LEMO (2 x NIM/TTL)
			GOUT           : OUT    std_logic_vector ( 1 DOWNTO 0);   -- Out G - LEMO (2 x NIM/TTL)
			-- Port Output Enable (0=Output, 1=Input)
			nOED           : OUT    std_logic;                       -- Output Enable Port D (only for A395D)
			nOEE           : OUT    std_logic;                       -- Output Enable Port E (only for A395D)
			nOEF           : OUT    std_logic;                       -- Output Enable Port F (only for A395D)
			nOEG           : OUT    std_logic;                       -- Output Enable Port G
			-- Port Level Select (0=NIM, 1=TTL)
			SELD           : OUT    std_logic;                       -- Output Level Select Port D (only for A395D)
			SELE           : OUT    std_logic;                       -- Output Level Select Port E (only for A395D)
			SELF           : OUT    std_logic;                       -- Output Level Select Port F (only for A395D)
			SELG           : OUT    std_logic;                       -- Output Level Select Port G

			-- Expansion Mezzanine Identifier:
			-- 000 : A395A (32 x IN LVDS/ECL)
			-- 001 : A395B (32 x OUT LVDS)
			-- 010 : A395C (32 x OUT ECL)
			-- 011 : A395D (8  x IN/OUT NIM/TTL)
			IDD            : IN     std_logic_vector (2 DOWNTO 0);   -- Slot D
			IDE            : IN     std_logic_vector (2 DOWNTO 0);   -- Slot E
			IDF            : IN     std_logic_vector (2 DOWNTO 0);   -- Slot F
	
			-- Delay Lines
			-- 0:1 => PDL (Programmable Delay Line): Step = 0.25ns / FSR = 64ns
			-- 2:3 => FDL (Free Running Delay Line with fixed delay)
			PULSE          : IN     std_logic_vector (3 DOWNTO 0);   -- Output of the delay line (0:1 => PDL; 2:3 => FDL)
			nSTART         : OUT    std_logic_vector (3 DOWNTO 2);   -- Start of FDL (active low)
			START          : OUT    std_logic_vector (1 DOWNTO 0);   -- Input of PDL (active high)
			DDLY           : INOUT  std_logic_vector (7 DOWNTO 0);   -- R/W Data for the PDL
			WR_DLY0        : OUT    std_logic;                       -- Write signal for the PDL0
			WR_DLY1        : OUT    std_logic;                       -- Write signal for the PDL1
			DIRDDLY        : OUT    std_logic;                       -- Direction of PDL data (0 => Read Dip Switches)
																				--                       (1 => Write from FPGA)
			nOEDDLY0       : OUT    std_logic;                       -- Output Enable for PDL0 (active low)
			nOEDDLY1       : OUT    std_logic;                       -- Output Enable for PDL1 (active low)
	
			-- LED drivers
			nLEDG          : OUT    std_logic;                       -- Green (active low)
			nLEDR          : OUT    std_logic;                       -- Red (active low)

			--Spare
			--SPARE        : INOUT  std_logic_vector (11 DOWNTO 0);

			-- Local Bus in/out signals
			nLBRES         : IN     std_logic;
			nBLAST         : IN     std_logic;
			WnR            : IN     std_logic;
			nADS           : IN     std_logic;
			LCLK           : IN     std_logic;
			nREADY         : OUT    std_logic;
			nINT           : OUT    std_logic;
			LAD            : INOUT  std_logic_vector (15 DOWNTO 0)
		);
	end component LHCF_LOGIC_MAIN;
	
	
	component gatep is
		port(
			LCLK				:	in	std_logic;
			A         		: in  std_logic_vector(31 downto 0);  -- in a (32 x lvds/ecl)
			B         		: in  std_logic_vector(31 downto 0);  -- in b (32 x lvds/ecl)
			C         		: out std_logic_vector(31 downto 0);			
			GIN            : in  std_logic_vector( 1 downto 0);
			ctrl_reg			:	in	std_logic_vector(31 downto 0);
			mask_A	      :	in	std_logic_vector(31 downto 0);
			mask_B	      :	in	std_logic_vector(31 downto 0);
			user_value_C	: in  std_logic_vector(31 downto 0);
			
			REG_STATUS		:	inout	std_logic_vector(31 downto 0);
			pattern			:	out	std_logic_vector(31 downto 0)
	 );
	end component gatep;
	
	component lbemulator is
	  port(
			nLBRES         : out    std_logic;
			nBLAST         : out    std_logic;
			WnR            : out    std_logic;
			nADS           : out    std_logic;
			LCLK           : in			std_logic;
			nREADY         : in     std_logic;
			nINT           : in     std_logic;
			LAD            : inout  std_logic_vector (15 DOWNTO 0) 
		);
	end component lbemulator ;
	
	component fpemulator is
		port(
			-- Front Panel Ports
			LCLK			  : in std_logic;
			A             : out		std_logic_vector (31 DOWNTO 0);  -- In A (32 x LVDS/ECL)
			B             : out 	std_logic_vector (31 DOWNTO 0);  -- In B (32 x LVDS/ECL)
			GIN           : out   std_logic_vector ( 1 DOWNTO 0)   -- In G - LEMO (2 x NIM/TTL)
		);
	end component fpemulator ;
	
	component SHIFT_REG_A is 
		port (
			CLK           : in  STD_LOGIC;
			START         : in  STD_LOGIC;
			SHIFT_EN      : in  STD_LOGIC;
			COUNT_00      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_01      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_02      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_03      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_04      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_05      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_06      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_07      : in  STD_LOGIC_VECTOR (31 downto 0);	
			COUNT_08      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_09      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_10      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_11      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_12      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_13      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_14      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_15      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_16      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_17      : in  STD_LOGIC_VECTOR (31 downto 0);	
			COUNT_18      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_19      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_20      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_21      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_22      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_23      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_24      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_25      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_26      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_27      : in  STD_LOGIC_VECTOR (31 downto 0);	
			COUNT_28      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_29      : in  STD_LOGIC_VECTOR (31 downto 0);	
			COUNT_30      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_31      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_32      : in  STD_LOGIC_VECTOR (31 downto 0);	
			COUNT_33      : in  STD_LOGIC_VECTOR (31 downto 0);
			COUNT_34      : in  STD_LOGIC_VECTOR (31 downto 0);		  
			WR_EN         : out  STD_LOGIC;
			SHIFT_COUNT   : out  STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;
	
	component SHIFT_REG_B is 
		port (
			CLK           : in   STD_LOGIC ;
			WR            : in   STD_LOGIC ;
			SHIFT_EN      : out   STD_LOGIC ;
			EXTER_EN      : out   STD_LOGIC ;
			INPUT         : in   STD_LOGIC_VECTOR (31 downto 0);
			OUTPUT        : out  STD_LOGIC_VECTOR (3 downto 0)
		);
	end component;
	component DSC_COUNTER is 
		port (	
			CLK       : in  std_logic;
			ECR       : in  std_logic;
			LATCH     : in  std_logic;
			SDSC2_IN  : in  std_logic_vector(15 downto 0);
			LDSC2_IN  : in  std_logic_vector(15 downto 0);
			COUNT_S00 : out std_logic_vector(31 downto 0);
			COUNT_S01 : out std_logic_vector(31 downto 0);
			COUNT_S02 : out std_logic_vector(31 downto 0);
			COUNT_S03 : out std_logic_vector(31 downto 0);
			COUNT_S04 : out std_logic_vector(31 downto 0);
			COUNT_S05 : out std_logic_vector(31 downto 0);
			COUNT_S06 : out std_logic_vector(31 downto 0);
			COUNT_S07 : out std_logic_vector(31 downto 0);
			COUNT_S08 : out std_logic_vector(31 downto 0);
			COUNT_S09 : out std_logic_vector(31 downto 0);
			COUNT_S10 : out std_logic_vector(31 downto 0);
			COUNT_S11 : out std_logic_vector(31 downto 0);
			COUNT_S12 : out std_logic_vector(31 downto 0);
			COUNT_S13 : out std_logic_vector(31 downto 0);
			COUNT_S14 : out std_logic_vector(31 downto 0);
			COUNT_S15 : out std_logic_vector(31 downto 0);
			
			COUNT_L00 : out std_logic_vector(31 downto 0);
			COUNT_L01 : out std_logic_vector(31 downto 0);
			COUNT_L02 : out std_logic_vector(31 downto 0);
			COUNT_L03 : out std_logic_vector(31 downto 0);
			COUNT_L04 : out std_logic_vector(31 downto 0);
			COUNT_L05 : out std_logic_vector(31 downto 0);
			COUNT_L06 : out std_logic_vector(31 downto 0);
			COUNT_L07 : out std_logic_vector(31 downto 0);
			COUNT_L08 : out std_logic_vector(31 downto 0);
			COUNT_L09 : out std_logic_vector(31 downto 0);
			COUNT_L10 : out std_logic_vector(31 downto 0);
			COUNT_L11 : out std_logic_vector(31 downto 0);
			COUNT_L12 : out std_logic_vector(31 downto 0);
			COUNT_L13 : out std_logic_vector(31 downto 0);
			COUNT_L14 : out std_logic_vector(31 downto 0);
			COUNT_L15 : out std_logic_vector(31 downto 0)
	);
	end component;
	
	component CONTROL_FLAG is 
		port (
		CLK              : in   STD_LOGIC ;
		FLAG             : in   STD_LOGIC ;
		CLEAR_FLAG       : out   STD_LOGIC);
	end component;

	component COUNTER_N is 
		generic(N : integer := 4);
		Port ( 
			CLK           : in  STD_LOGIC;
			RESET         : in  STD_LOGIC;
			ENABLE        : in  STD_LOGIC;
			PULSE         : out  STD_LOGIC);	
	end component;
	
	component CLK_PULSE is 
		generic(N : integer := 4);
		port (
			CLK           : in  std_logic;
			INPUT         : in  std_logic; 
			PRESET        : in std_logic_vector (N-1 downto 0);	
			OUTPUT        : out std_logic);
	end component;
	
	component INTERNALCOUNTER is 
		generic(N : integer := 4);
		port (
			CLK           : in std_logic;
			START         : in std_logic;
			PRESET        : in std_logic_vector (N-1 downto 0);
			STAT          : out std_logic;
			ENDMARK       : out std_logic);
	end component;
	
	component INTERNALCOUNTER3 is 
		generic(N : integer := 4);
		port (
			CLK           : in std_logic;
			START         : in std_logic;
			PRESET        : in std_logic_vector (N-1 downto 0);
			STAT          : out std_logic;
			ENDMARK       : out std_logic);
	end component;

	component INTERNALCOUNTER4 is 
		generic(N : integer := 4);
		port (
			CLK           : in std_logic;
			START         : in std_logic;
			PRESET        : in std_logic_vector (N-1 downto 0);
			STAT          : out std_logic;
			ENDMARK       : out std_logic);
	end component;

	component LOGIC_BPTX is 
		port (
			bptx1         : in std_logic;
			bptx2         : in std_logic;
			laser         : in std_logic;
			sellogic      : in std_logic_vector(2 downto 0);
			bptx          : out std_logic);
	end component;
	
	component LOGIC_BPTX01 is 
		port (
			bptx1         : in std_logic;
			bptx2         : in std_logic;
			laser         : in std_logic;
			laser_pede    : in std_logic;
			sellogic      : in std_logic_vector(2 downto 0);
			bptx          : out std_logic);
	end component;
	
	component LOGIC_BPTX2 is 
		port (
			bptx1         : in std_logic;
			bptx2         : in std_logic;
			sellogic      : in std_logic_vector(1 downto 0);
			bptx          : out std_logic);
	end component;

	component TESTOUT is 
		port(
			input         : in std_logic_vector(385 downto 0);
			mask          : in std_logic_vector(11 downto 0);
			output        : out std_logic);
	end component;
	
	component SYC_WIDTH is
		port (
			CLK           : in  std_logic;
			SDSC_IN       : in  std_logic_vector(15 downto 0);
			SDSC2         : out std_logic_vector(15 downto 0);
			LDSC_IN       : in  std_logic_vector(15 downto 0);
			LDSC2         : out std_logic_vector(15 downto 0));
	end component;
	
	component triggerlogic01 is
		port(
			CLK 	        : in  std_logic ;
			TRIG          : in  std_logic ; -- BPTX
			SDSC          : in  std_logic_vector(15 downto 0);  -- discriminator out of small tower 
			LDSC          : in  std_logic_vector(15 downto 0);  -- discriminator out of large tower
			CLEAR         : in  std_logic ; -- pattern clear
			STRIG1        : out std_logic ; -- logic out of small tower 
			LTRIG1        : out std_logic ; -- logic out of large tower
			STRIG2        : out std_logic ; -- coincidence with bptx1 
			LTRIG2        : out std_logic ; -- coincidence with bptx1
			SPATTERN      : out std_logic_vector(15 downto 0); -- discriminator pattern of s 
			LPATTERN      : out std_logic_vector(15 downto 0)); -- discriminator pattern of s
	end component;
	

	component triggerlogic02 is
		port(
			CLK 	        : in  std_logic ;
			TRIG          : in  std_logic ; -- BPTX
			SDSC          : in  std_logic_vector(15 downto 0);  -- discriminator out of small tower 
			LDSC          : in  std_logic_vector(15 downto 0);  -- discriminator out of large tower
			CLEAR         : in  std_logic ; -- pattern clear
			STRIG1        : out std_logic ; -- logic out of small tower 
			LTRIG1        : out std_logic ; -- logic out of large tower
			STRIG2        : out std_logic ; -- coincidence with bptx1 
			LTRIG2        : out std_logic ; -- coincidence with bptx1
			SPATTERN      : out std_logic_vector(15 downto 0); -- discriminator pattern of s 
			LPATTERN      : out std_logic_vector(15 downto 0)); -- discriminator pattern of s
	end component;
	
	component triggerlogic06 is
		port(
			CLK 	            : in  std_logic ;
			TRIG              : in  std_logic ; -- DL1T
			TRIG_BPTX         : in  std_logic ; -- LD_BPTX_AND
			SEL_SLOGIC_SOURCE : in  std_logic ;
	      SEL_LLOGIC_SOURCE : in  std_logic ;
			SDSC              : in  std_logic_vector(15 downto 0);  -- discriminator out of small tower 
			LDSC              : in  std_logic_vector(15 downto 0);  -- discriminator out of large tower
			CLEAR             : in  std_logic ; -- pattern clear
			STRIG1            : out std_logic ; -- logic out of small tower 
			LTRIG1            : out std_logic ; -- logic out of large tower	
			STRIG2            : out std_logic ; -- coincidence with DL1T 
			LTRIG2            : out std_logic ; -- coincidence with DL1T
			STRIG3            : out std_logic ; -- coincidence with LD_BPTX_AND 
			LTRIG3            : out std_logic ; -- coincidence with LD_BPTX_AND
			SPATTERN          : out std_logic_vector(15 downto 0); -- discriminator pattern of s 
			LPATTERN          : out std_logic_vector(15 downto 0)); -- discriminator pattern of s
	end component;
	
	component triggerlogic07 is
		port(
			CLK 	   : in  std_logic ;
			TRIG     : in  std_logic ; -- DL1T
			TRIG_BPTX: in  std_logic ; -- LD_BPTX_AND
			SDSC     : in  std_logic_vector(15 downto 0);  -- discriminator out of small tower 
			LDSC     : in  std_logic_vector(15 downto 0);  -- discriminator out of large tower
			CLEAR    : in  std_logic ; -- pattern clear
			STRIG1   : out std_logic ; -- logic out of small tower 
			LTRIG1   : out std_logic ; -- logic out of large tower	
			STRIG2   : out std_logic ; -- coincidence with DL1T 
			LTRIG2   : out std_logic ; -- coincidence with DL1T
			STRIG3   : out std_logic ; -- coincidence with LD_BPTX_AND 
			LTRIG3   : out std_logic ; -- coincidence with LD_BPTX_AND
			SPATTERN : out std_logic_vector(15 downto 0); -- discriminator pattern of s 
			LPATTERN : out std_logic_vector(15 downto 0)); -- discriminator pattern of s
	end component;

	component triggerlogic03 is
		port(
			CLK 	        : in  std_logic ;
			L1T           : in  std_logic ; -- BPTX
			SDSC          : in  std_logic_vector(15 downto 0);  -- discriminator out of small tower 
			LDSC          : in  std_logic_vector(15 downto 0);  -- discriminator out of large tower
			TRG           : out std_logic );
	end component;
	
	component triggerlogic04 is
		port(
			CLK 	        : in  std_logic ;
			L1T           : in  std_logic ; -- BPTX
			SDSC          : in  std_logic_vector(15 downto 0);  -- discriminator out of small tower 
			LDSC          : in  std_logic_vector(15 downto 0);  -- discriminator out of large tower
			TRG           : out std_logic );
	end component;

	component triggerlogic05 is
		port(
			CLK 	        : in  std_logic ;
			L1T           : in  std_logic ; -- BPTX
			SDSC          : in  std_logic_vector(15 downto 0);  -- discriminator out of small tower 
			LDSC          : in  std_logic_vector(15 downto 0);  -- discriminator out of large tower
			TRG           : out std_logic );
	end component;
	
	component triggerlogic08 is
		port(
			CLK 	            : in  std_logic ;
			L1T               : in  std_logic ; -- DL1T
			BPTX              : in  std_logic ; -- LD_BPTX
			SEL_SLOGIC_SOURCE : in  std_logic ;
	      SEL_LLOGIC_SOURCE : in  std_logic ;
			SDSC              : in  std_logic_vector(15 downto 0);  -- discriminator out of small tower 
			LDSC              : in  std_logic_vector(15 downto 0);  -- discriminator out of large tower
			TRG_BPTX          : out std_logic ;
			TRG               : out std_logic );
	end component;
	
	component SHOWER_MODULE is
		port(
			CLK                     : in  std_logic;
			CLK80                   : in  std_logic;
			DL1T                    : in  std_logic;
			BEAMFLAG                : in  std_logic;
			SDSC                    : in  std_logic_vector(15 downto 0);
			LDSC                    : in  std_logic_vector(15 downto 0);
			FLAG_CLEAR              : in  std_logic;
			NSTEP_SHOWER_TRG_PRESET : in  std_logic_vector(5 downto 0);
			SHOWER_SOURCE_MASK      : in  std_logic_vector(1 downto 0);
			SHOWER_MASK             : in  std_logic_vector(1 downto 0);
			
			STRIG1                  : out std_logic; -- logic out of small tower 
			LTRIG1                  : out std_logic; -- logic out of large tower
			STRG   					   : out std_logic; -- coincidence with bptx 
			LTRG   					   : out std_logic; -- coincidence with bptx
			SPATTERN                : out std_logic_vector(15 downto 0); -- discriminator pattern of s 
			LPATTERN                : out std_logic_vector(15 downto 0); -- discriminator pattern of s
			SHOWER_TRG1             : out std_logic;
			SHOWER_TRG2             : out std_logic;
			SHOWER_TRG3             : out std_logic;
			L2T_SHOWER              : out std_logic );
	end component;
	
	
	component  SHOWER_MODULE01 is port(
			CLK                     : in  std_logic;
			CLK80                   : in  std_logic;
			DL1T                    : in  std_logic;
			LD_BPTX                 : in  std_logic;
			BEAMFLAG                : in  std_logic;
			SDSC                    : in  std_logic_vector(15 downto 0);
			LDSC                    : in  std_logic_vector(15 downto 0);
			FLAG_CLEAR              : in  std_logic;
			NSTEP_SHOWER_TRG_PRESET : in  std_logic_vector(5 downto 0);
			SHOWER_SOURCE_MASK      : in  std_logic_vector(1 downto 0);
			SHOWER_MASK             : in  std_logic_vector(1 downto 0);
			
			STRIG1                  : out std_logic ; -- logic out of small tower 
			LTRIG1                  : out std_logic ; -- logic out of large tower
			STRG   					   : out std_logic ; -- coincidence with bptx 
			LTRG   					   : out std_logic ; -- coincidence with bptx
			SPATTERN                : out std_logic_vector(15 downto 0); -- discriminator pattern of s 
			LPATTERN                : out std_logic_vector(15 downto 0); -- discriminator pattern of s
			SHOWER_BPTX_X           : out std_logic;
			SHOWER_TRG1             : out std_logic;
			SHOWER_TRG2             : out std_logic;
			SHOWER_TRG3             : out std_logic;
			L2T_SHOWER              : out std_logic );
	end component;
	
	component  SHOWER_MODULE02 is port(
			CLK                     : in  std_logic;
			CLK80                   : in  std_logic;
			DL1T                    : in  std_logic;
			LD_BPTX                 : in  std_logic;
			BEAMFLAG                : in  std_logic;
			SEL_SLOGIC_SOURCE       : in  std_logic;
	      SEL_LLOGIC_SOURCE       : in  std_logic;
			SDSC                    : in  std_logic_vector(15 downto 0);
			LDSC                    : in  std_logic_vector(15 downto 0);
			FLAG_CLEAR              : in  std_logic;
			NSTEP_SHOWER_TRG_PRESET : in  std_logic_vector(5 downto 0);
			SHOWER_SOURCE_MASK      : in  std_logic_vector(1 downto 0);
			SHOWER_MASK             : in  std_logic_vector(1 downto 0);
			
			STRIG1                  : out std_logic ; -- logic out of small tower 
			LTRIG1                  : out std_logic ; -- logic out of large tower
			STRG   					   : out std_logic ; -- coincidence with bptx 
			LTRG   					   : out std_logic ; -- coincidence with bptx
			SPATTERN                : out std_logic_vector(15 downto 0); -- discriminator pattern of s 
			LPATTERN                : out std_logic_vector(15 downto 0); -- discriminator pattern of s
			SHOWER_BPTX_X           : out std_logic;
			SHOWER_TRG1             : out std_logic;
			SHOWER_TRG2             : out std_logic;
			SHOWER_TRG3             : out std_logic;
			L2T_SHOWER              : out std_logic );
	end component;
	
	
	component SPECIAL_TRG_MODULE is
		port(
			CLK                     : in  std_logic;
			CLK80                   : in  std_logic;
			DL1T                    : in  std_logic;
			BEAMFLAG                : in  std_logic;
			SDSC                    : in  std_logic_vector(15 downto 0);
			LDSC                    : in  std_logic_vector(15 downto 0);
			NSTEP_SPECIAL_TRG_PRESET: in  std_logic_vector(5 downto 0);
			SPECIAL_SOURCE_MASK     : in  std_logic_vector(1 downto 0);
			SPECIAL_TRG_MASK        : in  std_logic_vector(1 downto 0);
			SPECIAL_TRG1            : out std_logic;
			SPECIAL_TRG2            : out std_logic;
			SPECIAL_TRG3            : out std_logic;
			L2T_SPECIAL             : out std_logic );
	end component;	
	
	component SPECIAL_TRG_MODULE01 is
			port(
			CLK                     : in  std_logic;
			CLK80                   : in  std_logic;
			DL1T                    : in  std_logic;
			LD_BPTX                 : in  std_logic;
			BEAMFLAG                : in  std_logic;
			SDSC                    : in  std_logic_vector(15 downto 0);
			LDSC                    : in  std_logic_vector(15 downto 0);
			NSTEP_SPECIAL_TRG_PRESET: in  std_logic_vector(5 downto 0);
			SPECIAL_SOURCE_MASK     : in  std_logic_vector(1 downto 0);
			SPECIAL_TRG_MASK        : in  std_logic_vector(1 downto 0);
			SPECIAL_TRG_BPTX        : out std_logic;
			SPECIAL_TRG1            : out std_logic;
			SPECIAL_TRG2            : out std_logic;
			SPECIAL_TRG3            : out std_logic;
			L2T_SPECIAL             : out std_logic );
	end component;	
	
	component SPECIAL_TRG_MODULE02 is
			port(
			CLK                     : in  std_logic;
			CLK80                   : in  std_logic;
			DL1T                    : in  std_logic;
			LD_BPTX                 : in  std_logic;
			BEAMFLAG                : in  std_logic;
         SEL_SLOGIC_SOURCE       : in  std_logic;
	      SEL_LLOGIC_SOURCE       : in  std_logic;
			SDSC                    : in  std_logic_vector(15 downto 0);
			LDSC                    : in  std_logic_vector(15 downto 0);
			NSTEP_SPECIAL_TRG_PRESET: in  std_logic_vector(5 downto 0);
			SPECIAL_SOURCE_MASK     : in  std_logic_vector(1 downto 0);
			SPECIAL_TRG_MASK        : in  std_logic_vector(1 downto 0);
			SPECIAL_TRG_BPTX        : out std_logic;
			SPECIAL_TRG1            : out std_logic;
			SPECIAL_TRG2            : out std_logic;
			SPECIAL_TRG3            : out std_logic;
			L2T_SPECIAL             : out std_logic );
	end component;	
	
	component GATEandDELAY is
		port(
			CLK           : in std_logic;
			START         : in std_logic;	
			DELAY         : in std_logic_vector (7 downto 0);
			WIDTH         : in std_logic_vector (7 downto 0);
			STAT          : out std_logic;
			OUTPUT        : out std_logic;
			ENDMARK       : out std_logic);
	end component;
	
	component MUX is 
		port (
			SOURCE_IN1    : in std_logic;
			SOURCE_IN2    : in std_logic;
			FLAG          : in std_logic;
			SOURCE_OUT    : out std_logic);
	end component;
	
	component LATCH_M is 
		port (
			CLK           : in std_logic;
			START         : in std_logic;
			STOP          : in std_logic;
			OUTPUT        : out std_logic;
			STARTMARK     : out std_logic;
			ENDMARK       : out std_logic);
	end component;
	
	component SYNCHRONIZE is 
		port(
			CLK           : in std_logic;
			input         : in std_logic;
			output        : out std_logic);
	end component;
	
	component EN_COUNTER is 
		port (
			CLK           : in  std_logic;
			INPUT         : in  std_logic;  -- input width must be 25 nsec.
			CLR           : in  std_logic;
			INHIBIT       : in  std_logic;
			COUNT_MAX     : in  std_logic_vector(15 downto 0);
			ENABLE        : out std_logic);
	end component;

	component SCOUNTER is 
		port (
			CLK           : in  std_logic;
			INPUT         : in  std_logic;  -- input width must be 25 nsec.
			CLR           : in  std_logic;
			INHIBIT       : in  std_logic;
			COUNT         : out std_logic_vector(31 downto 0));
	end component;
	
	component SCOUNTER2 is 
		port (
			CLK           : in  std_logic;
			INPUT         : in  std_logic;  
			CLR           : in  std_logic;
			INHIBIT       : in  std_logic;
			COUNT         : out std_logic_vector(31 downto 0));
	end component;
	
	component CLK_COUNTER is 
		generic ( N : integer := 32 );
			port (
			CLK           : in  std_logic;
			CLR           : in  std_logic;
			INHIBIT       : in  std_logic;
			LATCH         : in  std_logic;
			CLEAR         : in  std_logic;
			BCOUNT        : out std_logic_vector(N-1 downto 0));
	end component;
	
	component CLK_COUNTER3 is 
		generic ( N : integer := 32 );
			port (
			CLK     : in  std_logic;
			CLR     : in  std_logic;
			INHIBIT : in  std_logic;
			LATCH1  : in  std_logic;
			LATCH2  : in  std_logic;
			CLEAR   : in  std_logic;
			BCOUNT1 : out std_logic_vector(N-1 downto 0);
			BCOUNT2 : out std_logic_vector(N-1 downto 0));
	end component;
	
	component BUFFER_COUNTER is 
		generic ( N : integer := 32);
			port (
			CLK           : in  std_logic;
			LATCH         : in  std_logic;
			CLEAR         : in  std_logic;
			COUNT         : in  std_logic_vector(N-1 downto 0);
			BCOUNT        : out std_logic_vector(N-1 downto 0));
	end component;
	
	component TESTOUT2 is 
		port(
			input         : in std_logic_vector(47 downto 0);
			mask          : in std_logic_vector(15 downto 0);
			output        : out std_logic);
	end component;
	
	component LOGIC_FC is 
		port (
			CLK           : in std_logic;
			BPTX          : in std_logic;
			INPUT         : in std_logic_vector(3 downto 0);
			SEL           : in std_logic_vector(7 downto 0);
			CLR           : in std_logic;
			TRG1          : out std_logic;	
			TRG2          : out std_logic;  -- COINCIDENCE WITH BPTX
			OUTPUT        : out std_logic_vector(3 downto 0);
			BOUT          : out std_logic_vector(3 downto 0));
	end component;
	
	component LOGIC_FC01 is 
		port (
			CLK     : in std_logic;
			L1T     : in std_logic;
			BPTX    : in std_logic;
			INPUT   : in std_logic_vector(3 downto 0);
			SEL     : in std_logic_vector(7 downto 0);
			CLR     : in std_logic;
			TRG1    : out std_logic; 	
			TRG2    : out std_logic;  -- COINCIDENCE WITH DL1T
			TRG3    : out std_logic;  -- COINCIDENCE WITH LD_BPTX
			OUTPUT  : out std_logic_vector(3 downto 0);
			BOUT    : out std_logic_vector(3 downto 0));
	end component;
	
	component FC_MODULE is 
		port (
			CLK           : in  std_logic;
			CLK80         : in  std_logic;
			DBPTX         : in  std_logic;
			CLEAR         : in  std_logic;
			FC_MASK       : in  std_logic_vector(7 downto 0);
			FC            : in  std_logic_vector(3 downto 0);
			FC2           : out std_logic_vector(3 downto 0);
			PATTERN       : out std_logic_vector(3 downto 0);
			FCL           : out std_logic_vector(3 downto 0);
			FCL_OR        : out std_logic;
			FC_TRG1       : out std_logic;
			FC_TRG2       : out std_logic);
	end component;
	
	component FC_MODULE01 is 
		port (
			CLK           : in  std_logic;
			CLK80         : in  std_logic;
			DL1T          : in  std_logic;
			LD_BPTX       : in  std_logic;
			FC_MASK       : in  std_logic_vector(7 downto 0);
			FC            : in  std_logic_vector(3 downto 0);
			FC2           : out std_logic_vector(3 downto 0);
			PATTERN       : out std_logic_vector(3 downto 0);
			FCL           : out std_logic_vector(3 downto 0);
			FCL_OR        : out std_logic;
			FC_TRG1       : out std_logic;
			FC_TRG2       : out std_logic;
			FC_TRG_BPTXX  : out std_logic);
	end component;
	
	component FIFO_COUNTER is 
		port (
			CLK           : in std_logic;
			COUNT         : in std_logic_vector(31 downto 0);
			WR            : in std_logic;
	--		RD            : in std_logic;
			LATCH         : in std_logic;
			OUTPUT0       : out std_logic_vector(31 downto 0);
			OUTPUT1       : out std_logic_vector(31 downto 0);
			OUTPUT2       : out std_logic_vector(31 downto 0);
			OUTPUT3       : out std_logic_vector(31 downto 0));		
   end component;
	
	component TESTOUT3 is 
		port (
			input1        : in std_logic_vector(18 downto 0);
			input2        : in std_logic_vector(15 downto 0);
			input3        : in std_logic_vector(15 downto 0);
			input4        : in std_logic_vector(15 downto 0);
			input5        : in std_logic_vector(15 downto 0);
			input6        : in std_logic_vector(15 downto 0);
			mask          : in std_logic_vector(11 downto 0);
			output        : out std_logic);
   end component;

	component SCOUNTER3 is 
		generic(N : integer := 31);
			port(
			CLK           : in  std_logic;
			INPUT         : in  std_logic; 
			CLR           : in  std_logic;
			INHIBIT       : in  std_logic;
			LATCH         : in  std_logic;
			CLEAR         : in  std_logic;
			BCOUNT        : out std_logic_vector(N-1 downto 0));
	end component;

	component SCOUNTER_2LATCH is 
		generic ( N : integer := 31 );
			Port (
		   CLK           : in  STD_LOGIC;
		   INPUT         : in  STD_LOGIC;
		   CLR           : in  STD_LOGIC;
		   INHIBIT       : in  STD_LOGIC;
		   LATCH1        : in  STD_LOGIC;
		   LATCH2        : in  STD_LOGIC;
		   CLEAR         : in  STD_LOGIC;
		   BCOUNT1       : out  STD_LOGIC_VECTOR (N-1 downto 0);
		   BCOUNT2       : out  STD_LOGIC_VECTOR (N-1 downto 0));
		end component;
	
	component SCOUNTER4 is 
		generic (N : integer := 31);
			port (
			CLK           : in  std_logic;
			INPUT         : in  std_logic; 
			CLR           : in  std_logic;
			COUNT         : out std_logic_vector(N-1 downto 0));
	end component;

	component BUNCHCOUNTER is 
		generic (N : integer := 24);
			port (
			CLK           : in  std_logic;
			BPTX          : in  std_logic;
			ORBIT         : in  std_logic;
			INPUT         : in  std_logic; 
			CLR           : in  std_logic;
			COUNT01       : out std_logic_vector(N-1 downto 0);
			COUNT02       : out std_logic_vector(N-1 downto 0);
			COUNT03       : out std_logic_vector(N-1 downto 0);
			COUNT04       : out std_logic_vector(N-1 downto 0);
			COUNT05       : out std_logic_vector(N-1 downto 0);
			COUNT06       : out std_logic_vector(N-1 downto 0);
			COUNT07       : out std_logic_vector(N-1 downto 0);
			COUNT08       : out std_logic_vector(N-1 downto 0);
			COUNT09       : out std_logic_vector(N-1 downto 0);
			COUNT10       : out std_logic_vector(N-1 downto 0);
			COUNT11       : out std_logic_vector(N-1 downto 0);
			COUNT12       : out std_logic_vector(N-1 downto 0);
			COUNT13       : out std_logic_vector(N-1 downto 0);
			COUNT14       : out std_logic_vector(N-1 downto 0);
			COUNT15       : out std_logic_vector(N-1 downto 0);
			COUNT16       : out std_logic_vector(N-1 downto 0);
			COUNT17       : out std_logic_vector(N-1 downto 0);
			COUNT18       : out std_logic_vector(N-1 downto 0);
			COUNT19       : out std_logic_vector(N-1 downto 0);
			COUNT20       : out std_logic_vector(N-1 downto 0));
	end component;
	
	component BUFFER_SIGNAL is 
		port (
			CLK           : in  std_logic;
			LATCH         : in  std_logic;
			CLR           : in  std_logic;
			INPUT         : in  std_logic;
			OUTPUT        : out std_logic);
	end component;		

	component CLK_COUNTER2 is 
		port (
			CLK           : in  std_logic;
			CLR           : in  std_logic;
			INHIBIT       : in  std_logic;
			COUNT         : out std_logic_vector(31 downto 0));
	end component;

   component PRESETCOUNTER is 
		generic(N : integer := 4);
			port (
			CLK           : in std_logic;
			INPUT         : in std_logic;
			PRESET        : in std_logic_vector (N-1 downto 0);
			CLEAR         : in std_logic;
			STAT          : out std_logic);
	end component;

   component PRESETCOUNTER2 is 
		generic(N : integer := 4);
			port (
			CLK           : in std_logic;
			INPUT         : in std_logic;
			PRESET        : in std_logic_vector (N-1 downto 0);
			CLEAR         : in std_logic;
			INITVAL       : in std_logic_vector (N-1 downto 0);
			STAT          : out std_logic);
	end component;


	component BPTXMASK is 
		port (
			CLK           : in std_logic;
			INPUT         : in std_logic;                        
			ORBIT         : in std_logic;                        
			MASK          : in std_logic_vector(31 downto 0);
			STAT          : out std_logic);
	end component;

	component TESTOUT_L1T is 
		port (
			input1        : in std_logic_vector(51 downto 0);
			input2        : in std_logic_vector( 7 downto 0);
			input3        : in std_logic_vector(26 downto 0);
			input4        : in std_logic_vector(17 downto 0);
			mask          : in std_logic_vector(11 downto 0);
			output        : out std_logic);
	end component;

	component TESTOUT_SPS is 
		port (
			input         : in std_logic_vector(31 downto 0);
			mask          : in std_logic_vector(11 downto 0);
			output        : out std_logic);
	end component;

	component DSCWIDTH is 
		port (
			CLK           : in  std_logic;
			DSC_IN        : in  std_logic_vector(15 downto 0);
			DSC_OUT       : out std_logic_vector(15 downto 0));
	end component;
-------------------CLK PLL----------------------------------
	component CLKMHZ is 
		port (
			CLK           : in  std_logic;
			MHZ           : out std_logic);
	end component;

	component CLK10HZ is 
		port (
			CLK           : in  std_logic;
			OUTPUT        : out std_logic);
	end component;
-----------------------------------------------------------

	component CONV_INTEG is 
	generic(
	NBITS  : integer := 7 );
		port(
			DSELECT       : in std_logic_vector(6 downto 0);
			NCLK          : out integer);
	end component;

	component LINEDELAY is 
	generic(
	NMAX   : integer := 48;
	NBITS  : integer := 7 );
		port(
			CLK           : in std_logic;
			INPUT         : in std_logic;
			DSELECT       : in std_logic_vector(6 downto 0);
			OUTPUT        : out std_logic);
	end component;
	
	component LINEDELAY_FIX is 
	generic(NMAX   : integer := 4);
		port(
			CLK           : in std_logic;
			INPUT         : in std_logic;
			OUTPUT        : out std_logic);
	end component;

  function AND_WITH_MASK (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal input3    : in std_logic;
		signal mask      : in std_logic_vector(3 downto 0))
		return std_logic;
	
  function OR_WITH_MASK (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal input3    : in std_logic;
		signal mask      : in std_logic_vector(3 downto 0))
		return std_logic;
		
  function AND_WITH_MASK3 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal mask      : in std_logic_vector(2 downto 0))
		return std_logic;
	
  function OR_WITH_MASK3 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal mask      : in std_logic_vector(2 downto 0))
		return std_logic; 

  function AND_WITH_MASK2 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal mask      : in std_logic_vector(1 downto 0))
		return std_logic;
	
  function OR_WITH_MASK2 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal mask      : in std_logic_vector(1 downto 0))
		return std_logic; 
		
  function OR_WITH_MASK5 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal input3    : in std_logic;
		signal input4    : in std_logic;
		signal mask      : in std_logic_vector(4 downto 0))
		return std_logic; 
		
  function OR_WITH_MASK8 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal input3    : in std_logic;
		signal input4    : in std_logic;
		signal input5    : in std_logic;
		signal input6    : in std_logic;
		signal input7    : in std_logic;
		signal mask      : in std_logic_vector(7 downto 0))
		return std_logic; 

  function OR_WITH_MASK10 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal input3    : in std_logic;
		signal input4    : in std_logic;
		signal input5    : in std_logic;
		signal input6    : in std_logic;
		signal input7    : in std_logic;
		signal input8    : in std_logic;
		signal input9    : in std_logic;
		signal mask      : in std_logic_vector(9 downto 0))
		return std_logic; 
		

	-- Added by Menjo at 2015/03/15
	component RAM_COUNTER is 
	port(
		CLK1				: in std_logic;
		CLK2				: in std_logic;
		COUNTER_SIGNAL	: in std_logic;  -- syncronized with CLK1    
		BUF_INC			: in std_logic;  -- syncronized with CLK1   
		BUF_RESET		: in std_logic;  -- syncronized with CLK1   
		CLEAR				: in std_logic;
		READ_RESET		: in std_logic;  -- syncronized with CLK2 
		READ_INC			: in std_logic;  -- syncronized with CLK2 
		DATA_OUT			: out std_logic_vector(31 downto 0)
	);
	end component;	

---------------------------------------------------------------
-------------------- FOR LHCF_FC_SCALER -----------------------
---------------------------------------------------------------
	component LB_INT_FC_SCALER is
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
	end component ;
	
	component TESTOUT_FC_SCALER is port(
		input  : in std_logic_vector(51 downto 0);
		mask   : in std_logic_vector(7 downto 0);
		output : out std_logic);
	end component;
	
END components;

--------------------components body----------------------------

package body components is

  function AND_WITH_MASK (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal input3    : in std_logic;
		signal mask      : in std_logic_vector(3 downto 0))
	return std_logic is 
		variable output  : std_logic;
	begin 
		output := ( input0 or (not mask(0)) ) and
					 ( input1 or (not mask(1)) ) and
					 ( input2 or (not mask(2)) ) and
					 ( input3 or (not mask(3)) );
		return output;
	end AND_WITH_MASK;
	
	function OR_WITH_MASK (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal input3    : in std_logic;
		signal mask      : in std_logic_vector(3 downto 0))
	return std_logic is 
		variable output  : std_logic;
	begin 
		output := ( input0 and mask(0) ) or
					 ( input1 and mask(1) ) or
					 ( input2 and mask(2) ) or
					 ( input3 and mask(3) );
		return output;
	end OR_WITH_MASK;
	
	 function AND_WITH_MASK3 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal mask      : in std_logic_vector(2 downto 0))
	return std_logic is 
		variable output  : std_logic;
	begin 
		output := ( input0 or (not mask(0)) ) and
					 ( input1 or (not mask(1)) ) and
					 ( input2 or (not mask(2)) );
		return output;
	end AND_WITH_MASK3;
	
	function OR_WITH_MASK3 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal mask      : in std_logic_vector(2 downto 0))
	return std_logic is 
		variable output  : std_logic;
	begin 
		output := ( input0 and mask(0) ) or
					 ( input1 and mask(1) ) or
					 ( input2 and mask(2) );
		return output;
	end OR_WITH_MASK3;
	
	function AND_WITH_MASK2 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal mask      : in std_logic_vector(1 downto 0))
	return std_logic is 
		variable output  : std_logic;
	begin 
		output := ( input0 or (not mask(0)) ) and
					 ( input1 or (not mask(1)) );
		return output;
	end AND_WITH_MASK2;
	
	function OR_WITH_MASK2 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal mask      : in std_logic_vector(1 downto 0))
	return std_logic is 
		variable output  : std_logic;
	begin 
		output := ( input0 and mask(0) ) or
					 ( input1 and mask(1) );
		return output;
	end OR_WITH_MASK2;
	
	function OR_WITH_MASK5 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;	
		signal input3    : in std_logic;
		signal input4    : in std_logic;
		signal mask      : in std_logic_vector(4 downto 0))
	return std_logic is 
		variable output  : std_logic;
	begin 
		output := ( input0 and mask(0) ) or
					 ( input1 and mask(1) ) or
					 ( input2 and mask(2) ) or
					 ( input3 and mask(3) ) or
					 ( input4 and mask(4) ) ;
		return output;
	end OR_WITH_MASK5;
	
	function OR_WITH_MASK8 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;	
		signal input3    : in std_logic;
		signal input4    : in std_logic;
		signal input5    : in std_logic;
		signal input6    : in std_logic;
		signal input7    : in std_logic;	
		signal mask      : in std_logic_vector(7 downto 0))
	return std_logic is 
		variable output  : std_logic;
	begin 
		output := ( input0 and mask(0) ) or
					 ( input1 and mask(1) ) or
					 ( input2 and mask(2) ) or
					 ( input3 and mask(3) ) or
					 ( input4 and mask(4) ) or
					 ( input5 and mask(5) ) or
					 ( input6 and mask(6) ) or
					 ( input7 and mask(7) ) ;
		return output;
	end OR_WITH_MASK8;

  function OR_WITH_MASK10 (
		signal input0    : in std_logic;
		signal input1    : in std_logic;
		signal input2    : in std_logic;
		signal input3    : in std_logic;
		signal input4    : in std_logic;
		signal input5    : in std_logic;
		signal input6    : in std_logic;
		signal input7    : in std_logic;
		signal input8    : in std_logic;
		signal input9    : in std_logic;
		signal mask      : in std_logic_vector(9 downto 0))
		return std_logic is 
		variable output  : std_logic;
	begin 
		output := ( input0 and mask(0) ) or
					 ( input1 and mask(1) ) or
					 ( input2 and mask(2) ) or
					 ( input3 and mask(3) ) or
					 ( input4 and mask(4) ) or
					 ( input5 and mask(5) ) or
					 ( input6 and mask(6) ) or
					 ( input7 and mask(7) ) or
					 ( input8 and mask(8) ) or
					 ( input9 and mask(9) ) ;
		return output;
	end OR_WITH_MASK10;
	
	
END components;