#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : UDP Server
           Recieve temperature message and display it on OLED
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

        # init control object for OLED display
        oled = OLED(rst=24, i2c_addr=0x3C)
        oled.on()  # turn on display
        # set font face and size
        """
        for font face you can use the path of your ttf file(just with name if in current dir)
        or you can use truetype fonts in /usr/share/fonts/truetype
        """
        oled.set_text_style('FreeMono.ttf', fontsize=20, position=(10, 10))
        print('OLED init finished')

        # --- recieve loop ---
        while True:
            data, addr = sock.recvfrom(1024)
            oled.display_text(data)  # display text on OLED

    except KeyboardInterrupt:
        print('\nKeyboardInterrupt, exit')
        oled.off()  # turn off display
        exit(0)

    finally:
        # turn off display
        oled = OLED(rst=24, i2c_addr=0x3C)
        oled.off()
        exit(0)

if __name__ == "__main__":
    main()
