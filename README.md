# Wiznet W5300 Driver, Powered by SystemVerilog

<p>
<img src='https://img.shields.io/badge/License-MIT-informational?style=flat-square'>
<img src=https://img.shields.io/badge/FPGA-SystemVerilog-green.svg?style=flat-square>
<img src=https://img.shields.io/badge/Tools-Python3-yellow.svg?logo=python&style=flat-square>
<img src=https://img.shields.io/badge/Powered_by-Hog-orange.svg?style=flat-square>
</p>

### Preface

[W5300](https://www.wiznet.io/product-item/w5300/) is a TCP/IP controller, manufactured by [WizNet Inc.](https://wiznet.io/), which could be applied for Ethernet with TCP, UDP or PPPoE protocol based on IPv4.

This driver is planned to implement UDP communication in a LAN, with Intel Cyclone IV series. The FPGA chip is EP4CE10F17C8, with other hardware suites to debug or finish this design.

Why SystemVerilog? I chose it after reading [*synthensizing SystemVerilog, Busting the Myth that SystemVerilog is only for Verification*](https://www.sutherland-hdl.com/papers/2013-SNUG-SV_Synthesizable-SystemVerilog_paper.pdf).

And this project is based on project [HDL on Git](https://hog.readthedocs.io/en/2023.1/index.html), a.k.a *Hog*, a resolution for managing HDL project by Git. I used it to (re)generate the project configuration of Intel Quartus. Due to some reason, the synthensizing is supported only.

### References

1. [W5300 datasheet v1.3.4e](https://www.wiznet.io/wp-content/uploads/wiznethome/Chip/W5300/Documents/W5300_DS_V134E.pdf)
2. [RFC 768: UDP Datagram Protocol](https://www.rfc-editor.org/rfc/rfc768)
3. [Hog: HDL on git](https://hog.readthedocs.io/en/2023.1/index.html)
