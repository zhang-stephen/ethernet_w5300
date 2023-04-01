// testbench for w5300/_rw.v
// Stephen Zhang
// 2023-03-29

`timescale 1ns/10ps

module tb__w5300_parallel_if_rw();

reg clk = 0;
reg rst = 1;
wire rst_n;
wire cs_n, rd_n, we_n, rw_n, ready;
wire[9:0] io_addr;
wire[15:0] io_data, c_odata;
reg[15:0] c_idata = 16'd0;
reg[10:0] c_addr = 11'd0;

assign rst_n = rst;

initial begin
	#0 begin
	end
	#10 rst <= 1'b0;
	#20 rst <= 1'b1;
	#945 $finish;
end

always #5 clk = ~clk;

always @(posedge ready) begin
	c_addr = c_addr + 2'd2;
	c_addr[10] = ~c_addr[10];
	c_idata = c_idata + 1'b1;
end

_w5300_parallel_if_rw _tb__w5300_parallel_if_rw(
	// physical ports to w5300
	.rst_n(rst_n),
	.clk(clk),
	.data(io_data),
	.addr(io_addr),
	.cs_n(cs_n),
	.rd_n(rd_n),
	.we_n(we_n),
	.rw_n(rw_n),
	
	// logic control ports
	.c_addr(c_addr),
	.c_idata(c_idata),
	.c_odata(c_odata),
	.rw_ready(ready)		// pull down for r/w operation is ongoing
);

endmodule

// EOF