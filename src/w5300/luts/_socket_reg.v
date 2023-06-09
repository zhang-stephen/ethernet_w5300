// W5300 lut for operations of registers of Socket N
// Stephen Zhang
// 2023-04-19

module _w5300_socket_n_regs_conf_lut#
    (
        parameter [3:0] N = 0    // socket N, socket 0 in the default
    )
    (
        input [5:0] index,
        output reg [26:0] data
    );

    localparam ADDR_OP_RD = 1'b1, ADDR_OP_WR = 1'b0;
    localparam [9:0] SOCKET_N_OFFSET = 10'h040 * N;

    /**
     * Socket N Mode Register, Sn_MR
     */
    localparam [9:0] Sn_MR = 10'h200 + SOCKET_N_OFFSET;
    localparam Sn_MR_ALIGN = 16'h0100;
    localparam Sn_MR_MULTI = 16'h0080;
    localparam Sn_MR_MF = 16'h0040;
    localparam Sn_MR_ND_MC = 16'h0020; // configure ACK delay for TCP, or IGMP version for UDP multi-broadcast
    localparam Sn_MR_P_UDP = 16'h0002;

    /**
     * Socket N Command Register, Sn_CR
     */
    localparam [9:0] Sn_CR = 10'h202 + SOCKET_N_OFFSET;
    localparam Sn_CR_OPEN = 16'h0001;

    /**
     * Socket N Interrupt Mask Register, Sn_IMR
     */
    localparam [9:0] Sn_IMR = 10'h204 + SOCKET_N_OFFSET;
    localparam Sn_IMR_SENDOK = 16'h0100;
    localparam Sn_IMR_RECV = 16'h0040;

    /**
     * Socket N Status Register, Sn_SSR
     */
    localparam Sn_SSR = 10'h208 + SOCKET_N_OFFSET;

    /**
     * Socket N Source Port Register, Sn_PORTR
     */
    localparam [9:0] Sn_PORTR = 10'h20A + SOCKET_N_OFFSET;

    /**
     * Socket N Maximum Segment Size Register, Sn_MSSR
     */
    localparam [9:0] Sn_MSSR = 10'h218 + SOCKET_N_OFFSET;
    localparam Sn_MSSR_UDP_DEFAULT = 16'h05c0; // 1472 Bytes

    always @*
        case (index)
            6'h00:
                data <= {ADDR_OP_WR, Sn_MR, Sn_MR_P_UDP};
            6'h01:
                data <= {ADDR_OP_WR, Sn_IMR, Sn_IMR_SENDOK | Sn_IMR_RECV};
            6'h02:
                data <= {ADDR_OP_WR, Sn_PORTR, 16'h1b58};
            6'h03:
                data <= {ADDR_OP_WR, Sn_MSSR, Sn_MSSR_UDP_DEFAULT};
            6'h04:
                data <= {ADDR_OP_WR, Sn_CR, Sn_CR_OPEN};
            6'h05:
                data <= {ADDR_OP_RD, Sn_SSR, 16'hffff};
            default:
                data <= {ADDR_OP_RD, 10'h3ff, 16'hffff};
        endcase

endmodule

// EOF
