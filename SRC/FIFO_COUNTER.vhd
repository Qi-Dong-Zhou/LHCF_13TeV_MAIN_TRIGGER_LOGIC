----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:11:11 02/19/2008 
-- Design Name: 
-- Module Name:    FIFO_COUNTER - Behavioral 
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

entity FIFO_COUNTER is port (
	CLK    : in std_logic;
	COUNT  : in std_logic_vector(31 downto 0);
	WR     : in std_logic;
--	RD     : in std_logic;
	LATCH  : in std_logic;
	OUTPUT0 : out std_logic_vector(31 downto 0);
	OUTPUT1 : out std_logic_vector(31 downto 0);
	OUTPUT2 : out std_logic_vector(31 downto 0);
   OUTPUT3 : out std_logic_vector(31 downto 0)
);
end FIFO_COUNTER;

architecture Behavioral of FIFO_COUNTER is
	subtype count_type is std_logic_vector(31 downto 0);
	type array_type is array(0 to 3) of count_type;
	signal WBUFFER : array_type;
--	signal RBUFFER : array_type;
	signal WADD : integer range 0 to 3;
	signal RADD0 : integer range 0 to 3;
	signal RADD1 : integer range 0 to 3;
	signal RADD2 : integer range 0 to 3;
	signal RADD3 : integer range 0 to 3;
	signal WCHECK : std_logic := '0';
	signal RCHECK : std_logic := '0';
begin
	process (CLK) begin
		if(CLK'event and CLK='1') then
	
			if(WR = '1' and WCHECK = '0') then 
				WBUFFER(WADD) <= COUNT;
				WCHECK <= '1';
			elsif(WR = '0' and WCHECK = '1') then
				WADD <= WADD + 1;
				WCHECK <= '0';
			end if;
			
			if(LATCH = '1') then
--				RBUFFER <= WBUFFER;
				RADD0 <= WADD - 1;
				RADD1 <= WADD - 2;
				RADD2 <= WADD - 3;	
				RADD3 <= WADD - 4;	
			   RCHECK <= '1';
			elsif( RCHECK = '1') then
				OUTPUT0 <= WBUFFER(RADD0);
				OUTPUT1 <= WBUFFER(RADD1);
				OUTPUT2 <= WBUFFER(RADD2);
				OUTPUT3 <= WBUFFER(RADD3);				
				RCHECK <= '0';
			end if;
--				RADD <= WADD -1;	
--				RADD <= WADD;	
--				RCHECK = '1';
--			else 
--			elsif(RD = '1' and RCHECK = '0') then
--				RADD <= RADD - 1 ;
--				RCHECK <= '1';
--			elsif(RD = '0' and RCHECK = '1') then
----				RADD <= RADD - 1 ;
--				RCHECK <= '0';
--			else
--				OUTPUT <= RBUFFER(RADD);
--			end if;
			
--			OUTPUT0 <= RBUFFER(0);
--			OUTPUT1 <= RBUFFER(1);	
--			OUTPUT2 <= RBUFFER(2);
--			OUTPUT3 <= RBUFFER(3);	
			
		end if;
	end process;

end Behavioral;

