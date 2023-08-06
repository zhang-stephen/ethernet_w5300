// Wiznet W5300 IRQ Handler Module
// Stephen Zhang
// 2023-08-06

`timescale 1ns/10ps

module tb_w5300_irq_handler;

import W5300::*;

logic clk      = 1'b1;
logic rst_n    = 1'b1;
logic int_n    = 1'b1;
logic op_state = 1'b1;

logic wr_rd_flag, ir_occurred, clear;
logic [2 :0] socket;
logic [7 :0] ir_state;
logic [9 :0] addr;
logic [15:0] rd_data, wr_data;

always #2 clk <= ~clk;

w5300_irq_handler dut (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .addr({wr_rd_flag, addr}),
    .rd_data(rd_data),
    .wr_data(wr_data),
    .ir_state(ir_state),
    .socket({ir_occurred, socket}),
    .int_n(int_n),
    .op_state(op_state)
);

initial begin
    rd_data <= 16'd0;

    #5 rst_n <= 1'b0;
    #5 rst_n <= 1'b1;

    // Case 1 IPCF interrupt
    int_n <= 1'b0;
    #5;
    rd_data <= IR_IMR_IPCF;
    #5;
    rd_data <= 16'd0;
    int_n <= 1'b1;
    #10;

    // Case 2 Socket 0 RECV
    int_n <= 1'b0;
    #5;
    rd_data <= 1'b1 << Socket0;
    #5;
    rd_data <= Sn_IR_IMR_RECV;
    int_n <= 1'b1;
    #10;

    // Case 3 Socket 3 SENDOK
    int_n <= 1'b0;
    #5;
    rd_data <= 1'b1 << Socket3;
    #5;
    rd_data <= Sn_IR_IMR_SENDOK;
    int_n <= 1'b1;
    #10;

    // Case 4 Socket 7 CONNECT
    int_n <= 1'b0;
    #5;
    rd_data <= 1'b1 << Socket7;
    #5;
    rd_data <= Sn_IR_IMR_CONNECT;
    int_n <= 1'b1;
    #10;

    $stop;
end

endmodule
