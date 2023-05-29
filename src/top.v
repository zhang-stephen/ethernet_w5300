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

        // LEDs for status
        output [3:0] leds
    );

    wire wclk0;
    wire stp_clk;
    wire w5300_busy_n;
    wire [2:0] err_code;

    pll wpll(
            .inclk0(clk0),
            .c0(wclk0),
            .c1(stp_clk)
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
            .TX_BUFFER_ADDR_WIDTH(12),
            .RX_BUFFER_ADDR_WIDTH(12)
        )
        w5300_entry_inst_0(
            .rst_n(rst_n),
            .clk(wclk0),
            .tx_req(),
            .tx_data(),
            .tx_buffer_addr(),
            .rx_data(),
            .rx_buffer_addr(),
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
endmodule

// EOF
