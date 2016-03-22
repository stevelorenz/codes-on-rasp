/*************************************************************************
* About  : UDP Client
*          get temperature value and send it to server via UDP
* Author : Xiang,Zuo
* Mail   : xianglinks@gmail.com
* Date   : 2016-03-22
* Ver    : 0.1
**************************************************************************/

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
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
#define DELAY 1

#define BASE 200
#define SPI_CHAN 0


// define functions
float read_temp(void);

// --- main function ---
int main(int argc, char *argv[])
{
    // --- init mcp3004/8 ADC ---
    // ------------------------------------------
    if(wiringPiSetup () == -1) {
        printf("wiringP init do not work. exiting.\n");
        exit(1);
    }
    // init MCP3008-ADC(using SPI interface on channel 0)
    mcp3004Setup(BASE, SPI_CHAN);
    // ------------------------------------------

    // -- init socket --
    // ------------------------------------------
    int clientSockFd;
    struct sockaddr_in remote_addr;  // server net_addr struct

    char buffer[BUFFSIZE];  // buffer for data transmitt

    memset(&remote_addr, 0, sizeof(remote_addr)); // clear to zero

    // set remote_addr struct
    remote_addr.sin_family=AF_INET; // use IPv4
    remote_addr.sin_addr.s_addr=inet_addr("127.0.0.1");  // server IP
    remote_addr.sin_port=htons(UDP_PORT);  // udp port

    // creat UDP socket
    if((clientSockFd = socket(PF_INET, SOCK_DGRAM, 0)) < 0)
    {
        perror("socket");
        exit(1);
    }

    int sin_size;
    sin_size=sizeof(struct sockaddr_in);
    // ------------------------------------------

    float tmp; //temperature value
    char tmpChar[20];
    // send data to UDP server
    while(1) {
        tmp = read_temp();
        sprintf(tmpChar, "%f", tmp);
        strcpy(buffer, tmpChar);
        printf("sending: %s \n", buffer);
        int len;
        if((len = sendto(clientSockFd, buffer, strlen(buffer), 0, (struct sockaddr *)&remote_addr, sizeof(struct sockaddr))) < 0)
        {
            perror("sendto");
            exit(1);
        }
        sleep(DELAY);
    }

    close(clientSockFd);  // close socket
    return 0;
}

float read_temp(void) {
    int value;
    float volts, temp;
    value = analogRead(BASE);
    // caculate the temperature
    volts = (value * 3.3) / 1024.0;
    temp = (volts - 0.5) * 100;
    return temp;
}
