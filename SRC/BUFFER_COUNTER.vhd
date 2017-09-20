----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:28:17 02/19/2008 
-- Design Name: 
-- Module Name:    BUFFER_COUNTER - Behavioral 
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

entity BUFFER_COUNTER is 
generic(N : integer := 32);
port (
	CLK    : in  std_logic;
	LATCH  : in  std_logic;
	CLEAR  : in  std_logic;
	COUNT  : in  std_logic_vector(N-1 downto 0);
	BCOUNT : out std_logic_vector(N-1 downto 0)
);
end BUFFER_COUNTER;

architecture Behavioral of BUFFER_COUNTER is
begin
	process (CLK) begin
		if(CLK'event and CLK='1') then 
		   if(LATCH = '1') then
				BCOUNT <= COUNT;
			elsif (CLEAR = '1') then 
				BCOUNT <= (others => '0');
			end if;
		end if;
	end process;
end Behavioral;

