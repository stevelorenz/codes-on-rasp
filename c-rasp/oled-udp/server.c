/*************************************************************************
* About  : UDP Server
*          reciver temperature value and show it on the OLED display
* Author : Xiang,Zuo
* Mail   : xianglinks@gmail.com
* Date   : 2016-03-22
* Ver    : 0.1
**************************************************************************/

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>

#include "ssd1306_i2c.h"

// --- define constants ---
#define BUFFSIZE 1024
#define DELAY 1
#define UDP_PORT 9000

// --- catch keyboardinterrupt ---
// flag for keyboard interrupt
static volatile int keepRunning = 1;

// signal handler
void intHandler(int sig) {
    keepRunning = 0;
}

// --- main function ---
int main(int argc, char* argv[]) {

    /* ctrl + c as interrupt signal
     * if interrupt detected -> keepRunning == 0
     * */
    signal(SIGINT, intHandler);

    // init display
    // ------------------------------------------
    int fd;  // file descriptor for I2C writing
    fd = ssd1306I2CSetup(0x3C);  // init SSD1306 and I2C interface
    displayOn(fd);
    // print init info on display
    printf("OLED display init finished\n");
    draw_line(2, 1, "init done");
    updateDisplay(fd);
    sleep(1);  // wait for one second
    clearDisplay(fd);
    // ------------------------------------------

    // init UDP socket
    // ------------------------------------------
    struct sockaddr_in server_addr;  // server net_addr struct: ipv4
    struct sockaddr_in remote_addr;  // client net_addr struct: ipv4
    char buffer[BUFFSIZE];  // buffer for data trans BUFFSIZE defined in stdio.h (1024 for gcc)

    memset(&server_addr, 0, sizeof(server_addr));  // clear to zero
    // set server socket struct
    server_addr.sin_family = AF_INET;  // use IP
    server_addr.sin_addr.s_addr = INADDR_ANY;  // recive from any IP
    server_addr.sin_port = htons(UDP_PORT);  // UDP port

    int serverSockFd;  // server socket file descriptor

    // creat server socket
    if ((serverSockFd = socket(PF_INET, SOCK_DGRAM, 0)) < 0 ) {
        // creat failed
        perror("socket");
        exit(1);
    }

    // bind server socket to server_addr struct
    if (bind(serverSockFd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr)) < 0) {
        perror("bind");
        exit(1);
    }

    int sin_size = sizeof(struct sockaddr_in);

    printf("Server UDP socket init and bind finished\n");
    // print socket init info on display
    draw_line(2, 1, "socket init done");
    updateDisplay(fd);
    sleep(1);
    clearDisplay(fd);
    // ------------------------------------------

    // -- main loop: recive tmp value and show it on display --
    int len;  // data len for recived data
    while( keepRunning ) {
        // use revfrom function to get data from client
        if ((len=(recvfrom(serverSockFd, buffer, BUFFSIZE, 0, (struct sockaddr *)&remote_addr, &sin_size))) < 0) {
            perror("revfrom");
            exit(1);
        }

        buffer[len] = '\0'; // add string flag at the end of buffer
        printf("recieve: %s\n", buffer);

        draw_line(2, 1, buffer);
        updateDisplay(fd);
        sleep(DELAY);
        clearDisplay(fd);
    }

    /* when keyboardinterrupt detected
     * keepRunning == 0
     * */
    clearDisplay(fd);
    // print off info on display
    draw_line(2, 1, "off in 2 seconds");
    updateDisplay(fd);
    sleep(2);
    displayOff(fd);   // turn off display
    close(serverSockFd);  // close server socket
    printf("UDP Server closed\n");

    return 0;
}
