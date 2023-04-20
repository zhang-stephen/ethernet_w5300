# Copyright (C) 2022  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions
# and other software and tools, and any partner logic
# functions, and any output files from any of the foregoing
# (including device programming or simulation files), and any
# associated documentation or information are expressly subject
# to the terms and conditions of the Intel Program License
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: ethernet_w5300.tcl
# Generated on: Thu Apr 20 23:26:01 2023

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
        project_open -revision ethernet_w5300 ethernet_w5300
    } else {
        project_new -revision ethernet_w5300 ethernet_w5300
    }
    set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
    set_global_assignment -name FAMILY "Cyclone IV E"
    set_global_assignment -name DEVICE EP4CE10F17C8
    set_global_assignment -name ORIGINAL_QUARTUS_VERSION 22.1STD.0
    set_global_assignment -name PROJECT_CREATION_TIME_DATE "01:40:46  MARCH 28, 2023"
    set_global_assignment -name LAST_QUARTUS_VERSION "22.1std.0 Lite Edition"
    set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
    set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
    set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
    set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
    set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.2V
    set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "Precision Synthesis"
    set_global_assignment -name EDA_LMF_FILE mentor.lmf -section_id eda_design_synthesis
    set_global_assignment -name EDA_INPUT_DATA_FORMAT VQM -section_id eda_design_synthesis
    set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim (Verilog)"
    set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
    set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
    set_global_assignment -name EDA_BOARD_DESIGN_TIMING_TOOL "Stamp (Timing)"
    set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
    set_global_assignment -name EDA_OUTPUT_DATA_FORMAT STAMP -section_id eda_board_design_timing
    set_global_assignment -name EDA_BOARD_DESIGN_SYMBOL_TOOL "FPGA Xchange (Symbol)"
    set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
    set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "FPGA XCHANGE" -section_id eda_board_design_symbol
    set_global_assignment -name EDA_BOARD_DESIGN_SIGNAL_INTEGRITY_TOOL "HSPICE (Signal Integrity)"
    set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
    set_global_assignment -name EDA_OUTPUT_DATA_FORMAT HSPICE -section_id eda_board_design_signal_integrity
    set_global_assignment -name EDA_BOARD_DESIGN_BOUNDARY_SCAN_TOOL "BSDL (Boundary Scan)"
    set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
    set_global_assignment -name EDA_OUTPUT_DATA_FORMAT BSDL -section_id eda_board_design_boundary_scan
    set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
    set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
    set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
    set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
    set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
    set_global_assignment -name EDA_MAP_ILLEGAL_CHARACTERS OFF -section_id eda_simulation
    set_global_assignment -name EDA_ENABLE_GLITCH_FILTERING OFF -section_id eda_simulation
    set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS TEST_BENCH_MODE -section_id eda_simulation
    set_global_assignment -name EDA_NATIVELINK_SIMULATION_TEST_BENCH tb__w5300_common_regs_conf_lut -section_id eda_simulation
    set_global_assignment -name EDA_TEST_BENCH_NAME tb__w5300_parallel_if_rw -section_id eda_simulation
    set_global_assignment -name EDA_DESIGN_INSTANCE_NAME NA -section_id tb__w5300_parallel_if_rw
    set_global_assignment -name EDA_TEST_BENCH_MODULE_NAME tb__w5300_parallel_if_rw -section_id tb__w5300_parallel_if_rw
    set_global_assignment -name FLOW_ENABLE_RTL_VIEWER ON
    set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON
    set_global_assignment -name SMART_RECOMPILE ON
    set_global_assignment -name NUM_PARALLEL_PROCESSORS 12
    set_global_assignment -name EDA_TEST_BENCH_FILE testbench/w5300/_rw.v -section_id tb__w5300_parallel_if_rw
    set_global_assignment -name EDA_TEST_BENCH_NAME tb__w5300_common_regs_conf_lut -section_id eda_simulation
    set_global_assignment -name EDA_DESIGN_INSTANCE_NAME NA -section_id tb__w5300_common_regs_conf_lut
    set_global_assignment -name EDA_TEST_BENCH_MODULE_NAME tb__w5300_common_regs_conf_lut -section_id tb__w5300_common_regs_conf_lut
    set_global_assignment -name EDA_TEST_BENCH_FILE testbench/w5300/luts/_common_reg.v -section_id tb__w5300_common_regs_conf_lut
    set_global_assignment -name QIP_FILE ip/ram/udp_buffer.qip
    set_global_assignment -name QIP_FILE ip/pll/pll.qip
    set_global_assignment -name VERILOG_FILE src/w5300/udp.v
    set_global_assignment -name VERILOG_FILE src/w5300/entry.v
    set_global_assignment -name VERILOG_FILE src/top.v
    set_global_assignment -name VERILOG_FILE src/w5300/_rw.v
    set_global_assignment -name VERILOG_FILE src/w5300/if.v
    set_global_assignment -name VERILOG_FILE src/led/led.v
    set_global_assignment -name VERILOG_FILE src/w5300/luts/_common_reg.v
    set_global_assignment -name VERILOG_FILE src/w5300/luts/_socket_reg.v
    set_global_assignment -name VERILOG_FILE testbench/w5300/_rw.v
    set_global_assignment -name VERILOG_FILE testbench/w5300/luts/_common_reg.v
    set_location_assignment PIN_B10 -to addr[9]
    set_location_assignment PIN_C6 -to data[8]
    set_location_assignment PIN_E10 -to leds[0]
    set_location_assignment PIN_F9 -to leds[1]
    set_location_assignment PIN_C9 -to leds[2]
    set_location_assignment PIN_D9 -to leds[3]
    set_location_assignment PIN_E1 -to clk0
    set_location_assignment PIN_N13 -to rst_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to leds[0]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to leds[1]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[9]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to leds[2]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to leds[3]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to leds
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rst_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[11]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk0
    set_location_assignment PIN_M2 -to uart_rxd
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart_rxd
    set_location_assignment PIN_N1 -to uart_txd
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart_txd
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[0]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr[0]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr[1]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr[2]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr[3]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr[4]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr[5]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr[6]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr[7]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr[8]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr[9]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to addr
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cs_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[1]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[2]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[3]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[4]
    set_location_assignment PIN_E9 -to data[14]
    set_location_assignment PIN_D8 -to data[12]
    set_location_assignment PIN_F8 -to data[10]
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
    set_location_assignment PIN_B8 -to addr[5]
    set_location_assignment PIN_B7 -to addr[3]
    set_location_assignment PIN_B6 -to addr[1]
    set_location_assignment PIN_B5 -to we_n
    set_location_assignment PIN_B4 -to cs_n
    set_location_assignment PIN_A9 -to addr[8]
    set_location_assignment PIN_A8 -to addr[6]
    set_location_assignment PIN_A7 -to addr[4]
    set_location_assignment PIN_A6 -to addr[2]
    set_location_assignment PIN_A5 -to addr[0]
    set_location_assignment PIN_A4 -to rd_n
    set_location_assignment PIN_A3 -to int_n
    set_location_assignment PIN_A2 -to rw_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to we_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rw_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rd_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to int_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[5]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[6]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[8]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[7]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[10]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[12]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[13]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[15]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data[14]
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to data
    set_location_assignment PIN_B3 -to wrst_n
    set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to wrst_n
    set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

    # Commit assignments
    export_assignments

    # Close project
    if {$need_to_close_project} {
        project_close
    }
}
