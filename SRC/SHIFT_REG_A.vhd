----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:36:19 02/15/2015 
-- Design Name: 
-- Module Name:    MULTI_SINGLE - Behavioral 
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

entity SHIFT_REG_A is Port ( 
	CLK         : in  STD_LOGIC;
	START       : in  STD_LOGIC;
	SHIFT_EN    : in  STD_LOGIC;
	COUNT_00    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_01    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_02    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_03    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_04    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_05    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_06    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_07    : in  STD_LOGIC_VECTOR (31 downto 0);	
	COUNT_08    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_09    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_10    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_11    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_12    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_13    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_14    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_15    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_16    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_17    : in  STD_LOGIC_VECTOR (31 downto 0);	
	COUNT_18    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_19    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_20    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_21    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_22    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_23    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_24    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_25    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_26    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_27    : in  STD_LOGIC_VECTOR (31 downto 0);	
	COUNT_28    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_29    : in  STD_LOGIC_VECTOR (31 downto 0);	
	COUNT_30    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_31    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_32    : in  STD_LOGIC_VECTOR (31 downto 0);	
	COUNT_33    : in  STD_LOGIC_VECTOR (31 downto 0);
	COUNT_34    : in  STD_LOGIC_VECTOR (31 downto 0);	
	WR_EN       : out  STD_LOGIC;
	SHIFT_COUNT : out  STD_LOGIC_VECTOR (31 downto 0));
end SHIFT_REG_A ;

architecture Behavioral of SHIFT_REG_A  is
	subtype  count_type is std_logic_vector(31 downto 0);
	type     array_type is array(0 to 34) of count_type;
	signal   COUNT : array_type;
	SHARED variable WADD : integer range 0 to 35:=0;
	constant Nmax :integer :=35;
begin

	COUNT(0) <= COUNT_00;
	COUNT(1) <= COUNT_01;
	COUNT(2) <= COUNT_02;
	COUNT(3) <= COUNT_03;
	COUNT(4) <= COUNT_04;
	COUNT(5) <= COUNT_05;
	COUNT(6) <= COUNT_06;
	COUNT(7) <= COUNT_07;
	COUNT(8) <= COUNT_08;
	COUNT(9) <= COUNT_09;
	COUNT(10) <= COUNT_10;
	COUNT(11) <= COUNT_11;
	COUNT(12) <= COUNT_12;
	COUNT(13) <= COUNT_13;
	COUNT(14) <= COUNT_14;
	COUNT(15) <= COUNT_15;
	COUNT(16) <= COUNT_16;
	COUNT(17) <= COUNT_17;
	COUNT(18) <= COUNT_18;
	COUNT(19) <= COUNT_19;
	COUNT(20) <= COUNT_20;
	COUNT(21) <= COUNT_21;
	COUNT(22) <= COUNT_22;
	COUNT(23) <= COUNT_23;
	COUNT(24) <= COUNT_24;
	COUNT(25) <= COUNT_25;
	COUNT(26) <= COUNT_26;
	COUNT(27) <= COUNT_27;
	COUNT(28) <= COUNT_28;
	COUNT(29) <= COUNT_29;
	COUNT(30) <= COUNT_30;
	COUNT(31) <= COUNT_31;
	COUNT(32) <= COUNT_32;
	COUNT(33) <= COUNT_33;
	COUNT(34) <= COUNT_34;
	process (CLK) 
		type S_type is (ST0, ST1, ST2, ST3);
		variable STAT : S_type := ST0;
	begin
		if(CLK'event and CLK='1') then
			case STAT is
				when ST0 => 
					if (START = '1') then
						STAT:= ST1;
					else
						WADD := 0;
						WR_EN <= '0';
					end if;
				when ST1 =>
					WR_EN <= '1';
					SHIFT_COUNT <= COUNT(WADD);
					STAT:= ST2;
				when ST2 =>
					WR_EN <= '0';
					WADD:= WADD + 1;
					STAT:= ST3; 
				when ST3 =>	
					if (SHIFT_EN = '1') then
						if (WADD = Nmax) then
							STAT:= ST0;
						else	
							STAT:= ST1;
						end if;
					end if;
			end case;
		end if;
	end process;
		
end Behavioral;

