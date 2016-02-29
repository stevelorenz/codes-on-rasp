/******************************************************************************
 * About  : Different status of leds controlled by JT-Button
 * Date   : 2015-12-14 15:48:04
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

.equ modeNum, 5

/* import c fuctions */
.extern map_peripheral    /* mapping a block (4096 bytes) of physical addresses to virtual space */

/* import asm functions */
.extern set_pin_input
.extern set_pin_output
.extern get_pin_level
.extern set_idle
.extern set_all_on
.extern set_yellow_on
.extern set_green_on
.extern set_red_on

/* main function */
.global main
.func main
main:
  push {r4-r11, lr}

/* memory mapping using c function */
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

/* gpio settings: set inputs and outputs */
gpio_settings:
  mov r0, r9
  bl set_pin_output

  mov r0, r9
  bl set_pin_input

/* The bit for programm-status is saved in r10
 * 0 -> idle_status
 * 1 -> all_on_status
 * 2 -> all led flash
 * 3 -> mode3(yellow to red)
 * 4 -> mode4(yellow to red and backwards)
 * this status should be changed by button-input signal */

mov r10, #0  /* init with idle_status */

/* init with idle_status: all leds off */
  mov r0, r9
  bl set_idle

/* main loop */
main_loop:

/* check the status-bit in r10 */
check_status:
  /* jump to different status(0 to (modeNum - 1)) */
  cmp r10, #0
  beq mode0

  cmp r10, #1
  beq mode1

  cmp r10, #2
  beq mode2

  cmp r10, #3
  beq mode3

  cmp r10, #4
  beq mode4

/* mode0: (idle_status) all leds off */
mode0 :
  mov r0, r9
  bl set_idle
  /* check for button signal */
  mov r0, r9
  bl get_pin_level
  cmp r0, #0  /* no button signal */
  beq mode0
  bl change_mode
  b main_loop

/* mode1: all led on */
mode1:
  mov r0, r9
  bl set_all_on
  /* check for button signal */
  mov r0, r9
  bl get_pin_level
  cmp r0, #0  /* no button signal */
  beq mode1
  bl change_mode
  b main_loop

/* mode2: all led flash (0.2s) */
mode2:
  md2_step1:
    mov r0, r9
    bl set_all_on
    mov r0, #20
    bl wait
    /* check the button status */
    mov r0, r9
    bl get_pin_level
    cmp r0, #0
    beq md2_step2
    bl change_mode
    b main_loop

  md2_step2:
    mov r0, r9
    bl set_idle
    mov r0, #20
    bl wait
    /* check the button status */
    mov r0, r9
    bl get_pin_level
    cmp r0, #0
    beq md2_step1
    bl change_mode
    b main_loop

/* mode3: from yellow to red and again (0.5s) */
mode3:
  md3_step1:
    mov r0, r9
    bl set_yellow_on
    mov r0, #50
    bl wait
    /* check the button status */
    mov r0, r9
    bl get_pin_level
    cmp r0, #0
    beq md3_step2
    bl change_mode
    b main_loop

  md3_step2:
    mov r0, r9
    bl set_green_on
    mov r0, #50
    bl wait

    /* check the button status */
    mov r0, r9
    bl get_pin_level
    cmp r0, #0
    beq md3_step3
    bl change_mode
    b main_loop

  md3_step3:
    mov r0, r9
    bl set_red_on
    mov r0, #50
    bl wait
    mov r0, r9
    bl get_pin_level
    cmp r0, #0
    beq md3_step1
    bl change_mode
    b main_loop

/* mode4: from yellow to red and backwards (0.5s) */
mode4:
  md4_step1:
    mov r0, r9
    bl set_yellow_on
    mov r0, #50
    bl wait
    /* check the button status */
    mov r0, r9
    bl get_pin_level
    cmp r0, #0
    beq md4_step2
    bl change_mode
    b main_loop

  md4_step2:
    mov r0, r9
    bl set_green_on
    mov r0, #50
    bl wait

    /* check the button status */
    mov r0, r9
    bl get_pin_level
    cmp r0, #0
    beq md4_step3
    bl change_mode
    b main_loop

  md4_step3:
    mov r0, r9
    bl set_red_on
    mov r0, #50
    bl wait
    mov r0, r9
    bl get_pin_level
    cmp r0, #0
    beq md4_step4
    bl change_mode
    b main_loop

  md4_step4:
    mov r0, r9
    bl set_green_on
    mov r0, #50
    bl wait
    mov r0, r9
    bl get_pin_level
    cmp r0, #0
    beq md4_step1
    bl change_mode
    b main_loop

end_main:
  mov r0, #0
  pop {r4-r11, pc}
.endfunc  /* end main function */


/* function to change mode */
/* the change of programm-status should be triggered
 * by falling edge of the button-input: when there is 10 */
.global change_mode
.func change_mode
change_mode:
  push {lr}
  check_falling_edge:
  mov r0, r9
  bl get_pin_level
  cmp r0, #1
  beq check_falling_edge
  /* if the falling edge is detected: 10 -> change status
   * change the status using XOR */
  change_status:
  add r10, r10, #1
  cmp r10, #modeNum
  blt return
  /* if r10 >= modeNum(out of period), set status to null */
  sub r10, r10, #modeNum
return:
  mov r0, #20
  bl wait
  pop {pc}
.endfunc

/* function to delay */
.global wait
.func wait
/* delay for some time (0.01 * r0) second */
wait:
  mov r3, r0
wait_loop2:
  sub r3, #1
  mov r2, #0x3F0000
wait_loop1:
  sub r2,#1
  cmp r2,#0
  bne wait_loop1
  cmp r3, #0
  bne wait_loop2
  /* end main_loop */
  bx lr
.endfunc

/* ---------------- Data Section ---------------- */
.data
.balign 4

/* definations for strings */
errMsg1: .ascii "memory mapping do not work. aborting...\n"
