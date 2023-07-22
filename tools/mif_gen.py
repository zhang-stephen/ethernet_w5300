#!/bin/python3

# Intel/Altera Memory Initialization File(.mif) generator

import argparse as ap
import random
import sys
from pathlib import Path

MIF_HEADER =[
    '-- Copyright (C) 2017  Intel Corporation. All rights reserved.\n',
    '-- Your use of Intel Corporation\'s design tools, logic functions\n',
    '-- and other software and tools, and its AMPP partner logic\n',
    '-- functions, and any output files from any of the foregoing\n',
    '-- (including device programming or simulation files), and any\n',
    '-- associated documentation or information are expressly subject\n',
    '-- to the terms and conditions of the Intel Program License\n',
    '-- Subscription Agreement, the Intel Quartus Prime License Agreement,\n',
    '-- the Intel FPGA IP License Agreement, or other applicable license\n',
    '-- agreement, including, without limitation, that your use is for\n',
    '-- the sole purpose of programming logic devices manufactured by\n',
    '-- Intel and sold by Intel or its authorized distributors.  Please\n',
    '-- refer to the applicable agreement for further details.\n',
    '\n',
    '-- Quartus Prime generated Memory Initialization File (.mif)\n',
    '\n',
]

MIF_CONTENT_HEAD = 'CONTENT BEGIN\n'
MIF_CONTENT_END = 'END;\n'

_parser = ap.ArgumentParser('Intel/Altera Memory Initialization(.mif) Generator')
_parser.add_argument('-b', '--bits', type=int, default=8, required=False, help='the bit width of memory cells, 8 bits in default')
_parser.add_argument('-d', '--depth', type=int, required=True, help='the number of memory cells')
_parser.add_argument('-r', '--radix', required=False, default='hex', type=str, choices=['dec', 'hex'], help='radix of addr/data. hex in default')
_parser.add_argument('filename', metavar='FILE', type=str, help='path of generated .mif file')


if __name__ == '__main__':
    parsed = _parser.parse_args(sys.argv[1:]) # type: ignore

    bits, depth, radix, filename = parsed.bits, parsed.depth, parsed.radix, parsed.filename

    formatter = lambda num: hex(num)[2:].upper()

    if radix == 'dec':
        formatter = lambda num: str(num)

    with open(Path(filename), 'w', encoding='utf-8') as mif:
        print(f'[{filename}] generating, with {bits} bits, {depth} words and {radix}...')

        mif.writelines(MIF_HEADER)

        mif_config = [
            f'WIDTH={bits};\n',
            f'DEPTH={depth};\n',
            '\n',
            f'ADDRESS_RADIX={radix.upper()};\n',
            f'DATA_RADIX={radix.upper()};\n',
            '\n'
        ]

        mif.writelines(mif_config)

        mif_content = [
            MIF_CONTENT_HEAD
        ]

        for i in range(depth):
            mif_content.append(f'    {formatter(i)}: {formatter(random.randrange(2 ** bits - 1))};\n')

        mif_content.append(MIF_CONTENT_END)

        mif.writelines(mif_content)

# EOF
