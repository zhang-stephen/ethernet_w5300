// Wiznet W5300 IO module
// Stephen Zhang
// 2023-07-29

module w5300_interface #(
    parameter byte CLK_FREQ = 100
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
    Write,
    Read
} state_c, state_n;

// constants
localparam RST_P1_TICKS = 200 * CLK_FREQ / CLK_REF;         // 2us
localparam RST_P2_TICKS = 5000 * CLK_FREQ / CLK_REF;        // 50us
localparam DATA_SETUP_TICKS = 5 * CLK_FREQ / CLK_REF;       // 0.05us

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
assign cs_n = (state_c == Read || state_c == Write) ? 1'b0 : 1'b1;
assign rd_n = (state_c == Read) ? 1'b0 : 1'b1;
assign wr_n = (state_c == Write) ? 1'b0 : 1'b1;

// bidirectional data bus controller
assign data         = !wr_n ? data_out : {16{1'bz}};
assign ctrl_rd_data = data_in;

always_ff @(posedge clk, negedge rst_n) begin : DataOut
    if (!rst_n) begin
        data_out <= 16'd0;
    end
    else if (state_c == Write) begin
        data_out <= ctrl_wr_data;
    end
    else begin
        data_out <= 16'd0;
    end
end

always_ff @(posedge clk, negedge rst_n) begin : DataIn
    if (!rst_n) begin
        data_in <= 16'd0;
    end
    else if (state_c == Read) begin
        data_in <= data;
    end
    else begin
        data_in <= 16'd0;
    end
end

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
        ResetPhase1: tick_cnt_rst_n <= rst_p1_cplt ? 1'b0 : 1'b1;
        ResetPhase2: tick_cnt_rst_n <= rst_p2_cplt ? 1'b0 : 1'b1;
        Write:       tick_cnt_rst_n <= data_setup_flag ? 1'b0 : 1'b1;
        Read:        tick_cnt_rst_n <= data_setup_flag ? 1'b0 : 1'b1;
        default:     tick_cnt_rst_n <= 1'b0;
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
        PowerOn:     state_n <= ResetPhase1;
        ResetPhase1: state_n <= rst_p1_cplt ? ResetPhase2 : ResetPhase1;
        ResetPhase2: state_n <= rst_p2_cplt ? Idle : ResetPhase2;
        Idle:        state_n <= addr_op == WR ? Write : Read;
        Write:       state_n <= data_setup_flag ? Idle : Write;
        Read:        state_n <= data_setup_flag ? Idle : Read;
        default:     state_n <= PowerOn;
    endcase
end

endmodule
