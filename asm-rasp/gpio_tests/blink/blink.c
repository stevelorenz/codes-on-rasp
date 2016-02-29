/*************************************************************************
	> File Name:
	> Author: Xiang,Zuo
	> Mail: xianglinks@gmail.com
	> Created Time:
	> Version: 0.1
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include<wiringPi.h>

int main(void) {
    int pin = 7;  // define pin number
    if(wiringPiSetup() == -1 ) {
        printf("Setup did not work...");
    }
    pinMode(pin, OUTPUT);  // set the pin to output-mode
    while(1) {
    digitalWrite(pin, 1);
    }

    return 0;
}

