#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Date   :
# Author : Xiang,Zuo
# E-Mail : xianglinks@gmail.com
# Github : stevelorenz

import time
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
GPIO.setup(12, GPIO.OUT)

p = GPIO.PWM(12, 800000)

p.start(0)

try:
    while True:
        p.ChangeDutyCycle(1)

except KeyboardInterrupt:
    pass
p.stop(0)

GPIO.cleanup()
