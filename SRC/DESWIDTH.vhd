----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:10 02/19/2008 
-- Design Name: 
-- Module Name:    DSCWIDTH - Behavioral 
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

entity DSCWIDTH is port(
	CLK     : in  std_logic;
	DSC_IN  : in  std_logic_vector(15 downto 0);
	DSC_OUT : out std_logic_vector(15 downto 0)
);
end DSCWIDTH;

architecture Behavioral of DSCWIDTH is
	constant NCLK_WIDTH : std_logic_vector(2 downto 0) := "101"; 
	signal TMP1 : std_logic;
	signal TMP2 : std_logic;
begin


	DSC_L0 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(0),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(0),
		ENDMARK  => open
	);

	DSC_L1 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(1),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(1),
		ENDMARK  => open
	);

	DSC_L2 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(2),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(2),
		ENDMARK  => open
	);

	DSC_L3 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(3),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(3),
		ENDMARK  => open
	);

	DSC_L4 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(4),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(4),
		ENDMARK  => open
	);

	DSC_L5 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(5),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(5),
		ENDMARK  => open
	);

	DSC_L6 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(6),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(6),
		ENDMARK  => open
	);

	DSC_L7 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(7),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(7),
		ENDMARK  => open
	);

	DSC_L8 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(8),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(8),
		ENDMARK  => open
	);

	DSC_L9 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(9),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(9),
		ENDMARK  => open
	);

	DSC_L10 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(10),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(10),
		ENDMARK  => open
	);

	DSC_L11 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(11),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(11),
		ENDMARK  => open
	);

	DSC_L12 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(12),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(12),
		ENDMARK  => open
	);

	DSC_L13 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(13),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(13),
		ENDMARK  => open
	);

	DSC_L14 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(14),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(14),
		ENDMARK  => open
	);

	DSC_L15 : INTERNALCOUNTER4 generic map(3) port map(
		CLK      => CLK,
		START    => DSC_IN(15),
		PRESET   => NCLK_WIDTH,
		STAT     => DSC_OUT(15),
		ENDMARK  => open
	);



end Behavioral;

