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

entity LINEDELAY_FIX is 
generic(
	NMAX   : integer := 4
);
port(
	CLK     : in std_logic;
	INPUT   : in std_logic;
	OUTPUT  : out std_logic
);
end LINEDELAY_FIX;

architecture Behavioral of LINEDELAY_FIX is
	signal TOUT  : std_logic;
	signal DELAY_LINE : std_logic_vector(NMAX-1 downto 0);
begin
	
	process (CLK) begin
		if(CLK'event and CLK='1') then
			DELAY_LINE(0) <= INPUT; 
		end if;
	end process;
	
	INPUT_DELAY_PROCESS : for i in 1 to NMAX-1 generate
		process (CLK) begin
			if(CLK'event and CLK='1') then
				DELAY_LINE(i) <= DELAY_LINE(i-1);
			end if;
		end process;
	end generate;

	OUTPUT <= DELAY_LINE(NMAX-1);

end Behavioral;

