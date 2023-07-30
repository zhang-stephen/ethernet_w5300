// Wiznet W5300 definitions for registers and some utilities
// Stephen Zhang
// 2023-07-23

/**
 *  Common Definition of W5300
 *      - PPPoE mode is not supported
 *      - Indirect mode is not supported
 *      - BRDY pins are not supported
 *      - Width of data bus is 16 bits
 */
package W5300;

/************************* Common Registers *************************/

/**
 *  Mode Register, MR
 */
localparam MR = 10'h00;
localparam MR_DBW = 16'h8000;
localparam MR_MPF = 16'h4000;
localparam MR_WDF = 16'h3800;
localparam MR_RDH = 16'h0400;
localparam MR_FS = 16'h0100;
localparam MR_RST = 16'h0080;
localparam MR_MT = 16'h0020;
localparam MR_PB = 16'h0010;
localparam MR_IND = 16'h0001;

/**
 * Interrupt Register, IR
 * Interrupt Mask Rregister, IMR
 */
localparam IR = 10'h002;
localparam IMR = 10'h004;
localparam IR_IMR_IPCF = 16'h8000;
localparam IR_IMR_DPUR = 16'h4000;
localparam IR_IMR_FMTU = 16'h1000;
localparam IR_IMR_S7 = 16'h0080;
localparam IR_IMR_S6 = 16'h0040;
localparam IR_IMR_S5 = 16'h0020;
localparam IR_IMR_S4 = 16'h0010;
localparam IR_IMR_S3 = 16'h0008;
localparam IR_IMR_S2 = 16'h0004;
localparam IR_IMR_S1 = 16'h0002;
localparam IR_IMR_S0 = 16'h0001;

/**
 * Source Hardware Address Resgiter, SHAR
 */
localparam SHAR0 = 10'h008;
localparam SHAR2 = 10'h00a;
localparam SHAR4 = 10'h00c;

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
 * Memory Type Register, MTYPER
 */
localparam MTYPER = 10'h030;

/**
 * Unreachable IP Address Register, UIPR
 * Unreachable Port Register
 */
localparam UIPR0 = 10'h048;
localparam UIPR2 = 10'h04a;
localparam UPORTR = 10'h04c;

/**
 * Fragment MTU Register
 */
localparam FMTUR = 10'h04e;

/**
 * Identification Register, IDR
 */
localparam IDR = 10'h0fe;

/************************* Socket Registers *************************/

localparam Sn_ADDR_BASE = 10'h100; // just for some judge

function automatic bit [9:0] get_socket_n_reg
(
    input [9:0] baseAddr,
    input [9:0] socketN = 10'h000
);
    bit [9:0] offset = 10'h040;
    return baseAddr + socketN << $clog2(offset);
endfunction

/**
 * Socket N Mode Register, Sn_MR
 */
localparam Sn_MR = 10'h200;
localparam Sn_MR_ALIGN = 16'h0100;
localparam Sn_MR_MULTICAST = 16'h0080;
localparam Sn_MR_MAC_FILTER = 16'h0040;
localparam Sn_MR_NO_DELAY_ACK = 16'h0020;
localparam Sn_MR_IGMP_VER = 16'h0020;
localparam Sn_MR_P_MAC_RAW = 16'h00004;
localparam Sn_MR_P_IP_RAW = 16'h0003;
localparam Sn_MR_P_UDP = 16'h0002;
localparam Sn_MR_P_TCP = 16'h0001;
localparam Sn_MR_P_INVALID = 16'h0000;

/**
 * Socket N Command Register, Sn_CR
 */
localparam Sn_CR = 10'h202;
localparam Sn_CR_OPEN = 16'h0001;
localparam Sn_CR_LISTEN = 16'h0002;
localparam Sn_CR_CONNECT = 16'h0004;
localparam Sn_CR_DISCONNECT = 16'h0008;
localparam Sn_CR_CLOSE = 16'h0010;
localparam Sn_CR_SEND = 16'h0020;
localparam Sn_CR_SEND_MAC = 16'h0021;
localparam Sn_CR_SEND_KEEP = 16'h0022;
localparam Sn_CR_RECEIVE = 16'h0040;

/**
 * Socket N Interrupt Register, Sn_IR
 * Socket N Interrupt Mask Register, Sn_IMR
 */
localparam Sn_IR = 10'h206;
localparam Sn_IMR = 10'h204;
localparam Sn_IR_IMR_SENDOK = 16'h0010;
localparam Sn_IR_IMR_TIMEOUT = 16'h0008;
localparam Sn_IR_IMR_RECV = 16'h0004;
localparam Sn_IR_IMR_DISCONNECT = 16'h0002;
localparam Sn_IR_IMR_CONNECT = 16'h0001;

/**
 * Socket N Status Register, Sn_SSR
 * the lower 8 bits are effective
 */
localparam Sn_SSR = 10'h208;
localparam Sn_SSR_SOCK_CLOSED = 16'hxx00;
localparam Sn_SSR_SOCK_INIT = 16'hxx13;
localparam Sn_SSR_SOCK_LISTEN = 16'hxx14;
localparam Sn_SSR_SOCK_ESTABLISHED = 16'hxx17;
localparam Sn_SSR_SOCK_CLOSE_WAIT = 16'hxx1c;
localparam Sn_SSR_SOCK_UDP = 16'hxx22;
localparam Sn_SSR_SOCK_IPRAW = 16'hxx32;
localparam Sn_SSR_SOCK_MACRAW = 16'hxx42;
// some temporary status are ignored..., see datasheet Sn_SSR section

/**
 * Socket N source Port Register, Sn_PORTR
 */
localparam Sn_PORTR = 10'h20a;

/**
 * Socket N Destination Hardware Address Register, Sn_DHAR
 */
localparam Sn_DHAR0 = 10'h20c;
localparam Sn_DHAR2 = 10'h20e;
localparam Sn_DHAR4 = 10'h210;

/**
 * Socket N Destination Port Register, Sn_DPORTR
 */
localparam Sn_DPORTR = 10'h212;

/**
 * Socket N Destination IP Address Register, Sn_DIPR
 */
localparam Sn_DIPR0 = 10'h214;
localparam Sn_DIPR2 = 10'h216;

/**
 * Socket N Maximum Segment Size Register, Sn_MSSR
 * KEEP this default value if no special requirement!
 */
localparam Sn_MSSR = 10'h218;
localparam Sn_MSSR_TCP = 16'd1460;
localparam Sn_MSSR_UDP = 16'd1472;
localparam Sn_MSSR_IPRAW = 16'd1480;
localparam Sn_MSSR_MACRAW = 16'd1514;

/**
 * Socket N Keep Alive Time Register, Sn_KPALVTR(min time unit is 5s)
 * Socket N Protocol Number Register, Sn_PROTOR
 * they are 2 1-byte registers, and I have to bundle them up for 16-bit data bus
 */
localparam Sn_KPALVTR_PROTOR = 10'h21a;

/**
 * Socket N TOS(Type of Service) Register, Sn_TOSR
 */
localparam Sn_TOSR = 16'h21c;

/**
 * Socket N TTL(Time to Live) Register, Sn_TTLR
 */
localparam Sn_TTLR = 10'h21e;
localparam Sn_TTLR_DEFAULT = 16'd128;

/**
 * Socket N Tx Write Size Register, Sn_TX_WRSR
 */
localparam Sn_TX_WRSR0 = 10'h220;
localparam Sn_TX_WRSR2 = 10'h222;

/**
 * Socket N Tx Free Size Register, Sn_TX_FSR
 */
localparam Sn_TX_FSR0 = 10'h224;
localparam Sn_TX_FSR2 = 10'h226;

/**
 * Socket N Rx Received Size Register, Sn_RX_RSR
 */
localparam Sn_RX_RSR0 = 10'h228;
localparam Sn_RX_RSR2 = 10'h22a;

/**
 * Socket N Fragment Register, Sn_FRAGR
 */
localparam Sn_FRAGR = 10'h22c;

/**
 * Socket N Tx FIFO Register, Sn_TX_FIFOR
 */
localparam Sn_TX_FIFOR = 10'h22e;

/**
 * Socket N Rx FIFO Register, Sn_RX_FIFOR
 */
localparam Sn_RX_FIFOR = 10'h230;

/************************* Other Definitions *************************/
typedef enum bit
{
    WR = 1'b0,
    RD = 1'b1
} AddrOperation;

typedef enum bit
{
    Valid = 1'b0,
    Invalid = 1'b1
} AddrValidStatus;

typedef enum bit [2:0]
{
    Socket0 = 3'd0,
    Socket1 = 3'd1,
    Socket2 = 3'd2,
    Socket3 = 3'd3,
    Socket4 = 3'd4,
    Socket5 = 3'd5,
    Socket6 = 3'd6,
    Socket7 = 3'd7
} Socket;

endpackage

package network;

function automatic calc_gateway(input [31:0] srcIpv4);
    return {srcIpv4[31:8], 8'd1};
endfunction

endpackage

package common;

localparam CLK_REF = 100; // 100MHz, for delay counting

endpackage
