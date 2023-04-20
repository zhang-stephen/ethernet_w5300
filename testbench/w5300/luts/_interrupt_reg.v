// testbench for w5300/luts/_interrupt_reg.v
// Stephen Zhang
// 2023-04-20

`timescale 1ns/10ps

module tb__w5300_interrupt_regs_lut();

    localparam op = 1'b1;

    reg clk = 1'b0;
    reg rst = 1'b1;
    reg [5:0] lut_index;
    wire lut_data_op_r;
    wire lut_data_op_w;
    wire [9 :0] lut_data_addr_r;
    wire [9 :0] lut_data_addr_w;
    wire [15:0] lut_data_value_r;
    wire [15:0] lut_data_value_w;

    initial
        begin
            #0 lut_index <= 6'd0;
            #5 rst <= 1'b1;
            #10 rst <= 1'b0;
            #500 $finish;
        end

    always #5 clk <= ~clk;
    always #50 lut_index <= lut_index + 1'b1;

    _w5300_interrupt_regs_lut#
        (
            .op(op)
        )
        _w5300_interrupt_regs_lut_rd_tb_inst(
            .index(lut_index),
            .data({lut_data_op_r, lut_data_addr_r, lut_data_value_r})
        );

    _w5300_interrupt_regs_lut#
        (
            .op(!op)
        )
        _w5300_interrupt_regs_lut_wr_tb_inst(
            .index(lut_index),
            .data({lut_data_op_w, lut_data_addr_w, lut_data_value_w})
        );


endmodule

// EOF
