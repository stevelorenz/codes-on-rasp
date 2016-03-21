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

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <wiringPiI2C.h>

#include "ssd1306_i2c.h"

// --- functions ---

// send command byte to SSD1306
void sendCommand(int fd, unsigned char command)
{
    // write 8 bits data value to the given register
    int re;
    re = wiringPiI2CWriteReg8(fd, SSD1306_CONTROL_REG, command);
    if (re == -1) {
        printf("I2C write operation failed with errno:%d\n", errno);
        exit(1);
    }
}

// send data byte to SSD1306
void sendChar(int fd, unsigned char data)
{
    // write 8 bits data value to the given register
    int re;
    re = wiringPiI2CWriteReg8(fd, SSD1306_DATA_REG, data);
    if (re == -1) {
        printf("I2C write operation failed with errno:%d\n", errno);
        exit(1);
    }
}

/**
 * @brief: init I2C interface and SSD1306 Driver
 * @return: a standard file descriptor
 */
int ssd1306I2CSetup(void)
{
    // init I2C interface
    int fd;
    fd = wiringPiI2CSetup(SSD1306_I2C_ADDRESS);
    // if init failed
    if ( fd == -1) {
        printf("I2C interface init failed, with errno\n", errno);
        exit(1);
    }

    // init SSD1306 settings
    sendCommand(fd, SSD1306_DISPLAYOFF);  // Display off
    sendCommand(fd, SSD1306_MULTIPLEX_RATIO);  // Set Multiplex Ratio
    sendCommand(fd, 0x3F);

    sendCommand(fd, 0xD3);  // Set Display Offset
    sendCommand(fd, 0x00);  // no Offset

    sendCommand(fd, 0x40);  // Set display Start Line

    sendCommand(fd, 0xA1);  // Set Segment Re-Map

    sendCommand(fd, 0xC8);  // Set COM Output Scan Direction

    sendCommand(fd, 0xDA);  // Set COM Pins Hardware Configuration
    sendCommand(fd, 0x12);

    sendCommand(fd, 0x81);  // Set Contrast Control
    sendCommand(fd, 0x7F);

    sendCommand(fd, 0xA4);  // Set Entire Display On/Off

    sendCommand(fd, 0xA6);  // Set Normal/Inverse Display

    sendCommand(fd, 0xD9);  // Set Pre-Charge Period
    sendCommand(fd, 0xF1);  // Snternal

    sendCommand(fd, 0xDB);  // Set VCOMH Deselect Level
    sendCommand(fd, 0x40);

    sendCommand(fd, 0xD5);  // Set Display Clock Divide Ratio\Oscilator Frequency
    sendCommand(fd, 0x80);  // the suggested ratio 0x80

    sendCommand(fd, 0x8D);  // Set Charge Pump

    sendCommand(fd, 0x14);  // Vcc internal

    sendCommand(fd, 0x00);  // Set Lower Column Start Address

    sendCommand(fd, 0x10);  // Set Higher Column Start Address

    sendCommand(fd, 0xB0);  // Set Page Start Address for Page Addressing Mode

    // 00 - Horizontal Addressing Mode
    // 01 - Vertical Addressing Mode
    // 02 - Page Addressing Mode
    sendCommand(fd, 0x20);  // Set Memory Addressing Mode
    sendCommand(fd, 0x00);

    sendCommand(fd, 0x21);  // Set Column Address (only for horizontal or vertical mode)
    sendCommand(fd, 0x00);
    sendCommand(fd, 0x7F);

    sendCommand(fd, 0x22);  // Set Page Address
    sendCommand(fd, 0x00);
    sendCommand(fd, 0x07);

    sendCommand(fd, 0x2E);  // Deactivate Scroll

    sendCommand(fd, 0xAF);  // Set Display On

    return fd;  // return file descriptor
}
