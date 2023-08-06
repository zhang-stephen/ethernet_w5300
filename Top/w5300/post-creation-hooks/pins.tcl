# Copyright (C) 2017  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions
# and other software and tools, and its AMPP partner logic
# functions, and any output files from any of the foregoing
# (including device programming or simulation files), and any
# associated documentation or information are expressly subject
# to the terms and conditions of the Intel Program License
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details.

# Quartus Prime Version 17.1.0 Build 590 10/25/2017 SJ Lite Edition
# File: C:\Users\stephen\Desktop\ethernet_w5300.tcl
# Generated on: Wed Aug 02 10:48:48 2023

package require ::quartus::project

set_location_assignment PIN_B10 -to addr[9]
set_location_assignment PIN_A9 -to addr[8]
set_location_assignment PIN_E10 -to leds[0]
set_location_assignment PIN_F9 -to leds[1]
set_location_assignment PIN_C9 -to leds[2]
set_location_assignment PIN_D9 -to leds[3]
set_location_assignment PIN_E1 -to clk0
set_location_assignment PIN_M2 -to uart_rxd
set_location_assignment PIN_N1 -to uart_txd
set_location_assignment PIN_E9 -to data[14]
set_location_assignment PIN_D8 -to data[12]
set_location_assignment PIN_F8 -to data[10]
set_location_assignment PIN_C6 -to data[8]
set_location_assignment PIN_D5 -to data[6]
set_location_assignment PIN_B13 -to data[4]
set_location_assignment PIN_B12 -to data[2]
set_location_assignment PIN_B11 -to data[0]
set_location_assignment PIN_E8 -to data[15]
set_location_assignment PIN_C8 -to data[13]
set_location_assignment PIN_E7 -to data[11]
set_location_assignment PIN_D6 -to data[9]
set_location_assignment PIN_A13 -to data[7]
set_location_assignment PIN_A12 -to data[5]
set_location_assignment PIN_A11 -to data[3]
set_location_assignment PIN_A10 -to data[1]
set_location_assignment PIN_B9 -to addr[7]
set_location_assignment PIN_A8 -to addr[6]
set_location_assignment PIN_B8 -to addr[5]
set_location_assignment PIN_B7 -to addr[3]
set_location_assignment PIN_B6 -to addr[1]
set_location_assignment PIN_B4 -to cs_n
set_location_assignment PIN_A7 -to addr[4]
set_location_assignment PIN_A6 -to addr[2]
set_location_assignment PIN_A5 -to addr[0]
set_location_assignment PIN_A4 -to rd_n
set_location_assignment PIN_A3 -to int_n
set_location_assignment PIN_A2 -to rw_n
set_location_assignment PIN_B3 -to w_rst_n
set_location_assignment PIN_B5 -to wr_n
set_location_assignment PIN_N13 -to rst_n
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to clk0
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to cs_n
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to int_n
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rd_n
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rst_n
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rw_n
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_rxd
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_txd
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to wr_n
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to w_rst_n
