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
    printf("OLED display init finished\n");
    // ------------------------------------------

    // init socket
    // ------------------------------------------
    struct sockaddr_in server_addr;  // server net_addr struct: ipv4
    struct sockaddr_in remote_addr;  // client net_addr struct: ipv4
    char buffer[BUFSIZ];  // buffer for data trans BUFSIZ defined in stdio.h (1024 for gcc)
    memset(&server_addr, 0, sizeof(server_addr));  // clear to zero
    // set server socket struct
    server_addr.sin_family = AF_INET;  // use IP
    server_addr.sin_addr.s_addr = INADDR_ANY;  // recive from any IP
    server_addr.sin_port = htons(8000);  // udp port

    int serverSockFd;  // server socket file descriptor

    // creat server_socket
    if ((serverSockFd = socket(PF_INET, SOCK_DGRAM, 0)) < 0 ) {
        // creat failed
        perror("socket");
        exit(1);
    }

    // bind server_socket to server_addr struct
    if (bind(serverSockFd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr)) < 0) {
        perror("bind");
        exit(1);
    }

    int sin_size = sizeof(struct sockaddr_in);
    printf("Server UDP socket init and bind finished\n");
    // ------------------------------------------

    // -- main loop: recive tmp value and show on OLED --
    int len;  // data len for recived data
    while( keepRunning ) {
        // use revfrom function to get data from client
        if ((len=(recvfrom(serverSockFd, buffer, BUFSIZ, 0, (struct sockaddr *)&remote_addr, &sin_size))) < 0) {
            perror("revfrom");
            exit(1);
        }

        buffer[len] = '/0';
        printf("recieve: %s", buffer);

        close(serverSockFd);  // close server socket

        /* draw_line(1, 1, "hello"); */
        /* draw_line(2, 1, "world"); */
        /* updateDisplay(fd); */
        /* sleep(2); */
        /* clearDisplay(fd); */
        /* sleep(2); */
    }

    /* when keyboardinterrupt detected
     * keepRunning == 0
     * */
    displayOff(fd);   // turn off display

    return 0;
}
