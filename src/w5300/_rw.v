// W5300 read/write status management
// Stephen Zhang
// 2023-03-28

module _w5300_parallel_if_rw(
	// physical ports to w5300
	input rst_n,
	input clk,
	inout tri [15:0] data,
	output reg [9:0] addr,
	output reg cs_n,
	output reg rd_n,
	output reg we_n,
	output reg rw_n,

	// logic control ports
	input [10:0] c_addr,
	input [15:0] c_idata,
	output reg [15:0] c_odata,
	output reg rw_ready		// pull down for r/w operation is ongoing
);

localparam S_RW_IDLE = 3'd0, S_RW_ADDR_SETUP = 3'd1, S_RW_CTRL_SETUP = 3'd2, S_RW_DATA_SETUP = 3'd3, S_RW_CPLT = 3'd4;
localparam ADDR_OP_RD = 1'b1, ADDR_OP_WR = 1'b0;
localparam KEEP_TICKS = 4'd4; // all signal keeps for 4 ticks(40ns for 100MHz)

// Internal Module Registers(all starts with a leading underline)
reg [11:0] _addr;
reg [15:0] _data;
reg [7 :0] _state;
reg [3 :0] _cnt;

always @* begin
	_addr = c_addr;
end

assign data = _data;

always @(posedge clk or negedge rst_n)
	if (!rst_n) begin
		cs_n <= 1'b1;
		rd_n <= 1'b1;
		we_n <= 1'b1;
		rw_n <= 1'b1;
		rw_ready <= 1'b1;
		addr <= 10'bzz_zzzz_zzzz;
		_data <= 16'bzzzz_zzzz_zzzz;
		_state <= S_RW_IDLE;
		_cnt <= 4'd0;
	end
	else case (_state)
		S_RW_IDLE: begin
			_state <= S_RW_ADDR_SETUP;
			_data <= 16'bzzzz_zzzz_zzzz;
			_cnt <= 4'd0;
			cs_n <= 1'b1;
			rd_n <= 1'b1;
			we_n <= 1'b1;
			rw_n <= 1'b1;
			rw_ready <= 1'b1;
			addr <= 10'bzz_zzzz_zzzz;
		end

		S_RW_ADDR_SETUP: begin
			addr <= _addr[9:0];
			rw_ready = 1'b0;
			_state <= S_RW_CTRL_SETUP;
		end

		S_RW_CTRL_SETUP: begin
			cs_n <= 1'b0;
			rw_n <= _addr[10];
			rd_n <= _addr[10] == ADDR_OP_RD ? 1'b0 : 1'b1;
			we_n <= _addr[10] == ADDR_OP_WR ? 1'b0 : 1'b1;
			_state <= S_RW_DATA_SETUP;
		end

		S_RW_DATA_SETUP: begin
			_state <= S_RW_CPLT;

			case (_addr[10])
				ADDR_OP_RD: c_odata <= _data;
				ADDR_OP_WR: _data <= c_idata;
			endcase
		end

		S_RW_CPLT: begin
			if (_cnt < KEEP_TICKS) _cnt = _cnt + 1'b1;
			else _state <= S_RW_IDLE;
		end

		default: _state <= S_RW_IDLE;
	endcase

endmodule

// EOF
