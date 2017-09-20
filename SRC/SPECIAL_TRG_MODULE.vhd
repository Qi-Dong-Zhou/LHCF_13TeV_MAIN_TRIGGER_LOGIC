----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:10 11/26/2014 
-- Design Name: 
-- Module Name:    SHOWER_MODULE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.components.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPECIAL_TRG_MODULE is port(
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
	L2T_SPECIAL             : out std_logic
);
end SPECIAL_TRG_MODULE;

architecture Behavioral of SPECIAL_TRG_MODULE is 
	signal SUB_SPECIAL_TRG1        : std_logic := '0';
	signal SUB_SPECIAL_TRG2        : std_logic := '0';
	signal SUB_SPECIAL_TRG3        : std_logic;
	signal SUB_SPECIAL_TRG3_D      : std_logic;
--	signal SUB_SPECIAL_TRG3_D1     : std_logic;
--	signal SUB_SPECIAL_TRG3_D2     : std_logic;
	signal SPECIAL_TRG_PRESET1     : std_logic := '0';
	signal SPECIAL_TRG_PRESET2     : std_logic := '0';
begin

	SPECIAL_TRG1 <= SUB_SPECIAL_TRG1;
	SPECIAL_TRG2 <= SUB_SPECIAL_TRG2;
	SPECIAL_TRG3 <= SUB_SPECIAL_TRG3;

	TRIGGERLOGIC_SPECIAL : TRIGGERLOGIC05 port map(
		CLK      => CLK80,
		L1T      => DL1T,
		SDSC     => SDSC,
		LDSC     => LDSC,
		TRG      => SUB_SPECIAL_TRG1
	);

	SPECIAL_TRG_PRESET1 <= SUB_SPECIAL_TRG1;
	
	PERSET_SPECIAL_TRG_PRESET: PRESETCOUNTER generic map(6) port map(
		CLK =>    CLK80,
		INPUT =>  SPECIAL_TRG_PRESET1,
		PRESET => NSTEP_SPECIAL_TRG_PRESET,
		CLEAR =>  '0',
		STAT =>   SPECIAL_TRG_PRESET2
	);
	
	SUB_SPECIAL_TRG2 <= OR_WITH_MASK2(  SUB_SPECIAL_TRG1,
											   SPECIAL_TRG_PRESET2,
											   SPECIAL_SOURCE_MASK);

	SUB_SPECIAL_TRG3 <= AND_WITH_MASK2( SUB_SPECIAL_TRG2,
											   BEAMFLAG,
											   SPECIAL_TRG_MASK);
													
	L2T_SPECIAL_WIDTH : INTERNALCOUNTER generic map (4) port map(
		CLK          => CLK80,
		START        => SUB_SPECIAL_TRG3,
		PRESET       => "0101", 
		STAT         => SUB_SPECIAL_TRG3_D,                                      
		ENDMARK      => open                                              
	);
	
	L2T_SPECIAL <= SUB_SPECIAL_TRG3 or SUB_SPECIAL_TRG3_D;

	
--	L2T_SPC_WIDTH1 : LINEDELAY_FIX generic map(1) port map (
--	   CLK		=> CLK80,
--	   INPUT	   => SUB_SPECIAL_TRG3,
--	   OUTPUT   => SUB_SPECIAL_TRG3_D
--	);
--	
--	SUB_SPECIAL_TRG3_D1 <= SUB_SPECIAL_TRG3 or SUB_SPECIAL_TRG3_D;
--	
--	L2T_SPC_WIDTH2 : LINEDELAY_FIX generic map(2) port map (
--	   CLK		=> CLK80,
--	   INPUT	   => SUB_SPECIAL_TRG3_D1,
--	   OUTPUT   => SUB_SPECIAL_TRG3_D2
--	);
--
--	L2T_SPECIAL <= SUB_SPECIAL_TRG3_D1 or SUB_SPECIAL_TRG3_D2;
	
	
end Behavioral;

