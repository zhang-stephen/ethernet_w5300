module top(
    // system ports
    input clk0,   // 50MHz XTAL
    input rst_n,  // Reset

    // w5300 ports， without BRDY pins
    inout tri [15:0] data,
    input int_n,
    output [9:0] addr,
    output cs_n,
    output rd_n,
    output wr_n,
    output w_rst_n,
    output rw_n,   // for flip-flop controls

     // UART
    input uart_rxd,
    output uart_txd,

    // LEDs for status
    output [3:0] leds
);

localparam int BUFFER_ADDR_WIDTH = 9;
localparam int COMMAND_SEQ_LEN = 9; // 9 * 16-bit words
localparam logic [15:0] COMMAND_SEQ [9]  = '{3{16'h3031, 16'h3130, 16'h3020}};

enum bit [2:0] {
    Idle,
    Transmit,
    Receive,
    ReadRxBuffer
}state_c, state_n;

logic clk100m, clk200m;
logic eth_tx_req, eth_rx_req;
logic eth_op_state;
logic [BUFFER_ADDR_WIDTH - 1:0] eth_tx_buffer_addr;
logic [BUFFER_ADDR_WIDTH - 1:0] eth_rx_buffer_addr, rx_rd_addr;
logic [15:0] eth_tx_buffer_data, eth_rx_buffer_data, rx_rd_data;
logic command_seq_received;
logic [3:0] rx_rd_cnt;

assign rw_n       = wr_n;
assign eth_tx_req = state_c == Transmit ? 1'b0 : 1'b1;

// w5300 control FSM
always_ff @(posedge clk100m, negedge rst_n) begin
    if (!rst_n) begin
        state_c <= Idle;
    end
    else begin
        state_c <= state_n;
    end
end

always_comb begin
    case (state_c)
        Idle:     state_n = eth_rx_req ? Receive : Idle;
        Receive:  state_n = eth_op_state ? ReadRxBuffer : Receive;
        Transmit: state_n = !eth_op_state ? Idle : Transmit;
        default:  state_n = Idle;
        ReadRxBuffer:
            state_n = rx_rd_cnt == COMMAND_SEQ_LEN ? Transmit : ReadRxBuffer;
        // ReadRxBuffer: begin
        //     if (rx_rd_cnt == COMMAND_SEQ_LEN) begin
        //         state_n = command_seq_received ? Transmit : Idle;
        //     end
        //     else begin
        //         state_n = ReadRxBuffer;
        //     end
        // end
    endcase
end

always_ff @(posedge clk100m, negedge rst_n) begin
    if (!rst_n) begin
        command_seq_received <= 1'b0;
        rx_rd_cnt            <= 4'd0;
        rx_rd_addr           <= {BUFFER_ADDR_WIDTH{1'b0}};
    end
    else begin
        case (state_c)
            Idle: begin
                command_seq_received <= 1'b0;
                rx_rd_cnt            <= 4'd0;
                rx_rd_addr           <= {BUFFER_ADDR_WIDTH{1'b0}};
            end

            ReadRxBuffer: begin
                command_seq_received <= rx_rd_data == COMMAND_SEQ[rx_rd_cnt];
                rx_rd_cnt            <= rx_rd_cnt + 1'b1;
                rx_rd_addr           <= rx_rd_addr + 1'b1;
            end
        endcase
    end
end

// w5300 driver instance
w5300_driver_entry #(
    .ip({8'd192, 8'd168, 8'd22, 8'd111}),
    .port(16'd6588),
    .mac(48'h00_08_dc_ab_cd_ef),
    .subnet(8'd24),
    .CLK_FREQ(100),
    .ETH_TX_BUFFER_WIDTH(BUFFER_ADDR_WIDTH),
    .ETH_RX_BUFFER_WIDTH(BUFFER_ADDR_WIDTH)
) w5300_driver_entry_inst0(
    .clk(clk100m),
    .rst_n(rst_n),
    .w_rst_n(w_rst_n),
    .cs_n(cs_n),
    .rd_n(rd_n),
    .wr_n(wr_n),
    .int_n(int_n),
    .addr(addr),
    .data(data),
    .eth_tx_req(eth_tx_req),
    .eth_tx_bytes(17'd400),
    .eth_tx_buffer_addr(eth_tx_buffer_addr),
    .eth_tx_buffer_data(eth_tx_buffer_data),
    .eth_rx_req(eth_rx_req),
    .eth_rx_bytes(),
    .eth_rx_buffer_addr(eth_rx_buffer_addr),
    .eth_rx_buffer_data(eth_rx_buffer_data),
    .eth_op_state(eth_op_state)
);

// IP cores from Intel Quartus
pll pll_inst0(
    .inclk0(clk0),
    .c0(clk100m),
    .c1(clk200m)    // for Signal Tap Analyzer
);

rom ethernet_tx_buffer(
    .clock(clk100m),
    .address(eth_tx_buffer_addr),
    .q(eth_tx_buffer_data)
);

ram ethernet_rx_buffer(
    .clock(clk100m),
    .wren(eth_rx_req),
    .wraddress(eth_rx_buffer_addr),
    .data(eth_rx_buffer_data),
    .rdaddress(rx_rd_addr),
    .q(rx_rd_data)
);

endmodule
