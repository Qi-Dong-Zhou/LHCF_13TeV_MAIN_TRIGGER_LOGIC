----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:10 11/26/2014 
-- Design Name: 
-- Module Name:    SHOWER_MODULE - Behavioral 
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

entity SHOWER_MODULE is port(
	CLK                     : in  std_logic;
	CLK80                   : in  std_logic;
	DL1T                    : in  std_logic;
	BEAMFLAG                : in  std_logic;
	SDSC                    : in  std_logic_vector(15 downto 0);
	LDSC                    : in  std_logic_vector(15 downto 0);
	FLAG_CLEAR              : in  std_logic;
	NSTEP_SHOWER_TRG_PRESET : in  std_logic_vector(5 downto 0);
	SHOWER_SOURCE_MASK      : in  std_logic_vector(1 downto 0);
	SHOWER_MASK             : in  std_logic_vector(1 downto 0);
	
	STRIG1                  : out std_logic ; -- logic out of small tower 
	LTRIG1                  : out std_logic ; -- logic out of large tower
	STRG   					   : out std_logic ; -- coincidence with bptx 
	LTRG   					   : out std_logic ; -- coincidence with bptx
	SPATTERN                : out std_logic_vector(15 downto 0); -- discriminator pattern of s 
	LPATTERN                : out std_logic_vector(15 downto 0); -- discriminator pattern of s
   SHOWER_TRG1             : out std_logic;
   SHOWER_TRG2             : out std_logic;
   SHOWER_TRG3             : out std_logic;
	L2T_SHOWER              : out std_logic
);
end SHOWER_MODULE;

architecture Behavioral of SHOWER_MODULE is 
	signal SUB_SHOWER_TRG1    : std_logic := '0';
	signal SUB_SHOWER_TRG2    : std_logic := '0';
	signal SUB_SHOWER_TRG3    : std_logic;
	signal SUB_SHOWER_TRG3_D  : std_logic;
--	signal SUB_SHOWER_TRG3_D1 : std_logic;
--	signal SUB_SHOWER_TRG3_D2 : std_logic;
	signal STRIG2             : std_logic := '0';
	signal LTRIG2             : std_logic := '0';
	signal SHOWER_TRG_PRESET1 : std_logic := '0';
	signal SHOWER_TRG_PRESET2 : std_logic := '0';
begin

	STRG        <= STRIG2;
	LTRG        <= LTRIG2;
	SHOWER_TRG1 <= SUB_SHOWER_TRG1;
	SHOWER_TRG2 <= SUB_SHOWER_TRG2;
	SHOWER_TRG3 <= SUB_SHOWER_TRG3;
	
	TRIGGERLOGIC_SHOWER : TRIGGERLOGIC01 port map(
		CLK      => CLK80,
		TRIG     => DL1T,
		SDSC     => SDSC,
		LDSC     => LDSC,
		CLEAR    => FLAG_CLEAR,
		STRIG1   => STRIG1,
		LTRIG1   => LTRIG1,
		STRIG2   => STRIG2,
		LTRIG2   => LTRIG2,
		SPATTERN => SPATTERN,
		LPATTERN => LPATTERN
	);
	
	SUB_SHOWER_TRG1     <= STRIG2 or LTRIG2;
	SHOWER_TRG_PRESET1  <= SUB_SHOWER_TRG1;
	
	PERSET_SHOWER_TRG_PRESET: PRESETCOUNTER generic map(6) port map(
		CLK =>    CLK80,
		INPUT =>  SHOWER_TRG_PRESET1,
		PRESET => NSTEP_SHOWER_TRG_PRESET,
		CLEAR =>  '0',
		STAT =>   SHOWER_TRG_PRESET2
	);
	
	SUB_SHOWER_TRG2 <= OR_WITH_MASK2(  SUB_SHOWER_TRG1,
											   SHOWER_TRG_PRESET2,
											   SHOWER_SOURCE_MASK);

	SUB_SHOWER_TRG3 <= AND_WITH_MASK2( SUB_SHOWER_TRG2,
											   BEAMFLAG,
											   SHOWER_MASK);
												
	L2T_SHOWER_WIDTH : INTERNALCOUNTER generic map (4) port map(
		CLK          => CLK80,
		START        => SUB_SHOWER_TRG3,
		PRESET       => "0101", 
		STAT         => SUB_SHOWER_TRG3_D,                                      
		ENDMARK      => open                                              
	);
	
	L2T_SHOWER <= SUB_SHOWER_TRG3 or SUB_SHOWER_TRG3_D;
											
	
end Behavioral;

