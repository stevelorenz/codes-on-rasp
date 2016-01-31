/*************************************************************************
	> About: Read Temperature on MCP3008 with Sensor
	> Author: Xiang,Zuo
	> Mail: xianglinks@gmail.com
	> Created Time:
	> Version: 0.1
 ************************************************************************/

#include <wiringPi.h>
#include <mcp3004.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


#define BASE 200
#define SPI_CHAN 0

int main(void) {
    int chan;
    int x;
    printf ("Raspberry Pi wiringPi test program\n") ;

    if (wiringPiSetup () == -1)
        exit (1) ;

    mcp3004Setup (BASE, SPI_CHAN); // 3004 and 3008 are the same 4/8 channels

    /* for (chan = 0 ; chan < 8 ; ++chan) { */
        /* x = analogRead(BASE + chan) ; */
        /* printf("%d\n", x); */
    /* } */

    while(1) {
      x = analogRead(200);
      float volts = (x * 3.3) / 1024.0;
      float temperature;
      temperature = (volts - 0.5) * 100;
      printf("The Temperature is %f Celsius\n", temperature);
      sleep(3);
    }

    return 0;
}
