----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:42:16 02/15/2008 
-- Design Name: 
-- Module Name:    TESTOUT - Behavioral 
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

entity TESTOUT_FC_SCALER is port(
		input  : in std_logic_vector(51 downto 0);
		mask   : in std_logic_vector(7 downto 0);
		output : out std_logic);
end TESTOUT_FC_SCALER;

architecture Behavioral of TESTOUT_FC_SCALER is
begin

    output <=   input(0)  when mask = x"00" else  
                input(1)  when mask = x"01" else 
                input(2)  when mask = x"02" else  
                input(3)  when mask = x"03" else  
                input(4)  when mask = x"04" else  
                input(5)  when mask = x"05" else  
                input(6)  when mask = x"06" else  
                input(7)  when mask = x"07" else  
                input(8)  when mask = x"08" else  
		 input(9)  when mask = x"09" else  
	 input(10) when mask = x"0A" else 
	 input(11) when mask = x"0B" else 
		 input(12) when mask = x"0C" else 
	 input(13) when mask = x"0D" else 
                input(14)  when mask = x"0E" else 
                input(15)  when mask = x"0F" else 
                input(16)  when mask = x"10" else 
                input(17)  when mask = x"11" else  
                input(18)  when mask = x"12" else  
                input(19)  when mask = x"13" else  
                input(20)  when mask = x"14" else  
                input(21)  when mask = x"15" else  
                input(22)  when mask = x"16" else  
                input(23)  when mask = x"17" else
                input(24)  when mask = x"18" else 
                input(25)  when mask = x"19" else 
                input(26)  when mask = x"1A" else 
          	    input(27)  when mask = x"1B" else 
          	    input(28)  when mask = x"1C" else 
                input(29)  when mask = x"1D" else
                input(30)  when mask = x"1E" else
                input(31)  when mask = x"1F" else 
                input(32)  when mask = x"20" else
                input(33)  when mask = x"21" else
                input(34)  when mask = x"22" else
                input(35)  when mask = x"23" else
                input(36)  when mask = x"24" else
                input(37)  when mask = x"25" else
                input(38)  when mask = x"26" else
                input(39)  when mask = x"27" else
                input(40)  when mask = x"28" else 
                input(41)  when mask = x"29" else
                input(42)  when mask = x"2A" else 
                input(43)  when mask = x"2B" else 
                input(44)  when mask = x"2C" else 
                input(45)  when mask = x"2D" else 
                input(46)  when mask = x"2E" else 
		 input(47)  when mask = x"2F" else
		 input(48)  when mask = x"30" else
		 input(49)  when mask = x"31" else
		 input(50)  when mask = x"32" else 
		 input(51)  when mask = x"33" else  
				    '0';
end Behavioral;

