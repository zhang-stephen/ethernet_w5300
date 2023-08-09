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
    input  logic [15:0] eth_tx_buffer_data,
    output logic [ETH_TX_BUFFER_WIDTH - 1:0] eth_tx_buffer_addr,
    output logic tx_done,

    output logic [9 :0] addr,
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

localparam TX_CMD_PRE_OP_NUM = 3'd3;
localparam TX_CMD_OP_NUM = 3'd4;

enum bit [2:0]
{
    Idle,
    ReadTxDataSize0,
    ReadTxDataSize1,
    ReadTxBufferFreeSize,
    CheckTxBufferSize,
    WriteFifoReg,
    DoSend
} state_c, state_n;

logic [31:0] tx_data_size;
logic [31:0] tx_buffer_free_size;
logic [31:0] tx_cnt;
logic [2 :0] tx_cmd_cnt;
logic w5300_tx_idle;
logic tx_data_send_all;

assign w5300_tx_idle = tx_buffer_free_size >= tx_data_size;
assign tx_data_send_all = tx_cnt == tx_data_size;

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
        Idle:                 state_n <= eth_tx_req ? ReadTxDataSize0 : Idle;
        ReadTxDataSize0:      state_n <= ReadTxDataSize1;
        ReadTxDataSize1:      state_n <= ReadTxBufferFreeSize;
        ReadTxBufferFreeSize: state_n <= tx_cmd_cnt >= TX_CMD_PRE_OP_NUM ? CheckTxBufferSize : ReadTxBufferFreeSize;
        CheckTxBufferSize:    state_n <= w5300_tx_idle ? WriteFifoReg : ReadTxBufferFreeSize;
        WriteFifoReg:         state_n <= tx_data_send_all ? DoSend : WriteFifoReg;
        DoSend:               state_n <= tx_cmd_cnt >= TX_CMD_OP_NUM ? Idle : DoSend;
        default:              state_n <= Idle;
    endcase
end

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        tx_buffer_free_size <= 32'd0;
        tx_cnt              <= 32'd0;
        tx_cmd_cnt          <= 3'd0;
        tx_done             <= 1'b0;
        eth_tx_buffer_addr  <= {ETH_TX_BUFFER_WIDTH{1'b0}};
    end
    else begin
        case (state_c)
            Idle: begin
                tx_buffer_free_size <= 32'd0;
                tx_cnt              <= 32'd0;
                tx_cmd_cnt          <= 3'd0;
                tx_done             <= 1'b0;
                eth_tx_buffer_addr  <= {ETH_TX_BUFFER_WIDTH{1'b0}};
            end

            ReadTxBufferFreeSize: begin
                case (tx_cmd_cnt)
                    3'd0: tx_buffer_free_size[31:16] <= rd_data;
                    3'd1: tx_buffer_free_size[15: 0] <= rd_data;
                endcase
		        tx_cmd_cnt <= tx_cmd_cnt + (op_state ? 1'b1 : 1'b0);
            end

            WriteFifoReg: begin
                eth_tx_buffer_addr <= eth_tx_buffer_addr + 1'b1;
                tx_cnt             <= tx_cnt + (op_state ? 1'b1 : 1'b0);
            end

            ReadTxDataSize0: eth_tx_buffer_addr <= eth_tx_buffer_addr + 1'b1;
            ReadTxDataSize1: eth_tx_buffer_addr <= eth_tx_buffer_addr + 1'b1;
            CheckTxBufferSize:    tx_cmd_cnt    <= 3'd0;
            DoSend:               tx_cmd_cnt    <= tx_cmd_cnt + (op_state ? 1'b1 : 1'b0);
        endcase
    end
end

always_comb begin
    case (state_c)
        WriteFifoReg: {addr, wr_data} <= {WR, FIFOR, eth_tx_buffer_data};
        default:      {addr, wr_data} <= {RD, 10'h000, 16'h0000};

        ReadTxBufferFreeSize: begin
            case (tx_cmd_cnt)
                3'h0: {addr, wr_data} <= {RD, FSR0, 16'h0000};
                3'h1: {addr, wr_data} <= {RD, FSR2, 16'h0000};
                default:
                    {addr, wr_data} <= {RD, FSR0, 16'h0000};
            endcase
        end


        DoSend: begin
            case (tx_cmd_cnt)
                3'h0: {addr, wr_data} <= {WR, WRSR0, tx_data_size[31:16]};
                3'h1: {addr, wr_data} <= {WR, WRSR2, tx_data_size[15: 0]};
                3'h2: {addr, wr_data} <= {WR, CR, Sn_CR_SEND};
                default:
                    {addr, wr_data} <= {RD, 10'h000, 16'h0000};
            endcase
        end
    endcase
end

always_latch begin
    if (!rst_n) begin
        tx_data_size = 32'd0;
    end
    else if (state_c == ReadTxDataSize0) begin
        tx_data_size[31:16] <= eth_tx_buffer_data;
    end
    else if (state_c == ReadTxDataSize1) begin
        tx_data_size[15: 0] <= eth_tx_buffer_data;
    end
end

endmodule
