#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : Recive Number using UDP and display it on OLED
# Date   :
# Author : Xiang,Zuo
# E-Mail : xianglinks@gmail.com
"""

import socket
from sys import exit

from oled import OLED


def main():
    try:
        # init UDP socket
        UDP_IP = ''
        UDP_PORT = 8008

        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.bind((UDP_IP, UDP_PORT))
        print('Bind UDP socket on %d' % UDP_PORT)

        # init class for OLED display
        oled = OLED(24, 0x3C)
        # init font face and size
        oled.init_text('monaco.ttf', 20)

        while True:
            data, addr = sock.recvfrom(1024)
            if data == 'off':
                oled.off()
            else:
                oled.display_float(data)

    except KeyboardInterrupt:
        print('\nKeyboardInterrupt, exit')
        exit(0)

if __name__ == "__main__":
    main()
