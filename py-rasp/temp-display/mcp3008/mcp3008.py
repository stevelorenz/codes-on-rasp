#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : Class for MCP3008 Analog Digital Converter
# Date   : 2016-03-17
# Author : Xiang,Zuo
# E-Mail : xianglinks@gmail.com
"""

from spidev import SpiDev


class MCP3008(object):

    """Class for MCP3008 ADC"""

    def __init__(self, port=0, device=0):
        self.spi = SpiDev()
        # connect spi object to specified spi device
        self.spi.open(port, device)

    def readValueChannel(self, channel=0):
        """
        read SPI data from MCP3008 on channel -> digital value
            spi.xfer2() send three bytes to the device
                the first byte is 1 -> 00000001
                the second byte is 8 + channel and left shift with 4 bits
                the third byte is 0 -> 00000000
            the device return 3 bytes as responce
        """
        # perform spi transaction
        adc = self.spi.xfer2([1, (8 + channel) <<4, 0])
        # extract value from data bytes
        data = ((adc[1] & 3) << 8) + adc[2]
        return data

    def readVoltChannel(self, channel=0, vmax=3.3, places=5):
        """
        read the digital data from MCP3008 and convert it to voltage
            MCP3008: 10bit ADC -> value in number range 0-1023
            spi value -> voltage
                   0  ->  0v
                1023  ->  vmax
        """
        # read spi digital value
        adc = self.spi.xfer2([1, (8 + channel) <<4, 0])
        data = ((adc[1] & 3) << 8) + adc[2]
        # convert it to voltage
        volts = (data * vmax) / float(1023)
        # round to specified number of decimal places
        volts = round(volts, places)
        return volts
