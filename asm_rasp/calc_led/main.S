/******************************************************************************
 * About  : Calculate the Addition of Two Numbers inputed by Button and show the
            result using Leds
 * Date   : 2016-01-08 11:48:28
 * Author : Xiang,Zuo
 * Email  : xianglinks@gmail.com
 ******************************************************************************/

/* ---------------- Code Section ---------------- */
.text
.balign 4

/* determined by Application Binary Interface(ABI)
 * the calling of functions(both asm and c functions) in asm
 * use registers r0-r3 as first four arguments
 * and the frist four return-values use also r0-r3
 * more than four parameters should realized with stack */

/* init input pins */
.equ btnPin1, 5
.equ btnPin2, 15

/* import c fuctions */
.extern map_peripheral    /* mapping a block (4096 bytes) of physical addresses to virtual space */
.extern printf

/* import asm functions */
.extern set_pin_input
.extern set_pin_output
.extern get_pin_level

.extern set_idle
.extern blink_yellow_led
.extern blink_red_led
.extern blink_all_leds

.extern show_sum_led
.extern show_sum_blink

.extern wait

/* main function */
.global main
.func main
main:
  push {r4-r11, lr}

/* address mapping using c function */
mapping_addr:
  bl map_peripheral
  mov r9, r0  /* save the GPIO_BASE in r9 */
  mov r1, #-1
  cmp r0, r1
  bne gpio_settings
  /* when problem with mapping */
  ldr r0, =errMsg1
  bl printf
  b end_main

/* gpio settings */
gpio_settings:
  mov r0, r9
  bl set_pin_input

  mov r0, r9
  bl set_pin_output

  /* init registers for input1 and input2 */
  mov r7, #0
  mov r8, #0

  /* set all leds off */
  mov r0, r9
  bl set_idle

/* get the first value using button1 */
  ldr r0, =infoMsg1
  bl printf

get_btn1_input:
  mov r0, r9
  mov r1, #btnPin1
  bl get_pin_level
  cmp r0, #0
  beq get_btn1_input

check_btn2_input:
  mov r0, r9
  mov r1, #btnPin2
  bl get_pin_level
  cmp r0, #1
  beq end_btn1_input

check_btn1_falling_edge:
  mov r0, r9
  mov r1, #btnPin1
  bl get_pin_level
  cmp r0, #1
  beq check_btn1_falling_edge

/* when the falling edge of button1 is detected */
update_input1:
  add r7, r7, #1
  mov r0, r9
  bl blink_yellow_led
  b get_btn1_input
/* end_btn1_input */

end_btn1_input:
/* get the second value using button2 */
  ldr r0, =infoMsg2
  bl printf
  mov r0, #300
  bl wait

get_btn2_input:
  mov r0, r9
  mov r1, #btnPin2
  bl get_pin_level
  cmp r0, #0
  beq get_btn2_input

check_btn1_input:
  mov r0, r9
  mov r1, #btnPin1
  bl get_pin_level
  cmp r0, #1
  beq start_calc

check_btn2_falling_edge:
  mov r0, r9
  mov r1, #btnPin2
  bl get_pin_level
  cmp r0, #1
  beq check_btn2_falling_edge

/* when the falling edge of button1 is detected */
update_input2:
  add r8, r8, #1
  mov r0, r9
  bl blink_red_led
  b get_btn2_input
/* end_btn2_input */

start_calc:
  mov r0, r9
  bl blink_all_leds
/* print the value on screen */
  ldr r0, =valueMsg
  add r1, r7, r8
  bl printf
  add r6, r7, r8
  /* if the result is greater than 7 -> use blink to show result */
  cmp r6, #7
  bgt use_blink
/* otherwise leds should be used as binary code */
use_led:
  mov r0, r9
  mov r1, r6
  mov r2, #12
  bl show_sum_led
  b end_main

use_blink:
  mov r0, r9
  mov r1, r6
  bl show_sum_blink

end_main:
  mov r0, #2000
  bl wait
  mov r0, r9
  bl set_idle
  mov r0, #0
  pop {r4-r11, pc}
.endfunc

/* ---------------- Data Section ---------------- */
.data
.balign 4

/* definations for strings
 * asciz: add the final zero byte automatically
 * ascii: the final zero bytes should manually added
 */
errMsg1: .asciz "memory mapping do not work. aborting...\n"
infoMsg1: .asciz "please input the first value using button1: \n"
infoMsg2: .asciz "please input the second value using button2: \n"
valueMsg: .asciz "the sum is %d\n"
