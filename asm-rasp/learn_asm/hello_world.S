/*
* About  : 
* Date   :  
* Author : Xiang, Zuo
* Email  : xianglinks@gmail.com
*/
 
/* -- Data Section -- */
.data
string: .asciz "\nHello World!\n"

/* -- Code Section -- */
.text
 
.balign 4
.global main
.func main
/* Use extern functions */
.extern printf

main:
  push {ip, lr}
  ldr r0, =string
  bl printf
  pop {ip, pc}
