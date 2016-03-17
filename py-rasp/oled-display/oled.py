#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : Class for controlling display on OLED using SSD1306 driver
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

    def __init__(self, rst=24, i2c_addr=0x3C):
        """init OLED class"""
        # creat objec to controll SSD1306 driver
        self.disp = Adafruit_SSD1306.SSD1306_128_64(rst=rst, i2c_address=i2c_addr)
        # get display size
        self.width = self.disp.width
        self.height = self.disp.height
        logger.debug('OLED init finished')

    def start(self):
        """start OLED Display"""
        # creat image and draw object for text display
        self.image = Image.new('1', (self.width, self.height))
        self.draw = ImageDraw.Draw(self.image)
        # clear contents on display
        self.disp.begin()
        self.disp.clear()
        self.disp.display()
        logger.debug('OLED started')

    def set_text_style(self, fontname='FreeMono.ttf', fontsize=10, position=(0, 0)):
        """set font face and size"""
        self.font = ImageFont.truetype(fontname, fontsize)
        # set font start position(tuple)
        self.position = position

    def display_text(self, text):
        """display text on OLED"""
        # clear the old cotents in the display
        self.disp.clear()
        self.disp.display()
        # draw black rectangle as background
        self.draw.rectangle([0, 0, self.width, self.height], outline=0, fill=0)
        # draw text on rectangle
        self.draw.text(self.position, str(text), font=self.font, fill=255)
        self.disp.image(self.image)
        self.disp.display()
        logger.debug('display text finished')

    def off(self, seconds=3):
        # TODO check if OLED is on

        """turn off OLED in seconds"""
        # print off_message on OLED
        off_message = 'turn off in %d s' % seconds
        self.set_text_style('FreeMono.ttf', 13, (5, 10))
        self.display_text(off_message)
        sleep(seconds)
        self.disp.off()
