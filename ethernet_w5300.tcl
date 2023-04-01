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
# Generated on: Tue Mar 28 02:55:33 2023

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
	set_global_assignment -name TOP_LEVEL_ENTITY top
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
	set_global_assignment -name EDA_SIMULATION_TOOL "Questa Intel FPGA (Verilog)"
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
	set_global_assignment -name VERILOG_FILE src/top.v
	set_global_assignment -name QIP_FILE ip/pll.qip
	set_global_assignment -name VERILOG_FILE src/w5300/_rw.v
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Including default assignments
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON -family "Cyclone IV E"
	set_global_assignment -name TIMING_ANALYZER_REPORT_WORST_CASE_TIMING_PATHS ON -family "Cyclone IV E"
	set_global_assignment -name TIMING_ANALYZER_CCPP_TRADEOFF_TOLERANCE 0 -family "Cyclone IV E"
	set_global_assignment -name TDC_CCPP_TRADEOFF_TOLERANCE 0 -family "Cyclone IV E"
	set_global_assignment -name TIMING_ANALYZER_DO_CCPP_REMOVAL ON -family "Cyclone IV E"
	set_global_assignment -name DISABLE_LEGACY_TIMING_ANALYZER OFF -family "Cyclone IV E"
	set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON -family "Cyclone IV E"
	set_global_assignment -name SYNCHRONIZATION_REGISTER_CHAIN_LENGTH 2 -family "Cyclone IV E"
	set_global_assignment -name SYNTH_RESOURCE_AWARE_INFERENCE_FOR_BLOCK_RAM ON -family "Cyclone IV E"
	set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS" -family "Cyclone IV E"
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON -family "Cyclone IV E"
	set_global_assignment -name AUTO_DELAY_CHAINS ON -family "Cyclone IV E"
	set_global_assignment -name CRC_ERROR_OPEN_DRAIN OFF -family "Cyclone IV E"
	set_global_assignment -name USE_CONFIGURATION_DEVICE OFF -family "Cyclone IV E"
	set_global_assignment -name ENABLE_OCT_DONE OFF -family "Cyclone IV E"

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
