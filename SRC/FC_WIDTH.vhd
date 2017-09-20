----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:10 12/05/2014 
-- Design Name: 
-- Module Name:    SYC_WIDTH - Behavioral 
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

entity FC_WIDTH is port(
	CLK      : in  std_logic;
	FC_IN    : in  std_logic_vector(3 downto 0);
	FC2      : out std_logic_vector(3 downto 0)
);
end FC_WIDTH;

architecture Behavioral of FC_WIDTH is

	signal FC      : std_logic_vector(3 downto 0);
	signal FC_D    : std_logic_vector(3 downto 0);
	
begin

	-- For FC 
	Syc_FC_GEN : for i in 0 to 3 generate 
		SYC_SDSC : SYNCHRONIZE port map(
			CLK       => CLK,
			INPUT     => FC_IN(i),
			OUTPUT    => FC(i)
		);

		Linedelay_FC : LINEDELAY_FIX generic map(4) port map (
		  CLK		    => CLK,
		  INPUT	    => FC(i),
		  OUTPUT     => FC_D(i)
		  );

		FC2(i) <= FC(i) or FC_D(i);
	end generate;

end Behavioral;

