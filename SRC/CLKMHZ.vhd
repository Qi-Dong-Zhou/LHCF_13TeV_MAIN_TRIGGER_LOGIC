----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:17:20 02/21/2008 
-- Design Name: 
-- Module Name:    CLK_COUNTER - Behavioral 
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

entity CLKMHZ is 
port (
	CLK     : in  std_logic;
	MHZ     : out std_logic
);
end CLKMHZ;

architecture Behavioral of CLKMHZ is 
	signal   COUNT : integer range 0 to 39 :=0;
	signal   TOUT  : std_logic := '0';
begin
	MHZ <= TOUT;

	process (CLK) begin
		if(CLK'event and CLK='1') then
       
			if    (COUNT =  1) then
				TOUT <= '0';
            COUNT <= COUNT + 1;
			elsif (COUNT = 21) then
				TOUT <= '1';
				COUNT <= COUNT + 1;
			elsif (COUNT = 39) then
				COUNT <= 0;
			else 
			  COUNT <= COUNT + 1;				
			end if;

		end if;
	end process;	

end Behavioral;

