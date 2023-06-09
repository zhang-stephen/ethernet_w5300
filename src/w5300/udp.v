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
        input [31:0] dest_ip,
        input [15:0] dest_port,
        input [31:0] tx_data_size,
        input [15:0] tx_data,
        output reg [TX_BUFFER_ADDR_WIDTH - 1:0] tx_buffer_addr,

        // rx ports
        output reg [15:0] rx_data,
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
    localparam ADDR_OP_RD = 1'b1, ADDR_OP_WR = 1'b0;
    localparam ADDR_S_INVALID = 1'b1, ADDR_S_VALID = 1'b0;

    // External buffer addrs
    localparam MAX_TX_BUFFER_ADDR = 2 ** TX_BUFFER_ADDR_WIDTH - 1;
    localparam MAX_RX_BUFFER_ADDR = 2 ** RX_BUFFER_ADDR_WIDTH - 1;

    /**
     * FSM states decleration
     */
    localparam S_POWER_UP = 6'd0; // for W5300 power-up reset, wait for the first pull-up of op_status
    localparam S_HAND_SHAKE = 6'd1;
    localparam S_COMMON_INIT = 6'd2, S_WAIT_S0_UDP = 6'd5;
    localparam S_S0_TX = 6'd31, S_S0_RX = 6'd32;
    localparam S_S0_TX_WAIT = 6'd33;
    localparam S_IDLE = 6'd46, S_ERROR = 6'd47;
    localparam S_S0_INIT = 6'd48, S_S0_INIT_CPLT = 6'd49; // wait for S0_SSR_SOCK_UDP
    // STATE 50-63 reserved for Socket 1 - Socket 7

    /**
     * Task states
     */
    localparam TS_REG_INIT_IDLE = 2'd0;
    localparam TS_REG_INIT_WRITING = 2'd1;
    localparam TS_REG_INIT_WRITING_2 = 2'd3;
    localparam TS_REG_INIT_CPLT = 2'd2;

    localparam TS_TX_IDLE = 4'd0;
    localparam TS_TX_RD_FREE_SIZE_0 = 4'd1, TS_TX_RD_FREE_SIZE_1 = 4'd2;
    localparam TS_TX_WR_DST_IP_0 = 4'd3, TS_WR_DST_IP_1 = 4'd4, TS_WR_DST_PORT = 4'd5;
    localparam TS_TX_WR_USER_DATA = 4'd6;
    localparam TS_TX_WR_SEND_SIZE_0 = 4'd7, TS_TX_WR_SEND_SIZE_1 = 4'd8;
    localparam TS_TX_WR_CMD_SEND = 4'd9;
    localparam TS_TX_CPLT = 4'd10;

    // ERROR code
    // this module will be marked as S_ERROR and will not recover from this state unless it is reseted.
    // and the LED2-LED0 will be lighten up to indicate what error happened.
    // FIXME: no error handling
    localparam ERR_CLEAR = 3'd0; // No ERROR
    localparam ERR_IP_CONFLICT = 3'd1, ERR_DST_PORT_UNREACHABLE = 3'd2, ERR_FRAG_MTU = 3'd3; // COMMON ERROR
    localparam ERR_W5300_FOUND = 3'd6; // debug only
    localparam ERR_W5300_NOT_FOUND = 3'd7;

    // maximum steps of look-up table
    localparam COMMON_REGS_LUT_STEPS = 6'h0e;
    localparam INTERRUPT_REGS_LUT_STEPS = 6'h01; // interrupt r/w
    localparam S0_REGS_CONF_LUT_STEPS = 6'h05;
    localparam S0_REGS_UDP_TX_LUT_STEPS = 6'h07;
    localparam S0_REGS_UDP_RX_LUT_STEPS = 6'h03;

    // internal registers
    reg [3 :0] _task_state;
    reg [3 :0] _s0_init_state;
    reg [3 :0] _s0_tx_state;
    reg [5 :0] _state_n;    // next
    reg [5 :0] _state_c;    // current
    reg [5 :0] _state_i;    // jump to after interrupt handling
    reg [31:0] _tx_free_size;
    reg [31:0] _tx_cnt;
    reg [31:0] _rx_cnt;
    // internal operation status register
    // bit 15: 1 - task ongoing, 0 - task finished
    // bit 14: 1 - interrupt occurred, 0 - no interrupt occurred
    // bit 13: 1 - common initialized
    // bit [12:4]: reserved
    // bit  3: 1 - s0 initialized
    // bit [2 :0]: err_code
    reg [15:0] _status;
    reg [15:0] _status_2;

    reg [5 :0] _lut_index;
    wire [26:0] _common_reg_lut_data;
    wire [26:0] _s0_reg_lut_data;

    // assign
    assign err_code = _status[2:0];

    always @*
        rx_data <= rd_data;

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
                    _state_n <= (op_status == 1'b1) ? S_COMMON_INIT : S_POWER_UP;
                S_COMMON_INIT:
                    _state_n <= (op_status && _status[13]) ? S_S0_INIT : S_COMMON_INIT;
                S_S0_INIT:
                    _state_n <= (op_status && _status[3]) ? S_WAIT_S0_UDP : S_S0_INIT;
                S_WAIT_S0_UDP:
                    _state_n <= (op_status && rx_data[7:0] == 8'h22) ? S_IDLE : S_WAIT_S0_UDP;
                S_IDLE:
                    _state_n <= ~tx_req ? S_S0_TX : S_IDLE;
                S_S0_TX:
                    _state_n <= (op_status && _status_2[0]) ? S_IDLE : S_S0_TX;
                S_ERROR:
                    _state_n <= S_ERROR;
                default:
                    _state_n <= S_IDLE;
            endcase

    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            begin
                _lut_index <= 6'd0;
                _status <= 16'd0;
                _task_state <= 4'd0;
                _s0_init_state <= 4'd0;
                busy_n <= 1'b0;
                wr_data <= 16'd0;
                caddr <= {ADDR_S_INVALID, ADDR_OP_RD, 10'd0};
            end
        else
            case (_state_c)
                S_COMMON_INIT:
                    begin
                        w5300_common_regs_init;
                    end
                S_S0_INIT:
                    begin
                        w5300_socket0_init;
                    end
                S_WAIT_S0_UDP:
                    caddr <= {ADDR_S_VALID, ADDR_OP_RD, 10'h208};
                S_IDLE:
                    begin
                        _lut_index <= 6'd0;
                        caddr[11] <= ADDR_S_INVALID;
                        busy_n <= 1'b1;
                        _s0_tx_state <= 4'd0;
                        _status_2[0] <= 1'b0;
                    end
                S_S0_TX:
                    w5300_udp_tx;
                S_ERROR:
                    _status[2:0] <= 3'b111;
            endcase

    _w5300_common_regs_conf_lut _w5300_common_regs_conf_lut_inst(
                                    .index(_lut_index),
                                    .data(_common_reg_lut_data)
                                );

    _w5300_socket_n_regs_conf_lut#
        (
            .N(0)
        )
        _w5300_socket_n_regs_conf_lut_inst(
            .index(_lut_index),
            .data(_s0_reg_lut_data)
        );

    task w5300_common_regs_init;
        case (_task_state)
            TS_REG_INIT_IDLE:
                begin
                    _lut_index <= 6'd0;
                    _task_state <= TS_REG_INIT_WRITING_2;
                end

            TS_REG_INIT_WRITING:
                begin
                    _lut_index <= _lut_index + 1'b1;
                    _task_state <= (_lut_index > COMMON_REGS_LUT_STEPS) ? TS_REG_INIT_CPLT: TS_REG_INIT_WRITING_2;
                end

            TS_REG_INIT_WRITING_2: begin
                {caddr, wr_data} <= {ADDR_S_VALID, _common_reg_lut_data};
                _task_state <= op_status ? TS_REG_INIT_WRITING : TS_REG_INIT_WRITING_2;
                end

            TS_REG_INIT_CPLT: begin
                _status[13] <= 1'b1;
                end
        endcase
    endtask

    task w5300_socket0_init;
        case (_s0_init_state)
            TS_REG_INIT_IDLE:
                begin
                    _lut_index <= 6'd0;
                    _s0_init_state <= TS_REG_INIT_WRITING_2;
                end

            TS_REG_INIT_WRITING:
                begin
                    _lut_index <= _lut_index + 1'b1;
                    _s0_init_state <= (_lut_index > S0_REGS_CONF_LUT_STEPS) ? TS_REG_INIT_CPLT: TS_REG_INIT_WRITING_2;
                end

            TS_REG_INIT_WRITING_2: begin
                {caddr, wr_data} <= {ADDR_S_VALID, _s0_reg_lut_data};
                _s0_init_state <= op_status ? TS_REG_INIT_WRITING : TS_REG_INIT_WRITING_2;
                end

            TS_REG_INIT_CPLT: begin
                _status[3] <= 1'b1;
                end
        endcase
    endtask

//    task w5300_irq_handle;
//        case (_task_state)
//
//        endcase
//    endtask
//
    task w5300_udp_tx;
        // FIXME: hardcoded status should not be used!
        case (_s0_tx_state)
            4'h0:
                begin
                    _s0_tx_state <= 4'ha;
                    tx_buffer_addr <= 8'b0;
                end
            4'ha: // TX_FSR0
                begin
                    {caddr, _tx_free_size[31:16]} <= {ADDR_S_VALID, ADDR_OP_RD, 10'h224, rd_data};
                    _s0_tx_state <= op_status ? 4'hb : 4'ha;
                end
            4'hb: // TX_FSR2
                begin
                    {caddr, _tx_free_size[15: 0]} <= {ADDR_S_VALID, ADDR_OP_RD, 10'h226, rd_data};
                    _s0_tx_state <= op_status ? 4'hc : 4'hb;
                end
            4'hc:
                _s0_tx_state <= (_tx_free_size < tx_data_size) ? 4'ha : 4'h1;
            4'h1: // DIPR0
                begin
                    {caddr, wr_data} <= {ADDR_S_VALID, ADDR_OP_WR, 10'h214, dest_ip[31:16]};
                    _s0_tx_state <= op_status ? 4'h2 : 4'h1;
                end
            4'h2: // DIPR2
                begin
                    {caddr, wr_data} <= {ADDR_S_VALID, ADDR_OP_WR, 10'h216, dest_ip[15:0]};
                    _s0_tx_state <= op_status ? 4'h3 : 4'h2;
                end
            4'h3: // DPORTR
                begin
                    {caddr, wr_data} <= {ADDR_S_VALID, ADDR_OP_WR, 10'h212, dest_port};
                    _s0_tx_state <= op_status ? 4'h6 : 4'h3;
                end
            4'h6: //TX_FIFOR
                begin
                    {caddr, wr_data} <= {ADDR_S_VALID, ADDR_OP_WR, 10'h22e, tx_data};
                    _s0_tx_state <= op_status ? 4'h7 : 4'h6;
                end
            4'h7: // buff_addr++
                begin
                    tx_buffer_addr <= tx_buffer_addr + 1'b1;
                    // FIXME: tx_buffer_addr might overflow!
                    _s0_tx_state <= (tx_buffer_addr + 1'b1 == tx_data_size >> 1) ? 4'h4 : 4'h6;
                end
            4'h4: // WRSR0
                begin
                    {caddr, wr_data} <= {ADDR_S_VALID, ADDR_OP_WR, 10'h220, tx_data_size[31:16]};
                    _s0_tx_state <= op_status ? 4'h5 : 4'h4;
                end
            4'h5: // WRSR2
                begin
                    {caddr, wr_data} <= {ADDR_S_VALID, ADDR_OP_WR, 10'h222, tx_data_size[15:0]};
                    _s0_tx_state <= op_status ? 4'h8 : 4'h5;
                end
            4'h8: // CR
                begin
                    {caddr, wr_data} <= {ADDR_S_VALID, ADDR_OP_WR, 10'h202, 16'h0020};
                    _s0_tx_state <= op_status ? 4'h9 : 4'h8;
                end
            4'h9:
                _status_2[0] <= 1'b1;
            default: ;
        endcase
    endtask
//
//    task w5300_udp_rx;
//    endtask

endmodule

// EOF
