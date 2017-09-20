----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:10 11/26/2014 
-- Design Name: 
-- Module Name:    FC_MODULE01 - Behavioral 
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

entity FC_MODULE01 is port(
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
	FC_TRG_BPTXX  : out std_logic
);
end FC_MODULE01;

architecture Behavioral of FC_MODULE01 is 
	signal FC_TRG       : std_logic;
	signal FC_TRG_D     : std_logic;
--	signal FC_TRG_D1    : std_logic;
--	signal FC_TRG_D2    : std_logic;
	signal FC_SYC       : std_logic_vector(3 downto 0);
	signal FC_D         : std_logic_vector(3 downto 0);
	signal FC2_INTER    : std_logic_vector(3 downto 0);
begin

	FC_TRG1 <= FC_TRG;
	FC2     <= FC2_INTER;
	GEN_SYC_FC: for i in 0 to 3 generate 
		SYC_FC : SYNCHRONIZE port map(
			CLK    => CLK80,
			INPUT  => FC(i),
			OUTPUT => FC_SYC(i)
		);

		WIDTH_FC : INTERNALCOUNTER generic map (8) port map(
			CLK          =>  CLK80,
			START        =>  FC_SYC(i),
			PRESET       =>  x"0C",
			STAT         =>  FC_D(i),
			ENDMARK      =>  open
		);

		FC2_INTER(i) <= FC_SYC(i) or FC_D(i);
	end generate;
	
	L_FC : LOGIC_FC01 port map(
		CLK     => CLK80,
		L1T     => DL1T,
		BPTX    => LD_BPTX,
		INPUT   => FC2_INTER,
--		SEL     => FC_MASK,
		SEL     => x"FF",
		CLR     => '0',       --FLAG_CLEAR
		TRG1    => FCL_OR,    -- w/o coinsidence with BPTX
		TRG2    => FC_TRG,    -- w/  coinsidence with BPTX
		TRG3    => FC_TRG_BPTXX,    -- w/  coinsidence with BPTX
		OUTPUT  => FCL,
		BOUT    => PATTERN
	);
	
	FC2_WIDTH : INTERNALCOUNTER generic map (4) port map(
		CLK          => CLK80,
		START        => FC_TRG,
		PRESET       => "0101", 
		STAT         => FC_TRG_D,                                      
		ENDMARK      => open                                              
	);
	
	FC_TRG2 <= FC_TRG or FC_TRG_D;
	
end Behavioral;

