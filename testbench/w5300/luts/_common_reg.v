// testbench for w5300/luts/_common_reg.v
// Stephen Zhang
// 2023-04-20

`timescale 1ns/10ps

module tb__w5300_common_regs_conf_lut();

    reg clk = 1'b0;
    reg rst = 1'b1;
    reg [5:0] lut_index;
    wire lut_data_op;
    wire [9 :0] lut_data_addr;
    wire [15:0] lut_data_value;

    initial
        begin
            #0 lut_index <= 6'b0;
            #10 rst <= 1'b1;
            #20 rst <= 1'b0;
            #1500 $finish;
        end

    always #5 clk <= ~clk;
    always #100 lut_index <= lut_index + 1'b1;

    _w5300_common_regs_conf_lut _w5300_common_regs_conf_lut_tb_inst
                                (
                                    .index(lut_index),
                                    .data({lut_data_op, lut_data_addr, lut_data_value})
                                );

endmodule

// EOF
