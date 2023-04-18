// W5300 async parallel interface
// Stephen Zhang
// 2023-04-01

module w5300_parallel_if#
    (
        parameter CLK_FREQ = 100 // 100MHz in default
    )
    (
        // interna signals
        input rst_n,
        input clk,

        // control ports
        output op_status,

        // control addr/data
        input [11:0] uaddr,
        input [15:0] u_wr_data,
        output [15:0] u_rd_data,

        // physical ports
        inout tri [15:0] data,
        output [9:0] addr,
        output cs_n,
        output rd_n,
        output we_n,
        output rw_n
    );

    localparam CLK_FREQ_REF = 100;
    localparam S_POWER_ON = 4'd0, S_RESET_P1 = 4'd1, S_RESET_P2 = 4'd2, S_IDLE = 4'd3, S_BUSY = 4'd4;
    localparam ADDR_S_INVALID = 1'b1, ADDR_S_VALID = 1'b0;
    localparam RST_P1_TICKS = 200 * CLK_FREQ / CLK_FREQ_REF;    // phase 1: 2us, 200 ticks in 100MHz
    localparam RST_P2_TICKS = 5000 * CLK_FREQ / CLK_FREQ_REF;   // phase 2: 50us, 5000 ticks in 100MHz

    reg [15:0] _rst_p1_cnt;
    reg [15:0] _rst_p2_cnt;
    reg [3:0] _state_c;
    reg [3:0] _state_n;

    always@(posedge clk or negedge rst_n)
        if (!rst_n)
            _state_c <= S_POWER_ON;
        else
            _state_c <= _state_n;

    always @*
        if (!rst_n)
            _state_n <= S_POWER_ON;
        else
            case(_state_c)
                S_POWER_ON:
                    _state_n <= S_RESET_P1;
                S_RESET_P1:
                    _state_n <= (_rst_p1_cnt >= RST_P1_TICKS) ? S_RESET_P2 : S_RESET_P1;
                S_RESET_P2:
                    _state_n <= (_rst_p2_cnt >= RST_P2_TICKS) ? S_IDLE : S_RESET_P2;
                S_IDLE:
                    _state_n <= (uaddr[11] == ADDR_S_VALID) ? S_BUSY : S_IDLE;
                S_BUSY:
                    _state_n <= op_status ? S_IDLE : S_BUSY;
                default:
                    _state_n <= S_IDLE;
            endcase

    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            begin
                _rst_p1_cnt <= 16'd0;
                _rst_p2_cnt <= 16'd0;
            end
        else
            case(_state_n)
                S_RESET_P1:
                    _rst_p1_cnt <= _rst_p1_cnt + 16'd1;
                S_RESET_P2:
                    _rst_p2_cnt <= _rst_p2_cnt + 16'd1;
            endcase

    _w5300_parallel_if_rw #
        (
            .CLK_FREQ(CLK_FREQ)
        )
        _w5300_parallel_if_rw_inst
        (
            .rst_n(rst_n),
            .clk(clk),
            .c_addr(uaddr),
            .c_idata(u_wr_data),
            .c_odata(u_rd_data),
            .rw_ready(op_status),
            .data(data),
            .addr(addr),
            .cs_n(cs_n),
            .rd_n(rd_n),
            .we_n(we_n),
            .rw_n(rw_n)
        );
endmodule

// EOF
