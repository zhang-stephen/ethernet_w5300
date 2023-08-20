#!/bin/python3

# Reference: https://docs.python.org/zh-cn/3/library/socket.html

import socket
import time
import hashlib

SERVER_ADDR = ('192.168.22.111', 6588)

if __name__ == '__main__':
    client = socket.socket(socket.AF_INET)
    client.settimeout(15)
    client.connect(SERVER_ADDR)

    n = 1

    while (True):
        client.send(b'01100 01100 01100 ')

        try:
            rex = client.recv(400)
            print(f'data received, No.{n}, length = {len(rex)}, md5 = 0x{hashlib.md5(rex).hexdigest()}, content:')
            n += 1
            print(rex.hex('_'))
        except (socket.timeout, KeyboardInterrupt):
            print('timeout!')
            client.close()
            break

        time.sleep(0.02) # per 20ms
