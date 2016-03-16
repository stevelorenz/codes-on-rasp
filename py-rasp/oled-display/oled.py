#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : Class for controlling display on OLED with SSD1306 driver
# Date   : 2016-03-16 12:21:47
# Author : Xiang,Zuo
# E-Mail : xianglinks@gmail.com
"""

from time import sleep

from PIL import Image, ImageDraw, ImageFont

import Adafruit_SSD1306
from logger import logger


class OLED(object):

    """ Controll display on OLED """

    # Functions
    def __init__(self, rst=24, i2c_addr=0x3C):
        self.rst = rst
        self.i2c_addr = i2c_addr
        self.disp = Adafruit_SSD1306.SSD1306_128_64(rst=self.rst, i2c_address=self.i2c_addr)
        self.width = self.disp.width
        self.height = self.disp.height
        logger.debug('OLED class init finished')

    def init_text(self, fontname, fontsize=20, x_padding=20):
        self.disp.begin()
        self.disp.clear()
        self.disp.display()
        self.image = Image.new('1', (self.width, self.height))
        self.draw = ImageDraw.Draw(self.image)
        self.font = ImageFont.truetype(fontname, fontsize)
        y_padding = (64 - fontsize) / 2
        self.position = (x_padding, y_padding)
        logger.debug('text display init finished')

    def display_float(self, number):
        self.disp.clear()
        self.disp.display()
        # clear the cotent in the display
        self.draw.rectangle([0, 0, self.width, self.height], outline=0, fill=0)
        self.draw.text(self.position, str(number), font=self.font, fill=255)
        self.disp.image(self.image)
        self.disp.display()
        logger.debug('display float finished')

    def off(self, seconds=3):
        print("The OLED will poweroff after %d seconds" % seconds)
        sleep(seconds)
        self.disp.off()
