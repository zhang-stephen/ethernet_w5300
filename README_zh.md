# Wiznet W5300 Driver, Powered by SystemVerilog

<p>
<img src='https://img.shields.io/badge/Version-0.1.0-sea?style=flat-square'>
<img src='https://img.shields.io/badge/License-MIT-informational?style=flat-square'>
<img src=https://img.shields.io/badge/HDL-SystemVerilog-green.svg?style=flat-square>
<img src=https://img.shields.io/badge/Tools-Python3-yellow.svg?logo=python&style=flat-square>
<img src=https://img.shields.io/badge/Powered_by-Hog-orange.svg?style=flat-square>
</p>

### 前言

[W5300](https://www.wiznet.io/product-item/w5300/)是一种由韩国[WizNet公司](https://wiznet.io/)制造的TCP/IP控制器，可以被应用在基于以太网的TCP、UDP以及PPPoE通信，使用IPv4协议。

该项目原计划实现基于Intel Cyclone IV系列FPGA的局域网通信。使用的FPGA芯片是EP4CE10F17C8，以及一些其他必要的硬件。

为什么是SystemVerilog？最近恰好拜读了[*synthensizing SystemVerilog, Busting the Myth that SystemVerilog is only for Verification*](https://www.sutherland-hdl.com/papers/2013-SNUG-SV_Synthesizable-SystemVerilog_paper.pdf)，然后就选择了它。

此外，该项目基于[HDL on Git](https://hog.readthedocs.io/en/2023.1/index.html)，简称*Hog*，它是一种使用git进行HDL项目管理的解决方案。它在该项目中被用于（重）生成Quartus项目文件。由于某些原因，它生成的项目文件只支持综合。

### 使用

将项目克隆到本地，并切换到项目的根目录，然后运行（在Windows下使用git bash）：

```bash
./Hog/CreateProject.sh w5300
```

之后Quartus项目文件(.qpf)就可以在`Project/w5300`下找到。

#### 一些限制

这是一个简单的设计，且由于时间原因，我不得不放弃一些功能的实现。以下是已支持及尚不支持的功能列表：

- 支持：
    - 16位数据总线
    - IRQ处理（除了PPPoE相关的部分）
    - TCP服务器

- 尚不支持：
    - PPPoE模式（不会支持，它被设计用于LAN通信）
    - BRDY引脚（不会支持，硬件设计限制）
    - 8位数据总线（不会支持，硬件设计限制）
    - UDP（单播&多播，计划中）
    - TCP client（暂无计划）
    - 间接地址模式（IAM，暂无计划）
    - 多个socket（暂无计划）

#### 实例化

w5300驱动的顶层模块命名为`w5300_driver_entry`，用户只需实例化它即可。以下是它的声明及端口定义：

```verilog
module w5300_driver_entry #(
    parameter logic [31:0] ip     = {8'd192, 8'd168, 8'd1, 8'd15},  // w5300的IP地址
    parameter logic [15:0] port   = 16'd7000,                       // 端口号
    parameter logic [47:0] mac    = 48'h00_08_dc_01_02_03,          // MAC地址
    parameter logic [7: 0] subnet = 8'd24,                          // 子网掩码长度
    parameter int CLK_FREQ      = 8'd100,                           // 时钟频率，单位MHz
    parameter int ETH_TX_BUFFER_WIDTH = 16,                         // 发送缓冲区的地址宽度
    parameter int ETH_RX_BUFFER_WIDTH = 16                          // 接收缓冲区的地址宽度
)
(
    input logic clk,            // 驱动时钟，推荐使用100MHz
    input logic rst_n,          // 系统复位

    // w5300 physical ports
    output logic w_rst_n,       // w5300复位
    output logic cs_n,          // 片选
    output logic rd_n,          // 读使能
    output logic wr_n,          // 写使能
    output logic [9: 0] addr,   // w5300的寄存器地址
    input  logic int_n,         // 中断指示
    inout  tri   [15:0] data,   // 数据总线

    // dataflow ports
    input  logic eth_tx_req,                                        // 发送请求，低有效
    input  logic [16:0] eth_tx_bytes,                               // 发送数据的长度，单位是字节
    output logic [ETH_TX_BUFFER_WIDTH - 1:0] eth_tx_buffer_addr,    // 发送缓冲区的地址
    input  logic [15:0] eth_tx_buffer_data,                         // 发送缓冲区的数据
    output logic eth_rx_req,                                        // 接收请求，可以用作接收缓冲区的写使能信号，高有效
    output logic [16:0] eth_rx_bytes,                               // 接收数据的长度，单位是字节
    output logic [ETH_RX_BUFFER_WIDTH - 1:0] eth_rx_buffer_addr,    // 接收缓冲区的地址
    output logic [15:0] eth_rx_buffer_data,                         // 接收缓冲区的数据
    output logic eth_op_state                                       // 指示w5300是否在IDLE状态，高有效
);
    // ...
endmodule
```

#### 移植

我认为移植该驱动是比较容易的，只有[src/w5300](src/w5300/)下的SystemVerilog源文件是必须的。且它们不依赖任何Intel FPGA芯片的特有功能。

如何移植：
 - 拷贝`src/w5300`到你的项目中，
 - 实例化驱动顶层模块，
 - 创建接收/发送缓冲区，例如，由FPGA制造商提供的IP核，并将它们连接到驱动实例。

如果你使用VHDL，这可能会略有不同。但是我对VHDL一窍不通，因此无法提供这方面的帮助。

#### 仿真

由于[Hog的限制](https://hog.readthedocs.io/en/2023.1/02-User-Manual/01-Hog-local/02b-Simulation.html#)，Quartus的仿真流程暂不受支持。但是用户可以在Quartus中自行创建testbench。所有的testbench入口都可以在`testbench/src`下找到，且文件名都以`tb_`开头。

所有的testbench均依赖`src/w5300/defs.sv`。

testbench | submodule
--- | ---
`tb_if.sv` | `if.sv`
`tb_config_common.sv` | `config.sv`
`tb_config_socket.sv` | `config.sv`
`tb_irq.sv` | `irq.sv`
`tb_transmitter.sv` | `tranmitter.sv`
`tb_tick.sv` | `tick.sv`(*没有在驱动中使用*)

### 设计

**所有的状态图都可以在[docs/](docs/)找到。**

顶层模块之下包含了数个子模块，让我们一起看一下它们的有限状态机是如何设计的。

顶层模块的状态机如图：

![w5300 driver entry](https://cdn-0.plantuml.com/plantuml/png/RP51Qm8n48Nl_eev5mIXzB9G4UoXNcrlfOIGZ6vmCwcJsTM2FxxiH2MulIqpttilRtQLnRBqiOFJo_DYOJo70TaW2V_E002-dhvXFb_2Xe84s-di-gtpTQ9TsAzJZ8aQEDaWi4jSt80newYanbJtRiddrXwm0QTJunGnFX6gv4vKEH_97L0QO6-y5Gkli3YFIIgeaV9cts43MGUFzhei51-tQ7q3WSGGM2TXGEZIgSAMyCcMSWmYWVODeBH6peRnEE6BsyrvBD7XpRiD-rQfs-Q_RZvabuZG2Lmk825YwkLHjOGjEXpqCOnkcEvB-IGjyfYEpFsFG7AkvwnqtQWwLwbslrF9cI9yHPIfVYQFvJTlszaAoVUn-mC0)

#### `w5300_interface`

显然，w5300的接口与SRAM是很相似的，是一种不带时钟的异步并行接口。

它的状态机如图（system reset在其他图中被省略）：

![w5300 interface](https://cdn-0.plantuml.com/plantuml/png/VP11R_8m38Rl_8ht_Eb3Aqne4eU9wqv3k-p0K1KHTuqKqifs5_7lLqALGJPnQ_m-jXzt8sfOXwD7N3rMLUs24ZVcG3C0sFtRO_wCRHU9NqCgJT-OZ_Kt4j9jQuGMARjwuoPUOWr4unHDnrWEKk3BC_vYFOrSnbRLnAKWpJFsdPqcj_mQewdvglUf2ZBxxVHponfo4gKZ-9oNEdV8B7GNoNRtkD9lzAzPj0vm0dDGzqNmNIpbRh3MVRRPQOs3_5rMzdNNrw96QHgTcUoQ-ilj9M6ivGThr418XxwCsTRXFo9VndJXilhSj5jK-u8kl9oaXGaAdH9uD5HqpNH5-cjeN73Ialq8iQLGZ8X6q0_UayNGZoYB-XDc6mfsEFfl)

对于该接口而言，`ctrl_addr[10]`是一个扩展后的比特，用于指示当前地址应该被读取(0)或者写入(1)。这一点在其他子模块的寄存器查找表中可以看到。

#### `w5300_common_reg_conf`

该模块负责配置w5300的公共寄存器（共13个，启用10个）。

[这里](src/w5300/config.sv)的`CommonRegisters`块中列出了所有需要被配置的寄存器及其值。在此，IPCF、DPUT和FMTU中断被启用，但是它们没有对应得处理程序，因此在中断处理时被忽略。

![w5300 common config](https://cdn-0.plantuml.com/plantuml/png/LS_12i8m30RWUvyYfw62C1bU1ieENZpv02AZTbaNsDBHPkxrRK0HUsb9ln_-D4bib6KQOJrMPTcwm3tvV4rJO0Fvt7SFs9_XoYHaHnrztpg-pHYj4FiQaErpH2WA27ERn0eg_Wdbby1OwxzZWHCSAlDlQbWZ2O8Bh0KWegSa69EoJvgu8sT5aNPTD9bfJqnfm6vZdT0BOI0_R4s3tENjZ35l)

#### `w5300_socket_n_tcp_server_conf`

该模块被用于配置指定的Socket寄存器。寄存器及其有效值可以在[这里](src/w5300/config.sv)的`SockerRegisterLut`块中找到。

![w5300 socket n tcp server](https://cdn-0.plantuml.com/plantuml/png/VP51I_D048Rl-HLpAjyd529LX81Ig3qKYeefU2WbZ9jfEvZCbjr9wyytYzrOqs9EoSwJPzwP7Nj5fqrTmU5sbAQ5j-Q3j912pQxmvFRa2cDbdK3xBAzMC7o0cR0oLk4eliFmUBumknTqMFiCIF2z8XWCmBOgHQNkZuuAkZTapTkseP05reZ2FTm4-bSnm7FsIfA1AuiI5PTtMRfguVJpUdJEXr3XWtHIMKyPADTa6mtaqHG3H6_NFkfYwMzPZtkqGfSoVizqOe7-sfBp7MLmSAm4yMh0qIQqSlviuhOdOVb3vldhoQnHD9_bY-aJ65lNA6Kl_mL5FtJqJERF-VHKSvoRfMI3NUAMa3Ll6eVALc3DmdvBvJyqodk2BM-s_vCnITdKLP8aNm00)

#### `w5300_irq_handler`

该模块用于读取w5300的中断状态和清除中断。当`int_n`引脚被拉低时有效。

该模块有几个端口用于指示当前的中断状态。

`ir_state[7:0]`用于指示哪些中断发生了，它的字段定义如下：

B7 | B6 | B5 | B4 | B3 | B2 | B1 | B0
--- | --- | --- | --- | --- | --- | --- | ---
IPCF | DPUR | FMTU | SOCK_SENDOK | SOCK_TIMEOUT | SOCK_RECV | SOCK_DISCON | SOCK_CON

可以看到前三个比特是公共中断，而其他的比特是socket中断。

另一个命名为`socket[3:0]`的端口则被用于指示socket中断发生在哪个socket上。如果`socket[3]`为零，则没有socket中断发生。

![w5300 irq handler](https://cdn-0.plantuml.com/plantuml/png/ROz1IyKm48Jl_eev2uM2UEb17hnJhdr7aHBIrGJJHBTRwyytAQaGylRKdNuxcRciebcsnMD_VkhxoV7tP7MOFV43qhm-lg5xWKh2iUUFB8oavsjSbXWK3t11fW1jnFqGVDmpMY7eoiqjcayInITHX4BWwabpESfCfHJeK2gVIa5tvlqFFC1auWnetOTj4WxWj46DT_uOxStcjH1swup5UZoLMnFpzYKqDtMAtIrCQcnx3DZP2Q7_VKy3YL1ZqwIbYjs5mhmj_Wy0)


### 硬件

有几个必须的芯片套件用于该项目的开发测试，它们包括数个发光二极管(LED)、按键和w5300。所有引脚的分配都可以在[这里](Top/w5300/post-creation-hooks/pins.tcl)找到。

#### 时钟和电源

Cyclone IV系列的芯片由一个50MHz的有源晶振驱动，在内部，该时钟经由PLL倍频到100MHz，并用于和w5300的通信。该芯片的内核电压是1.2V，IO bank的电压是3.3V，这意味着IO引脚应该被设置为3.3V LVTTL或3.3V LVCMOS模式。

晶振的输入引脚是E1，复位按键的输入是N13。

#### w5300套件

我使用的w5300是一个独立的开发套件，它和FPGA经由杜邦线连接。这里另有一个额外的端口用于控制总线隔离芯片(74LVCH1622245A，用于隔离FPGA IO和w5300引脚)，它不在此处的讨论范围之内。

w5300由一个25MHz的有源晶振驱动，该时钟在芯片内部倍频到150MHz，用于处理网络信号。推荐使用3.3V电压给w5300供电。

w5300使用的FPGA引脚如下：

rst_n | cs_n | rd_n | wr_n | int_n
--- | --- | --- | --- | ---
B3 | B4 | A4 | B5 | A3

addr[9] | addr[8] | addr[7] | addr[6] | addr[5] | addr[4] | addr[3] | addr[2] | addr[1] | addr[0]
--- | --- | --- | --- | --- | --- | --- | --- | --- | ---
B10 | A9 | B9 | A8 | B8 | A7 | B7 | A6 | B6 | A5

data[15] | data[14] | data[13] | data[12] | data[11] | data[10] | data[9] | data[8] | data[7] | data[6] | data[5] | data[4] | data[3] | data[2] | data[1] | data[0]
--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---
E8 | E9 | C8 | D8 | E7 | F8 | D6 | C6 | A13 | D5 | A12 | B13 | A11 | B12 | A10 | B11

### 参考文献

1. [W5300 datasheet v1.3.4e](https://www.wiznet.io/wp-content/uploads/wiznethome/Chip/W5300/Documents/W5300_DS_V134E.pdf)
2. [RFC 9293: Transmission Control Protocol](https://www.ietf.org/rfc/rfc9293.html)
3. [RFC 768: UDP Datagram Protocol](https://www.rfc-editor.org/rfc/rfc768)
4. [Hog: HDL on git](https://hog.readthedocs.io/en/2023.1/index.html)
