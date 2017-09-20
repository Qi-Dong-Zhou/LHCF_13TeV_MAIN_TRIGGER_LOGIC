----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:03:30 02/15/2008 
-- Design Name: 
-- Module Name:    GATEandDELAY - Behavioral 
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

entity GATEandDELAY is
port(
	CLK     : in std_logic;
	START   : in std_logic;	
	DELAY   : in std_logic_vector (7 downto 0);
	WIDTH   : in std_logic_vector (7 downto 0);
	STAT    : out std_logic;
	OUTPUT  : out std_logic;
	ENDMARK : out std_logic);
end GATEandDELAY;

architecture Behavioral of GATEandDELAY is
signal DCOUNT : std_logic_vector(7 downto 0);
signal WCOUNT : std_logic_vector(7 downto 0);
signal DSTAT  : std_logic;
signal WSTAT  : std_logic;
signal TSTAT  : std_logic := '0';
signal TOUTPUT : std_logic := '0';
signal TENDMARK : std_logic := '0';
begin

	STAT <= TSTAT;
	OUTPUT <= TOUTPUT;
	ENDMARK <= TENDMARK;

	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(START = '1' and TSTAT = '0' and DELAY = x"00") then 
				DCOUNT <= x"01";
				WCOUNT <= (others => '0');
				TSTAT <= '1';
				TOUTPUT <= '1';
				DSTAT <= '0';
				WSTAT <= '1';
			elsif(START = '1' and TSTAT = '0') then 
			   DCOUNT <= x"01";
				WCOUNT <= (others => '0');
				TSTAT <= '1';
				TOUTPUT <= '0';
				DSTAT <= '1';
				WSTAT <= '0';
			elsif(TENDMARK='1') then
				TENDMARK <= '0';
			elsif(DCOUNT >= DELAY and DSTAT = '1') then 
				TOUTPUT <= '1';
				DSTAT  <= '0';
				WSTAT  <= '1';
			elsif(WCOUNT >= WIDTH and WSTAT = '1') then
				TOUTPUT <= '0';
				DSTAT <= '0';
				WSTAT <= '0';
				TSTAT <= '0';
				TENDMARK <= '1';
			elsif(DSTAT = '1') then 
				DCOUNT <= DCOUNT + 1;
			elsif(WSTAT = '1') then
				WCOUNT <= WCOUNT + 1;
			end if;
		end if;
	end process;
	
end Behavioral;

