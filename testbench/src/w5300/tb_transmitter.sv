// testbench for w5300 transmitter
// Stephen Zhang
// 2023-08-09

`timescale 1ns/10ps

module tb_w5300_transmitter;

import W5300::*;

logic clk = 1'b1;
logic rst_n = 1'b1;

always #2 clk <= ~clk;

logic tx_req, tx_done;
logic [8 :0] tx_buffer_addr;
logic [15:0] tx_buffer_data;

logic op_state;
logic idle;
logic [9: 0] addr;
logic [15:0] wr_data, rd_data;



w5300_transmitter #(
    .ETH_TX_BUFFER_WIDTH(9)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .eth_tx_req(tx_req),
    .eth_tx_buffer_data(tx_buffer_data),
    .eth_tx_buffer_addr(tx_buffer_addr),
    .tx_done(tx_done),
    .addr(addr),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .op_state(op_state)
);

assign idle = dut.w5300_tx_idle;

initial begin
    // w5300 busy
    #0 op_state <= 1'b0;

    // reset the dut
    #5 rst_n    <= 1'b0;
    #5 rst_n    <= 1'b1;

    // tx request effective
    #5 tx_req   <= 1'b1;
    #5 op_state <= 1'b1;

    #500 $stop;
end

always_comb begin
    case (tx_buffer_addr)
        9'h000:  tx_buffer_data <= 16'h0000;
        9'h001:  tx_buffer_data <= 16'h000f;
        default: tx_buffer_data <= {$random} % (1 << 16 - 1);
    endcase
end

always_comb begin
    case (addr)
        Sn_TX_FSR0: rd_data <= 16'h0000;
        Sn_TX_FSR2: rd_data <= ~idle ? 16'h00ff : 16'h000e;
        default: rd_data <= 16'h0000;
    endcase
end

endmodule
