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

entity DSC_COUNTER is port(
	CLK       : in  std_logic;
	ECR       : in  std_logic;
	LATCH     : in  std_logic;
	SDSC2_IN  : in  std_logic_vector(15 downto 0);
	LDSC2_IN  : in  std_logic_vector(15 downto 0);
	COUNT_S00 : out std_logic_vector(31 downto 0);
	COUNT_S01 : out std_logic_vector(31 downto 0);
	COUNT_S02 : out std_logic_vector(31 downto 0);
	COUNT_S03 : out std_logic_vector(31 downto 0);
	COUNT_S04 : out std_logic_vector(31 downto 0);
	COUNT_S05 : out std_logic_vector(31 downto 0);
	COUNT_S06 : out std_logic_vector(31 downto 0);
	COUNT_S07 : out std_logic_vector(31 downto 0);
	COUNT_S08 : out std_logic_vector(31 downto 0);
	COUNT_S09 : out std_logic_vector(31 downto 0);
	COUNT_S10 : out std_logic_vector(31 downto 0);
	COUNT_S11 : out std_logic_vector(31 downto 0);
	COUNT_S12 : out std_logic_vector(31 downto 0);
	COUNT_S13 : out std_logic_vector(31 downto 0);
	COUNT_S14 : out std_logic_vector(31 downto 0);
	COUNT_S15 : out std_logic_vector(31 downto 0);
	
	COUNT_L00 : out std_logic_vector(31 downto 0);
	COUNT_L01 : out std_logic_vector(31 downto 0);
	COUNT_L02 : out std_logic_vector(31 downto 0);
	COUNT_L03 : out std_logic_vector(31 downto 0);
	COUNT_L04 : out std_logic_vector(31 downto 0);
	COUNT_L05 : out std_logic_vector(31 downto 0);
	COUNT_L06 : out std_logic_vector(31 downto 0);
	COUNT_L07 : out std_logic_vector(31 downto 0);
	COUNT_L08 : out std_logic_vector(31 downto 0);
	COUNT_L09 : out std_logic_vector(31 downto 0);
	COUNT_L10 : out std_logic_vector(31 downto 0);
	COUNT_L11 : out std_logic_vector(31 downto 0);
	COUNT_L12 : out std_logic_vector(31 downto 0);
	COUNT_L13 : out std_logic_vector(31 downto 0);
	COUNT_L14 : out std_logic_vector(31 downto 0);
	COUNT_L15 : out std_logic_vector(31 downto 0)
);
end DSC_COUNTER;

architecture Behavioral of DSC_COUNTER is
	subtype  count_type is std_logic_vector(31 downto 0);
	type     arrayS_type is array(0 to 15) of count_type;
	signal   COUNT_S : arrayS_type;	
	type     arrayL_type is array(0 to 15) of count_type;
	signal   COUNT_L : arrayL_type;	
begin

	COUNT_S00 <= COUNT_S(0);
	COUNT_S01 <= COUNT_S(1);
	COUNT_S02 <= COUNT_S(2);
	COUNT_S03 <= COUNT_S(3);
	COUNT_S04 <= COUNT_S(4);
	COUNT_S05 <= COUNT_S(5);
	COUNT_S06 <= COUNT_S(6);
	COUNT_S07 <= COUNT_S(7);
	COUNT_S08 <= COUNT_S(8);
	COUNT_S09 <= COUNT_S(9);
	COUNT_S10 <= COUNT_S(10);
	COUNT_S11 <= COUNT_S(11);
	COUNT_S12 <= COUNT_S(12);
	COUNT_S13 <= COUNT_S(13);
	COUNT_S14 <= COUNT_S(14);
	COUNT_S15 <= COUNT_S(15);
	
	COUNT_L00 <= COUNT_L(0);
	COUNT_L01 <= COUNT_L(1);
	COUNT_L02 <= COUNT_L(2);
	COUNT_L03 <= COUNT_L(3);
	COUNT_L04 <= COUNT_L(4);
	COUNT_L05 <= COUNT_L(5);
	COUNT_L06 <= COUNT_L(6);
	COUNT_L07 <= COUNT_L(7);
	COUNT_L08 <= COUNT_L(8);
	COUNT_L09 <= COUNT_L(9);
	COUNT_L10 <= COUNT_L(10);
	COUNT_L11 <= COUNT_L(11);
	COUNT_L12 <= COUNT_L(12);
	COUNT_L13 <= COUNT_L(13);
	COUNT_L14 <= COUNT_L(14);
	COUNT_L15 <= COUNT_L(15);
	
	-- For Small Tower 
	SDSC_COUNT_GEN : for i in 0 to 15 generate 

		SDSC_COUNTER : SCOUNTER3 generic map(32) port map(
			CLK      => CLK,
			INPUT    => SDSC2_IN(i),
			CLR      => ECR,
			INHIBIT  => '0',
			LATCH    => LATCH,
			CLEAR    => '0',
			BCOUNT   => COUNT_S(i)
		);
	end generate;
	
	-- For Large Tower 
	LDSC_COUNT_GEN : for i in 0 to 15 generate 
	
		LDSC_COUNTER : SCOUNTER3 generic map(32) port map(
			CLK      => CLK,
			INPUT    => LDSC2_IN(i),
			CLR      => ECR,
			INHIBIT  => '0',
			LATCH    => LATCH,
			CLEAR    => '0',
			BCOUNT   => COUNT_L(i)
		);

	end generate;

end Behavioral;

