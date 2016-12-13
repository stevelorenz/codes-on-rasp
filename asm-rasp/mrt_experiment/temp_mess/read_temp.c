/*************************************************************************
	> About: Get the digitized value of temp-sensor on Rpi with MCP3008-ADC
	> Author: Xiang,Zuo
	> Mail: xianglinks@gmail.com
	> Created Time: 2015-12-04 15:07:52
	> Version: 1.0
 ************************************************************************/

#include <wiringPi.h>
#include <mcp3004.h>
#include <stdio.h>
#include <stdlib.h>

#define BASE 200
#define SPI_CHAN 0

/**
 * @brief init_mcp
 * init wiringpi settings and MCP3008-ADC
 * this function should be called by initialisation only once (avoiding pin overlapping)
 */
void init_mcp(void) {
    if(wiringPiSetup () == -1) {
        printf("init do not work. aborting...\n");
        exit(1);
    }
    // init MCP3008-ADC(using SPI-Dev on channel 0)
    mcp3004Setup (BASE, SPI_CHAN);
}

/**
 * @brief read_temp
 * read the digitized temp-value from sensor
 *
 * @return
 * int temp
 */
int read_temp(void) {
    int value;
    float volts, temp;
    value = analogRead(BASE);
    // caculate the temperature
    volts = (value * 3.3) / 1024.0;
    temp = (volts - 0.5) * 100;
    // convert float temp-value to a integer
    temp = (int)temp;
    return temp;
}
