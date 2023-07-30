// testbench for src/tick.sv
// Stephen-Zhang
// 2023-07-30

`timescale 1ns / 10ps

module tb_tick;

  logic rst_n = 1'b1;
  logic clk = 1'b0;

  always #2 clk <= ~clk;

  logic repeatable = 1'b0;
  logic [23:0] threshold = 24'd200;
  logic start, ended, clear;

  ticker tick_tb_inst0 (
      .rst_n(rst_n),
      .clk(clk),
      .repeatable(repeatable),
      .threshold(threshold),
      .start(start),
      .clear(clear),
      .irq(ended)
  );

  initial begin
    #5 rst_n <= 1'b0;
    #5 rst_n <= 1'b1;
    #5 start <= 1'b1;
    @(posedge ended) #10 clear <= 1'b1;
    #1985 $stop;
  end

endmodule
