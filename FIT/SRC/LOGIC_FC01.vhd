----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:33:39 02/23/2008 
-- Design Name: 
-- Module Name:    LOGIC_FC01 - Behavioral 
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

entity LOGIC_FC01 is port (
	CLK     : in std_logic;
	L1T     : in std_logic;
	BPTX    : in std_logic;
	INPUT   : in std_logic_vector(3 downto 0);
	SEL     : in std_logic_vector(7 downto 0);
	CLR     : in std_logic;
	TRG1    : out std_logic; 	
	TRG2    : out std_logic;  -- COINCIDENCE WITH DL1T
	TRG3    : out std_logic;  -- COINCIDENCE WITH LD_BPTX
	OUTPUT  : out std_logic_vector(3 downto 0);
	BOUT    : out std_logic_vector(3 downto 0)
);
end LOGIC_FC01;

architecture Behavioral of LOGIC_FC01 is
	signal TOUTPUT : std_logic_vector(3 downto 0) := x"0"; 
	signal TTRG  : std_logic;
	signal TTRG1 : std_logic := '0';
	signal TTRG2 : std_logic := '0';
begin

	TOUTPUT(0) <= INPUT(0) and INPUT(2);
	TOUTPUT(1) <= INPUT(0) and INPUT(3);
	TOUTPUT(2) <= INPUT(1) and INPUT(2);
	TOUTPUT(3) <= INPUT(1) and INPUT(3);	
	OUTPUT <= TOUTPUT;
	
	TTRG1 <= OR_WITH_MASK( INPUT(0),
								  INPUT(1),
							 	  INPUT(2),
								  INPUT(3),
								  SEL(3 downto 0));
	
	TTRG2 <= OR_WITH_MASK( TOUTPUT(0),
								  TOUTPUT(1),
								  TOUTPUT(2),
								  TOUTPUT(3),
								  SEL(7 downto 4));
	TTRG <= TTRG1 or TTRG2;
	TRG1 <= TTRG;
	TRG2 <= TTRG and L1T;
	TRG3 <= TTRG and BPTX;
	
	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(BPTX = '1') then 
				BOUT <= INPUT;
			elsif( CLR = '1') then 
				BOUT <= x"0";
			end if;
		end if;
	end process; 
	
end Behavioral;

