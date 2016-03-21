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
#include "font.h"

// send command byte to SSD1306
void sendCommand(unsigned char command)
{
    // write 8 bits data value to the given register
    wiringPiI2CWriteReg8(SSD1306_I2C_ADDRESS, SSD1306_CONTROL_REG, command);
}

// send data byte to SSD1306
void sendChar(unsigned char data)
{
    // write 8 bits data value to the given register
    wiringPiI2CWriteReg8(SSD1306_I2C_ADDRESS, SSD1306_DATA_REG, data);
}

void setCursorXY(int row, int col)
{
    sendCommand(0xB0 + (row & 0x0F));  // set page address, row is controlled by page
    sendCommand(0x00 + (8 * col & 0x0F) + 0);  // set low col address
    sendCommand(0x10 + (( 8 * col>>4) & 0x0F));  // set high col address
}

void sendStrXY(const char *string, int X, int Y)
{
    unsigned char i;

    setCursorXY(X, Y);
    while(*string) {
      for(i=0; i<8; i++) {
        sendChar(pgm_read_byte(myFont[*string-0x20] + i));
      }
      *string++;
    }
}

void displayOn(void)
{
    sendCommand(SSD1306_DISPLAYON);
}

void displayOff(void)
{
    sendCommand(SSD1306_DISPLAYOFF);
}

void clearDisplay(void)
{

}

// init I2C interface and SSD1306
void ssd1306I2CSetup(void)
{
    // init I2C interface
    int re;
    re = wiringPiI2CSetup(SSD1306_I2C_ADDRESS);
    if (re == -1) {
        printf("I2C Interface Setup failed.");
        exit(0);
    }

    // init SSD1306 settings
}
