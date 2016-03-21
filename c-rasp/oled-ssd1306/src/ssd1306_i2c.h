/*************************************************************************
* About  : SSD1306 OLED Driver Programm(using I2C Interface)
* Author : Xiang,Zuo
* Mail   : xianglinks@gmail.com
* Date   : 2016-03-20
* Ver    : 0.1
**************************************************************************/
#ifndef SSD1306_I2C_H
#define SSD1306_I2C_H

// --- Define functions ---
// ----------------------------------------------
// init I2C interface and SSD1306
void ssd1306I2CSetup(void);

// send command byte to SSD1306
// use unsigned char to express a byte of data
void sendCommand(unsigned char command);
// send data byte to SSD1306
void sendChar(unsigned char data);

// OLED settings
void setCursorXY(int row, int col);
void sendStrXY(const char *string, int X, int Y);

// display operations
void displayOn(void);
void displayOff(void);
void clearDisplay(void);

// ----------------------------------------------

// --- Define constants ----
// infos can be found in SSD1306 datasheet
// ----------------------------------------------
// address
#define SSD1306_I2C_ADDRESS 0x3C

// commands
#define SSD1306_DISPLAYON 0xAF
#define SSD1306_DISPLAYOFF 0xAE
#define SSD1306_NORMALDISPLAY 0xA6
#define SSD1306_INVERTDISPLAY 0xA7

// registers
#define SSD1306_CONTROL_REG 0x00
#define SSD1306_DATA_REG 0x40

// scrolling constants
#define SSD1306_ACTIVATE_SCROLL 0x2F
#define SSD1306_DEACTIVATE_SCROLL 0x2E
#define SSD1306_SET_VERTICAL_SCROLL_AREA 0xA3
#define SSD1306_RIGHT_HORIZONTAL_SCROLL 0x26
#define SSD1306_LEFT_HORIZONTAL_SCROLL 0x27
#define SSD1306_VERTICAL_AND_RIGHT_HORIZONTAL_SCROLL 0x29
#define SSD1306_VERTICAL_AND_LEFT_HORIZONTAL_SCROLL 0x2A
// ----------------------------------------------

#endif /* SSD1306_I2C_H */
