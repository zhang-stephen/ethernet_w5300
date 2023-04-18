// top module of example driver for w5300
// Stephen Zhang
// 2023-03-28

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
        output we_n,
        output wrst_n,
        output rw_n,   // for flip-flop controls

        // UART for debugging
        input  uart_rxd,
        output uart_txd,

        // LEDs for status
        output [3:0] leds
    );

    localparam UDP_BUFFER_ADDR_WIDTH = 12;
    localparam UDP_BUFFER_DATA_WIDTH = 12;
    localparam S_W5300_INIT = 4'd0, S_W5300_IDLE = 4'd1, S_W5300_BUSY = 4'd2;

    reg tx_req;
    reg [3:0] state_c;
    reg [3:0] state_n;

    wire wclk0;
    wire w5300_busy_n;
    wire rx_req;
    wire [2:0] err_code;
    wire [UDP_BUFFER_ADDR_WIDTH - 1:0] w5300_tx_addr;
    wire [UDP_BUFFER_DATA_WIDTH - 1:0] w5300_tx_data;
    wire [UDP_BUFFER_ADDR_WIDTH - 1:0] w5300_conf_rom_addr;
    wire [UDP_BUFFER_DATA_WIDTH - 1:0] w5300_conf_rom_data;
    wire [UDP_BUFFER_ADDR_WIDTH - 1:0] udp_tx_buffer_addr;
    wire [UDP_BUFFER_DATA_WIDTH - 1:0] udp_tx_buffer_data;
    wire [UDP_BUFFER_ADDR_WIDTH - 1:0] udp_rx_buffer_addr;
    wire [UDP_BUFFER_DATA_WIDTH - 1:0] udp_rx_buffer_data;

    assign w5300_tx_addr = (state_c != S_W5300_INIT) ? udp_tx_buffer_addr : w5300_conf_rom_addr;
    assign w5300_tx_data = (state_c != S_W5300_INIT) ? udp_tx_buffer_data : w5300_conf_rom_data;
    assign uart_txd = 1'b0;

    always @(posedge wclk0 or negedge rst_n)
        if (!rst_n)
            state_c <= S_W5300_INIT;
        else
            state_c <= state_n;

    always @*
        if (!rst_n)
            state_n <= S_W5300_INIT;
        else
            case(state_c)
                S_W5300_INIT:
                    state_n <= (w5300_busy_n == 1'b1) ? S_W5300_IDLE : S_W5300_INIT;
                S_W5300_IDLE:
                    state_n <= (tx_req == 1'b1) ? S_W5300_BUSY : S_W5300_IDLE;
                S_W5300_BUSY:
                    state_n <= (w5300_busy_n == 1'b1) ? S_W5300_IDLE : S_W5300_BUSY;
                default:
                    state_n <= S_W5300_IDLE;
            endcase

    // TODO: 3-stage FSM, the sequential output to be finished!
    always @(posedge wclk0 or negedge rst_n)
        if (!rst_n)
            tx_req <= 1'b0;
        else
            case(state_c)
                S_W5300_IDLE:
                    ;
            endcase


    pll wpll(
            .inclk0(clk0),
            .c0(wclk0)
        );

    led_status led_status_0(
                   .rst_n(rst_n),
                   .clk(clk0),
                   .err_n(err_code),
                   .leds(leds)
               );


    w5300_entry#
        (
            .CLK_FREQ(100),
            .TX_BUFFER_ADDR_WIDTH(UDP_BUFFER_ADDR_WIDTH),
            .RX_BUFFER_ADDR_WIDTH(UDP_BUFFER_ADDR_WIDTH)
        )
        w5300_entry_inst_0(
            .rst_n(rst_n),
            .clk(wclk0),
            .tx_req(tx_req),
            .tx_data(w5300_tx_data),
            .tx_buffer_addr(w5300_tx_addr),
            .rx_data(udp_rx_buffer_data),
            .rx_buffer_addr(udp_rx_buffer_addr),
            .rx_req(rx_req),
            .err_code(err_code),
            .busy_n(w5300_busy_n),
            .data(data),
            .addr(addr),
            .wrst_n(wrst_n),
            .cs_n(cs_n),
            .rd_n(rd_n),
            .we_n(we_n),
            .rw_n(rw_n),
            .int_n(int_n)
        );

    udp_buffer w5300_udp_tx_buffer_inst(
                   .address(udp_tx_buffer_addr),
                   .clock(wclk0),
                   .data(),
                   .wren(),
                   .q(udp_tx_buffer_data)
               );

    udp_buffer w5300_udp_rx_buffer_inst(
                   .address(udp_rx_buffer_addr),
                   .clock(wclk0),
                   .data(udp_rx_buffer_data),
                   .wren(!rx_req),
                   .q()
               );
endmodule

// EOF
