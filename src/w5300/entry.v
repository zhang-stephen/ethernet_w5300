// W5300 top module
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
        input rst_n,
        input clk,

        // tx data ports
        input tx_req,
        input [31:0] dest_ip,
        input [15:0] dest_port,
        input [31:0] tx_data_size,
        input [15:0] tx_data,
        output [TX_BUFFER_ADDR_WIDTH - 1:0] tx_buffer_addr,

        // rx data ports
        output [15:0] rx_data,
        output [RX_BUFFER_ADDR_WIDTH - 1:0] rx_buffer_addr,
        output rx_req,

        // control ports
        output [2 :0] err_code,
        output busy_n,

        // physical ports
        inout tri [15:0] data,
        output [9:0] addr,
        output wrst_n,
        output cs_n,
        output rd_n,
        output we_n,
        output rw_n,
        input int_n
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
