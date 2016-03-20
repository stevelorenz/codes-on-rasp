/*************************************************************************
* About  : SSD1306 OLED Driver Programm(using I2C Interface)
* Author : Xiang,Zuo
* Mail   : xianglinks@gmail.com
* Date   : 2016-03-20
* Ver    : 0.1
**************************************************************************/

/*
 * depend on Wiring Pi library to use I2C Interface
 * more info: http://www.wiringpi.com
 * */

#include <stdio.h>
#include <stdlib.h>
#include <wiringPiI2C.h>

#include "ssd1306_i2c.h"

// send SSD1306 control command using I2C
void sendCommand(unsigned char command)
{
    // write 8 bits data value into the device register
    wiringPiI2CWriteReg8(SSD1306_I2C_ADDRESS, SSD1306_CONTROL_REG, command);
}

// send char to SSD1306
void sendChar(unsigned char data)
{
    // write 8 bits data value into the device register
    wiringPiI2CWriteReg8(SSD1306_I2C_ADDRESS, SSD1306_DATA_REG, data);
}

// init SSD1306 Driver
int ssd1306I2CSetup(void)
{
    int re;
    // init I2C interface
    re = wiringPiI2CSetup(SSD1306_I2C_ADDRESS);
    if (re == -1) {
        printf("I2C Interface Setup failed.");
        exit(0);
    }

    // init SSD1306 settings
}
