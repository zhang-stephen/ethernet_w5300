# Wiznet W5300 Driver, Powered by SystemVerilog

<p>
<img src='https://img.shields.io/badge/License-MIT-informational?style=flat-square'>
<img src=https://img.shields.io/badge/HDL-SystemVerilog-green.svg?style=flat-square>
<img src=https://img.shields.io/badge/Tools-Python3-yellow.svg?logo=python&style=flat-square>
<img src=https://img.shields.io/badge/Powered_by-Hog-orange.svg?style=flat-square>
</p>

### Preface

[W5300](https://www.wiznet.io/product-item/w5300/) is a TCP/IP controller, manufactured by [WizNet Inc.](https://wiznet.io/), which could be applied for Ethernet with TCP, UDP or PPPoE protocol based on IPv4.

This driver is planned to implement TCP communication in a LAN, with Intel Cyclone IV series. The FPGA chip is EP4CE10F17C8, with other hardware suites to debug or finish this design.

Why SystemVerilog? I chose it after reading [*synthensizing SystemVerilog, Busting the Myth that SystemVerilog is only for Verification*](https://www.sutherland-hdl.com/papers/2013-SNUG-SV_Synthesizable-SystemVerilog_paper.pdf).

And this project is based on project [HDL on Git](https://hog.readthedocs.io/en/2023.1/index.html), a.k.a *Hog*, a resolution for managing HDL project by Git. I used it to (re)generate the project configuration of Intel Quartus. Due to some reason, the synthensizing is supported only.

### Usage

Clone this repo, change the cwd to root directory of it, and run this command(use git bash if on windows):

```bash
./hog/CreateProject.sh w5300
```

Then the Quartus Project File(.qpf) could be found in `Project/w5300/`.

#### Limitations

This is a simple design, and I have to abandon some features of w5300 itself with time issue. The followings are what supported or not supported:

- Supported:
    - 16-bit data bus
    - IRQ Handler(except PPPoE IRQ)
    - TCP server

- Not Supported:
    - PPPoE Mode(never, it is designed for LAN communication)
    - BRDY pins(never, due to hardware suite limitation)
    - 8-bit data bus(never, due to hardware suite limitation)
    - UDP(single-cast & multi-cast, ongoing)
    - TCP client(no plan)
    - Indirect Address Mode(no plan)
    - multi-socket(no plan)

#### Instantiation

The top module of w5300 driver is named as `w5300_driver_entry`, which is required by user only. The declaration and port definitions are following:

```verilog
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
    input logic clk,            // driver clock, 100MHz is perferred
    input logic rst_n,          // system reset

    // w5300 physical ports
    output logic w_rst_n,       // w5300 reset
    output logic cs_n,          // chip select
    output logic rd_n,          // read enable
    output logic wr_n,          // write enable
    output logic [9: 0] addr,   // address to w5300
    input  logic int_n,         // interrupt indicator
    inout  tri   [15:0] data,   // data from/to w5300

    // dataflow ports
    input  logic eth_tx_req,                                        // tx request, active low
    input  logic [16:0] eth_tx_bytes,                               // length of tx data, in bytes
    output logic [ETH_TX_BUFFER_WIDTH - 1:0] eth_tx_buffer_addr,    // address to tx data buffer
    input  logic [15:0] eth_tx_buffer_data,                         // data from tx data buffer
    output logic eth_rx_req,                                        // rx request, active high, could be used as WE_n for rx data buffer
    output logic [16:0] eth_rx_bytes,                               // length of rx data, in bytes
    output logic [ETH_RX_BUFFER_WIDTH - 1:0] eth_rx_buffer_addr,    // address to rx data buffer
    output logic [15:0] eth_rx_buffer_data,                         // data to rx data buffer
    output logic eth_op_state                                       // driver IDLE state, active high
);
    // ...
endmodule
```

#### Tranporting

I think it's easy to transport the  driver, only the SystemVerilog source files, under [src/w5300](src/w5300/), are required. And they are not implemented with any exclusive features of Intel FPGA chips.

How to transport:
 - copy `src/w5300` to your project,
 - instantiete the driver `module w5300_driver_entry`,
 - create data buffers for Tx/Rx, e.g. use RAM IP core provided by vendor, and connect them to the driver instance.

But there might be some exceptions, if you are using VHDL. I am not familiar with VHDL and cannot provide any help on it.

#### Simulation

Due to [limitation of Hog](https://hog.readthedocs.io/en/2023.1/02-User-Manual/01-Hog-local/02b-Simulation.html#), the simulation workflow of Quartus is not supported. But users could create testbenches in Quartus manually. Entries for testbench should be fould in `testbench/src/` and they are named with pattern `tb_<module>.sv`.

The common dependency is `src/w5300/defs.sv`, which is required by all of testbenches.

testbench | submodule
--- | ---
`tb_if.sv` | `if.sv`
`tb_config_common.sv` | `config.sv`
`tb_config_socket.sv` | `config.sv`
`tb_irq.sv` | `irq.sv`
`tb_transmitter.sv` | `tranmitter.sv`
`tb_tick.sv` | `tick.sv`(*not used in the driver*)

### Hardware

There is few hardware suite used, including LEDs, keys, and W5300 itself. All pin allocation could be found in [here](./Top/w5300/post-creation-hooks/pins.tcl), and it's used to restore whole Quartus Prime project, see [here](#Usage).

#### Clock Source And Power Supplies

The Cyclone IV chip is driven by a 50MHz oscillator, and it is boosted up to 100MHz for W5300 interface. The core voltage supply for the chip itself is 1.2V, for IO banks is 3.3V, that means the the 3.3V LVTTL/LVCMOS is compatible for the chip.

The pin of oscillator input is E1, and the pin of the reset key is N13.

#### W5300 Suite

The W5300 I used is a individual board and it is connected to FPGA board by DuPont Lines. And there is a extra port to control bus tranceivers, which are used to isolate the W5300 and FPGA IOs.

W5300 is driven by a 25MHz oscillator, and the clock is boosted up to 150MHz in W5300 itself. 3.3V power supplies are preferred.

List of Pins occupied by w5300.

rst_n | cs_n | rd_n | wr_n | int_n
--- | --- | --- | --- | ---
B3 | B4 | A4 | B5 | A3

addr[9] | addr[8] | addr[7] | addr[6] | addr[5] | addr[4] | addr[3] | addr[2] | addr[1] | addr[0]
--- | --- | --- | --- | --- | --- | --- | --- | --- | ---
B10 | A9 | B9 | A8 | B8 | A7 | B7 | A6 | B6 | A5

data[15] | data[14] | data[13] | data[12] | data[11] | data[10] | data[9] | data[8] | data[7] | data[6] | data[5] | data[4] | data[3] | data[2] | data[1] | data[0]
--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---
E8 | E9 | C8 | D8 | E7 | F8 | D6 | C6 | A13 | D5 | A12 | B13 | A11 | B12 | A10 | B11


#### LEDs

*NOT implemented.*

There are 4 LEDs, used as status indicator. LED0 blinks when FPGA is running normally in 500ms period. LED1 - LED3 indicate the error status of W5300.

LED0 | LED1 | LED2 | LED3
--- | --- | --- | ---
E10 | F9 | C9 | D9

The LEDs will light up when the IOs were put high level.

*to be done: error list*

### References

1. [W5300 datasheet v1.3.4e](https://www.wiznet.io/wp-content/uploads/wiznethome/Chip/W5300/Documents/W5300_DS_V134E.pdf)
2. [RFC 768: UDP Datagram Protocol](https://www.rfc-editor.org/rfc/rfc768)
3. [Hog: HDL on git](https://hog.readthedocs.io/en/2023.1/index.html)
