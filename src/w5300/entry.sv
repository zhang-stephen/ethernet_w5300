// w5300 entry module, the top of this driver
// Stephen Zhang
// 2023-08-05

module w5300_driver_entry #(
    parameter logic [31:0] ip     = {8'd192, 8'd168, 8'd1, 8'd15},
    parameter logic [15:0] port   = 16'd7000,
    parameter logic [47:0] mac    = 48'h00_08_dc_01_02_03,
    parameter logic [7: 0] subnet = 8'd24,
    parameter logic CLK_FREQ      = 8'd100,
    parameter logic ETH_TX_BUFFER_WIDTH = 16,
    parameter logic ETH_RX_BUFFER_WIDTH = 16
)
(
    input logic clk,
    input logic rst_n,

    // w5300 physical ports
    output logic w_rst_n,
    output logic cs_n,
    output logic rd_n,
    output logic wr_n,
    output logic [9: 0] addr,
    input  logic int_n,
    inout  tri   [15:0] data,

    // dataflow ports
    input  logic eth_tx_req,
    output logic [ETH_TX_BUFFER_WIDTH - 1:0] eth_tx_buffer_addr,
    input  logic [15:0] eth_tx_buffer_data,
    output logic eth_rx_req,
    output logic [ETH_RX_BUFFER_WIDTH - 1:0] eth_rx_buffer_addr,
    output logic [15:0] eth_rx_buffer_data
);

import common::CLK_REF;
import W5300::WR;
import W5300::RD;

localparam TIMEOUT = 6000 * CLK_FREQ / CLK_REF; // 60us

enum bit [3:0] {
    Initial,
    ConfigCommon,
    ConfigSocket,
    HandShake,
    Idle,
    IrqHandle,
    Transmitting,
    Receiving,
    Error
} statc_c, state_n;

logic if_op_state;
logic [15:0] if_rd_data;
logic [15:0] if_wr_data, common_config_wr_data, socket_config_wr_data, irq_handler_wr_data, eth_tx_wr_data, eth_rx_wr_data;
logic [10:0] if_addr, common_config_addr, socket_config_addr, irq_handler_addr, eth_tx_addr, eth_rx_addr;

always_comb begin : BusSwitcher
    case (state_c)
        ConfigCommon: {if_wr_data, if_addr} <= {common_config_wr_data, common_config_addr};
        ConfigSocket: {if_wr_data, if_addr} <= {socket_config_wr_data, socket_config_addr};
        HandShake:    if_addr               <= {RD, 10'h0fe};
        IrqHandle:    {if_wr_data, if_addr} <= {irq_handler_wr_data, irq_handler_addr};
        Transmitting: {if_wr_data, if_addr} <= {eth_tx_wr_data, eth_tx_addr};
        Receiving:    {if_wr_data, if_addr} <= {eth_rx_wr_data, eth_rx_addr};
        default:      if_addr               <= {RD, 10'h000};
    endcase
end

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state_c <= Initial;
    end
    else begin
        state_c <= state_n;
    end
end

// Submodules
w5300_interface #(
    .CLK_FREQ(CLK_FREQ)
) w5300_interface_inst0(
    .clk(clk),
    .rst_n(rst_n),
    .w_rst_n(w_rst_n),
    .cs_n(cs_n),
    .rd_n(rd_n),
    .wr_n(wr_n),
    .addr(addr),
    .data(data),
    .ctrl_addr(if_addr),
    .ctrl_wr_data(if_wr_data),
    .ctrl_rd_data(if_rd_data),
    .ctrl_op_state(if_op_state)
);

w5300_common_reg_conf #(
    .ip(ip),
    .mac(mac),
    .subnet(subnet)
) w5300_common_reg_conf_inst0(
    .clk(clk),
    .rst_n(rst_n),
    .done(),
    .addr(common_config_addr),
    .wr_data(common_config_wr_data),
    .rd_data(if_rd_data),
    .op_state(if_op_state),
    .enable()
);

w5300_socket_n_tcp_server_conf #(
    .port(port)
) w5300_socket0_tcp_server_conf_inst(
    .clk(clk),
    .rst_n(rst_n),
    .done(),
    .addr(socket_config_addr),
    .wr_data(socket_config_wr_data),
    .rd_data(if_rd_data),
    .op_state(if_op_state),
    .enable()
);

endmodule
