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

    localparam BUFFER_WIDTH = 8'h08;
    localparam MAX_COUNTER = 32'd25_000_000 - 1; // 150ms for 100MHz
    
    wire wclk0;
    wire stp_clk;
    wire w5300_busy_n;
    wire [2:0] err_code;
    wire [BUFFER_WIDTH - 1:0] tx_buffer_addr;
    wire [15:0] tx_buffer_data;
    
    reg tx_req = 1'b0;
    reg [31:0] _counter;

    always @(posedge wclk0 or negedge rst_n)
        begin
            if (!rst_n)
                begin
                    _counter <= 32'd0;
                    tx_req <= 1'b1;
                end
            else 
                if (_counter < MAX_COUNTER)
                    begin
                        _counter <= _counter + 32'd1;
                        tx_req <= 1'b1;
                    end
                else
                    begin
                        _counter <= 32'd0;
                        tx_req <= 1'b0; // trigger w5300 sending
                    end
        end

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
               
    ram_1port ram_1port_inst0(
        .address(tx_buffer_addr),
        .clock(wclk0),
        .data(),
        .wren(),
        .q(tx_buffer_data)
    );

    w5300_entry#
        (
            .CLK_FREQ(100),
            .TX_BUFFER_ADDR_WIDTH(BUFFER_WIDTH),
            .RX_BUFFER_ADDR_WIDTH(BUFFER_WIDTH)
        )
        w5300_entry_inst_0(
            .rst_n(rst_n),
            .clk(wclk0),
            .tx_req(tx_req),
            .dest_ip({8'd192, 8'd168, 8'd111, 8'd1}),
            .dest_port(16'd7000),
            .tx_data_size(32'd400),
            .tx_data(tx_buffer_data),
            .tx_buffer_addr(tx_buffer_addr),
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
