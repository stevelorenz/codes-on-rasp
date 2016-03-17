#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : UDP Server
           Recieve Message and display it on OLED
# Date   : 2016-03-17
# Author : Xiang,Zuo
# E-Mail : xianglinks@gmail.com
"""

import socket
from sys import exit

from oled import OLED


# --- main function ---
def main():
    try:
        # init UDP socket
        UDP_IP = ''  # recieve from all IPs
        UDP_PORT = 8008
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.bind((UDP_IP, UDP_PORT))
        print('Bind UDP socket on %d' % UDP_PORT)

        # init class for OLED display
        oled = OLED(rst=24, i2c_addr=0x3C)
        oled.start()  # start display
        # set font face and size
        oled.set_text_style('monaco.ttf', fontsize=20, position=(10, 10))

        # recieve loop
        while True:
            data, addr = sock.recvfrom(1024)
            oled.display_text(data)  # display text on display

    except KeyboardInterrupt:
        print('\nKeyboardInterrupt, exit')
        oled.off()  # turn off display
        exit(0)

if __name__ == "__main__":
    main()
