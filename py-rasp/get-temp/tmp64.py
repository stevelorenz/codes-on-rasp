#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : Class for TMP64 temperature sensor
# Date   : 2016-03-17
# Author : Xiang, Zuo
# E-Mail : xianglinks@gmail.com
"""

from mcp3008 import MCP3008


class TMP64(object):

    """Class for TMP64 temperature sensor"""

    def __init__(self, port=0, device=0):
        # creat object to control MCP3008 ADC
        self.mcp3008 = MCP3008(port, device)

    def readTmpValue(self, channel=0, places=3):
        """get temperature value"""
        # get voltage from mcp3008
        volt = self.mcp3008.readVoltChannel(channel)
        # convert voltage to temperature
        voltm = volt * 1000
        temp = 25 + (voltm - 750) / float(10)
        # round the temp to specified number of decimal places
        temp = round(temp, places)
        return temp
