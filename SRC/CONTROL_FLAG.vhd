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

entity CONTROL_FLAG is
	Port ( 
		CLK             : in   STD_LOGIC ;
		FLAG            : in   STD_LOGIC ;
		CLEAR_FLAG      : out   STD_LOGIC 
	);
end CONTROL_FLAG;

architecture Behavioral of CONTROL_FLAG is

	signal   SUB_FLAG  : std_logic := '0';

begin
	process (CLK) begin
		if(CLK'event and CLK='1') then
			if(FLAG /= SUB_FLAG) then
				SUB_FLAG <= FLAG;
				CLEAR_FLAG <= '1';
			else				
				CLEAR_FLAG <= '0';
			end if;	
		end if;
	end process;
end Behavioral;