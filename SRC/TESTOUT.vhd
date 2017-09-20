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
		input  : in std_logic_vector(385 downto 0);
		mask   : in std_logic_vector(11 downto 0);
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
					 
					 input(201)  when mask = x"C9" else  --LDSC(15)
                input(202)  when mask = x"CA" else  --LDSC2(15)
                input(203)  when mask = x"CB" else  --LASERFLAG_EXTERNAL
                input(204)  when mask = x"CC" else  --LASERFLAG
                input(205)  when mask = x"CD" else  --BEANFLAG
					 input(206)  when mask = x"CE" else  --LDSC2(7)
                input(207)  when mask = x"CF" else  --LDSC(15)
                input(208)  when mask = x"D0" else  --LDSC2(15)
                input(209)  when mask = x"D1" else  --LASERFLAG_EXTERNAL
                input(210)  when mask = x"D2" else  --LASERFLAG
                input(211)  when mask = x"D3" else  --BEANFLAG
					 input(212)  when mask = x"D4" else  --LDSC(15)
                input(213)  when mask = x"D5" else  --LDSC2(15)
                input(214)  when mask = x"D6" else  --LASERFLAG_EXTERNAL
                input(215)  when mask = x"D7" else  --LASERFLAG
                input(216)  when mask = x"D8" else  --BEANFLAG
                input(217)  when mask = x"D9" else  --BEANFLAG
                input(218)  when mask = x"DA" else  --LDSC(15)
                input(219)  when mask = x"DB" else  --LDSC2(15)					 
                input(220)  when mask = x"DC" else  --LASERFLAG_EXTERNAL
                input(221)  when mask = x"DD" else  --LASERFLAG
                input(222)  when mask = x"DE" else  --BEANFLAG
					 input(223)  when mask = x"DF" else  --LDSC2(7)
                input(224)  when mask = x"E0" else  --LDSC(15)
                input(225)  when mask = x"E1" else  --LDSC2(15)
                input(226)  when mask = x"E2" else  --LASERFLAG_EXTERNAL
                input(227)  when mask = x"E3" else  --LASERFLAG
                input(228)  when mask = x"E4" else  --BEANFLAG
					 input(229)  when mask = x"E5" else  --LDSC(15)
                input(230)  when mask = x"E6" else  --LDSC2(15)
                input(231)  when mask = x"E7" else  --LASERFLAG_EXTERNAL
                input(232)  when mask = x"E8" else  --LASERFLAG
                input(233)  when mask = x"E9" else  --BEANFLAG
                input(234)  when mask = x"EA" else  --LASERFLAG_EXTERNAL
                input(235)  when mask = x"EB" else  --LASERFLAG
                input(236)  when mask = x"EC" else  --BEANFLAG
					 input(237)  when mask = x"ED" else  --LDSC2(7)
                input(238)  when mask = x"EE" else  --LDSC(15)
                input(239)  when mask = x"EF" else  --LDSC2(15)
                input(240)  when mask = x"F0" else  --LASERFLAG_EXTERNAL
                input(241)  when mask = x"F1" else  --LASERFLAG
                input(242)  when mask = x"F2" else  --BEANFLAG
					 input(243)  when mask = x"F3" else  --LDSC(15)
                input(244)  when mask = x"F4" else  --LDSC2(15)
                input(245)  when mask = x"F5" else  --LASERFLAG_EXTERNAL
                input(246)  when mask = x"F6" else  --LASERFLAG
                input(247)  when mask = x"F7" else  --BEANFLAG
                input(248)  when mask = x"F8" else  --LASERFLAG
                input(249)  when mask = x"F9" else  --BEANFLAG
					 input(250)  when mask = x"FA" else  --LDSC2(7)
                input(251)  when mask = x"FB" else  --LDSC(15)
                input(252)  when mask = x"FC" else  --LDSC2(15)
                input(253)  when mask = x"FD" else  --LASERFLAG_EXTERNAL
                input(254)  when mask = x"FE" else  --LASERFLAG
                input(255)  when mask = x"FF" else  --BEANFLAG
					 input(256)  when mask = x"100" else  --LASERFLAG
                input(257)  when mask = x"101" else  --BEANFLAG
					 
					 input(258)  when mask = x"100" else  --LASERFLAG
                input(259)  when mask = x"101" else  --BEANFLAG
					 input(260)  when mask = x"102" else  --LASERFLAG
                input(261)  when mask = x"103" else  --BEANFLAG
					 input(262)  when mask = x"104" else  --LASERFLAG
                input(263)  when mask = x"105" else  --BEANFLAG
					 input(264)  when mask = x"106" else  --LASERFLAG
                input(265)  when mask = x"107" else  --BEANFLAG
					 input(266)  when mask = x"108" else  --BEANFLAG
					 input(267)  when mask = x"109" else  --BEANFLAG
					 input(268)  when mask = x"10A" else  --BEANFLAG
					 input(269)  when mask = x"10B" else  --LASERFLAG
                input(270)  when mask = x"10C" else  --BEANFLAG
					 input(271)  when mask = x"10D" else  --BEANFLAG
					 input(272)  when mask = x"10E" else  --BEANFLAG
					 input(273)  when mask = x"10F" else  --BEANFLAG
					 input(274)  when mask = x"110" else  --LASERFLAG
                input(275)  when mask = x"111" else  --BEANFLAG
					 input(276)  when mask = x"112" else  --LASERFLAG
                input(277)  when mask = x"113" else  --BEANFLAG
					 input(278)  when mask = x"114" else  --LASERFLAG
                input(279)  when mask = x"115" else  --BEANFLAG
					 input(280)  when mask = x"116" else  --LASERFLAG
                input(281)  when mask = x"117" else  --BEANFLAG
					 input(282)  when mask = x"118" else  --BEANFLAG
					 input(283)  when mask = x"119" else  --BEANFLAG
					 input(284)  when mask = x"11A" else  --BEANFLAG
					 input(285)  when mask = x"11B" else  --LASERFLAG
                input(286)  when mask = x"11C" else  --BEANFLAG
					 input(287)  when mask = x"11D" else  --BEANFLAG
					 input(288)  when mask = x"11E" else  --BEANFLAG
					 input(289)  when mask = x"11F" else  --BEANFLAG
					 
					 input(290)  when mask = x"120" else  --LASERFLAG
                input(291)  when mask = x"121" else  --BEANFLAG
					 input(292)  when mask = x"122" else  --LASERFLAG
                input(293)  when mask = x"123" else  --BEANFLAG
					 input(294)  when mask = x"124" else  --LASERFLAG
                input(295)  when mask = x"125" else  --BEANFLAG
					 input(296)  when mask = x"126" else  --LASERFLAG
                input(297)  when mask = x"127" else  --BEANFLAG
					 input(298)  when mask = x"128" else  --BEANFLAG
					 input(299)  when mask = x"129" else  --BEANFLAG
					 input(300)  when mask = x"12A" else  --BEANFLAG
					 input(301)  when mask = x"12B" else  --LASERFLAG
                input(302)  when mask = x"12C" else  --BEANFLAG
					 input(303)  when mask = x"12D" else  --BEANFLAG
					 input(304)  when mask = x"12E" else  --BEANFLAG
					 input(305)  when mask = x"12F" else  --BEANFLAG
					 
					 input(306)  when mask = x"130" else  --LASERFLAG
                input(307)  when mask = x"131" else  --BEANFLAG
					 input(308)  when mask = x"132" else  --LASERFLAG
                input(309)  when mask = x"133" else  --BEANFLAG
					 input(310)  when mask = x"134" else  --LASERFLAG
                input(311)  when mask = x"135" else  --BEANFLAG
					 input(312)  when mask = x"136" else  --LASERFLAG
                input(313)  when mask = x"137" else  --BEANFLAG
					 input(314)  when mask = x"138" else  --BEANFLAG
					 input(315)  when mask = x"139" else  --BEANFLAG
					 input(316)  when mask = x"13A" else  --BEANFLAG
					 input(317)  when mask = x"13B" else  --LASERFLAG
                input(318)  when mask = x"13C" else  --BEANFLAG
					 input(319)  when mask = x"13D" else  --BEANFLAG
					 input(320)  when mask = x"13E" else  --BEANFLAG
					 input(321)  when mask = x"13F" else  --BEANFLAG
					 
					 input(322)  when mask = x"140" else  --LASERFLAG
                input(323)  when mask = x"141" else  --BEANFLAG
					 input(324)  when mask = x"142" else  --LASERFLAG
                input(325)  when mask = x"143" else  --BEANFLAG
					 input(326)  when mask = x"144" else  --LASERFLAG
                input(327)  when mask = x"145" else  --BEANFLAG
					 input(328)  when mask = x"146" else  --LASERFLAG
                input(329)  when mask = x"147" else  --BEANFLAG
					 input(330)  when mask = x"148" else  --BEANFLAG
					 input(331)  when mask = x"149" else  --BEANFLAG
					 input(332)  when mask = x"14A" else  --BEANFLAG
					 input(333)  when mask = x"14B" else  --LASERFLAG
                input(334)  when mask = x"14C" else  --BEANFLAG
					 input(335)  when mask = x"14D" else  --BEANFLAG
					 input(336)  when mask = x"14E" else  --BEANFLAG
					 input(337)  when mask = x"14F" else  --BEANFLAG
					 
					 input(338)  when mask = x"150" else  --LASERFLAG
                input(339)  when mask = x"151" else  --BEANFLAG
					 input(340)  when mask = x"152" else  --LASERFLAG
                input(341)  when mask = x"153" else  --BEANFLAG
					 input(342)  when mask = x"154" else  --LASERFLAG
                input(343)  when mask = x"155" else  --BEANFLAG
					 input(344)  when mask = x"156" else  --LASERFLAG
                input(345)  when mask = x"157" else  --BEANFLAG
					 input(346)  when mask = x"158" else  --BEANFLAG
					 input(347)  when mask = x"159" else  --BEANFLAG
					 input(348)  when mask = x"15A" else  --BEANFLAG
					 input(349)  when mask = x"15B" else  --LASERFLAG
                input(350)  when mask = x"15C" else  --BEANFLAG
					 input(351)  when mask = x"15D" else  --BEANFLAG
					 input(352)  when mask = x"15E" else  --BEANFLAG
					 input(353)  when mask = x"15F" else  --BEANFLAG
					 
					 input(354)  when mask = x"160" else  --LASERFLAG
                input(355)  when mask = x"161" else  --BEANFLAG
					 input(356)  when mask = x"162" else  --LASERFLAG
                input(357)  when mask = x"163" else  --BEANFLAG
					 input(358)  when mask = x"164" else  --LASERFLAG
                input(359)  when mask = x"165" else  --BEANFLAG
					 input(360)  when mask = x"166" else  --LASERFLAG
                input(361)  when mask = x"167" else  --BEANFLAG
					 input(362)  when mask = x"168" else  --BEANFLAG
					 input(363)  when mask = x"169" else  --BEANFLAG
					 input(364)  when mask = x"16A" else  --BEANFLAG
					 input(365)  when mask = x"16B" else  --LASERFLAG
                input(366)  when mask = x"16C" else  --BEANFLAG
					 input(367)  when mask = x"16D" else  --BEANFLAG
					 input(368)  when mask = x"16E" else  --BEANFLAG
					 input(369)  when mask = x"16F" else  --BEANFLAG
					 input(370)  when mask = x"170" else  --LASERFLAG
                input(371)  when mask = x"171" else  --BEANFLAG
					 input(372)  when mask = x"172" else  --LASERFLAG
                input(373)  when mask = x"173" else  --BEANFLAG
					 input(374)  when mask = x"174" else  --LASERFLAG
					 input(375)  when mask = x"175" else  --BEANFLAG
					 input(376)  when mask = x"176" else  --LASERFLAG
                input(377)  when mask = x"177" else  --BEANFLAG
					 input(378)  when mask = x"178" else  --BEANFLAG
					 input(379)  when mask = x"179" else  --BEANFLAG
					 input(380)  when mask = x"17A" else  --BEANFLAG
					 input(381)  when mask = x"17B" else  --LASERFLAG
					 input(382)  when mask = x"17C" else  --LASERFLAG
                input(383)  when mask = x"17D" else  --BEANFLAG
					 input(384)  when mask = x"17E" else  --LASERFLAG
					 input(385)  when mask = x"17F" else  --BEANFLAG
				    '0';
end Behavioral;

