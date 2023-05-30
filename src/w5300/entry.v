// W5300 entry module
// Stephen Zhang
// 2023-04-17

module w5300_entry#
    (
        parameter CLK_FREQ = 100,
        parameter TX_BUFFER_ADDR_WIDTH = 12,
        parameter RX_BUFFER_ADDR_WIDTH = 12
    )
    (
        // driver ports
        input rst_n,                                                // module reset
        input clk,                                                  // driver clock, 100MHz in default

        // tx data ports
        input tx_req,                                               // tx request, pull-down to trigger sending
        input [31:0] dest_ip,                                       // destination IPv4
        input [15:0] dest_port,                                     // destination port
        input [31:0] tx_data_size,                                  // data length in bytes to be sent
        input [15:0] tx_data,                                       // data bus of tx buffer
        output [TX_BUFFER_ADDR_WIDTH - 1:0] tx_buffer_addr,         // addr bus of tx buffer

        // rx data ports
        output [15:0] rx_data,                                      // data bus of rx buffer
        output [RX_BUFFER_ADDR_WIDTH - 1:0] rx_buffer_addr,         // addr bus of rx buffer
        output rx_req,                                              // rx request, used to be wr_en to rx buffer or interrupt if data were received

        // control ports
        output [2 :0] err_code,                                     // error code for LEDs
        output busy_n,                                              // w5300 status, high for busy and low for IDLE

        // physical ports
        inout tri [15:0] data,                                      // data bus to w5300 chip
        output [9:0] addr,                                          // addr bus to w5300 chip
        output wrst_n,                                              // reset to w5300 chip
        output cs_n,                                                // chip select to w5300 chip
        output rd_n,                                                // read enable to w5300 chip
        output we_n,                                                // write enable to w5300 chip
        output rw_n,                                                // r/w control to isolation gates(optional)
        input int_n                                                 // interrupt from w5300 chip
    );

    assign wrst_n = rst_n;

    wire [15:0] _wr_data;
    wire [15:0] _rd_data;
    wire [11:0] _caddr;
    wire _op_status;

    w5300_udp_conf_comm#
        (
            .CLK_FREQ(CLK_FREQ),
            .TX_BUFFER_ADDR_WIDTH(TX_BUFFER_ADDR_WIDTH),
            .RX_BUFFER_ADDR_WIDTH(RX_BUFFER_ADDR_WIDTH)
        )
        w5300_udp_conf_comm_inst(
            .rst_n(rst_n),
            .clk(clk),
            .tx_req(tx_req),
            .dest_ip(dest_ip),
            .dest_port(dest_port),
            .tx_data_size(tx_data_size),
            .tx_data(tx_data),
            .tx_buffer_addr(tx_buffer_addr),
            .rx_data(rx_data),
            .rx_buffer_addr(rx_buffer_addr),
            .rx_req(rx_req),
            .err_code(err_code),
            .busy_n(busy_n),
            .op_status(_op_status),
            .rd_data(_rd_data),
            .wr_data(_wr_data),
            .caddr(_caddr),
            .int_n(int_n)
        );

    w5300_parallel_if#
        (
            .CLK_FREQ(CLK_FREQ)
        )
        w5300_parallel_if_inst
        (
            .rst_n(rst_n),
            .clk(clk),
            .op_status(_op_status),
            .uaddr(_caddr),
            .u_wr_data(_wr_data),
            .u_rd_data(_rd_data),
            .data(data),
            .addr(addr),
            .cs_n(cs_n),
            .rd_n(rd_n),
            .we_n(we_n),
            .rw_n(rw_n)
        );

endmodule

// EOF
