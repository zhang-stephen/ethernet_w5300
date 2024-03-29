// Wiznet W5300 IO module
// Stephen Zhang
// 2023-07-29

module w5300_interface #(
    parameter int CLK_FREQ = 100
)
(
    input logic clk,
    input logic rst_n,

    // physical ports
    output logic w_rst_n,
    output logic cs_n,
    output logic rd_n,
    output logic wr_n,
    output logic [9:0] addr,
    inout tri [15:0] data,

    // control ports
    input  logic [10:0] ctrl_addr,
    input  logic [15:0] ctrl_wr_data,
    output logic [15:0] ctrl_rd_data,
    output logic ctrl_op_state             // 1 for operation Idle
);

import W5300::AddrOperation;
import W5300::WR;
import W5300::RD;
import common::CLK_REF;

enum bit [2:0] {
    PowerOn,
    ResetPhase1,
    ResetPhase2,
    Idle,
    ReadWrite
} state_c, state_n;

// constants
localparam RST_P1_TICKS = 200 * CLK_FREQ / CLK_REF;         // 2us
localparam RST_P2_TICKS = 5000 * CLK_FREQ / CLK_REF;        // 50us
localparam DATA_SETUP_TICKS = 7 * CLK_FREQ / CLK_REF;       // 0.07us

// signals
bit [15:0] data_out;    // bidirectional unpacked
bit [15:0] data_in;

bit [15:0] tick_cnt;  // internal timer
logic tick_cnt_rst_n;
logic rst_p1_cplt;
logic rst_p2_cplt;
logic data_setup_flag;

AddrOperation addr_op;

always_comb begin
    addr_op    <= AddrOperation'(ctrl_addr[10]);
    addr       <= ctrl_addr[9:0];
end

// operation status
assign ctrl_op_state = (state_c == Idle) ? 1'b1 : 1'b0;

// w5300 chip control signals
assign w_rst_n = (state_c == ResetPhase1) ? 1'b0 : 1'b1;
assign cs_n = (state_c == ReadWrite) ? 1'b0 : 1'b1;
assign rd_n = (addr_op == RD) ? 1'b0 : 1'b1;
assign wr_n = (addr_op == WR) ? 1'b0 : 1'b1;

// bidirectional data bus controller
assign data         = !wr_n ? ctrl_wr_data : {16{1'bz}};
assign ctrl_rd_data = !rd_n ? data : 16'h0000;

// internal tick timer controller
always_ff @(posedge clk, negedge rst_n) begin : InternalTickTimer
    if (!rst_n) begin
        tick_cnt <= 16'd0;
    end
    else if (!tick_cnt_rst_n) begin
        tick_cnt <= 16'd0;
    end
    else begin
        tick_cnt <= tick_cnt + 1'b1;
    end
end

assign rst_p1_cplt = (tick_cnt >= RST_P1_TICKS) ? 1'b1 : 1'b0;
assign rst_p2_cplt = (tick_cnt >= RST_P2_TICKS) ? 1'b1 : 1'b0;
assign data_setup_flag = (tick_cnt >= DATA_SETUP_TICKS) ? 1'b1 : 1'b0;

always_comb begin
    case (state_c)
        ResetPhase1: tick_cnt_rst_n = rst_p1_cplt ? 1'b0 : 1'b1;
        ResetPhase2: tick_cnt_rst_n = rst_p2_cplt ? 1'b0 : 1'b1;
        ReadWrite:   tick_cnt_rst_n = data_setup_flag ? 1'b0 : 1'b1;
        default:     tick_cnt_rst_n = 1'b0;
    endcase
end

// W5300 State Machine
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        state_c <= PowerOn;
    else
        state_c <= state_n;
end

always_comb begin
    case (state_c)
        PowerOn:     state_n = ResetPhase1;
        ResetPhase1: state_n = rst_p1_cplt ? ResetPhase2 : ResetPhase1;
        ResetPhase2: state_n = rst_p2_cplt ? Idle : ResetPhase2;
        Idle:        state_n = ReadWrite;
        ReadWrite:   state_n = data_setup_flag ? Idle : ReadWrite;
        default:     state_n = PowerOn;
    endcase
end

endmodule
