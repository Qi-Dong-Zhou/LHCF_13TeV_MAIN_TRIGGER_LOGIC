----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:10:40 02/14/2008 
-- Design Name:    H.MENJO
-- Module Name:    LOGIC_BPTX - Behavioral 
-- Project Name:   LHCFLOGIC (LHCf_13TeV_V1495@11/20/2014)
-- Target Devices: 
-- Tool versions: 
-- Description:    
--
-- Dependencies: 
--
-- Revision: 
-- Revision 2.01
-- Additional Comments: 
--        13/05/2008
--        For LHCFLOGIC ver2.0 , The input of "laser" was added
--        and the format of sellogic was changed (2) -> (3).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LOGIC_BPTX is port (
-- input
	bptx1    : in std_logic;
	bptx2    : in std_logic;
	laser    : in std_logic;
	sellogic : in std_logic_vector(2 downto 0);
	bptx     : out std_logic);
end LOGIC_BPTX;

architecture Behavioral of LOGIC_BPTX is
begin

	bptx <= bptx1 and bptx2 when sellogic = "000" else
			  bptx1           when sellogic = "001" else
		  	  bptx2           when sellogic = "010" else
			  bptx1 or  bptx2 when sellogic = "011" else
			  laser           when sellogic = "100" else
			  '0';

end Behavioral;

