// W5300 async parallel interface
// Stephen Zhang
// 2023-04-01

module w5300_parallel_if(
        // interna signals
        input i_rst_n,
        input clk,

        // control ports

        // physical ports
        inout tri [15:0] data,
        output reg [9:0] addr,
        output reg o_rst_n,
        output reg cs_n,
        output reg rd_n,
        output reg we_n,
        output reg rw_n,
        input int_n
    );

    localparam S_POWER_ON = 4'd0, S_RESET_P1 = 4'd1, S_RESET_P2 = 4'd2, S_IDLE = 4'd3, S_BUSY = 4'd4;


endmodule

// EOF
