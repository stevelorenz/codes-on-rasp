/*
 * About  : Print Hello Wolrd on screen
 * Date   : 2015-12-03 21:06:22 
 * Author : Xiang, Zuo
 * Email  : xianglinks@gmail.com
 */
 
/* -- Data Section -- */
.data
.balign 4 

/* define for strings */
msg1: .asciz "Hello Wolrd\n"

/* -- Code Section -- */
.text
.balign 4

.extern printf
.equ

.global main
.func main

main:
  push {r4-r11, lr}
  
  ldr r0, =msg1
  bl printf

end_main:
  mov r0, #0
  pop {r4-r11, pc}

