// W5300 lut for operations of registers of interrupt
// Stephen Zhang
// 2023-04-20

module _w5300_interrupt_regs_lut#
    (
        parameter [0:0] op = 1'b1 // 1 - read, 0 - write
    )
    (
        input [5:0] index,
        output reg [26:0] data
    );

    localparam ADDR_OP_RD = 1'b1, ADDR_OP_WR = 1'b0;

    /**
     * Interrupt Register, IR
     */
    localparam IR = 10'h002;

    /**
     * Socket N Interrupt Register, Sn_IR
     * only Socket 0 is enabled for now
     */
    localparam S0_IR = 10'h206;
    localparam S1_IR = 10'h246;
    localparam S2_IR = 10'h286;
    localparam S3_IR = 10'h2C6;
    localparam S4_IR = 10'h306;
    localparam S5_IR = 10'h346;
    localparam S6_IR = 10'h386;
    localparam S7_IR = 10'h3C6;

    always @*
        case (index)
            6'h00:
                data <= {op, IR, 16'hffff};
            6'h01:
                data <= {op, S0_IR, 16'hffff};
            6'h02:
                data <= {op, S1_IR, 16'hffff};
            6'h03:
                data <= {op, S2_IR, 16'hffff};
            6'h04:
                data <= {op, S3_IR, 16'hffff};
            6'h05:
                data <= {op, S4_IR, 16'hffff};
            6'h06:
                data <= {op, S5_IR, 16'hffff};
            6'h07:
                data <= {op, S6_IR, 16'hffff};
            6'h08:
                data <= {op, S7_IR, 16'hffff};
            default:
                data <= {ADDR_OP_RD, 10'h3ff, 16'hffff};
        endcase

endmodule

// EOF
