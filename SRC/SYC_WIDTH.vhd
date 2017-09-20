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

entity SYC_WIDTH is port(
	CLK      : in  std_logic;
	SDSC_IN  : in  std_logic_vector(15 downto 0);
	SDSC2    : out std_logic_vector(15 downto 0);
	LDSC_IN  : in  std_logic_vector(15 downto 0);
	LDSC2    : out std_logic_vector(15 downto 0)
);
end SYC_WIDTH;

architecture Behavioral of SYC_WIDTH is

	signal SDSC      : std_logic_vector(15 downto 0);
	signal SDSC_D    : std_logic_vector(15 downto 0);
	signal LDSC      : std_logic_vector(15 downto 0);
	signal LDSC_D    : std_logic_vector(15 downto 0);
	
begin

	-- For Small Tower 
	Syc_SDSC_GEN : for i in 0 to 15 generate 
		SYC_SDSC : SYNCHRONIZE port map(
			CLK       => CLK,
			INPUT     => SDSC_IN(i),
			OUTPUT    => SDSC(i)
		);

--		Linedelay_SDSC : LINEDELAY_FIX generic map(4) port map (
--		  CLK		    => CLK,
--		  INPUT	    => SDSC(i),
--		  OUTPUT     => SDSC_D(i)
--		  );

		WIDTH_SDSC : INTERNALCOUNTER generic map (8) port map(
			CLK          =>  CLK,
			START        =>  SDSC(i),
			PRESET       =>  x"0C",
			STAT         =>  SDSC_D(i),
			ENDMARK      =>  open
		);

		SDSC2(i) <= SDSC(i) or SDSC_D(i);


	end generate;
	
	-- For Large Tower 
	SYC_LDSC_GEN : for i in 0 to 15 generate 
		SYC_LDSC : SYNCHRONIZE port map(
			CLK       => CLK,
			INPUT     => LDSC_IN(i),
			OUTPUT    => LDSC(i)
		);

--		LINEDELAY_LDSC : LINEDELAY_FIX generic map(4) port map (
--		  CLK		   => CLK,
--		  INPUT	   => LDSC(i),
--		  OUTPUT    => LDSC_D(i)
--		  );
--

		WIDTH_LDSC : INTERNALCOUNTER generic map (8) port map(
			CLK          =>  CLK,
			START        =>  LDSC(i),
			PRESET       =>  x"0C",
			STAT         =>  LDSC_D(i),
			ENDMARK      =>  open
		);
		LDSC2(i) <= LDSC(i) or LDSC_D(i);


	end generate;

end Behavioral;

