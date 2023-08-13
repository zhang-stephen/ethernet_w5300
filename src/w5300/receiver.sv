// w5300 receiver module
// Stephen Zhang
// 2023-08-12

module w5300_receiver #(
    parameter logic [2:0] N = 0,
    parameter int ETH_RX_BUFFER_WIDTH = 16
)(
    input  logic clk,
    input  logic rst_n,

    input  logic rx_irq,
    output logic eth_rx_req,
    output logic [15:0] eth_rx_buffer_data,
    output logic [ETH_RX_BUFFER_WIDTH - 1:0] eth_rx_buffer_addr,
    output logic rx_done,

    output logic [10:0] addr,
    output logic [15:0] wr_data,
    input  logic [15:0] rd_data,
    input  logic op_state
);

import W5300::*;

localparam CR    = get_socket_n_reg(Sn_CR, N);
localparam RSR0  = get_socket_n_reg(Sn_RX_RSR0, N);
localparam RSR2  = get_socket_n_reg(Sn_RX_RSR2, N);
localparam FIFOR = get_socket_n_reg(Sn_RX_FIFOR, N);

enum bit [2:0] {
    Idle,
    ReadRxDataSize, // Read the RX_FIFOR
    CalcRxReadTimes,
    ReadRxFifoReg,
    DoRecv,
    PostRecv
}state_c, state_n;

logic [15:0] rx_data_size_in_bytes;
logic [15:0] rx_data_size_in_16b;
logic [15:0] rx_cnt;
logic is_rx_bytes_odd;

assign is_rx_bytes_odd    = rx_data_size_in_bytes & 16'h0001;
assign eth_rx_req         = (state_c == ReadRxFifoReg) ? 1'b1 : 1'b0;
assign eth_rx_buffer_data = rd_data;
assign rx_done            = state_c == PostRecv;

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
        Idle:            state_n = (rx_irq && op_state) ? ReadRxDataSize : Idle;
        ReadRxDataSize:  state_n = op_state ? CalcRxReadTimes : ReadRxDataSize;
        CalcRxReadTimes: state_n = ReadRxFifoReg;
        ReadRxFifoReg:   state_n = (rx_cnt == rx_data_size_in_16b) ? DoRecv : ReadRxFifoReg;
        DoRecv:          state_n = op_state ? PostRecv : DoRecv;
        default:         state_n = Idle;
    endcase
end

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        {rx_data_size_in_bytes, rx_data_size_in_16b, rx_cnt} <= 48'd0;
        eth_rx_buffer_addr <= {ETH_RX_BUFFER_WIDTH{1'b0}};
    end
    else begin
        case (state_c)
            ReadRxDataSize:  rx_data_size_in_bytes <= rd_data;
            CalcRxReadTimes: rx_data_size_in_16b   <= (rx_data_size_in_bytes + is_rx_bytes_odd) >> 1;
            Idle:            begin
                {rx_data_size_in_bytes, rx_data_size_in_16b, rx_cnt} <= 48'd0;
                eth_rx_buffer_addr <= {ETH_RX_BUFFER_WIDTH{1'b0}};
            end
            ReadRxFifoReg: begin
                eth_rx_buffer_addr <= eth_rx_buffer_addr + (op_state ? 1'b1 : 1'b0);
                rx_cnt             <= rx_cnt + (op_state ? 1'b1 : 1'b0);
            end
        endcase
    end

end

always_comb begin
    case (state_c)
        ReadRxFifoReg, ReadRxDataSize:
        // if Sn_MR_ALIGN not configured, the Rx data size should be read from Sn_RX_FIFOR
            {addr, wr_data} = {RD, FIFOR, 16'h0000};
        DoRecv:
            {addr, wr_data} = {WR, CR, Sn_CR_RECEIVE};
        default:
            {addr, wr_data} = {RD, 16'h3fe, 16'h0000};
    endcase
end

endmodule
