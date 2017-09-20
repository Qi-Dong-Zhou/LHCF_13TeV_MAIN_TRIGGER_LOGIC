----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:36:55 12/05/2014 
-- Design Name: 
-- Module Name:    COUNTER5 - Behavioral 
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

entity COUNTER_N is
generic(N : integer := 4);
    Port ( CLK            : in  STD_LOGIC;
           RESET          : in  STD_LOGIC;
           ENABLE         : in  STD_LOGIC;
           PULSE          : out  STD_LOGIC);
end COUNTER_N;

architecture Behavior of COUNTER_N is

	signal COUNT : integer range 0 to N :=0;

begin

	PULSE <= '1' when (COUNT=N)else 
				'0';
				
	process (CLK) begin 
		if (CLK'event and CLK = '1') then
			if(RESET = '1' ) then
				COUNT <= 0;
			elsif(ENABLE = '1')then
				if(COUNT = N)then
					COUNT <= 0;
				else
					COUNT <= COUNT+1;
				end if;
			end if;
		end if;
	end process;		
end;

