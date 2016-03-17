#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : UDP Clinet
           Read Tmp value using TMP64 and send it using UDP
# Date   : 2016-03-17 14:59
# Author : Xiang,Zuo
# E-Mail : xianglinks@gmail.com
"""

import socket
from sys import exit
from time import sleep

from logger import logger
from tmp64 import TMP64


# --- main function ---
def main():
    try:
        # init UDP socket
        UDP_IP = '127.0.0.1'
        UDP_PORT = 8008
        logger.info('creat socket with ip %s and port %d' %(UDP_IP, UDP_PORT))
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

        # creat tmp object
        tmp = TMP64()
        delay = 2  # define delay(seconds) between the measurements

        # loop for temperature measurements
        while True:
            tmpValue = tmp.readTmpValue()  # get tmp value
            tmpValueStr = str(tmpValue)  # convert to string
            sock.sendto(tmpValueStr, (UDP_IP, UDP_PORT))
            sleep(delay)

    except KeyboardInterrupt:
        print('\nKeyboardInterrupt, exit')
        exit(0)

if __name__ == "__main__":
    main()
