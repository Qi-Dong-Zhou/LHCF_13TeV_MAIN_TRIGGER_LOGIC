----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:54:58 05/24/2015 
-- Design Name: 
-- Module Name:    EN_COUNTER - Behavioral 
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

entity EN_COUNTER is
    Port ( CLK       : in  STD_LOGIC;
           INPUT     : in  STD_LOGIC;  -- input width must be 25 nsec.
           CLR       : in  STD_LOGIC;
           INHIBIT   : in  STD_LOGIC;
			  COUNT_MAX : in  std_logic_vector(15 downto 0);
           ENABLE    : out STD_LOGIC);
end EN_COUNTER;

architecture Behavioral of EN_COUNTER is
	signal CLR_CHECK : std_logic := '0';
	signal TCOUNT : std_logic_vector(31 downto 0);
begin


	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(CLR = '1' and CLR_CHECK = '0') then
				CLR_CHECK <= '1';
				if (INPUT = '1') then
					TCOUNT <= x"00000001";
				else
					TCOUNT <= x"00000000";
				end if;
			elsif(INPUT = '1' and INHIBIT = '0') then 
				TCOUNT <= TCOUNT + 1;
			end if;
			
			if(CLR = '0' and CLR_CHECK = '1') then
				CLR_CHECK <= '0';
			end if;
		end if;
	end process;
	
	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(TCOUNT > COUNT_MAX) then
				ENABLE <= '0';
			else
				ENABLE <= '1';
			end if;
		end if;
	end process;

end Behavioral;

