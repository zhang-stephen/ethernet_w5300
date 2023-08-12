// w5300 entry module, the top of this driver
// Stephen Zhang
// 2023-08-05

module w5300_driver_entry #(
    parameter logic [31:0] ip     = {8'd192, 8'd168, 8'd1, 8'd15},
    parameter logic [15:0] port   = 16'd7000,
    parameter logic [47:0] mac    = 48'h00_08_dc_01_02_03,
    parameter logic [7: 0] subnet = 8'd24,
    parameter int CLK_FREQ      = 8'd100,
    parameter int ETH_TX_BUFFER_WIDTH = 16,
    parameter int ETH_RX_BUFFER_WIDTH = 16
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
import W5300::*;

localparam TIMEOUT = 6000 * CLK_FREQ / CLK_REF; // 60us

enum bit [3:0] {
    Initial,
    ConfigCommon,
    HandShake,
    ConfigSocket,
    Idle,
    IrqHandle,
    Transmitting,
    Receiving,
    Error
} state_c, state_n;

// addr bus & data bus for submodules
logic [15:0] if_rd_data;
logic [15:0] if_wr_data, common_config_wr_data, socket_config_wr_data, irq_handler_wr_data, eth_tx_wr_data, eth_rx_wr_data;
logic [10:0] if_addr, common_config_addr, socket_config_addr, irq_handler_addr, eth_tx_addr, eth_rx_addr;

// control signals for submodules
logic if_op_state;
logic common_config_enable, common_config_done;
logic socket_config_enable, socket_config_done;
logic irq_clear, irq_on_socket;
logic [2:0] irq_socket;
logic [2:0] irq_common_state;
logic [4:0] irq_socket_state;

always_comb begin : BusSwitcher
    case (state_c)
        ConfigCommon: {if_wr_data, if_addr} = {common_config_wr_data, common_config_addr};
        ConfigSocket: {if_wr_data, if_addr} = {socket_config_wr_data, socket_config_addr};
        HandShake:    {if_wr_data, if_addr} = {16'd0, RD, IDR};
        IrqHandle:    {if_wr_data, if_addr} = {irq_handler_wr_data, irq_handler_addr};
        Transmitting: {if_wr_data, if_addr} = {eth_tx_wr_data, eth_tx_addr};
        Receiving:    {if_wr_data, if_addr} = {eth_rx_wr_data, eth_rx_addr};
        default:      {if_wr_data, if_addr} = {16'd0, RD, 10'h3fe};
    endcase
end

// control logic
assign common_config_enable = (state_c == ConfigCommon) ? 1'b1 : 1'b0;
assign socket_config_enable = (state_c == ConfigSocket) ? 1'b1 : 1'b0;

// FSM
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state_c <= Initial;
    end
    else begin
        state_c <= state_n;
    end
end

always_comb begin
    if (!rst_n) begin
        state_n = Initial;
    end
    else begin
        case (state_c)
            Initial:      state_n = if_op_state ? ConfigCommon : Initial;
            ConfigCommon: state_n = common_config_done ? HandShake : ConfigCommon;
            HandShake:    state_n = (if_rd_data == IDR_ID) ? ConfigSocket : HandShake;
            ConfigSocket: state_n = socket_config_done ? Idle : ConfigSocket;
            Idle: begin
                if (!eth_tx_req) begin
                    state_n = Transmitting;
                end
                else if (!int_n) begin
                    state_n = IrqHandle;
                end
                else begin
                    state_n = Idle;
                end
            end

            IrqHandle: begin
                if (!int_n) begin
                    state_n = IrqHandle;
                end
                else begin
                    state_n = Idle;
                end
            end

            default: state_n = Initial;
        endcase
    end
end

// always_ff @(posedge clk, negedge rst_n) begin
//     if (!rst_n) begin

//     end
//     else begin

//     end
// end

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
    .done(common_config_done),
    .addr(common_config_addr),
    .wr_data(common_config_wr_data),
    .op_state(if_op_state),
    .enable(common_config_enable)
);

w5300_socket_n_tcp_server_conf #(
    .N(0),
    .port(port)
) w5300_socket0_tcp_server_conf_inst(
    .clk(clk),
    .rst_n(rst_n),
    .done(socket_config_done),
    .addr(socket_config_addr),
    .wr_data(socket_config_wr_data),
    .rd_data(if_rd_data),
    .op_state(if_op_state),
    .enable(socket_config_enable)
);

w5300_irq_handler w5300_irq_handler_inst(
    .clk(clk),
    .rst_n(rst_n),
    .clear(irq_clear),
    .addr(irq_handler_addr),
    .wr_data(irq_handler_wr_data),
    .rd_data(if_rd_data),
    .ir_state({irq_common_state, irq_socket_state}),
    .socket({irq_on_socket, irq_socket}),
    .int_n(int_n),
    .op_state(if_op_state)
);

w5300_transmitter #(
    .N(0),
    .ETH_TX_BUFFER_WIDTH(ETH_TX_BUFFER_WIDTH)
) w5300_transmitter_inst(
    .clk(clk),
    .rst_n(rst_n),
    .eth_tx_req(eth_tx_req),
    .eth_tx_buffer_data(eth_tx_buffer_data),
    .eth_tx_buffer_addr(eth_tx_buffer_addr),
    .addr(eth_tx_addr),
    .wr_data(eth_tx_wr_data),
    .rd_data(if_rd_data),
    .op_state(if_op_state)
);

endmodule
