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
        output [2 :0] err_code,
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
    localparam MAX_WAIT_CNT = 20 * CLK_FREQ / CLK_FREQ_REF; // wait every operation finish, 0.1us(0.2us for debugging)

    // External buffer addrs
    localparam MAX_TX_BUFFER_ADDR = 2 ** TX_BUFFER_ADDR_WIDTH - 1;
    localparam MAX_RX_BUFFER_ADDR = 2 ** RX_BUFFER_ADDR_WIDTH - 1;

    /**
     * FSM states decleration
     */
    localparam S_POWER_UP = 6'd0; // for W5300 power-up reset, wait for the first pull-up of op_status
    localparam S_HAND_SHAKE = 6'd1;
    localparam S_COMMON_INIT = 6'd2;
    localparam S_S0_TX = 6'd31, S_S0_RX = 6'd32;
    localparam S_IDLE = 6'd46, S_ERROR = 6'd47;
    localparam S_S0_INIT = 6'd48, S_S0_INIT_CPLT = 6'd49; // wait for S0_SSR_SOCK_UDP
    // STATE 50-63 reserved for Socket 1 - Socket 7

    // ERROR code
    // this module will be marked as S_ERROR and will not recover from this state unless it is reseted.
    // and the LED2-LED0 will be lighten up to indicate what error happened.
    // FIXME: no error handling
    localparam ERR_CLEAR = 3'd0; // No ERROR
    localparam ERR_IP_CONFLICT = 3'd1, ERR_DST_PORT_UNREACHABLE = 3'd2, ERR_FRAG_MTU = 3'd3; // COMMON ERROR
    localparam ERR_W5300_FOUND = 3'd6; // debug only
    localparam ERR_W5300_NOT_FOUND = 3'd7;

    localparam LUT_COMMON_MAX = 6'h0e;

    // internal registers
    reg [3 :0] _wait_cnt;
    reg [5 :0] _state_n;    // next
    reg [5 :0] _state_c;    // current
    reg [15:0] _rd_reg;
    reg [31:0] _tx_cnt;
    reg [31:0] _rx_cnt;
    // internal operation status register
    // bit 15: 1 - W5300 found, 0 - W5300 not found
    // bit 14: 1 - interrupt occurred, 0 - no interrupt occurred
    // bit 13: 1 - operation timeout, 0 - operation not timeout
    // bit [12:3]: reserved
    // bit [2 :0]: err_code
    reg [15:0] _status;
    // control addr to w5300_parallel_if
    // bit 11: 1 - address is invalid, 0 - address is valid
    // bit 10: 1 - read, 0 - write
    // bit [9:0]: true address of W5300 registers
    reg [11:0] _caddr;

    reg [5 :0] _lut_index;
    reg [5 :0] _common_reg_lut_index;
    reg [5 :0] _s0_reg_lut_index;
    reg [5 :0] _s0_udp_tx_reg_lut_index;
    reg [5 :0] _s0_udp_rx_reg_lut_index;
    reg [26:0] _lut_data;
    wire [26:0] _common_reg_lut_data;
    wire [26:0] _s0_reg_lut_data;
    wire [26:0] _s0_udp_tx_reg_lut_data;
    wire [26:0] _s0_udp_rx_reg_lut_data;

    // assign
    assign err_code = _status[2:0];

    always @(posedge clk or negedge rst_n)
        begin
            if (!rst_n)
                begin
                    _common_reg_lut_index <= 6'd0;
                    _s0_reg_lut_index <= 6'd0;
                    _s0_udp_tx_reg_lut_index <= 6'd0;
                    _s0_udp_rx_reg_lut_index <= 6'd0;
                    _lut_data <= 27'd0;
                end
            else
                case (_state_c)
                    S_COMMON_INIT:
                        begin
                            _common_reg_lut_index <= _lut_index;
                            _lut_data <= _common_reg_lut_data;
                        end
                    S_S0_INIT:
                        begin
                            _s0_reg_lut_index <= _lut_index;
                            _lut_data <= _s0_reg_lut_data;
                        end
                    S_S0_TX:
                        begin
                            _s0_udp_tx_reg_lut_index <= _lut_index;
                            _lut_data <= _s0_udp_tx_reg_lut_data;
                        end
                    S_S0_RX:
                        begin
                            _s0_udp_rx_reg_lut_index <= _lut_index;
                            _lut_data <= _s0_udp_rx_reg_lut_data;
                        end
                    default:
                        begin
                            _lut_data <= 27'h7_ffff_ffff_ffff;
                        end
                endcase
        end

    // FSM
    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            _state_c <= S_POWER_UP;
        else
            _state_c <= _state_n;

    always @*
        if (!rst_n)
            _state_n <= S_POWER_UP;
        else
            case(_state_c)
                S_POWER_UP:
                    _state_n <= (op_status == 1'b1) ? S_HAND_SHAKE : S_POWER_UP;
                S_HAND_SHAKE:
                    _state_n <= S_HAND_SHAKE;
                S_COMMON_INIT:
                    _state_n <= (op_status == 1'b1) ? S_S0_INIT : S_COMMON_INIT;
                S_S0_INIT:
                    _state_n <= (op_status == 1'b1) ? S_IDLE : S_S0_INIT;
                S_IDLE:
                    _state_n <= S_IDLE;
                S_ERROR:
                    _state_n <= S_ERROR;
                default:
                    _state_n <= S_IDLE;
            endcase

    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            begin
                busy_n <= 1'b0;
                _lut_index <= 6'd0;
            end
        else
            case (_state_c)
                S_HAND_SHAKE:
                    begin
                        caddr <= {1'b0, 1'b1, 10'h0fe};
                        _rd_reg <= rd_data;
                    end
                S_COMMON_INIT:
                    begin
                        if (_lut_index >= LUT_COMMON_MAX)
                            begin
                                caddr <= {1'b0, _lut_data[26:16]};
                                wr_data <= _lut_data[15:0];
                            end
                        else
                            _lut_index <= _lut_index + 1'b1;
                    end
                S_S0_INIT:
                    begin
                        caddr <= {1'b0, 1'b0, 10'h202};
                        wr_data <= 16'h0002;
                    end
                S_IDLE:
                    begin
                        busy_n <= 1'b1;
                        caddr[11] = 1'b1;
                    end
            endcase

    // post-processing after operation finshed
    // FIXME: do not use complex driver!
    always @(posedge (clk && op_status) or negedge rst_n)
        if (!rst_n)
            begin
                _status <= 16'h0000;
                rx_req <= 1'b0;
            end
        else
            case (_state_c)
                S_HAND_SHAKE:
                    if (_rd_reg == 16'h5300)
                        begin
                            _status[15] <= 1'b1;
                            _status[2:0] <= ERR_W5300_FOUND;
                        end
                    else
                        _status[2:0] <= ERR_W5300_NOT_FOUND;
            endcase

    _w5300_common_regs_conf_lut _w5300_common_regs_conf_lut_inst(
                                    .index(_common_reg_lut_index),
                                    .data(_common_reg_lut_data)
                                );

    _w5300_socket_n_regs_conf_lut#
        (
            .N(0)
        )
        _w5300_socket_n_regs_conf_lut_inst(
            .index(_s0_reg_lut_index),
            .data(_s0_reg_lut_data)
        );

    _w5300_socket_n_regs_udp_tx_lut#
        (
            .N(0)
        )
        _w5300_socket_n_regs_udp_tx_lut_inst(
            .index(_s0_udp_tx_reg_lut_index),
            .data(_s0_udp_tx_reg_lut_data)
        );

    _w5300_socket_n_regs_udp_rx_lut#
        (
            .N(0)
        )
        _w5300_socket_n_regs_udp_rx_lut_inst(
            .index(_s0_udp_rx_reg_lut_index),
            .data(_s0_udp_rx_reg_lut_data)
        );

endmodule

// EOF
