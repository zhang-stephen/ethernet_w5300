// experimental UDP Tx packet
// Stephen Zhang
// 2023-05-07

module _w5300_exp_udp_tx_lut#(
parameter [3:0] N = 0)
(
        input [5:0] index,
        output reg [26:0] data
    );
    
    localparam ADDR_OP_RD = 1'b1, ADDR_OP_WR = 1'b0;
    localparam [9:0] SOCKET_N_OFFSET = 10'h040 * N;
    
    localparam Sn_DIPR0 = 10'h214 + SOCKET_N_OFFSET;
    localparam Sn_DIPR2 = 10'h216 + SOCKET_N_OFFSET;
    
    localparam Sn_DPORTR = 10'h212 + SOCKET_N_OFFSET;
    
    localparam Sn_TX_FIFOR = 10'h22e + SOCKET_N_OFFSET;
    
    localparam Sn_WRSR0 = 10'h220 + SOCKET_N_OFFSET;
    localparam Sn_WRSR2 = 10'h222 + SOCKET_N_OFFSET;
    
    localparam Sn_CR = 10'h202 + SOCKET_N_OFFSET;
    localparam Sn_CR_SEND_MAC = 16'h0021;
    
    localparam Sn_DHAR0 = 10'h20c + SOCKET_N_OFFSET;
    localparam Sn_DHAR2 = 10'h20e + SOCKET_N_OFFSET;
    localparam Sn_DHAR4 = 10'h210 + SOCKET_N_OFFSET;
    
    always @*
        case (index)
            6'h06: data <= {ADDR_OP_WR, Sn_TX_FIFOR, {"N", "J"}};
            6'h07: data <= {ADDR_OP_WR, Sn_TX_FIFOR, {"U", "S"}};
            6'h08: data <= {ADDR_OP_WR, Sn_TX_FIFOR, {"T", "-"}};
            6'h09: data <= {ADDR_OP_WR, Sn_TX_FIFOR, {"E", "O"}};
            6'h0a: data <= {ADDR_OP_WR, Sn_TX_FIFOR, {"E", "-"}};
            6'h0b: data <= {ADDR_OP_WR, Sn_TX_FIFOR, {"2", "0"}};
            6'h0c: data <= {ADDR_OP_WR, Sn_TX_FIFOR, {"2", "3"}};
            6'h0d: data <= {ADDR_OP_WR, Sn_TX_FIFOR, {"\r", "\n"}};
            6'h0e: data <= {ADDR_OP_WR, Sn_WRSR0, 16'h0000};
            6'h0f: data <= {ADDR_OP_WR, Sn_WRSR2, 16'h0010};
            6'h10: data <= {ADDR_OP_WR, Sn_CR, 16'h0020};
            default:
                data <= {ADDR_OP_RD, 10'h3ff, 16'hffff};
        endcase
    

endmodule

// EOF