----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:11:12 02/19/2008 
-- Design Name: 
-- Module Name:    CLK_PULSE - Behavioral 
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
use work.components.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CLK_PULSE is
generic(N : integer := 4);
port (
	CLK     : in  std_logic;
	INPUT   : in  std_logic; 
   PRESET  : in  std_logic_vector (N-1 downto 0);	
	OUTPUT  : out std_logic);
end CLK_PULSE;

architecture Behavioral of CLK_PULSE is
	signal INPUT_SYC 	: std_logic := '0';
begin

	SYC : SYNCHRONIZE port map(
		CLK          => CLK,
		INPUT        => INPUT,
		OUTPUT       => INPUT_SYC
	);
	
	INPUT_WIDTH : INTERNALCOUNTER generic map(N) port map (
		CLK          =>  CLK,
		START        =>  INPUT_SYC,
		PRESET       =>  PRESET,
		STAT         =>  open,
		ENDMARK      =>  OUTPUT
	);
	
end Behavioral;

