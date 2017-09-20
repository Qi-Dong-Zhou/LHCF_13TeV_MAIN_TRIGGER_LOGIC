----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:10 02/19/2008 
-- Design Name: 
-- Module Name:    MUX - Behavioral 
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

entity MUX is port(
	SOURCE_IN1    : in std_logic;
	SOURCE_IN2    : in std_logic;
	FLAG          : in std_logic;
	SOURCE_OUT    : out std_logic
);
end MUX;

architecture Behavioral of MUX is
begin

	SOURCE_OUT <=     SOURCE_IN1           when FLAG = '0' else
					      SOURCE_IN2           when FLAG = '1' else
					      '0';

end Behavioral;

