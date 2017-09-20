----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:51:38 03/07/2015 
-- Design Name: 
-- Module Name:    SCOUNTER_2LATCH - Behavioral 
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

entity SCOUNTER_2LATCH is 
generic (
	N : integer := 31
);
Port (
			  CLK     : in  STD_LOGIC;
           INPUT   : in  STD_LOGIC;
           CLR     : in  STD_LOGIC;
           INHIBIT : in  STD_LOGIC;
           LATCH1  : in  STD_LOGIC;
			  LATCH2  : in  STD_LOGIC;
           CLEAR   : in  STD_LOGIC;
           BCOUNT1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
			  BCOUNT2 : out  STD_LOGIC_VECTOR (N-1 downto 0));
end SCOUNTER_2LATCH;

architecture Behavioral of SCOUNTER_2LATCH is
	signal INPUT_CHECK : std_logic := '0';
	signal CLR_CHECK : std_logic := '0';
	signal COUNT : std_logic_vector(N-1 downto 0);
begin

	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(CLR = '1' and CLR_CHECK = '0') then
				CLR_CHECK <= '1';
				if (INPUT = '1') then
					COUNT(0) <= '1';
					COUNT(N-1 downto 0) <= (others=> '0');
				else
					COUNT <= (others => '0');
				end if;
			elsif(INPUT = '1' and INHIBIT = '0' and INPUT_CHECK = '0') then 
				COUNT <= COUNT + 1;
				INPUT_CHECK <= '1';
			end if;
			
			if(INPUT = '0' and INPUT_CHECK ='1') then
				INPUT_CHECK <= '0';
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



