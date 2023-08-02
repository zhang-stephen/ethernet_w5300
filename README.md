# Wiznet W5300 Driver, Powered by SystemVerilog

<p>
<img src='https://img.shields.io/badge/License-MIT-informational?style=flat-square'>
<img src=https://img.shields.io/badge/FPGA-SystemVerilog-green.svg?style=flat-square>
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

The the Quartus Project File(.qpf) could be found in `Project/w5300/`.

Due to [limitation of Hog](https://hog.readthedocs.io/en/2023.1/02-User-Manual/01-Hog-local/02b-Simulation.html#), the simulation workflow of Quartus is not supported. But users could create testbenches in Quartus manually. Entries for testbench should be fould in `testbench/src/` and they are named with pattern `tb_<module>.sv`.

### Hardware

There are many hardware suite used, including LEDs, keys, and W5300 itself. All pin allocation could be found in [here](./Top/w5300/post-creation-hooks/pins.tcl), and it's used to restore whole Quartus Prime project, see [here](#Usage)

#### Clock Source And Power Supplies

The Cyclone IV chip is driven by a 50MHz oscillator, and it is boosted up to 100MHz for W5300 interface. The core voltage supply for the chip itself is 1.2V, for IO banks is 3.3V, that means the the 3.3V LVTTL/LVCMOS is compatible for the chip.

The pin of oscillator input is E1, and the pin of the reset key is N13.

#### W5300 Suite

The W5300 I used is a individual board and it is connected to FPGA board by DuPont Lines. And there is a extra port to control bus tranceivers, which are used to isolate the W5300 and FPGA IOs.

W5300 is driven by a 25MHz oscillator, and the clock is boosted up to 150MHz in W5300 itself. 3.3V power supplies are preferred.

*to be done: the pin allocation for w5300 suite.*

#### LEDs

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
