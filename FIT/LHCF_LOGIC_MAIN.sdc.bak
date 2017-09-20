#************************************************************
# THIS IS A WIZARD-GENERATED FILE.                           
#
# Version 11.0 Build 208 07/03/2011 Service Pack 1 SJ Web Edition
#
#************************************************************

# Copyright (C) 1991-2011 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.



# Clock constraints
#create_clock -name "LCLK" -period 40.000ns [get_ports {LCLK}] modified
#create_clock -name "LCLK" -period 25.000ns [get_ports {LCLK}]
#create_clock -name "LHCCLK" -period 25.000ns [get_ports {GIN[0]}]


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {LHCCLK} -period 25.000 -waveform { 0.000 12.500 } [get_ports {GIN[0]}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {CLK_40to80|altpll_component|pll|clk[0]} -source [get_pins {CLK_40to80|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -master_clock {LHCCLK} [get_pins {CLK_40to80|altpll_component|pll|clk[0]}] 
create_generated_clock -name {CLK_40to80|altpll_component|pll|clk[1]} -source [get_pins {CLK_40to80|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {LHCCLK} [get_pins {CLK_40to80|altpll_component|pll|clk[1]}] 


# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks


# Automatically calculate clock uncertainty to jitter and other effects.
#derive_clock_uncertainty
# Not supported for family Cyclone

# tsu/th constraints

# tco constraints

# tpd constraints

