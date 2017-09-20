----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:10 02/19/2008 
-- Design Name: 
-- Module Name:    SYNCHRONIZE - Behavioral 
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
USE ieee.numeric_std.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LINEDELAY is 
generic(
	NMAX   : integer := 48;
	NBITS  : integer := 7
);
port(
	CLK     : in std_logic;
	INPUT   : in std_logic;
	DSELECT : in std_logic_vector(NBITS-1 downto 0);
	OUTPUT  : out std_logic
);
end LINEDELAY;

architecture Behavioral of LINEDELAY is
	signal TOUT       : std_logic;
	signal DELAY_LINE : std_logic_vector(NMAX-1 downto 0);
	signal NDLY  : integer :=0;
--	signal DUMMY : std_logic_vector(7 downto 0):= "00001010";
begin
	
	process (CLK) begin
		if(CLK'event and CLK='1') then
			DELAY_LINE(0) <= INPUT; 
		end if;
	end process;
	
	INPUT_DELAY_PROCESS : for i in 1 to NMAX-1 generate
		process (CLK) begin
			if(CLK'event and CLK='1') then
				DELAY_LINE(i) <= DELAY_LINE(i-1);
			end if;
		end process;
	end generate;
	
	OUTPUT <= DELAY_LINE(to_integer(unsigned(DSELECT)));

end Behavioral;


-- THE OLD VERSION-------------------------
------------------------------------------------------------------------------------
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
------ Uncomment the following library declaration if instantiating
------ any Xilinx primitives in this code.
----library UNISIM;
----use UNISIM.VComponents.all;
--
--entity LINEDELAY is port(
--	CLK     : in std_logic;
--	INPUT   : in std_logic;
--	DSELECT : in std_logic_vector(6 downto 0);
--	OUTPUT  : out std_logic
--);
--end LINEDELAY;
--
--architecture Behavioral of LINEDELAY is
--	signal TOUT  : std_logic;
--	signal DLINE : std_logic_vector(127 downto 0);
--	signal TDSELECT : std_logic_vector(7 downto 0) := x"00";
--begin
--
--	TDSELECT(6 downto 0) <= DSELECT;
--	
--	process (CLK) begin
--		if(CLK'event and CLK='1') then
--			DLINE(127 downto 1) <= DLINE(126 downto 0);
--			DLINE(0) <= INPUT; 
--		end if;
--
--		case TDSELECT is
--
--			when x"38"     => OUTPUT <= DLINE(56);
--			when x"39"     => OUTPUT <= DLINE(57);
--			when x"3A"     => OUTPUT <= DLINE(58);
--			when x"3B"     => OUTPUT <= DLINE(59);
--			when x"3C"     => OUTPUT <= DLINE(60);
--			when x"3D"     => OUTPUT <= DLINE(61);
--			when x"3E"     => OUTPUT <= DLINE(62);
--			when x"3F"     => OUTPUT <= DLINE(63);
--			when x"40"     => OUTPUT <= DLINE(64);
--			when x"41"     => OUTPUT <= DLINE(65);
--			when x"42"     => OUTPUT <= DLINE(66);
--			when x"43"     => OUTPUT <= DLINE(67);
--			when x"44"     => OUTPUT <= DLINE(68);
--			when x"45"     => OUTPUT <= DLINE(69);
--			when x"46"     => OUTPUT <= DLINE(70);
--			when x"47"     => OUTPUT <= DLINE(71);
--			when x"48"     => OUTPUT <= DLINE(72);
--			when x"49"     => OUTPUT <= DLINE(73);
--			when x"4A"     => OUTPUT <= DLINE(74);
--			when x"4B"     => OUTPUT <= DLINE(75);
--			when x"4C"     => OUTPUT <= DLINE(76);
--			when x"4D"     => OUTPUT <= DLINE(77);
--			when x"4E"     => OUTPUT <= DLINE(78);
--			when x"50"     => OUTPUT <= DLINE(79);
--			when x"51"     => OUTPUT <= DLINE(80);
--			when x"52"     => OUTPUT <= DLINE(81);
--			when x"53"     => OUTPUT <= DLINE(82);
--			when x"54"     => OUTPUT <= DLINE(83);
--			when x"55"     => OUTPUT <= DLINE(84);
--			when x"56"     => OUTPUT <= DLINE(85);
--			when x"57"     => OUTPUT <= DLINE(86);
--			when x"58"     => OUTPUT <= DLINE(87);
--			when others    => OUTPUT <= '0';
--		end case;
--
--	end process;
--
--end Behavioral;
--
