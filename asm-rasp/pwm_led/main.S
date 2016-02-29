/******************************************************************************
 * About  : Hardware Support PWM on Rpi
 * Date   : 2015-12-12 21:37:55
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

end_main:
  mov r0, #0
  pop {r4-r11, pc}


/* ---------------- Data Section ---------------- */
.data
.balign 4

