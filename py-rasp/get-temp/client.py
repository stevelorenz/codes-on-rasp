#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : UDP Clinet
           Read temperature value using TMP64 and send it using UDP
# Date   : 2016-03-17 14:59
# Author : Xiang,Zuo
# E-Mail : xianglinks@gmail.com
"""

import socket
from sys import exit
from time import sleep

from tmp64 import TMP64


# --- main function ---
def main():
    try:
        # init UDP socket
        UDP_IP = '127.0.0.1'
        UDP_PORT = 8008
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        print('creat socket with ip %s and port %d' %(UDP_IP, UDP_PORT))

        # creat tmp object
        # info about SPI device can be found in path: /dev/spidevx.x
        # i.e. /dev/spidev0.0 for port 0 an device 0
        tmp = TMP64(port=0, device=0)

        delay = 2  # define delay(seconds) between the measurements

        #  --- loop for temperature measurements ---
        print('start send temperature message')
        while True:
            tmpValue = tmp.readTmpValue()  # get temperature value
            tmpValueStr = str(tmpValue)
            sock.sendto(tmpValueStr, (UDP_IP, UDP_PORT))  # send tmpValue
            sleep(delay)

    except KeyboardInterrupt:
        print('\nKeyboardInterrupt, exit')
        exit(0)

if __name__ == "__main__":
    main()
