----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:41:12 01/10/2008 
-- Design Name: 
-- Module Name:    triggerlogic06 - Behavioral 
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

entity triggerlogic06 is
port(
	CLK 	            : in  std_logic ;
	TRIG              : in  std_logic ; -- DL1T
	TRIG_BPTX         : in  std_logic ; -- LD_BPTX_AND
	SEL_SLOGIC_SOURCE : in  std_logic ;
	SEL_LLOGIC_SOURCE : in  std_logic ;
	SDSC              : in  std_logic_vector(15 downto 0);  -- discriminator out of small tower 
 	LDSC              : in  std_logic_vector(15 downto 0);  -- discriminator out of large tower
	CLEAR             : in  std_logic ; -- pattern clear
	STRIG1            : out std_logic ; -- logic out of small tower 
	LTRIG1            : out std_logic ; -- logic out of large tower	
	STRIG2            : out std_logic ; -- coincidence with DL1T 
	LTRIG2            : out std_logic ; -- coincidence with DL1T
	STRIG3            : out std_logic ; -- coincidence with LD_BPTX_AND 
	LTRIG3            : out std_logic ; -- coincidence with LD_BPTX_AND
	SPATTERN          : out std_logic_vector(15 downto 0); -- discriminator pattern of s 
	LPATTERN          : out std_logic_vector(15 downto 0)); -- discriminator pattern of s
end triggerlogic06;

architecture Behavioral of triggerlogic06 is
	signal SLOGIC   : std_logic;
	signal LLOGIC   : std_logic;
	signal SLOGIC_1 : std_logic;
	signal LLOGIC_1 : std_logic;
	signal SLOGIC_2 : std_logic;
	signal LLOGIC_2 : std_logic;
begin

-- trigger logic 

	SLOGIC_1 <= ( SDSC(0) and SDSC(1) and SDSC(2) ) 
			   or ( SDSC(1) and SDSC(2) and SDSC(3) )
			   or ( SDSC(2) and SDSC(3) and SDSC(4) )	
			   or ( SDSC(3) and SDSC(4) and SDSC(5) )
			   or ( SDSC(4) and SDSC(5) and SDSC(6) )
			   or ( SDSC(5) and SDSC(6) and SDSC(7) )
			   or ( SDSC(6) and SDSC(7) and SDSC(8) )
			   or ( SDSC(7) and SDSC(8) and SDSC(9) )
			   or ( SDSC(8) and SDSC(9) and SDSC(10) )
			   or ( SDSC(9) and SDSC(10) and SDSC(11) )
			   or ( SDSC(10) and SDSC(11) and SDSC(12) )
			   or ( SDSC(11) and SDSC(12) and SDSC(13) )
			   or ( SDSC(12) and SDSC(13) and SDSC(14) )
			   or ( SDSC(13) and SDSC(14) and SDSC(15) );

	LLOGIC_1 <= ( LDSC(0) and LDSC(1) and LDSC(2) ) 
			   or ( LDSC(1) and LDSC(2) and LDSC(3) )
			   or ( LDSC(2) and LDSC(3) and LDSC(4) )	
			   or ( LDSC(3) and LDSC(4) and LDSC(5) )
			   or ( LDSC(4) and LDSC(5) and LDSC(6) )
			   or ( LDSC(5) and LDSC(6) and LDSC(7) )
			   or ( LDSC(6) and LDSC(7) and LDSC(8) )
			   or ( LDSC(7) and LDSC(8) and LDSC(9) )
			   or ( LDSC(8) and LDSC(9) and LDSC(10) )
			   or ( LDSC(9) and LDSC(10) and LDSC(11) )
			   or ( LDSC(10) and LDSC(11) and LDSC(12) )
			   or ( LDSC(11) and LDSC(12) and LDSC(13) )
			   or ( LDSC(12) and LDSC(13) and LDSC(14) )
			   or ( LDSC(13) and LDSC(14) and LDSC(15) );
			
	--For test	
	SLOGIC_2 <= SDSC(0) or SDSC(1)  or SDSC(2)  or SDSC(3) 
			  or SDSC(4)  or SDSC(5)  or SDSC(6)  or SDSC(7)
			  or SDSC(8)  or SDSC(9)  or SDSC(10) or SDSC(11)
			  or SDSC(12) or SDSC(13) or SDSC(14) or SDSC(15);
	LLOGIC_2 <= LDSC(0) or LDSC(1)  or LDSC(2)  or LDSC(3) 
			  or LDSC(4)  or LDSC(5)  or LDSC(6)  or LDSC(7)
			  or LDSC(8)  or LDSC(9)  or LDSC(10) or LDSC(11)
			  or LDSC(12) or LDSC(13) or LDSC(14) or LDSC(15);
			
	MUX_SLOGIC : MUX port map(
		SOURCE_IN1   => SLOGIC_1,
		SOURCE_IN2   => SLOGIC_2,
		FLAG         => SEL_SLOGIC_SOURCE,
		SOURCE_OUT   => SLOGIC
	);	
	
	MUX_LLOGIC : MUX port map(
		SOURCE_IN1   => LLOGIC_1,
		SOURCE_IN2   => LLOGIC_2,
		FLAG         => SEL_LLOGIC_SOURCE,
		SOURCE_OUT   => LLOGIC
	);	
	
	STRIG1 <= SLOGIC;
	LTRIG1 <= LLOGIC;
	STRIG2 <= SLOGIC and TRIG;
	LTRIG2 <= LLOGIC and TRIG;
	STRIG3 <= SLOGIC and TRIG_BPTX;
	LTRIG3 <= LLOGIC and TRIG_BPTX;
-- for timing 
	process(CLK) begin
		if(CLK'event and CLK='1') then
			if(TRIG='1') then
				SPATTERN <= SDSC;
				LPATTERN <= LDSC;
			elsif (CLEAR = '1') then 
				SPATTERN <= (others=>'0');
				LPATTERN <= (others=>'0');			
			end if;
		end if;
	end process;
end Behavioral;

