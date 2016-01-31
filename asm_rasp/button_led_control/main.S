/******************************************************************************
 * About  : Simple LED control(GPIO) with JT-Button
 * Date   : 2015-12-11 15:12:46
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

/* import c fuctions */
.extern map_peripheral    /* mapping a block (4096 bytes) of physical addresses to virtual space */

/* import asm functions */
.extern set_pin_input
.extern set_pin_output
.extern get_pin_level
.extern set_led_on
.extern set_led_off

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
  bl set_pin_output

  mov r0, r9
  bl set_pin_input

/* The bit for programm-status is saved in r10
 * 0 -> led_off
 * 1 -> led_on
 * this status should be changed by button-input signal */

mov r10, #0  /* init with led_off */

/* init with idle_status */
  mov r0, r9
  bl set_led_off

/* main loop */
main_loop:

  /* the change of programm-status should be triggered
   * by falling edge of the button-input: when there is 10
   */

  /* get button-input( on:1, off:0 ) */
  mov r0, r9
  bl get_pin_level
  cmp r0, #0  /* no button input signal -> keep current status */
  beq wait

  /* if button-value is 1
   * the next button-input should be read: waiting for falling edge
   */
check_falling_edge:
  mov r0, r9
  bl get_pin_level
  cmp r0, #1
  beq check_falling_edge

/* if the falling edge is detected: 10 -> change status
 * change the status using XOR */
change_status:
  eor r10, r10, #1

/* check the status-bit in r10 */
check_status:
  cmp r10, #0
  beq idle_status

/* if the status-bit is 1 */
on_status:
  mov r0, r9
  bl set_led_on
  b wait  /* wait some time for GPIO setting up */

/* if the status-bit is 0 */
idle_status:
  mov r0, r9
  bl set_led_off
  b wait

/* delay for some time(here default about 0.05s) */
wait:
  mov r3, #5  /* change delay time by modifying this value */
wait_loop2:
  sub r3, #1
  mov r2, #0x3F0000
wait_loop1:
  sub r2,#1
  cmp r2,#0
  bne wait_loop1
  cmp r3, #0
  bne wait_loop2
  b main_loop
  /* end main_loop */

end_main:
  mov r0, #0
  pop {r4-r11, pc}


/* ---------------- Data Section ---------------- */
.data
.balign 4

/* definations for strings */
errMsg1: .ascii "memory mapping do not work. aborting...\n"
