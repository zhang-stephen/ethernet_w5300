// W5300 async parallel interface
// Stephen Zhang
// 2023-04-01

module w5300_parallel_if
    #(
         parameter CLK_FREQ = 100 // 100MHz in default
     )
     (
         // interna signals
         input i_rst_n,
         input clk,

         // control ports

         // physical ports
         inout tri [15:0] data,
         output [9:0] addr,
         output o_rst_n,
         output cs_n,
         output rd_n,
         output we_n,
         output rw_n,
         input int_n
     );

    localparam S_POWER_ON = 4'd0, S_RESET_P1 = 4'd1, S_RESET_P2 = 4'd2, S_IDLE = 4'd3, S_BUSY = 4'd4;

    wire rw_ready;

    _w5300_parallel_if_rw #(
                              .CLK_FREQ(CLK_FREQ)
                          )
                          _w5300_parallel_if_rw_inst
                          (
                              .rst_n(i_rst_n),
                              .clk(clk),
                              .c_addr(),
                              .c_idata(),
                              .c_odata(),
                              .rw_ready(rw_ready),
                              .data(data),
                              .addr(addr),
                              .cs_n(cs_n),
                              .rd_n(rd_n),
                              .we_n(we_n),
                              .rw_n(rw_n)
                          );


endmodule

// EOF
