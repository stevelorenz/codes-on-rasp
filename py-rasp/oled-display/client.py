#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : Send Temp Value using UDP
# Date   :
# Author : Xiang,Zuo
# E-Mail : xianglinks@gmail.com
"""
import socket
from sys import exit


def main():
    try:
        # init UDP socket
        UDP_IP = '192.168.12.100'
        UDP_PORT = 8008

        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

        while True:
            message = raw_input('input number:')
            sock.sendto(message, (UDP_IP, UDP_PORT))

    except KeyboardInterrupt:
        print('\nKeyboardInterrupt, exit')
        exit(0)

if __name__ == "__main__":
    main()
