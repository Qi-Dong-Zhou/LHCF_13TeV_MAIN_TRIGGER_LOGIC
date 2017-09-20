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

entity CLK_COUNTER3 is 
generic (
	N : integer := 31
);
port (
	CLK     : in  std_logic;
	CLR     : in  std_logic;
	INHIBIT : in  std_logic;
	LATCH1  : in  std_logic;
	LATCH2  : in  std_logic;
	CLEAR   : in  std_logic;
	BCOUNT1 : out std_logic_vector(N-1 downto 0);
	BCOUNT2 : out std_logic_vector(N-1 downto 0)
);
end CLK_COUNTER3;

architecture Behavioral of CLK_COUNTER3 is
	signal CLR_CHECK : std_logic := '0';
	signal COUNT     : std_logic_vector(N-1 downto 0);
begin

	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(CLR = '1' and CLR_CHECK = '0') then
				CLR_CHECK <= '1';
				COUNT <= (others => '0');
			elsif(INHIBIT = '0') then 
				COUNT <= COUNT + 1;
			end if;
			
			if(CLR = '0' and CLR_CHECK = '1') then
				CLR_CHECK <= '0';
			end if;
			
		   if(LATCH1 = '1') then
				BCOUNT1 <= COUNT;
			elsif (CLEAR = '1') then 
				BCOUNT1 <= (others => '0');
			end if;
			
			if(LATCH2 = '1') then
				BCOUNT2 <= COUNT;
			elsif (CLEAR = '1') then 
				BCOUNT2 <= (others => '0');
			end if;
		end if;
	end process;

end Behavioral;

