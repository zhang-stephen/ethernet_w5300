// w5300 transmit module
// Stephen Zhang
// 2023-08-09

module w5300_transmitter #(
    parameter logic [2:0] N = 0,
    parameter int ETH_TX_BUFFER_WIDTH = 16
)(
    input logic clk,
    input logic rst_n,

    input  logic eth_tx_req,
    input  logic [16:0] eth_tx_bytes,    // in bytes
    input  logic [15:0] eth_tx_buffer_data,
    output logic [ETH_TX_BUFFER_WIDTH - 1:0] eth_tx_buffer_addr,
    output logic tx_done,

    output logic [10:0] addr,
    output logic [15:0] wr_data,
    input  logic [15:0] rd_data,
    input  logic op_state
);

import W5300::*;

localparam CR    = get_socket_n_reg(Sn_CR, N);
localparam FSR0  = get_socket_n_reg(Sn_TX_FSR0, N);
localparam FSR2  = get_socket_n_reg(Sn_TX_FSR2, N);
localparam WRSR0 = get_socket_n_reg(Sn_TX_WRSR0, N);
localparam WRSR2 = get_socket_n_reg(Sn_TX_WRSR2, N);
localparam FIFOR = get_socket_n_reg(Sn_TX_FIFOR, N);

localparam TX_CMD_PRE_OP_NUM = 3'd2;
localparam TX_CMD_OP_NUM = 3'd4;

enum bit [2:0]
{
    Idle,
    ReadTxBufferFreeSize,
    CheckTxBufferSize,
    WaitRwOpReady,
    WriteFifoReg,
    DoSend,
    PostSend
} state_c, state_n;

logic [17:0] tx_data_size;
logic [17:0] tx_buffer_free_size;
logic [17:0] tx_cnt;
logic [2 :0] tx_cmd_cnt;
logic w5300_tx_idle;
logic tx_data_send_all;
logic is_tx_bytes_odd;

assign is_tx_bytes_odd  = eth_tx_bytes & 1'b1;
assign tx_data_size     = (eth_tx_bytes + is_tx_bytes_odd) >> 1; // in 16-bit words
assign w5300_tx_idle    = tx_buffer_free_size >= eth_tx_bytes;
assign tx_data_send_all = tx_cnt == tx_data_size;
assign tx_done          = state_c == PostSend ? 1'b1 : 1'b0;

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state_c <= Idle;
    end
    else begin
        state_c <= state_n;
    end
end

always_comb begin
    case (state_c)
        Idle:                 state_n = !eth_tx_req ? ReadTxBufferFreeSize : Idle;
        ReadTxBufferFreeSize: state_n = tx_cmd_cnt >= TX_CMD_PRE_OP_NUM ? CheckTxBufferSize : ReadTxBufferFreeSize;
        CheckTxBufferSize:    state_n = w5300_tx_idle ? WaitRwOpReady : ReadTxBufferFreeSize;
        WaitRwOpReady:        state_n = op_state ? WriteFifoReg : WaitRwOpReady;
        WriteFifoReg:         state_n = tx_data_send_all ? DoSend : WriteFifoReg;
        DoSend:               state_n = tx_cmd_cnt >= TX_CMD_OP_NUM && op_state ? PostSend : DoSend;
        default:              state_n = Idle;
    endcase
end

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        tx_buffer_free_size <= 17'd0;
        tx_cnt              <= 17'd0;
        tx_cmd_cnt          <= 3'd0;
        eth_tx_buffer_addr  <= {ETH_TX_BUFFER_WIDTH{1'b0}};
    end
    else begin
        case (state_c)
            Idle: begin
                tx_buffer_free_size <= 17'd0;
                tx_cnt              <= 17'd0;
                tx_cmd_cnt          <= 3'd0;
                eth_tx_buffer_addr  <= {ETH_TX_BUFFER_WIDTH{1'b0}};
            end

            ReadTxBufferFreeSize: begin
                case (tx_cmd_cnt)
                    3'd0: tx_buffer_free_size[16]    <= rd_data[0];
                    3'd1: tx_buffer_free_size[15: 0] <= rd_data;
                endcase
		        tx_cmd_cnt <= tx_cmd_cnt + (op_state ? 1'b1 : 1'b0);
            end

            WriteFifoReg: begin
                eth_tx_buffer_addr <= eth_tx_buffer_addr + (op_state ? 1'b1 : 1'b0);
                tx_cnt             <= tx_cnt + (op_state ? 1'b1 : 1'b0);
            end

            CheckTxBufferSize:    tx_cmd_cnt    <= 3'd0;
            DoSend:               tx_cmd_cnt    <= tx_cmd_cnt + (op_state ? 1'b1 : 1'b0);
            PostSend:             eth_tx_buffer_addr  <= {ETH_TX_BUFFER_WIDTH{1'b0}};
        endcase
    end
end

always_comb begin
    case (state_c)
        WriteFifoReg: {addr, wr_data} = {WR, FIFOR, eth_tx_buffer_data};
        default:      {addr, wr_data} = {RD, 10'h3fe, 16'h0000};

        ReadTxBufferFreeSize: begin
            case (tx_cmd_cnt)
                3'h0: {addr, wr_data} = {RD, FSR0, 16'h0000};
                3'h1: {addr, wr_data} = {RD, FSR2, 16'h0000};
                default:
                    {addr, wr_data} = {RD, 10'h3fe, 16'h0000};
            endcase
        end

        DoSend: begin
            case (tx_cmd_cnt)
                3'h0: {addr, wr_data} = {WR, WRSR0, 15'd0, eth_tx_bytes[16]};
                3'h1: {addr, wr_data} = {WR, WRSR2, eth_tx_bytes[15: 0]};
                3'h2: {addr, wr_data} = {WR, CR, Sn_CR_SEND};
                default:
                    {addr, wr_data} = {RD, 10'h3fe, 16'h0000};
            endcase
        end
    endcase
end

endmodule
