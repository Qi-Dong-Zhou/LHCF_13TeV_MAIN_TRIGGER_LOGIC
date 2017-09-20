----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:36:43 02/24/2008 
-- Design Name: 
-- Module Name:    BUFFER_SIGNAL - Behavioral 
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

entity BUFFER_SIGNAL is port (
	CLK    : in  std_logic;
	LATCH  : in  std_logic;
	CLR    : in  std_logic;
	INPUT  : in  std_logic;
	OUTPUT : out std_logic
);
end BUFFER_SIGNAL;

architecture Behavioral of BUFFER_SIGNAL is
	signal CHECK : std_logic ;
begin

	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(LATCH = '1' and CHECK= '1') then 
				OUTPUT <= INPUT;
				CHECK  <= '0'; 
			elsif (CLR = '1') then
				OUTPUT <= '0';
         elsif (LATCH = '0') then
	         CHECK <= '1';
			end if;
		end if;
	end process; 
	
end Behavioral;

