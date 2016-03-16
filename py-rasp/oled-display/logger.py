#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# About  : Logger
# Date   : 2016-03-09
# Author : Xiang,Zuo
# E-Mail : xianglinks@gmail.com
"""

import logging

# creat logger
logger = logging.getLogger("display_logger")
logger.setLevel(logging.DEBUG)

# --- creat handlers ---
# ---------------------------------
# handler for logging in terminal
sh = logging.StreamHandler()
sh.setLevel(logging.INFO)
# handler for logging in file
log_file_path = './display.log'
fh = logging.FileHandler(log_file_path)
fh.setLevel(logging.DEBUG)
# ---------------------------------

# --- create formatter ---
# ---------------------------------
# formatter for terminal handler
shfmt = logging.Formatter('%(message)s')
sh.setFormatter(shfmt)

# formatter for file handler
fmt = "%(asctime)-15s %(levelname)s %(filename)s %(lineno)d %(process)d %(message)s"
datefmt = "%a %d %b %Y %H:%M:%S"
fhfmt = logging.Formatter(fmt, datefmt)
fh.setFormatter(fhfmt)
# ---------------------------------

# --- add handler to logger ---
logger.addHandler(sh)
logger.addHandler(fh)
