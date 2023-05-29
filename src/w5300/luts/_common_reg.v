// W5300 lut for operations of common registers
// Stephen Zhang
// 2023-04-19

module _w5300_common_regs_conf_lut
    (
        input [5:0] index,
        // [26]: 1 - read, 0 - write
        // [25:16]: w5300 register addr offset
        // [15: 0]: w5300 register value, 0xffff for reading, or should be ignored.
        output reg [26:0] data
    );

    localparam ADDR_OP_RD = 1'b1, ADDR_OP_WR = 1'b0;

    /**
     * NOTE: value of all registers, except Sn_TX_FIFOR & Sn_RX_FIFOR, is big-endian format.
     */

    /**
     * Mode Register, MR
     */
    localparam MR = 10'h000;
    localparam MR_DBW = 16'h8000;
    localparam MR_WDFs = 16'h3800;
    localparam MR_RDH = 16'h0400;
    localparam MR_FS = 16'h0100;
    localparam MR_RST = 16'h0080;
    localparam MR_MT = 16'h0020;
    localparam MR_PB = 16'h0010;
    localparam MR_PPPoE = 16'h0008;
    localparam MR_DBS = 16'h0004;
    localparam MR_IND = 16'h0001;

    /**
     * Interrupt Mask Register, IMR
     */
    localparam IMR = 10'h004;
    localparam IMR_IPCF = 16'h8000;
    localparam IMR_DPUR = 16'h4000;
    localparam IMR_PPPT = 16'h2000;
    localparam IMR_FMTU = 16'h1000;
    localparam IMR_S0 = 16'h0001; // S7 - S1 are ignored

    /**
     * Soruce Hardware Address Register, SHAR
     */
    localparam SHAR0 = 10'h008;
    localparam SHAR2 = 10'h00A;
    localparam SHAR4 = 10'h00C;

    /**
     * Gateway IP Address Register, GAR
     */
    localparam GAR0 = 10'h010;
    localparam GAR2 = 10'h012;

    /**
     * Subnet Mask Register, SUBR
     */
    localparam SUBR0 = 10'h014;
    localparam SUBR2 = 10'h016;

    /**
     * Source IP Address Register, SIPR
     */
    localparam SIPR0 = 10'h018;
    localparam SIPR2 = 10'h01a;

    /**
     * Re-transmission Timeout-period Register, RTR
     */
    localparam RTR = 10'h01c;

    /**
     * Re-transmission Retry-Count Register, RCR(seems not required for UDP)
     */
    localparam RCR = 10'h01e;

    /**
     * Tx Memory Size xy Register, TMSxyR
     * there should be 64kB memory for Tx, and it is divided into 64 blocks logically, 1kB per block.
     * this register is used to configure how many blocks for socket x and socket y.
     * socket 2 - 7 are ignored now.
     */
    localparam TMS01R = 10'h020;

    /**
     * Rx Memory Size xy Register, RMSxyR
     */
    localparam RMS01R = 10'h028;

    /**
     * Memory TYPE register
     */
    localparam MTYPER = 10'h030;

    always @*
        case (index)
            6'h00:
                data <= {ADDR_OP_WR, MR, MR_DBW | MR_WDFs};
            6'h01:
                data <= {ADDR_OP_WR, IMR, IMR_IPCF | IMR_DPUR | IMR_FMTU | IMR_S0 };
            6'h02:
                data <= {ADDR_OP_WR, SHAR0, 16'h0008};   // mac addr: 00.08.dc.01.02.03
            6'h03:
                data <= {ADDR_OP_WR, SHAR2, 16'hdc01};
            6'h04:
                data <= {ADDR_OP_WR, SHAR4, 16'h0203};
            6'h05:
                data <= {ADDR_OP_WR, GAR0, 16'hc0a8};    // gateway: 10.10.0.1
            6'h06:
                data <= {ADDR_OP_WR, GAR2, 16'h6f01};
            6'h07:
                data <= {ADDR_OP_WR, SUBR0, 16'hffff};   // subnet: 255.255.255.0
            6'h08:
                data <= {ADDR_OP_WR, SUBR2, 16'hff00};
            6'h09:
                data <= {ADDR_OP_WR, SIPR0, 16'hc0a8};
            6'h0a:
                data <= {ADDR_OP_WR, SIPR2, 16'h6f0f};   // ip: 10.10.0.15
            6'h0b:
                data <= {ADDR_OP_WR, RTR, 16'h0fa0};     // 400ms
            6'h0c:
                data <= {ADDR_OP_WR, TMS01R, 16'h0800};  // 8kB for socket 0 Tx, and 0kB for socket 1
            6'h0d:
                data <= {ADDR_OP_WR, RMS01R, 16'h0800};  // 8kB for socket 0 Rx
            6'h0e:
                data <= {ADDR_OP_WR, MTYPER, 16'h00ff};  // higher 64kB for Rx and lower 64kB for Tx
            default:
                data <= {ADDR_OP_RD, 10'h3ff, 16'hffff};
        endcase

endmodule

// EOF
