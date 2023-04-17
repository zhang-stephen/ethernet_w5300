// LED status for w5300 debugging
// Stephen Zhang
// 2022-04-13

module led_status(
        input rst_n,
        input clk, // XTAL 50MHz
        input [2:0] err_n,
        output reg [4:0] leds
    );

    localparam MAX_COUNTER = 32'd15_000_000 - 1; // blink period: 300ms for 50MHz

    reg [31:0] _counter;

    always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                begin
                    _counter <= 32'd0;
                    leds[3] <= 1'b0;
                end
            else if (_counter < MAX_COUNTER)
                _counter <= _counter + 32'd1;
            else
                begin
                    _counter <= 32'd0;
                    leds[3] <= !leds[3];
                end
        end

    always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                leds[2:0] <= 3'b000;
            else
                leds[2:0] <= err_n;
        end

endmodule

// EOF
