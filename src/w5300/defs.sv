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

function automatic get_socket_n_reg
(
    input [9:0] baseAddr,
    input [9:0] socketN = 10'h000
);
    unsigned [9:0] offset = 10'h040;
    return baseAddr + socketN << $clog2(offset);
endfunction

endpackage
