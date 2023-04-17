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

    wire wclk0;

    pll wpll(
            .inclk0(clk0),
            .c0(wclk0)
        );

    led_status led_status_0(
                   .rst_n(rst_n),
                   .clk(clk0),
                   .err_n(),
                   .leds(leds)
               );


    w5300_parallel_if w5300_parallel_if_0(
                          .rst_n(rst_n),
                          .clk(wclk0),
                          .data(data),
                          .addr(addr),
                          .cs_n(cs_n),
                          .rd_n(rd_n),
                          .we_n(we_n),
                          .rw_n(rw_n)
                      );

    assign wrst_n = rst_n;

endmodule

// EOF
