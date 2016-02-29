/*
* About  : Set a pin of GPIO to 1 
* Date   : 2015-12-01 22:15:50  
* Author : Xiang, Zuo
* Email  : xianglinks@gmail.com
*/
 
/* -- Data Section -- */
.data
.balign 4

/* define for strings */
stMsg: .asciz "Set pin using wiring Pi\n"
errMsg: .asciz "Setup do not work Aborting...\n"
sucMsg: .asciz "Pin 7 is now set to 1\n"

pin: .int 7
OUTPUT = 1

 
/* -- Code Section -- */
.text
.balign 4
.global main
.func main
/* assignment for extern functions */
.extern printf
.extern wiringPiSetup  /* init the pin settings */
.extern pinMode  /* set pin-mode: input or output*/
.extern digitalWrite  /* write digital data into pin */

main:
  /* for function_call */
  push {ip, lr}
  bl wiringPiSetup  /* call wiringPiSetup Function */
  mov r1, #-1
  cmp r1, r0
  bne init
  /* if Setup is wrong: quit the programm */
  ldr r0, =errMsg
  bl printf
  b done

init:
  ldr r0, =pin
  ldr r0, [r0]  /* get the addr of pin*/
  mov r1, #OUTPUT
  bl pinMode
  
  /* set the pin to 1 */
  ldr r0, =pin
  ldr r0, [r0]
  mov r1, #1
  bl digitalWrite
  ldr r0, =sucMsg
  bl printf

/* a always loop for test*/
loopA:
  b loopA

done:
  pop {ip, pc}  /* return the addr into pc */
