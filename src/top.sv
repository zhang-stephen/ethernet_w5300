module top(
    input clk,
    input rst_n,

    output logic [3:0] leds
);

always_ff @(posedge clk, negedge rst_n  ) begin : TemplateFlipFlopBlock
    if(!rst_n) begin
        leds <= 4'd0;
    end
    else
    begin
        leds <= 4'd15;
    end
end

endmodule
