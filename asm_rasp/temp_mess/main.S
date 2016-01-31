/******************************************************************************
 * About  : Temperature measurement and processing on Rpi
 * Date   : 2015-12-03 23:52:37
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
.extern init_mcp          /* init wiring-pi and mcp3008 */
.extern read_temp         /* read_temp using wiringPi */
.extern map_peripheral    /* mapping the physical addr */
.extern printf            /* print value on the screen */

/* import asm functions */
.extern set_pin_input
.extern set_pin_output
.extern get_pin_level
.extern set_idle
.extern yellow_led
.extern green_led
.extern red_led

/* main function */
.global main
.func main
main:
  push {r4-r11, lr}

  /* initiation wiring_pins and mcp3008
   * (run only once) */
  bl init_mcp
  mov r1, #-1
  cmp r0, r1
  bne mapping_addr
  /* when problem */
  ldr r0, =errMsg1
  bl printf
  b end_main

/* addr_mapping using c function */
mapping_addr:
  bl map_peripheral
  mov r9, r0  /* save gpio_base_addr in r9 */
  mov r1, #-1
  cmp r0, r1
  bne gpio_settings
  /* when problem */
  ldr r0, =errMsg2
  bl printf
  b end_main

gpio_settings:
  mov r0, r9
  bl set_pin_output

  mov r0, r9
  bl set_pin_input

/* The bit for programm-status is saved in r10
 * 0 -> idle_status: stop temp-processing
 * 1 -> proc_status: start temp-processing
 * this status should be changed by button-input */

mov r10, #0  /* init with idle_status */

/* main loop */
main_loop:

  /* the change of programm-status should be triggered
   * by falling edge of the button-input: 10 */

  /* get button-input( on:1, off:0 ) */
  mov r0, r9
  bl get_pin_level
  cmp r0, #0
  beq check_status

  /* if button-value is 1
   * the next button-input should be read
   */
check_falling_edge:
  mov r0, r9
  bl get_pin_level
  cmp r0, #1
  beq check_falling_edge  /* if the input is still 1 -> loop for falling edge checking */

/* if the falling edge is detected: 10 -> change status
 * change the status using XOR */

change_status:
  eor r10, r10, #1

/* check the status-bit in r10 */
check_status:
  /* check up status */
  cmp r10, #0
  beq idle_status

proc_staus:
  /* get the temp-value */
  bl read_temp
  mov r4, r0  /* save the temp-value in r4 before calling fuctions */
  mov r1, r0
  /* print the tmp-value on screen */
  ldr r0, =tempMsg
  bl printf

  /* processing of temp-value */
  mov r5, #25
  cmp r4, r5
  bgt high_temp

  mov r5, #19
  cmp r4, r5
  bgt med_temp

/* temperature < 20 -> yellow_led */
low_temp:
  mov r0, r9
  bl yellow_led
  b wait

/* temperature > 25C -> red_led*/
high_temp:
  mov r0, r9
  bl red_led
  b wait

/* 20C =< temperature <= 25C -> green_led */
med_temp:
  mov r0, r9
  bl green_led
  b wait

/* operate for idle status */
idle_status:
  mov r0, r9
  bl set_idle
  b wait

/* delay for some time(here default about 0.2s) */
wait:
  mov r3, #20  /* change delay time by modifying this value */
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
errMsg1: .ascii "initiation do not work. aborting...\n"
errMsg2: .ascii "memory mapping do not work. aborting...\n"
tempMsg: .ascii "temperature is: %dC.\n"
