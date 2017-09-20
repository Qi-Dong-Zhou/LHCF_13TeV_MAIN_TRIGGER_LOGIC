----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:42:16 02/15/2008 
-- Design Name: 
-- Module Name:    TESTOUT - Behavioral 
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

entity TESTOUT is port(
		input  : in std_logic_vector(200 downto 0);
		mask   : in std_logic_vector(7 downto 0);
		output : out std_logic);
end TESTOUT;

architecture Behavioral of TESTOUT is
begin
    output <=   input(0)  when mask = x"00" else  --LCLK
                input(1)  when mask = x"01" else  --LHCCLK
                input(2)  when mask = x"02" else  --CLK
                input(3)  when mask = x"03" else  --CLK80
                input(4)  when mask = x"04" else  --BPTX1_1
                input(5)  when mask = x"05" else  --BPTX1_2
                input(6)  when mask = x"06" else  --BPTX2_1
                input(7)  when mask = x"07" else  --BPTX2_2
                input(8)  when mask = x"08" else  --A1_L1T
					 input(9)  when mask = x"09" else  --A1_DL1T
					 input(10) when mask = x"0A" else  --A1_LDSC(15)
					 input(11) when mask = x"0B" else  --A1_LDSC2(15)
					 input(12) when mask = x"0C" else  --A1_STRG
					 input(13) when mask = x"0D" else  --A1_LTRG
                input(14)  when mask = x"0E" else  --A1_SLOGIC
                input(15)  when mask = x"0F" else  --A1_LLOGIC
                input(16)  when mask = x"10" else  --A1_SHOWER_TRG1
                input(17)  when mask = x"11" else  --A1_SHOWER_TRG2
                input(18)  when mask = x"12" else  --A1_SHOWER_TRG3
                input(19)  when mask = x"13" else  --A1_L2T_SHOWER
                input(20)  when mask = x"14" else  --A1_SPECIAL_TRG1
                input(21)  when mask = x"15" else  --A1_SPECIAL_TRG2
                input(22)  when mask = x"16" else  --A1_SPECIAL_TRG3
                input(23)  when mask = x"17" else  --A1_L2T_SPECIAL
                input(24)  when mask = x"18" else  --A1_PEDE_TRG1
                input(25)  when mask = x"19" else  --A1_L2T_PEDE
                input(26)  when mask = x"1A" else  --A1_L2T_L1T1
          	    input(27)  when mask = x"1B" else  --A1_L2T_L1T
          	    input(28)  when mask = x"1C" else  --DBPTX1
                input(29)  when mask = x"1D" else  --DBPTX2
                input(30)  when mask = x"1E" else  --A2_FC(0)
                input(31)  when mask = x"1F" else  --A1_FC_TRG1
                input(32)  when mask = x"20" else  --A1_FC_TRG
                input(33)  when mask = x"21" else  --A2_FC_TRG1
                input(34)  when mask = x"22" else  --A2_FC_TRG
                input(35)  when mask = x"23" else  --A1_L2T_FC
                input(36)  when mask = x"24" else  --A1_L3T1
                input(37)  when mask = x"25" else  --A1_ENABLE_FLAG
                input(38)  when mask = x"26" else  --A1_L3TT
                input(39)  when mask = x"27" else  --A1_L3T2
                input(40)  when mask = x"28" else  --A1_LATCH
                input(41)  when mask = x"29" else  --A1_LATCH_STOP_INTERNAL4
                input(42)  when mask = x"2A" else  --A1_LATCH_STOP_FIXED
                input(43)  when mask = x"2B" else  --A1_LATCH_STOP_EXTERNAL3
                input(44)  when mask = x"2C" else  --A1_L3T 
                input(45)  when mask = x"2D" else  --A1_SELFVETO					 
                input(46)  when mask = x"2E" else  --A1_ENABLE
					 input(47)  when mask = x"2F" else  --A1_PEDE_FLAG
					 input(48)  when mask = x"30" else  --A2_FC2(0)
					 input(49)  when mask = x"31" else  --A1_ATLAS
					 input(50)  when mask = x"32" else  --A1_LATCH_STOP_INTERNAL1
					 input(51)  when mask = x"33" else  --A1_SDSC(14)
                input(52)  when mask = x"34" else  --A1_SDSC2(14)
					 input(53)  when mask = x"35" else  --ATLAS_L1A
					 input(54)  when mask = x"36" else  --ATLAS_ECR
					 input(55)  when mask = x"37" else  --ORBIT
					 input(56)  when mask = x"38" else  --A1_SDSC(5)
                input(57)  when mask = x"39" else  --A1_SDSC(6)
					 input(58)  when mask = x"3A" else  --A1_SDSC(7)
                input(59)  when mask = x"3B" else  --A1_SDSC(8)
                input(60)  when mask = x"3C" else  --A1_SDSC(9)
                input(61)  when mask = x"3D" else  --A1_SDSC(10)
                input(62)  when mask = x"3E" else  --A1_SDSC(11)
                input(63)  when mask = x"3F" else  --A1_SDSC(12)
                input(64)  when mask = x"40" else  --A1_SDSC(13)
                input(65)  when mask = x"41" else  --A1_SDSC(14)
                input(66)  when mask = x"42" else  --A1_SDSC(15)					 
                input(67)  when mask = x"43" else  --A1_WR					 
                input(68)  when mask = x"44" else  --A1_SHIFT_EN                             
                input(69)  when mask = x"45" else  --A1_TRANSFER_EN
					 input(70)  when mask = x"46" else  --A1_SDSC(5)
                input(71)  when mask = x"47" else  --A1_SDSC(6)
					 input(72)  when mask = x"48" else  --A1_SDSC(7)
                input(73)  when mask = x"49" else  --A1_SDSC(8)
                input(74)  when mask = x"4A" else  --A1_SDSC(9)
                input(75)  when mask = x"4B" else  --A1_SDSC(10)
                input(76)  when mask = x"4C" else  --A1_SDSC(11)
                input(77)  when mask = x"4D" else  --A1_SDSC(12)
                input(78)  when mask = x"4E" else  --A1_SDSC(13)
                input(79)  when mask = x"4F" else  --A1_SDSC(14)
                input(80)  when mask = x"50" else  --A1_SDSC(15)					 
					 input(81)  when mask = x"51" else  --nLBRES
                input(82)  when mask = x"52" else  --nBLAST
                input(83)  when mask = x"53" else  --WnR
                input(84)  when mask = x"54" else  --nADS
                input(85)  when mask = x"55" else  --nREADY
                input(86)  when mask = x"56" else  --nINT					 
					 input(87)  when mask = x"57" else  --A1_PEDE_FLAG_SYN
                input(88)  when mask = x"58" else  --A1_PEDE_FLAG1
                input(89)  when mask = x"59" else  --LDSC2(7)
                input(90)  when mask = x"5A" else  --LDSC(15)
                input(91)  when mask = x"5B" else  --LDSC2(15)
                input(92)  when mask = x"5C" else  --LASERFLAG_EXTERNAL
                input(93)  when mask = x"5D" else  --LASERFLAG
                input(94)  when mask = x"5E" else  --BEANFLAG
					 input(95)  when mask = x"5F" else  --LDSC2(7)
                input(96)  when mask = x"60" else  --LDSC(15)
                input(97)  when mask = x"61" else  --LDSC2(15)
                input(98)  when mask = x"62" else  --LASERFLAG_EXTERNAL
                input(99)  when mask = x"63" else  --LASERFLAG
                input(100)  when mask = x"64" else  --BEANFLAG
                input(101)  when mask = x"65" else  --LDSC(15)
                input(102)  when mask = x"66" else  --LDSC2(15)
                input(103)  when mask = x"67" else  --LASERFLAG_EXTERNAL
                input(104)  when mask = x"68" else  --LASERFLAG
                input(105)  when mask = x"69" else  --BEANFLAG
					 input(106)  when mask = x"6A" else  --LDSC2(7)
                input(107)  when mask = x"6B" else  --LDSC(15)
                input(108)  when mask = x"6C" else  --LDSC2(15)
                input(109)  when mask = x"6D" else  --LASERFLAG_EXTERNAL
                input(110)  when mask = x"6E" else  --LASERFLAG
                input(111)  when mask = x"6F" else  --BEANFLAG
					 input(112)  when mask = x"70" else  --LDSC(15)
                input(113)  when mask = x"71" else  --LDSC2(15)
                input(114)  when mask = x"72" else  --LASERFLAG_EXTERNAL
                input(115)  when mask = x"73" else  --LASERFLAG
                input(116)  when mask = x"74" else  --BEANFLAG
                input(117)  when mask = x"75" else  --BEANFLAG
                input(118)  when mask = x"76" else  --LDSC(15)
                input(119)  when mask = x"77" else  --LDSC2(15)					 
                input(120)  when mask = x"78" else  --LASERFLAG_EXTERNAL
                input(121)  when mask = x"79" else  --LASERFLAG
                input(122)  when mask = x"7A" else  --BEANFLAG
					 
					 input(123)  when mask = x"7B" else  --LDSC2(7)
                input(124)  when mask = x"7C" else  --LDSC(15)
                input(125)  when mask = x"7D" else  --LDSC2(15)
                input(126)  when mask = x"7E" else  --LASERFLAG_EXTERNAL
                input(127)  when mask = x"7F" else  --LASERFLAG
                input(128)  when mask = x"80" else  --BEANFLAG
					 input(129)  when mask = x"81" else  --LDSC(15)
                input(130)  when mask = x"82" else  --LDSC2(15)
                input(131)  when mask = x"83" else  --LASERFLAG_EXTERNAL
                input(132)  when mask = x"84" else  --LASERFLAG
                input(133)  when mask = x"85" else  --BEANFLAG
                input(134)  when mask = x"86" else  --LASERFLAG_EXTERNAL
                input(135)  when mask = x"87" else  --LASERFLAG
                input(136)  when mask = x"88" else  --BEANFLAG
					 input(137)  when mask = x"89" else  --LDSC2(7)
                input(138)  when mask = x"8A" else  --LDSC(15)
                input(139)  when mask = x"8B" else  --LDSC2(15)
                input(140)  when mask = x"8C" else  --LASERFLAG_EXTERNAL
                input(141)  when mask = x"8D" else  --LASERFLAG
                input(142)  when mask = x"8E" else  --BEANFLAG
					 input(143)  when mask = x"8F" else  --LDSC(15)
                input(144)  when mask = x"90" else  --LDSC2(15)
                input(145)  when mask = x"91" else  --LASERFLAG_EXTERNAL
                input(146)  when mask = x"92" else  --LASERFLAG
                input(147)  when mask = x"93" else  --BEANFLAG
                input(148)  when mask = x"94" else  --LASERFLAG
                input(149)  when mask = x"95" else  --BEANFLAG
					 input(150)  when mask = x"96" else  --LDSC2(7)
                input(151)  when mask = x"97" else  --LDSC(15)
                input(152)  when mask = x"98" else  --LDSC2(15)
                input(153)  when mask = x"99" else  --LASERFLAG_EXTERNAL
                input(154)  when mask = x"9A" else  --LASERFLAG
                input(155)  when mask = x"9B" else  --BEANFLAG
					 
					 input(156)  when mask = x"9C" else  --LDSC2(7)
                input(157)  when mask = x"9D" else  --LDSC(15)
                input(158)  when mask = x"9E" else  --LDSC2(15)
                input(159)  when mask = x"9F" else  --LASERFLAG_EXTERNAL
                input(160)  when mask = x"A0" else  --LASERFLAG
                input(161)  when mask = x"A1" else  --BEANFLAG
					 input(162)  when mask = x"A2" else  --LDSC2(7)
                input(163)  when mask = x"A3" else  --LDSC(15)
                input(164)  when mask = x"A4" else  --LDSC2(15)
                input(165)  when mask = x"A5" else  --LASERFLAG_EXTERNAL
                input(166)  when mask = x"A6" else  --LASERFLAG
                input(167)  when mask = x"A7" else  --BEANFLAG
					 input(168)  when mask = x"A8" else  --LASERFLAG
                input(169)  when mask = x"A9" else  --BEANFLAG
					 input(170)  when mask = x"AA" else  --BEANFLAG
					 input(171)  when mask = x"AB" else  --LDSC2(7)
                input(172)  when mask = x"AC" else  --LDSC(15)
                input(173)  when mask = x"AD" else  --LDSC2(15)
                input(174)  when mask = x"AE" else  --LASERFLAG_EXTERNAL
                input(175)  when mask = x"AF" else  --LASERFLAG
                input(176)  when mask = x"B0" else  --BEANFLAG
					 input(177)  when mask = x"B1" else  --LASERFLAG
                input(178)  when mask = x"B2" else  --BEANFLAG
					 input(179)  when mask = x"B3" else  --LASERFLAG
                input(180)  when mask = x"B4" else  --BEANFLAG
					 input(181)  when mask = x"B5" else  --LASERFLAG
                input(182)  when mask = x"B6" else  --BEANFLAG
					 input(183)  when mask = x"B7" else  --LASERFLAG
                input(184)  when mask = x"B8" else  --BEANFLAG
					 input(185)  when mask = x"B9" else  --LASERFLAG
                input(186)  when mask = x"BA" else  --BEANFLAG
					 input(187)  when mask = x"BB" else  --BEANFLAG
					 input(188)  when mask = x"BC" else  --LASERFLAG
                input(189)  when mask = x"BD" else  --BEANFLAG
					 
					 input(190)  when mask = x"BE" else  --LASERFLAG
                input(191)  when mask = x"BF" else  --BEANFLAG
					 input(192)  when mask = x"C0" else  --LASERFLAG
                input(193)  when mask = x"C1" else  --BEANFLAG
					 input(194)  when mask = x"C2" else  --BEANFLAG
					 input(195)  when mask = x"C3" else  --LASERFLAG
                input(196)  when mask = x"C4" else  --BEANFLAG
                input(197)  when mask = x"C5" else  --BEANFLAG
					 input(198)  when mask = x"C6" else  --BEANFLAG
					 input(199)  when mask = x"C7" else  --LASERFLAG
                input(200)  when mask = x"C8" else  --BEANFLAG
				    '0';
end Behavioral;

