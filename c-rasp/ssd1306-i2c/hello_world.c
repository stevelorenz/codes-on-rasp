/*************************************************************************
* About  : Example Programm
*          Print "hello world" on OLED Display
* Author : Xiang,Zuo
* Mail   : xianglinks@gmail.com
* Date   : 2016-03-22
* Ver    : 0.1
**************************************************************************/

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "ssd1306_i2c.h"

// flag for keyboard interrupt
static volatile int keepRunning = 1;

// signal handler
void intHandler(int sig) {
    keepRunning = 0;
}

// --- main function ---
int main(void) {

    /* ctrl + c as interrupt signal
     * if interrupt detected -> keepRunning = 0
     * */
    signal(SIGINT, intHandler);

    int fd;  // file descriptor for I2C writing
    fd = ssd1306I2CSetup(0x3C);  // init SSD1306 and I2C interface
    displayOn(fd);

    // -- main loop --
    while( keepRunning ) {
        // turn on display
        draw_line(1, 1, "hello");
        draw_line(2, 1, "world");
        updateDisplay(fd);
        sleep(2);
        clearDisplay(fd);
        sleep(2);
    }
    // turn off display
    displayOff(fd);

    return 0;
}
