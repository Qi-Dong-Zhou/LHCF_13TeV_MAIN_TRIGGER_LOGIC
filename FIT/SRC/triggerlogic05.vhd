----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:41:12 01/10/2008 
-- Design Name: 
-- Module Name:    triggerlogic05 - Behavioral 
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

entity triggerlogic05 is
port(
	CLK 	   : in  std_logic ;
	L1T      : in  std_logic ; -- BPTX
	SDSC     : in  std_logic_vector(15 downto 0);  -- discriminator out of small tower 
 	LDSC     : in  std_logic_vector(15 downto 0);  -- discriminator out of large tower
	TRG      : out std_logic );
end triggerlogic05;

architecture Behavioral of triggerlogic05 is
	signal SLOGIC : std_logic;
	signal LLOGIC : std_logic;
	signal TRG1   : std_logic;
begin

-- trigger logic 

	SLOGIC <= ( NOT SDSC(0) ) and ( NOT SDSC(1) )   
		  	    and (
					( SDSC(2) and SDSC(3) and SDSC(4) ) or
					( SDSC(3) and SDSC(4) and SDSC(5) ) or	
				   ( SDSC(4) and SDSC(5) and SDSC(6) ) or 
				   ( SDSC(5) and SDSC(6) and SDSC(7) ) or 
				   ( SDSC(6) and SDSC(7) and SDSC(8) ) or 
			      ( SDSC(7) and SDSC(8) and SDSC(9) ) or 
			  	   ( SDSC(8) and SDSC(9) and SDSC(10) ) or 
					( SDSC(9) and SDSC(10) and SDSC(11) ) or
					( SDSC(10) and SDSC(11) and SDSC(12) ) or
					( SDSC(11) and SDSC(12) and SDSC(13) ) or
					( SDSC(12) and SDSC(13) and SDSC(14) ) or
					( SDSC(13) or SDSC(14) or SDSC(15) )
			 	 );
--					( SDSC(13) and SDSC(14) and SDSC(15) )
	LLOGIC <= ( LDSC(0) and LDSC(1) and LDSC(2) )
			 or ( LDSC(1) and LDSC(2) and LDSC(3) )
			 or ( LDSC(2) and LDSC(3) and LDSC(4) )
			 or ( LDSC(3) and LDSC(4) and LDSC(5) );

--   TRG <= SLOGIC and LLOGIC and L1T;
	TRG1 <= SLOGIC or LLOGIC;
	TRG  <= TRG1 and L1T;
end Behavioral;

