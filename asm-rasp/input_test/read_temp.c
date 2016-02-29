/*************************************************************************
	> About: Read the temperature on Raspberry-Pi with MCP3008-ADC
	> Author: Xiang,Zuo
	> Mail: xianglinks@gmail.com
	> Created Time: 2015-12-04 15:07:52
	> Version: 0.3
 ************************************************************************/

#include <wiringPi.h>
#include <mcp3004.h>
#include <stdio.h>
#include <stdlib.h>

#define BASE 200
#define SPI_CHAN 0

/**
 * @brief init_mcp
 * Init wiringPi Setttings and MCP3008 ADC
 * This should run at the begin only once (avoid Pin overlapping)
 */
void init_mcp(void) {
    // init gpio for wiringPi
    if(wiringPiSetup () == -1) {
        printf("Init do not work. Aborting...\n");
        exit(1);
    }

    // init MCP3008(using SPI-Dev on channel 0)
    mcp3004Setup (BASE, SPI_CHAN);
}


/**
 * @brief read_temp
 * Read the temperature from sensor
 *
 * @return
 * int temp
 */
int read_temp(void) {
    int value;
    float volts, temp;
    // get the digitalized value
    value = analogRead(200);
    // caculate the temperature
    volts = (value * 3.3) / 1024.0;
    temp = (volts - 0.5) * 100;
    // convert temperature to a integer
    temp = (int)temp;
    return temp;
}
