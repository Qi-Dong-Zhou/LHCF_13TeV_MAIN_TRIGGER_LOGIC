----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:24:43 02/18/2008 
-- Design Name: 
-- Module Name:    LATCH - Behavioral 
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

entity LATCH_M is port (
	CLK     : in std_logic;
	START   : in std_logic;
	STOP    : in std_logic;
	OUTPUT    : out std_logic;
	STARTMARK : out std_logic;
	ENDMARK   : out std_logic
);
end LATCH_M;

architecture Behavioral of LATCH_M is
	signal TOUTPUT    : std_logic := '0';
	signal TSTARTMARK : std_logic := '0';
	signal TENDMARK   : std_logic := '0';
begin
	OUTPUT    <= TOUTPUT;
	STARTMARK <= TSTARTMARK;
	ENDMARK   <= TENDMARK;

	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(START = '1' and TOUTPUT = '0') then
				TOUTPUT <= '1';
				TSTARTMARK <= '1';
			elsif(STOP = '1' and TOUTPUT = '1') then 
				TOUTPUT <= '0';
				TENDMARK <= '1';
			elsif(TSTARTMARK = '1') then
				TSTARTMARK <= '0';
			elsif(TENDMARK = '1') then
				TENDMARK <= '0';
			end if;
		end if;
	end process; 

end Behavioral;

