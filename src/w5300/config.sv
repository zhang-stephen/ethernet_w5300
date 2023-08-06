// Wiznet W5300 Register Configuration Module
// Stephen Zhang
// 2023-07-29

module w5300_common_reg_conf #(
    parameter logic [31:0] ip     = {8'd192, 8'd168, 8'd1, 8'd15},
    parameter logic [47:0] mac    = 48'h0_08_dc_01_02_03,
    parameter logic [7 :0] subnet = 24
)
(
    input  logic clk,
    input  logic rst_n,

    output logic done,
    output logic [10:0] addr,
    output logic [15:0] wr_data,
    input  logic op_state,
    input  logic enable
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
    if (!rst_n) begin
        state_n <= Initial;
    end
    else begin
        case (state_c)
            Initial:   state_n <= enable ? Operating : Initial;
            Operating: state_n <= op_cnt == NUM_OF_OPERATIONS ? Done : Operating;
            Done:      state_n <= Done;
            default:   state_n <= Initial;
        endcase
    end
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
        4'h9: {addr, wr_data} <= {WR, RTR, 16'hfa0};         // 400ms = 0x0fa0 * 100us
        4'ha: {addr, wr_data} <= {WR, RCR, 16'd7};           // retransmission count = 8 = RCR + 1
        4'hb: {addr, wr_data} <= {WR, TMS01R, {8'd8, 8'd0}}; // socket 0 Tx buffer: 8kB
        4'hc: {addr, wr_data} <= {WR, RMS01R, {8'd4, 8'd0}}; // socket 0 Rx buffer: 4kB
        default:
            {addr, wr_data} <= {RD, 10'h00, 16'h000};
    endcase
end

endmodule

module w5300_socket_n_tcp_server_conf #(
    parameter int      N    = 0,
    parameter shortint port = 7000
)
(
    input logic clk,
    input logic rst_n,

    output logic done,
    output logic [10:0] addr,
    output logic [15:0] wr_data,
    input  logic [15:0] rd_data,
    input  logic op_state,
    input  logic enable
);

import W5300::*;

enum bit [3:0]
{
    Initial,
    InitTcpParams,
    WaitSockInit,
    Listen,
    WaitListen,
    SocketClose,
    Done
} state_c, state_n;

localparam MR    = get_socket_n_reg(.baseAddr(Sn_MR), .socketN(N));
localparam CR    = get_socket_n_reg(.baseAddr(Sn_CR), .socketN(N));
localparam IMR   = get_socket_n_reg(.baseAddr(Sn_IMR), .socketN(N));
localparam SSR   = get_socket_n_reg(.baseAddr(Sn_SSR), .socketN(N));
localparam PORTR = get_socket_n_reg(.baseAddr(Sn_PORTR), .socketN(N));
localparam KPALVTR_PROTOR = get_socket_n_reg(.baseAddr(Sn_KPALVTR_PROTOR), .socketN(N));
localparam OP_CNT         = 4'd6;
localparam OP_TIMEOUT     = 16'd100;

logic [3 :0] init_tcp_op_cnt;
logic [15:0] tick_cnt;              // Wait SSR timeout
logic tick_cnt_rst_n;
logic tick_overflow_flag;

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state_c <= Initial;
    end
    else begin
        state_c <= state_n;
    end
end

always_comb begin
    if (!rst_n) begin
        state_n <= Initial;
    end
    else begin
        case (state_c)
            Initial:       state_n <= (enable & op_state) ? InitTcpParams : Initial;
            InitTcpParams: state_n <= (init_tcp_op_cnt == OP_CNT) ? WaitSockInit : InitTcpParams;
            Listen:        state_n <= op_state ? WaitListen : Listen;
            SocketClose:   state_n <= op_state ? InitTcpParams : SocketClose;
            Done:          state_n <= Done;
            default:       state_n <= Initial;

            WaitSockInit : begin
                if (tick_overflow_flag) begin
                    state_n <= SocketClose;
                end
                else begin
                    state_n <= (rd_data[7:0] == Sn_SSR_SOCK_INIT[7:0]) ? Listen : WaitSockInit;
                end
            end

            WaitListen: begin
                if (tick_overflow_flag) begin
                    state_n <= SocketClose;
                end
                else begin
                    state_n <= (rd_data[7:0] == Sn_SSR_SOCK_LISTEN[7:0]) ? Done : WaitListen;
                end
            end

        endcase
    end
end

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        {done, init_tcp_op_cnt} <= 5'd0;
    end
    else begin
        case (state_c)
            InitTcpParams: init_tcp_op_cnt         <= init_tcp_op_cnt + (op_state ? 1'b1 : 1'b0);
            Done:          done                    <= 1'b1;
            default:       {done, init_tcp_op_cnt} <= 5'd0;
        endcase
    end
end

always_comb begin : BusLookUpTable
    case (state_c)
        InitTcpParams: begin
            case (init_tcp_op_cnt)
                4'd0: {addr, wr_data} <= {WR, MR, Sn_MR_P_TCP};
                4'd1: {addr, wr_data} <= {WR, PORTR, port};
                4'd2: {addr, wr_data} <= {WR, IMR, Sn_IR_IMR_SENDOK |
                                                   Sn_IR_IMR_TIMEOUT |
                                                   Sn_IR_IMR_RECV |
                                                   Sn_IR_IMR_DISCONNECT |
                                                   Sn_IR_IMR_CONNECT};
                4'd3: {addr, wr_data} <= {WR, KPALVTR_PROTOR, {8'd1, 8'd1}}; // KPALVTR = 1, Keep Alive Packet trasmission per 5s * KPLVTR
                4'd4: {addr, wr_data} <= {WR, CR, Sn_CR_OPEN};
                default:
                    {addr, wr_data} <= {RD, 10'h000, 16'd0};
            endcase
        end

        WaitListen:   {addr, wr_data} <= {RD, SSR, 16'd0};
        WaitSockInit: {addr, wr_data} <= {RD, SSR, 16'd0};
        Listen:       {addr, wr_data} <= {WR, CR, Sn_CR_LISTEN};
        SocketClose:  {addr, wr_data} <= {WR, CR, Sn_CR_CLOSE};
        default:
            {addr, wr_data} <= {RD, 10'h000, 16'd0};
    endcase
end

// internal tick timer controller
assign tick_overflow_flag = (tick_cnt >= OP_TIMEOUT) ? 1'b1 : 1'b0;

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

always_comb begin
    case (state_c)
        WaitSockInit: tick_cnt_rst_n <= tick_overflow_flag ? 1'b0 : 1'b1;
        WaitListen:   tick_cnt_rst_n <= tick_overflow_flag ? 1'b0 : 1'b1;
        default:      tick_cnt_rst_n <= 1'b0;
    endcase
end

endmodule
