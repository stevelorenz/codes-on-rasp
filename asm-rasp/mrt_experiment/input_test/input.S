/******************************************************************************
 * About  : Temperature measurement and processing on Rpi
 * Date   : 2015-12-03 23:52:37
 * Author : Xiang,Zuo
 * Email  : xianglinks@gmail.com
 ******************************************************************************/

/* ---------------- Data Section ---------------- */
.data
.balign 4

/* definations for strings */
errMsg1: .asciz "initiation do not work. aborting...\n"
errMsg2: .asciz "addr_mapping do not work. aborting...\n"
tempMsg: .asciz "temperature is: %dC.\n"


/* ---------------- Code Section ---------------- */
.text
.balign 4

/* import c fuctions */
.extern init_mcp          /* init wiringPi and mcp3008 */
.extern read_temp         /* read_temp using wiringPi */
.extern map_peripheral    /* mapping the physical addr */
.extern sleep             /* TODO do not use it */
.extern printf            /* print value on the screen */

/* import asm functions */
.extern set_gpio_input
.extern set_gpio_output
.extern blue_led
.extern green_led
.extern red_led

.equ btnPin, 15

.global main
.func main

main:
  push {r4-r11, lr}

  /* initiation wiring_pins and mcp3008 (run only once) */
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
  mov r9, r0                /* save gpio_base_addr in r9 */
  mov r1, #-1
  cmp r0, r1
  bne gpio_settings
  /* when problem */
  ldr r0, =errMsg2
  bl printf
  b end_main

gpio_settings:
  mov r0, r9
  bl set_gpio_input

  mov r0, r9
  bl set_gpio_input

/* get some thing from input */
input_loop:

/* get gpio_pin level GPLEV-Register
 * addr = base + #(52 + 4 * (pinNum / 32))
 */
  ldr r3, [r9, #(52 + 4 * (btnPin / 32))]
  lsr r3, #15
  and r3, #1
  ldr r0, =tempMsg
  mov r1, r3
  bl printf


  mov r0, #1
  bl sleep

  b input_loop


end_main:
  mov r0, #0
  pop {r4-r11, pc}
