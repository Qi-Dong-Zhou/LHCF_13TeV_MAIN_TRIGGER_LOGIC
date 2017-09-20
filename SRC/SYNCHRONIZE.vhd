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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SYNCHRONIZE is port(
	CLK    : in std_logic;
	INPUT  : in std_logic;
	OUTPUT : out std_logic
);
end SYNCHRONIZE;

architecture Behavioral of SYNCHRONIZE is
begin
	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(INPUT = '1') then 
				OUTPUT <= '1';
			else 
				OUTPUT <= '0';
			end if;
		end if;
	end process;

end Behavioral;

