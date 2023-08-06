// Wiznet W5300 IRQ Handler Module
// Stephen Zhang
// 2023-08-05

module w5300_irq_handler(
    input  logic clk,
    input  logic rst_n,

    output logic clear,
    output logic [10:0] addr,
    output logic [15:0] wr_data,
    input  logic [15:0] rd_data,
    output logic [7 :0] ir_state,
    output logic [3 :0] socket,
    input  logic int_n,
    input  logic op_state
);

import W5300::*;

enum bit [3:0] {
    Idle,
    ReadCommonIr,
    ReadSocketIr,
    ClearCommonIr,
    ClearSocketIr
} state_c, state_n;

// basic control
assign clear = (state_c == Idle) ? 1'b1 : 1'b0;

// state machine
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state_c <= Idle;
    end
    else begin
        state_c <= state_n;
    end
end

always_comb begin
    if (!rst_n) begin
        state_n <= Idle;
    end
    else begin
        case (state_c)
            Idle:          state_n <= !int_n ? ReadCommonIr : Idle;
            ReadCommonIr:  state_n <= op_state ? ReadSocketIr : ReadCommonIr;
            ReadSocketIr:  state_n <= op_state ? ClearCommonIr : ReadSocketIr;
            ClearCommonIr: state_n <= op_state ? ClearSocketIr : ClearCommonIr;
            ClearSocketIr: state_n <= op_state ? Idle : ClearSocketIr;
            default:       state_n <= Idle;
        endcase
    end
end

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        ir_state <= 8'd0;
    end
    else begin
        case (state_c)
            ReadCommonIr: ir_state[7:5] <= {rd_data[15:14], rd_data[12]};
            ReadSocketIr: ir_state[4:0] <= rd_data[4:0];
        endcase
    end
end

always_comb begin
    case (state_c)
        ReadCommonIr:  {addr, wr_data} <= {RD, IR, 16'd0};
        ReadSocketIr:  {addr, wr_data} <= {RD, get_socket_n_reg(.baseAddr(Sn_IR), .socketN(socket)), 16'd0};
        ClearCommonIr: {addr, wr_data} <= {WR, IR, 16'hffff};
        ClearSocketIr: {addr, wr_data} <= {WR, get_socket_n_reg(.baseAddr(Sn_IR), .socketN(socket)), 16'hffff};
        default:       {addr, wr_data} <= {RD, 10'h000, 16'd0};
    endcase
end

always_latch begin
    if (!rst_n) begin
        socket <= {1'b0, Socket0};
    end
    else if (state_c == ReadCommonIr) begin
        case (rd_data)
            8'h01: socket <= {1'b1, Socket0};
            8'h02: socket <= {1'b1, Socket1};
            8'h04: socket <= {1'b1, Socket2};
            8'h08: socket <= {1'b1, Socket3};
            8'h10: socket <= {1'b1, Socket4};
            8'h20: socket <= {1'b1, Socket5};
            8'h40: socket <= {1'b1, Socket6};
            8'h80: socket <= {1'b1, Socket7};
            default:
                socket <= {1'b0, Socket0};
        endcase
    end
end

endmodule
