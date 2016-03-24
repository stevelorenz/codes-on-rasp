/*************************************************************************
* About  : Example Programm
*          Blink "hello world" on OLED Display
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

// interrupt signal handler
void intHandler(int sig) {
    keepRunning = 0;
}

// --- main function ---
int main(int argc, char* argv[])
{
    /* catch interrupt signal(SIGINT), i.e. ctrl+c
     * if interrupt detected -> keepRunning = 0
     * */
    signal(SIGINT, intHandler);

    int fd;  // file descriptor for I2C writing
    fd = ssd1306I2CSetup(0x3C);  // init SSD1306 and I2C interface
    displayOn(fd);  // turn on display

    // -- main loop --
    while(keepRunning) {
        // turn on display
        draw_line(1, 1, "hello");
        draw_line(2, 1, "world");
        updateDisplay(fd);
        sleep(1);
        clearDisplay(fd);
    }

    // --- routine when interrupt detected ---
    clearDisplay(fd);
    draw_line(2, 1, "off in 2 sec");
    updateDisplay(fd);
    sleep(2);
    displayOff(fd);

    return 0;
}
