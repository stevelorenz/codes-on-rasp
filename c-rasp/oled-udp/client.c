/*************************************************************************
* About  : UDP Client
*          get temperature value and send it to server via UDP
* Author : Xiang,Zuo
* Mail   : xianglinks@gmail.com
* Date   : 2016-03-22
* Ver    : 0.1
**************************************************************************/

#include <string.h>
#include <stdio.h>

#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>

int main(int argc, char *argv[])
{
    int clientSockFd;
    int len;

    struct sockaddr_in remote_addr;  // server net_addr struct

    int sin_size;
    char buffer[BUFSIZ];  // buffer for data transmitt
    memset(&remote_addr,0,sizeof(remote_addr)); //数据初始化--清零
    remote_addr.sin_family=AF_INET; //设置为IP通信
    remote_addr.sin_addr.s_addr=inet_addr("127.0.0.1");//服务器IP地址
    remote_addr.sin_port=htons(8000); //服务器端口号

         /*创建客户端套接字--IPv4协议，面向无连接通信，UDP协议*/
    if((clientSockFd=socket(PF_INET,SOCK_DGRAM,0))<0)
    {
        perror("socket");
        return 1;
    }
    strcpy(buffer,"This is a test message");
    printf("sending: '%s'/n",buffer);
    sin_size=sizeof(struct sockaddr_in);

    /*向服务器发送数据包*/
    if((len=sendto(clientSockFd,buffer,strlen(buffer),0,(struct sockaddr *)&remote_addr,sizeof(struct sockaddr)))<0)
    {
        perror("recvfrom");
        return 1;
    }

    close(clientSockFd);
    return 0;
}
