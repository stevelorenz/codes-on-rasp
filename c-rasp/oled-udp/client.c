/*************************************************************************
* About  : UDP Client
*          get temperature value and send it to server via UDP
* Author : Xiang,Zuo
* Mail   : xianglinks@gmail.com
* Date   : 2016-03-22
* Ver    : 0.3
**************************************************************************/

#include <math.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>

#include <wiringPi.h>
#include <mcp3004.h>

// --- define constants ---
#define UDP_PORT 9000
#define BUFFSIZE 1024
#define MAXVOLT 3.3
#define DELAY 1

#define BASE 200
#define SPI_CHAN 0


// --- define functions ---
// get temperature value
float read_temp(void);

// flag for keyboard interrupt
static volatile int keepRunning = 1;

// interrupt signal handler
void intHandler(int sig)
{
    keepRunning = 0;
}

// --- main function ---
int main(int argc, char *argv[])
{
    /* catch interrupt signal(SIGINT), i.e. ctrl+c
     * if interrupt detected -> keepRunning = 0
     * */
    signal(SIGINT, intHandler);

    // --- init mcp3008 ADC ---
    // ------------------------------------------
    if(wiringPiSetup () == -1) {
        printf("wiringP init do not work. exiting.\n");
        exit(1);
    }
    // init MCP3008-ADC(using SPI interface on channel 0)
    mcp3004Setup(BASE, SPI_CHAN);
    printf("MCP3008 ADC init done\n");
    // ------------------------------------------

    // -- init UDP socket --
    // ------------------------------------------
    int clientSockFd;
    struct sockaddr_in remote_addr;  // server net_addr struct

    char buffer[BUFFSIZE];  // buffer for data transmitt

    memset(&remote_addr, 0, sizeof(remote_addr)); // clear to zero

    // set remote_addr struct
    remote_addr.sin_family=AF_INET; // use IPv4
    remote_addr.sin_addr.s_addr=inet_addr("127.0.0.1");  // server IP
    remote_addr.sin_port=htons(UDP_PORT);  // UDP port

    // creat UDP socket
    if((clientSockFd = socket(PF_INET, SOCK_DGRAM, 0)) < 0)
    {
        perror("socket");
        exit(1);
    }

    int sin_size;
    sin_size=sizeof(struct sockaddr_in);
    printf("UDP socket init done\n");
    // ------------------------------------------

    // --- main loop ---
    // read tmp value and send it to server
    float tmp; //tmp value
    char tmpChar[6]; // tmp char

    while(keepRunning) {
        tmp = read_temp();  // get tmp value
        sprintf(tmpChar, "%.1f", tmp);  // convert float to string
        strcpy(buffer, tmpChar);  // copy tmp char into buffer
        printf("sending: %s\n", buffer);
        // send data in buffer to server
        int len;
        if((len = sendto(clientSockFd, buffer, strlen(buffer), 0, (struct sockaddr *)&remote_addr, sizeof(struct sockaddr))) < 0)
        {
            perror("sendto");
            exit(1);
        }
        sleep(DELAY);
    }

    // --- routine when interrupt detected ---
    close(clientSockFd);  // close socket
    printf("\nUDP Client closed\n");
    return 0;
}

/**
 * @brief: get temperature using TMP64 sensor and MCP3008 ADC
 *
 * @return: temperature value
 */
float read_temp(void) {
    int value;
    float volt, volt_m, tmp;

    // read digital value from MCP3008
    value = analogRead(BASE);

    // clac the voltage
    volt = (value * MAXVOLT) / 1024.0;

    // convert voltage to temperature
    volt_m = volt * 1000;  //convert V to mV
    tmp = 25 + (volt_m - 750) / 10.0;

    // round the tmp value to 1 decimal places
    tmp = roundf(tmp * 10) / 10;
    return tmp;
}
