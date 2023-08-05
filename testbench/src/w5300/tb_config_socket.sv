// testbench for src/w5300/config.sv(socket)
// Stephen-Zhang
// 2023-08-05

`timescale 1ns/10ps

module tb_w5300_config_socket;

import W5300::*;

logic clk      = 1'b1;
logic rst_n    = 1'b1;
logic enable   = 1'b0;
logic op_state = 1'b1;

logic done;
logic wr_rd_flag;
logic [9:0] addr;
logic [15:0] wr_data;
logic [15:0] rd_data;

always #2 clk <= ~clk;

w5300_socket_n_tcp_server_conf dut (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .op_state(op_state),
    .done(done),
    .addr({wr_rd_flag, addr}),
    .wr_data(wr_data),
    .rd_data(rd_data)
);

// 初始化
initial begin
    rd_data <= 16'd0;

    #5 rst_n <= 1'b0;
    #5 rst_n <= 1'b1;

    // Case 1: Initial
    #10;

    // Case 2: InitTcpParams
    enable = 1;
    #10;

    // Case 3: WaitSockInit
    #600;   // Timeout, go back to Initial

    // Case 4: WaitSockInit (2nd time)
    rd_data <= Sn_SSR_SOCK_INIT;
    #10;

    // Case 5: WaitListen
    rd_data <= Sn_SSR_SOCK_LISTEN;


    #30 $stop;
end

endmodule
