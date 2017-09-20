----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:29 11/25/2007 
-- Design Name: 
-- Module Name:    PRESETCOUNTER - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PRESETCOUNTER is 
generic(N : integer := 4);
port (
	CLK     : in std_logic;
	INPUT   : in std_logic;
	PRESET  : in std_logic_vector (N-1 downto 0);
	CLEAR   : in std_logic;
	STAT    : out std_logic);
end PRESETCOUNTER;

architecture Behavioral of PRESETCOUNTER is
signal COUNT   : std_logic_vector(N-1 downto 0);
signal TSTAT   : std_logic := '0';
signal INSTAT  : std_logic := '0';
begin
 
	STAT <= TSTAT;
	
process (CLK) begin
	if(CLK'event and CLK='1') then
		if (CLEAR = '1') then
			COUNT <= (others=>'0');
			TSTAT <= '0';
			INSTAT <= '0';
		elsif (INPUT='1' and INSTAT='0' and COUNT=PRESET) then 
			TSTAT  <= '1';
		   INSTAT <= '1';
			COUNT <= (others=>'0');
		elsif (INPUT='1' and INSTAT='0') then
			COUNT <= COUNT + 1;
			INSTAT <= '1';
		else 
			if( TSTAT = '1' ) then
				TSTAT <= '0';
			end if;
			if( INPUT='0' and INSTAT='1') then 	
				INSTAT <= '0';
			end if;
		end if;
	end if;
end process;


end Behavioral;

