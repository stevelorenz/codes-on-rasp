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

/**
 * @brief: init I2C interface and SSD1306 Driver
 * @return: a standard file descriptor
 */
int ssd1306I2CSetup();

// send command byte to SSD1306
void sendCommand(int fd, unsigned char command);
// send data byte to SSD1306
void sendChar(int fd, unsigned char data);

// OLED settings

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
#define SSD1306_MULTIPLEX_RATIO 0xA8

// registers
#define SSD1306_CONTROL_REG 0x00  // Co = 0, DC = 0
// #define SSD1306_CONTROL_REG 0x80
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
