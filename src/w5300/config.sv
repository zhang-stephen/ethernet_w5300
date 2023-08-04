// Wiznet W5300 Register Configuration Module
// Stephen Zhang
// 2023-07-29

module w5300_common_reg_conf #(
    parameter logic [31:0] ip     = {8'd192, 8'd168, 8'd1, 8'd15},
    parameter logic [47:0] mac    = 48'h0_08_dc_01_02_03,
    parameter logic [7 :0] subnet = 24
)
(
    input clk,
    input rst_n,

    output logic done,
    output logic [10:0] addr,
    output logic [15:0] wr_data,
    input logic op_state,
    input logic enable
);

import W5300::*;
import network::*;

localparam NUM_OF_OPERATIONS = 8'd14;
localparam GATEWAY = calc_gateway(ip);
localparam SUBNET  = {32{1'b1}} ^ {(32 - subnet){1'b1}};

enum bit[2:0] {
    Initial,
    Operating,
    Done
}state_c, state_n;

logic [3:0] op_cnt;

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state_c <= Initial;
    end
    else begin
        state_c <= state_n;
    end
end

always_comb begin
    case (state_c)
        Initial:   state_n <= (enable & op_state) ? Operating : Initial;
        Operating: state_n <= op_cnt == NUM_OF_OPERATIONS ? Done : Operating;
        Done:      state_n <= Done;
        default:   state_n <= Initial;
    endcase
end

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        done   <= 1'b0;
        op_cnt <= 4'd0;
    end
    else begin
        case (state_c)
            Operating: op_cnt         <= op_cnt + (op_state ? 1'b1 : 1'b0);
            Done:      {done, op_cnt} <= {1'b1, 4'd0};
            default:   {done, op_cnt} <= 5'd0;
        endcase
    end
end

always_comb begin : CommonRegisters
    case (op_cnt)
        4'h0: {addr, wr_data} <= {WR, MR, MR_DBW | MR_WDF};
        4'h1: {addr, wr_data} <= {WR, IMR, IR_IMR_IPCF | IR_IMR_DPUR | IR_IMR_S0};
        4'h2: {addr, wr_data} <= {WR, SHAR0, mac[47:32]};
        4'h3: {addr, wr_data} <= {WR, SHAR2, mac[31:16]};
        4'h4: {addr, wr_data} <= {WR, SHAR4, mac[15: 0]};
        4'h5: {addr, wr_data} <= {WR, SUBR0, SUBNET[31:16]};
        4'h6: {addr, wr_data} <= {WR, SUBR2, SUBNET[15: 0]};
        4'h7: {addr, wr_data} <= {WR, SIPR0, ip[31:16]};
        4'h8: {addr, wr_data} <= {WR, SIPR2, ip[15: 0]};
        4'h9: {addr, wr_data} <= {WR, RTR, 16'hfa0};        // 400ms = 0x0fa0 * 100us
        4'ha: {addr, wr_data} <= {WR, RCR, 16'd7};           // retransmission count = 8 = RCR + 1
        4'hb: {addr, wr_data} <= {WR, TMS01R, {8'd8, 8'd0}}; // socket 0 Tx buffer: 8kB
        4'hc: {addr, wr_data} <= {WR, RMS01R, {8'd4, 8'd0}}; // socket 0 Rx buffer: 4kB
        default:
            {addr, wr_data} <= {RD, 10'h00, 16'h000};
    endcase
end

endmodule

module w5300_socket_n_reg_conf#(parameter int N = 0)
(

);

endmodule
