/*************************************************************************
* About  : Test SSD1306 OLED Display Driver Programm
* Author : Xiang,Zuo
* Mail   : xianglinks@gmail.com
* Date   :
* Ver    : 0.1
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "ssd1306_i2c.h"

// --- main function ---
int main(void) {
    int fd = ssd1306I2CSetup(0x3C);
	draw_line(1, 1, "tmp is 20 C");
	updateDisplay(fd);
    sleep(2);
    clearDisplay(fd);
    sleep(2);
	draw_line(1, 1, "tmp is 20 C");
	updateDisplay(fd);
    displayOff(fd);
    return 0;
}
