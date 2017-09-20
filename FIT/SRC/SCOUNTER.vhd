----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:11:12 02/19/2008 
-- Design Name: 
-- Module Name:    SCOUNTER - Behavioral 
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

entity SCOUNTER is 
generic (
	N : integer := 31
);
port (
	CLK     : in  std_logic;
	INPUT   : in  std_logic;  -- input width must be 25 nsec.
	CLR     : in  std_logic;
	INHIBIT : in  std_logic;
	COUNT   : out std_logic_vector(N-1 downto 0)
);
end SCOUNTER;

architecture Behavioral of SCOUNTER is
	signal CLR_CHECK 	: std_logic := '0';
	signal TCOUNT 		: std_logic_vector(N-1 downto 0);
begin

	COUNT <= TCOUNT;

	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(CLR = '1' and CLR_CHECK = '0') then
				CLR_CHECK <= '1';
				TCOUNT <= (others=>'0');
			elsif(INPUT = '1' and INHIBIT = '0') then 
				TCOUNT <= TCOUNT + 1;
			end if;
			
			if(CLR = '0' and CLR_CHECK = '1') then
				CLR_CHECK <= '0';
			end if;
		end if;
	end process;
	
end Behavioral;

