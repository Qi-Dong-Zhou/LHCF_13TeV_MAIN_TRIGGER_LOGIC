----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:29 11/25/2007 
-- Design Name: 
-- Module Name:    INTERNALCOUNTER - Behavioral 
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

entity INTERNALCOUNTER is 
generic(N : integer := 4);
port (
	CLK     : in std_logic;
	START   : in std_logic;
	PRESET  : in std_logic_vector (N-1 downto 0);
	STAT    : out std_logic;
	ENDMARK : out std_logic);
end INTERNALCOUNTER;

architecture Behavioral of INTERNALCOUNTER is
signal COUNT : std_logic_vector(N-1 downto 0);
signal TSTAT : std_logic := '0';
signal TENDMARK : std_logic := '0';
signal CHECK: std_logic := '1';
begin
 
	STAT    <= TSTAT;
	ENDMARK <= TENDMARK;
	
process (CLK) begin
	if(CLK'event and CLK='1') then
		if (START = '1' and TSTAT = '0' and CHECK = '1') then 
			COUNT <= (others=>'0');
			TSTAT <= '1';
			TENDMARK <= '0';
			CHECK <= '0';
		elsif (TENDMARK = '1') then
			TENDMARK <= '0';
		elsif (COUNT >= PRESET and TSTAT = '1') then
			TENDMARK <= '1';
			TSTAT <='0';
		elsif (TSTAT = '1') then 
			COUNT <= COUNT + 1;
		elsif (START = '0' and CHECK='0') then
			CHECK <= '1';
		end if;
		
--		if(START ='0' and CHECK='0') then 
--			CHECK <= '1';
--		end if;
	end if;
end process;

end Behavioral;

