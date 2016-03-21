/*************************************************************************
* About  : Test SSD1306 OLED Display Driver Programm
* Author : Xiang,Zuo
* Mail   : xianglinks@gmail.com
* Date   :
* Ver    : 0.1
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "ssd1306_i2c.h"

// --- main function ---
int main(void) {
    int fd = ssd1306I2CSetup();
    return 0;
}
