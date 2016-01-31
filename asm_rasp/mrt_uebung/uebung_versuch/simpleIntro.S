/*
* About  : 
* Date   :  
* Author : Xiang, Zuo
* Email  : xianglinks@gmail.com
*/
 
/* -- Data Section -- */
.data
/* Ensure variable is 4-byte aligned */
.balign 4 
myVar1:
  .word 0x89ABCDEF  /*Using addr as var*/
 

/* -- Code Section -- */
.text
 
.balign 4
.global main
.func main

main:
  ldr r1, addr_of_myvar1
  ldr r1, [r1]  /* r1 = *myVar1 */
  mov r2, #16
  str r2, [r1]
  bx lr  
 
/* Labels needed to access data */
addr_of_myvar1 : .word myVar1

