// testbench for src/w5300/if.sv
// Stephen-Zhang
// 2023-07-31

`timescale 1ns / 10ps

typedef struct {
    logic rst_n;
    logic cs_n;
    logic wr_n;
    logic rd_n;
    logic [9 :0] addr;
} w5300_physical_ports;


typedef struct {
    logic [10:0] addr;
    logic [15:0] wr_data;
    logic [15:0] rd_data;
    logic op_state;
} w5300_if_ctrl_ports;

module tb_w5300_if;

import W5300::AddrOperation;
import W5300::WR;
import W5300::RD;

logic clk = 1'b1;
logic rst_n = 1'b1;
tri [15:0] data;

always #2 clk = ~clk;

w5300_physical_ports phy;
w5300_if_ctrl_ports ctrl;

w5300_interface w5300_if_inst0(
    .clk(clk),
    .rst_n(rst_n),
    .w_rst_n(phy.rst_n),
    .cs_n(phy.cs_n),
    .rd_n(phy.rd_n),
    .wr_n(phy.wr_n),
    .addr(phy.addr),
    .data(data),
    .ctrl_addr(ctrl.addr),
    .ctrl_wr_data(ctrl.wr_data),
    .ctrl_rd_data(ctrl.rd_data), 
    .ctrl_op_state(ctrl.op_state)
);

initial begin
    #0 begin
        ctrl.addr    <= 10'd0;
        ctrl.wr_data <= 16'd0;
    end
    #5     rst_n <= 1'b0;
    #10    rst_n <= 1'b1;

    #1985 $stop;
end

always @(posedge ctrl.op_state) begin
    ctrl.addr     <= ctrl.addr + 2'b10;
    ctrl.addr[10] <= ~ctrl.addr[10];    // RD/WR switching
    ctrl.wr_data  <= ctrl.wr_data + 1'b1;

    if (ctrl.addr[10] == RD) begin
        w5300_if_inst0.data_in <= {$random} % (1 << 16 - 1);
    end
end

endmodule
