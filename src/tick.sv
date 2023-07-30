// a simple tick timer module for timing
// Stephen-Zhang
// 2023-07-29

module ticker
(
    input clk,
    input rst_n,

    input repeatable,
    input clear,
    input start,
    input [23:0] threshold,

    output bit irq
);

bit running; // counting in progress
bit done;    // counting finished
bit [23:0] r_counter;

enum bit [2:0]
{
    Stop,
    Loading,
    Counting,
    Idle
} state_c, state_n;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state_c <= Stop;
    end
    else begin
        state_c <= state_n;
    end
end

always @* begin : TickStateSwitcher
    if (!rst_n) begin
        state_n <= Stop;
    end
    else begin
        case(state_c)
            Idle:     state_n <= running && repeatable ? Loading : Stop; // timer running and repeatation enabled
            Loading:  state_n <= running ? Counting : Loading;
            Counting: state_n <= done ? Idle : Counting; // goto Idle if counting down to zero
            Stop:     state_n <= start? Loading : Stop;
        endcase
    end
end

always_ff @(posedge clk, negedge rst_n, posedge clear) begin : TickTimerCore
    if (!rst_n) begin
        {running, done, r_counter} <= 26'd0;
    end
    else if (clear) begin
        irq <= 1'b0;
    end
    else begin
        case(state_c)
            Idle: begin
                done <= 1'b0;
            end

            Loading: begin
                running <= 1'b1;          // set to running
                r_counter <= threshold;
            end

            Counting: begin
                if (r_counter > 24'd0) begin
                    r_counter <= r_counter - 24'd1;
                end
                else begin
                    done <= 1'b1;      // counting down finished
                    irq <= 1'b1;
                end
            end

            Stop: begin
                running <= 1'b0;
            end
        endcase
    end
end


endmodule
