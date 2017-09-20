-- ========================================================================
-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1495 -  Multipurpose Programmable Trigger Unit
-- Device:          ALTERA EP1C4F400C6
-- Author:          Carlo Tintori
-- Date:            May 26th, 2010
-- ----------------------------------------------------------------------------
-- Module:          lb_int
-- Description:     Local Bus interface
-- ****************************************************************************

library ieee;
use IEEE.Std_Logic_1164.all;
use IEEE.Std_Logic_arith.all;
use IEEE.Std_Logic_unsigned.all;

ENTITY clk_divi is
	port(
		-- Local Bus in/out signals
		CLK       : in   	std_logic;
		WR        : out 	 	std_logic
	);

END clk_divi ;


ARCHITECTURE rtl of clk_divi is

	signal DD    : std_logic_vector(15 downto 0);

begin

  process(CLK)
  begin
	if(CLK'event and CLK='1') then
		DD <= DD + '1';
	end if;	
  end process;
  
  process(DD)
  begin
--	if(CLK'event and CLK='1') then
		if(DD = "111111111111") then
			WR <= '1';
		else
			WR <= '0';
		end if;
--	end if;	
  end process;

END rtl;

