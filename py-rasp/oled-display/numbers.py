#!/usr/bin/env python
# -*- coding: utf-8 -*-
# #########################################################
# About  : Using OLED to display numbers
# Date   : 2016-03-07
# Author : Xiang,Zuo
# E-Mail : xianglinks@gmail.com
# #########################################################

import Adafruit_SSD1306

# --- Initialization ---
# ---------------------------------------------------------
# setup reset pin.
RST = 24

# 128x64 display with hardware I2C (init class)
disp = Adafruit_SSD1306.SSD1306_128_64(rst=RST)

disp.begin()  # init the display

# disp.display() write the contents in buffer to physical display

disp.clear()  # clear contents of display buffer
disp.display()

# get width and height of the display
width = disp.width
height = disp.height
# ---------------------------------------------------------
