/******************************************************************************
 * About  :
 * Date   :
 * Author : Xiang, Zuo
 * Email  : xianglinks@gmail.com
 ******************************************************************************/

/* ---------------- Code Section ---------------- */
.text
.balign 4

.global main
.func main

main:
  push {r4-r11, lr}

  mov r7, #4
  mov r0, #1
  mov r2, #12
  ldr r1,=msg
  swi 0

end_main:
  mov r0, #0
  pop {r4-r11, pc}

addr_number: .


/* ---------------- Data Section ---------------- */
.data
.balign 4

/* define for strings */
msg: .ascii "Hello World\n"
number: .word 4
