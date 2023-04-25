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

# Quartus Prime: Generate Tcl File for Project
# File: ethernet_w5300.tcl
# Generated on: Tue Apr 25 21:32:18 2023

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
    if {[string compare $quartus(project) "ethernet_w5300"]} {
        puts "Project ethernet_w5300 is not open"
        set make_assignments 0
    }
} else {
    # Only open if not already open
    if {[project_exists ethernet_w5300]} {
        project_open -revision top ethernet_w5300
    } else {
        project_new -revision top ethernet_w5300
    }
    set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
    set_global_assignment -name FAMILY "Cyclone IV E"
    set_global_assignment -name DEVICE EP4CE10F17C8
    set_global_assignment -name ORIGINAL_QUARTUS_VERSION 17.1.0
    set_global_assignment -name PROJECT_CREATION_TIME_DATE "03:54:58  APRIL 22, 2023"
    set_global_assignment -name LAST_QUARTUS_VERSION "17.1.0 Lite Edition"
    set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
    set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
    set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
    set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
    set_global_assignment -name FLOW_ENABLE_RTL_VIEWER ON
    set_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS ON
    set_global_assignment -name SMART_RECOMPILE ON
    set_global_assignment -name NUM_PARALLEL_PROCESSORS 12
    set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim (Verilog)"
    set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
    set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
    set_global_assignment -name ENABLE_SIGNALTAP OFF
    set_global_assignment -name USE_SIGNALTAP_FILE debug/w5300_udp.stp
    set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
    set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
    set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
    set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
    set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS TEST_BENCH_MODE -section_id eda_simulation
    set_global_assignment -name EDA_NATIVELINK_SIMULATION_TEST_BENCH tb__w5300_parallel_if_rw -section_id eda_simulation
    set_global_assignment -name EDA_TEST_BENCH_NAME tb__w5300_parallel_if_rw -section_id eda_simulation
    set_global_assignment -name EDA_DESIGN_INSTANCE_NAME NA -section_id tb__w5300_parallel_if_rw
    set_global_assignment -name EDA_TEST_BENCH_MODULE_NAME tb__w5300_parallel_if_rw -section_id tb__w5300_parallel_if_rw
    set_global_assignment -name SLD_NODE_CREATOR_ID 110 -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_ENTITY_NAME sld_signaltap -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_RAM_BLOCK_TYPE=AUTO" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_NODE_INFO=805334529" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_POWER_UP_TRIGGER=0" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STORAGE_QUALIFIER_INVERSION_MASK_LENGTH=0" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_SEGMENT_SIZE=1024" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ATTRIBUTE_MEM_MODE=OFF" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STATE_FLOW_USE_GENERATED=0" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STATE_BITS=11" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_BUFFER_FULL_STOP=1" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_CURRENT_RESOURCE_WIDTH=1" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INCREMENTAL_ROUTING=1" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_LEVEL=1" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_SAMPLE_DEPTH=1024" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_IN_ENABLED=0" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_PIPELINE=0" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_RAM_PIPELINE=0" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_COUNTER_PIPELINE=0" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ADVANCED_TRIGGER_ENTITY=basic,1," -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_LEVEL_PIPELINE=1" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ENABLE_ADVANCED_TRIGGER=0" -section_id auto_signaltap_1
    set_global_assignment -name VERILOG_FILE testbench/w5300/luts/_interrupt_reg.v
    set_global_assignment -name VERILOG_FILE testbench/w5300/luts/_common_reg.v
    set_global_assignment -name VERILOG_FILE testbench/w5300/_rw.v
    set_global_assignment -name VERILOG_FILE src/led/led.v
    set_global_assignment -name VERILOG_FILE src/w5300/luts/_socket_reg.v
    set_global_assignment -name VERILOG_FILE src/w5300/luts/_interrupt_reg.v
    set_global_assignment -name VERILOG_FILE src/w5300/luts/_common_reg.v
    set_global_assignment -name VERILOG_FILE src/w5300/udp.v
    set_global_assignment -name VERILOG_FILE src/w5300/if.v
    set_global_assignment -name VERILOG_FILE src/w5300/entry.v
    set_global_assignment -name VERILOG_FILE src/w5300/_rw.v
    set_global_assignment -name VERILOG_FILE src/top.v
    set_global_assignment -name QIP_FILE ip/pll/pll.qip
    set_global_assignment -name QIP_FILE ip/ram/udp_buffer.qip
    set_global_assignment -name MIF_FILE ip/ram/udp_tx_buffer.mif
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_DATA_BITS=55" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_BITS=55" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STORAGE_QUALIFIER_BITS=55" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INVERSION_MASK=000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" -section_id auto_signaltap_1
    set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INVERSION_MASK_LENGTH=189" -section_id auto_signaltap_1
    set_global_assignment -name SLD_FILE db/stp1_auto_stripped.stp
    set_global_assignment -name EDA_TEST_BENCH_FILE testbench/w5300/_rw.v -section_id tb__w5300_parallel_if_rw
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
    set_location_assignment PIN_B3 -to wrst_n
    set_location_assignment PIN_B5 -to we_n
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
    set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to data
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
    set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to we_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to wrst_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to addr
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[0] -to addr[0] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[1] -to addr[1] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[2] -to addr[2] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[3] -to addr[3] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[4] -to addr[4] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[5] -to addr[5] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[6] -to addr[6] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[7] -to addr[7] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[8] -to addr[8] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[9] -to addr[9] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[10] -to cs_n -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[11] -to data[0] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[12] -to data[10] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[13] -to data[11] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[14] -to data[12] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[15] -to data[13] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[16] -to data[14] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[17] -to data[15] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[18] -to data[1] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[19] -to data[2] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[20] -to data[3] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[21] -to data[4] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[22] -to data[5] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[23] -to data[6] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[24] -to data[7] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[25] -to data[8] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[26] -to data[9] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[27] -to rd_n -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[28] -to rw_n -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[0] -to addr[0] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[1] -to addr[1] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[2] -to addr[2] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[3] -to addr[3] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[4] -to addr[4] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[5] -to addr[5] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[6] -to addr[6] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[7] -to addr[7] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[8] -to addr[8] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[9] -to addr[9] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[10] -to cs_n -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[11] -to data[0] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[12] -to data[10] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[13] -to data[11] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[14] -to data[12] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[15] -to data[13] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[16] -to data[14] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[17] -to data[15] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[18] -to data[1] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[19] -to data[2] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[20] -to data[3] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[21] -to data[4] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[22] -to data[5] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[23] -to data[6] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[24] -to data[7] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[25] -to data[8] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[26] -to data[9] -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[27] -to rd_n -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[28] -to rw_n -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[5] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[25] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[2] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[10] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[20] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[23] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[26] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[30] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[4] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_clk -to "pll:wpll|c1" -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[7] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[29] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[0]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[30] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[10]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[31] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[1]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[32] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[2]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[33] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[3]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[34] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[4]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[35] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[5]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[36] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[6]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[37] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[7]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[38] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[8]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[39] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[9]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[40] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[0]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[41] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[10]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[42] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[11]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[43] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[1]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[44] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[2]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[45] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[3]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[46] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[4]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[47] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[5]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[48] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[6]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[49] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[7]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[50] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[8]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[51] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[9]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[52] -to "w5300_entry:w5300_entry_inst_0|w5300_udp_conf_comm:w5300_udp_conf_comm_inst|_state_c.S_COMMON_INIT" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[29] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[0]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[30] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[10]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[31] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[1]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[32] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[2]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[33] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[3]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[34] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[4]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[35] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[5]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[36] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[6]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[37] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[7]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[38] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[8]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[39] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|_w5300_parallel_if_rw:_w5300_parallel_if_rw_inst|caddr[9]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[40] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[0]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[41] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[10]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[42] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[11]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[43] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[1]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[44] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[2]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[45] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[3]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[46] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[4]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[47] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[5]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[48] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[6]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[49] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[7]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[50] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[8]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[51] -to "w5300_entry:w5300_entry_inst_0|w5300_parallel_if:w5300_parallel_if_inst|uaddr[9]" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[52] -to "w5300_entry:w5300_entry_inst_0|w5300_udp_conf_comm:w5300_udp_conf_comm_inst|_state_c.S_COMMON_INIT" -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[11] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[18] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[19] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[22] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[0] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[6] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[8] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[13] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[14] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[15] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[17] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[21] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[27] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[28] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[29] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[53] -to "w5300_entry:w5300_entry_inst_0|w5300_udp_conf_comm:w5300_udp_conf_comm_inst|op_status" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[54] -to we_n -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[53] -to "w5300_entry:w5300_entry_inst_0|w5300_udp_conf_comm:w5300_udp_conf_comm_inst|op_status" -section_id auto_signaltap_1
    set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[54] -to we_n -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[1] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[3] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[9] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[12] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[16] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[24] -to auto_signaltap_1|vcc -section_id auto_signaltap_1
    set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[31] -to auto_signaltap_1|gnd -section_id auto_signaltap_1
    set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

    # Commit assignments
    export_assignments

    # Close project
    if {$need_to_close_project} {
        project_close
    }
}
