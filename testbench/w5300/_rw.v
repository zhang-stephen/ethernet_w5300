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
wire[15:0] io_data, rd_data;
reg[15:0] wr_data = 16'd0;
reg[15:0] io_data_r = 16'd0;
reg[10:0] caddr = 11'd0;

assign rst_n = rst;
assign io_data = caddr[10] ? io_data_r : {16{1'bz}};

_w5300_parallel_if_rw#(.CLK_FREQ(100)) tb__w5300_parallel_if_rw_inst

(
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
    .caddr(caddr),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .rw_ready(ready)        // pull down for r/w operation is ongoing
);

initial begin
    #0 caddr[11] = 1'b1;
    #10 rst <= 1'b0;
    #20 rst <= 1'b1;
    #1200 $finish;
end

always #5 clk = ~clk;

always @(posedge ready) begin
    caddr <= caddr + 2'd2;
    caddr[10] <= ~caddr[10];
    wr_data <= wr_data + 1'b1;
    io_data_r <= {$random} % 65536;
    
//    if (caddr[10] == 1'b1)
//        tb__w5300_parallel_if_rw_inst._data <= {$random} % 65536;
end


endmodule

// EOF
