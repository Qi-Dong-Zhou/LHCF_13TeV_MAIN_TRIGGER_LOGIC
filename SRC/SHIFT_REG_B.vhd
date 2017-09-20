----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:17:00 09/05/2014 
-- Design Name: 
-- Module Name:    shift_register - Behavioral 
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

entity SHIFT_REG_B is
    Port ( 
		CLK      : in   STD_LOGIC ;
		WR       : in   STD_LOGIC ;
		SHIFT_EN : out   STD_LOGIC ;
		EXTER_EN : out   STD_LOGIC ;
		INPUT    : in   STD_LOGIC_VECTOR (31 downto 0);
		OUTPUT   : out  STD_LOGIC_VECTOR (3 downto 0)
	 );
end SHIFT_REG_B;

architecture Behavioral of SHIFT_REG_B is

	subtype count_type is std_logic_vector(3 downto 0);
	type array_type is array(0 to 7) of count_type;
	signal WBUFFER : array_type;
--	signal WADD : integer range 0 to 7 :=0;
	SHARED variable WADD : integer range 0 to 7:=0;
	constant RADD0 : integer :=0;
	constant RADD1 : integer :=1;
	constant RADD2 : integer :=2;
	constant RADD3 : integer :=3;
	constant RADD4 : integer :=4;
	constant RADD5 : integer :=5;
	constant RADD6 : integer :=6;
	constant RADD7 : integer :=7;
	signal  WCHECK : std_logic := '1';
	signal  RD_EN  : std_logic;
	signal  INTER_EN  : std_logic;

begin
	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(WR = '1' and WCHECK = '1') then
				WBUFFER(RADD0) <= INPUT(3  downto 0 );
				WBUFFER(RADD1) <= INPUT(7  downto 4 );
				WBUFFER(RADD2) <= INPUT(11 downto 8 );
				WBUFFER(RADD3) <= INPUT(15 downto 12);
				WBUFFER(RADD4) <= INPUT(19 downto 16);
				WBUFFER(RADD5) <= INPUT(23 downto 20);
				WBUFFER(RADD6) <= INPUT(27 downto 24);
				WBUFFER(RADD7) <= INPUT(31 downto 28);
				WCHECK <= '0';
				RD_EN  <= '1';
			elsif(WR = '0' and WCHECK = '0') then				
				WBUFFER(0) <= WBUFFER(7);
				WBUFFER(1) <= WBUFFER(0);
				WBUFFER(2) <= WBUFFER(1);
				WBUFFER(3) <= WBUFFER(2);
				WBUFFER(4) <= WBUFFER(3);
				WBUFFER(5) <= WBUFFER(4);
				WBUFFER(6) <= WBUFFER(5);
				WBUFFER(7) <= WBUFFER(6);
				
				if(WADD = RADD7) then
					RD_EN  <= '0';
					WCHECK <= '1';
					WADD   := 0;
				else
					WADD  := WADD + 1;	
				end if;
			end if;	
		end if;
	end process;
	
	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(RD_EN = '1') then
				OUTPUT <= WBUFFER(7);
				INTER_EN <= '1';
			else
				OUTPUT <= "0000";
				INTER_EN <= '0';
			end if;
		end if;
	end process;
	
	process (CLK) 
		type S_type is (ST0, ST1, ST2, ST3);
		variable STAT : S_type := ST0;
	begin
		if(CLK'event and CLK='1') then	
			case STAT is
				when ST0 =>
					if(WR = '1') then
						STAT:= ST1;
					end if;
				when ST1 =>
						EXTER_EN <= '0';
						STAT:= ST2;
				when ST2 =>
					if(INTER_EN = '0') then
						EXTER_EN <= '1';
						STAT:= ST3;
					else 
						EXTER_EN <= '0';
					end if;
				when ST3 =>
					EXTER_EN <= '0';
					STAT:= ST0;
			end case;
		end if;
	end process;

	SHIFT_EN <= INTER_EN;
end Behavioral;




