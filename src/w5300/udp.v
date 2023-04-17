// W5300 UDP configuration and communication with Fixed-IP
// Stephen Zhang
// 2023-04-17

module w5300_udp_conf_comm#
    (
        parameter CLK_FREQ = 100,
        parameter TX_BUFFER_ADDR_WIDTH = 12,
        parameter RX_BUFFER_ADDR_WIDTH = 12
    )
    (
        // driver signals
        input rst_n,
        input clk,

        // tx ports
        input tx_req,
        input [15:0] tx_data,
        output reg [TX_BUFFER_ADDR_WIDTH - 1:0] tx_buffer_addr,

        // rx ports
        output [15:0] rx_data,
        output reg [RX_BUFFER_ADDR_WIDTH - 1:0] rx_buffer_addr,
        output reg rx_req,

        // control ports
        output reg [2 :0] err_code,
        output reg busy_n,

        // intraconnect ports
        input op_status,
        input [15:0] rd_data,
        output reg [15:0] wr_data,
        output reg [11:0] caddr,

        // physical ports
        input int_n
    );

    localparam CLK_FREQ_REF = 100;
    localparam ADDR_OFFSET_MR = 16'h0000, ADDR_OFFSET_SnMR = 16'h0200;
    localparam MAX_WAIT_CNT = 10 * CLK_FREQ / CLK_FREQ_REF; // wait every operation finish, 0.1us

    // FSM states decleration
    localparam S_POWER_UP = 6'd0, S_FIND_W5300 = 6'd1;
    localparam S_COMMON_REG_CONFIG = 6'd2, S_COMMON_REG_CONFIG_CPLT = 6'd3;
    localparam S_S0_REG_CONFIG = 6'd4, S_S0_REG_CONFIG_CPLT = 6'd5;
    localparam S_INT_OCCUR = 6'd6, S_INT_READ_REG = 6'd7, S_INT_CLEAR_REG = 6'd8;
    localparam S_IDLE = 6'd62;
    localparam S_ERROR = 6'd63;

    // Address & Mask of some W5300 registers
    // IDentification Register
    localparam IDR = 16'h00FE;

    // ERROR code
    // this module will be marked as S_ERROR and will not recover from this state unless it is reseted.
    // and the LED2-LED0 will be lighten up to indicate what error happened.
    // FIXME: no error handling
    localparam ERR_CLEAR = 3'd0; // No ERROR
    localparam ERR_IP_CONFLICT = 3'd1, ERR_DST_PORT_UNREACHABLE = 3'd2, ERR_FRAG_MTU = 3'd3; // COMMON ERROR
    localparam ERR_W5300_NOT_FOUND = 3'd7;

    // Network common configuration(see w5300_conf_regs.mif)

    // internal registers
    reg [5 :0] _state_n;    // next state of FSM
    reg [5 :0] _state_c;    // current state of FSM
    reg [31:0] _tx_cnt;
    reg [31:0] _rx_cnt;
    // internal operation status register
    // bit 15: 1 - W5300 found, 0 - W5300 not found
    // bit 14: 1 - interrupt occurred, 0 - no interrupt occurred
    // bit 13: 1 - operation timeout, 0 - operation not timeout(not enabled now)
    // bit [12:3]: reserved
    // bit [2 :0]: err_code
    reg [15:0] _status;
    // control addr to w5300_parallel_if
    // bit 11: 1 - address is invalid, 0 - address is valid
    // bit 10: 1 - read, 0 - write
    // bit [9:0]:  true address of W5300 registers
    reg [11:0] _caddr;
    reg [3 :0] _wait_cnt;

    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            _state_c <= S_POWER_UP;
        else
            _state_c <= _state_n;

    // TODO: a timeout judgement, not finishied!
    //    always @(posedge clk or negedge rst_n)
    //        if (!rst_n)
    //            _wait_cnt <= 4'd0;
    //        else
    //            if (_state_c != _state_n) // state switched
    //                _wait_cnt <= 4'd0;
    //            else if (_state_c > S_POWER_UP) // duration of reset is more than 0.1us, ignored
    //                if (_wait_cnt >= MAX_WAIT_CNT)
    //                    _status[13] <= 1'b1;
    //                else
    //                    _wait_cnt <= _wait_cnt + 4'd1;

    always @*
        if (!rst_n)
            _state_n <= S_POWER_UP;
        else
            case(_state_c)
                S_POWER_UP:
                    _state_n <= (busy_n == 1'b1) ? S_FIND_W5300 : S_POWER_UP;
                S_FIND_W5300:
                    _state_n <= S_FIND_W5300;
                S_ERROR:
                    _state_n <= S_ERROR;
            endcase

    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            begin
            end
    //        else case (_state_c)
    //
    //        endcase

endmodule

// EOF
