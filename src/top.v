// top module of example driver for w5300
// Stephen Zhang
// 2023-03-28

module top(
	// system ports
	input clk0,   // 50MHz XTAL
	input rst_n,  // Reset
	
	// w5300 ports
	// without BRDY support
	inout tri [15:0] data,
	input int_n,
	output [9:0] addr,
	output cs_n,
	output rd_n,
	output we_n,
	output reset_n,
	output rw_n   // for flip-flop controls
);

wire wclk0;

pll wpll(
	.inclk0(clk0),
	.c0(wclk0)
);

_w5300_parallel_if_rw rw();

endmodule

// EOF