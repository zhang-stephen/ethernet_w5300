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

logic clk100m, clk200m;
logic eth_tx_req, eth_rx_req;
logic eth_op_state;
logic [BUFFER_ADDR_WIDTH - 1:0] eth_tx_buffer_addr;
logic [BUFFER_ADDR_WIDTH - 1:0] eth_rx_buffer_addr;
logic [15:0] eth_tx_buffer_data, eth_rx_buffer_data;

assign rw_n = wr_n;

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
    .eth_tx_req(1'b1),
    .eth_tx_buffer_addr(eth_tx_buffer_addr),
    .eth_tx_buffer_data(eth_tx_buffer_data),
    .eth_rx_req(eth_rx_req),
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
    .rdaddress(),
    .q()
);

endmodule
