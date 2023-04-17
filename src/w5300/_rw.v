// W5300 read/write status management
// Stephen Zhang
// 2023-03-28

module _w5300_parallel_if_rw
    #(
         parameter CLK_FREQ = 100  // clock frequency(MHz)
     )
     (
         // internal signals
         input rst_n,
         input clk,

         // control ports
         input [10:0] c_addr,
         input [15:0] c_idata,
         output reg [15:0] c_odata,
         output reg rw_ready,       // pull down for r/w operation is ongoing

         // physical ports
         inout tri [15:0] data,
         output reg [9:0] addr,
         output reg cs_n,
         output reg rd_n,
         output reg we_n,
         output reg rw_n
     );

    localparam S_RW_IDLE = 3'd0, S_RW_ADDR_SETUP = 3'd1, S_RW_CTRL_SETUP = 3'd2, S_RW_DATA_SETUP = 3'd3, S_RW_CPLT = 3'd4;
    localparam ADDR_OP_RD = 1'b1, ADDR_OP_WR = 1'b0;
    localparam KEEP_TICKS = 2 * 100 / CLK_FREQ; // all signal keeps for 2 ticks(20ns for 100MHz)

    // Internal Module Registers(all starts with a leading underline)
    reg [11:0] _addr;
    reg [15:0] _data;
    reg [3 :0] _cnt;

    always @*
        _addr = c_addr;

    assign data = _data;

    // Meely 3-stage FSM
    // 0. state decleration
    reg[3:0] _state_n; // next
    reg[3:0] _state_c; // current

    // 1. state switching
    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            _state_c <= S_RW_IDLE;
        else
            _state_c <= _state_n;

    // 2. state switch conditions
    always @*
        if (!rst_n)
            _state_n <= S_RW_IDLE;
        else
            case (_state_c)
                S_RW_IDLE:
                    _state_n <= S_RW_ADDR_SETUP;
                S_RW_ADDR_SETUP:
                    _state_n <= S_RW_CTRL_SETUP;
                S_RW_CTRL_SETUP:
                    _state_n <= S_RW_DATA_SETUP;
                S_RW_DATA_SETUP:
                    _state_n <= S_RW_CPLT;
                S_RW_CPLT:
                    _state_n <= (_cnt < KEEP_TICKS) ? S_RW_CPLT : S_RW_IDLE;
                default:
                    _state_n <= S_RW_IDLE;
            endcase

    // 3. output with sequential block
    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            begin
                cs_n <= 1'b1;
                rd_n <= 1'b1;
                we_n <= 1'b1;
                rw_n <= 1'b1;
                rw_ready <= 1'b1;
                addr <= 10'bzz_zzzz_zzzz;
                _data <= 16'bzzzz_zzzz_zzzz_zzzz;
                _cnt <= 4'd0;
            end
        else
            case (_state_c)
                S_RW_IDLE:
                    begin
                        _data <= 16'bzzzz_zzzz_zzzz_zzzz;
                        _cnt <= 4'd0;
                        cs_n <= 1'b1;
                        rd_n <= 1'b1;
                        we_n <= 1'b1;
                        rw_n <= 1'b1;
                        rw_ready <= 1'b1;
                        addr <= 10'bzz_zzzz_zzzz;
                    end

                S_RW_ADDR_SETUP:
                    begin
                        addr <= _addr[9:0];
                        rw_ready <= 1'b0;
                    end

                S_RW_CTRL_SETUP:
                    begin
                        cs_n <= 1'b0;
                        rw_n <= _addr[10];
                        rd_n <= _addr[10] == ADDR_OP_RD ? 1'b0 : 1'b1;
                        we_n <= _addr[10] == ADDR_OP_WR ? 1'b0 : 1'b1;
                    end

                S_RW_DATA_SETUP:
                    case (_addr[10])
                        ADDR_OP_RD:
                            c_odata <= _data;
                        ADDR_OP_WR:
                            _data <= c_idata;
                    endcase

                S_RW_CPLT:
                    if (_cnt < KEEP_TICKS)
                        _cnt <= _cnt + 1'b1;
            endcase

endmodule

// EOF
