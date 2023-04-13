// LED status for w5300 debugging
// Stephen Zhang
// 2022-04-13

module led_status(
        input rst_n,
        input clk, // XTAL 50MHz
        input [2:0] err_n,
        output reg [4:0] leds
    );

    localparam MAX_COUNTER = 32'd25_000_000 - 1;

    reg [31:0] _counter;

    always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                begin
                    _counter <= 32'd0;
                    leds[0] <= 1'b0;
                end
            else if (_counter < MAX_COUNTER)
                _counter <= _counter + 32'd1;
            else
                begin
                    _counter <= 32'd0;
                    leds[0] <= !leds[0];
                end
        end

    always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                leds[3:1] <= 4'd0;
            else
                leds[3:1] <= err_n;
        end

endmodule

// EOF
