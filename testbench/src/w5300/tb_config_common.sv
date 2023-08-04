// testbench for src/w5300/if.sv
// Stephen-Zhang
// 2023-08-04

`timescale 1ns / 10ps

module tb_w5300_config_common;

logic clk = 1'b1;
logic rst_n = 1'b1;

always #2 clk = ~clk;

// common config interface
logic [10:0] addr;
logic [15:0] wr_data;
logic enable, done, op_state;

w5300_common_reg_conf w5300_common_reg_conf_inst0(
    .clk(clk),
    .rst_n(rst_n),
    .done(done),
    .addr(addr),
    .wr_data(wr_data),
    .op_state(op_state),
    .enable(enable)
);

initial begin
    #0 begin
        op_state <= 1'b1;
        enable   <= 1'b0;
    end

    #5 rst_n  <= 1'b0;
    #5 rst_n  <= 1'b1;
    #5 enable <= 1'b1;
    #120 $stop;
end

endmodule
