/******************************************************************************
 * About  : Functions for interaction with GPIO-pins on Rpi
 * Date   : 2016-01-08 10:51:17
 * Author : Xiang,Zuo
 * Email  : xianglinks@gmail.com
 ******************************************************************************/

/* -- Code Section -- */
.text
.balign 4

/* definations for BCM-pins
 * this number is the same as that on LK-RB-Shield
 * the mapping between BCM-pins, WiringPi-pins and Physical-pins
 * can be found on webseite: http://www.pinout.xyz/
 * note: The usage of BCM-pin 19-21 can cause some unknown problem by Raspbian
 */

.equ yellowLed, 12
.equ greenLed, 13
.equ redLed, 14
.equ btnPin1, 5
.equ btnPin2, 15

/* detailed information about GPIO-Registers
 * can be found on datasheet bcm2835 on page 89-105
 */

/* set pin's mode: manipulating GPFSEL-Register
 * address of register = base + 4 * ( pinNum / 10 )
 * each 3 bits stand for a pin
 * mode position of pin = (pinNum % 10) * 3
 * 000 = GPIO Pin is an input
 * 001 = GPIO Pin is an output
 * 100 = GPIO Pin takes alternate function 0
 * 101 = GPIO Pin takes alternate function 1
 * 110 = GPIO Pin takes alternate function 2
 * 111 = GPIO Pin takes alternate function 3
 * 011 = GPIO Pin takes alternate function 4
 * 010 = GPIO Pin takes alternate function 5 */

/* set pins as input */
.global set_pin_input
.func set_pin_input
set_pin_input:
  ldr r1, [r0, #(4 * (btnPin1 / 10))]
  and r1, #~(7 << ((btnPin1 % 10) * 3))  /* set pin-bits to 000 */
  str r1, [r0, #(4 * (btnPin1 / 10))]

  ldr r1, [r0, #(4 * (btnPin2 / 10))]
  and r1, #~(7 << ((btnPin2 % 10) * 3))  /* set pin-bits to 000 */
  str r1, [r0, #(4 * (btnPin2 / 10))]

  bx lr
.endfunc

/* set pin(ledPin) as output */
.global set_pin_output
.func set_pin_output
set_pin_output:
  and r1, #~(7 << ((yellowLed % 10) * 3))  /* set pin-bits to 000 */
  orr r1, #(1 << ((yellowLed % 10) * 3))   /* set pin-bits to 001 */
  str r1, [r0, #(4 * (yellowLed / 10))]

  and r1, #~(7 << ((greenLed % 10) * 3))  /* set pin-bits to 000 */
  orr r1, #(1 << ((greenLed % 10) * 3))   /* set pin-bits to 001 */
  str r1, [r0, #(4 * (greenLed / 10))]

  and r1, #~(7 << ((redLed % 10) * 3))  /* set pin-bits to 000 */
  orr r1, #(1 << ((redLed % 10) * 3))   /* set pin-bits to 001 */
  str r1, [r0, #(4 * (redLed / 10))]

  bx lr
.endfunc

/* get pin volt-level: reading GPLEV-Register
 * address of register = base + #(51 + 4 * (pinNum / 32))
 * each bit stand for volt-level of the pin(0:low, 1:high(3.3V))
 * args  :  r0  GPIO_BASE
            r1  pinNum
 * return:  r0  pin volt-level
 */
.global get_pin_level
.func get_pin_level
get_pin_level:
  mov r4, r1  /* backup the pinNum in r4 */
  /* get the interval of pinNum */
  cmp r4, #32
  bgt upper_get_pin_level
  /* if pinNum < 32 -> pinNum / 32 = 0 */
  mov r2, #0
  mov r2, r2, LSL #4
  add r2, r2, #52
  ldr r1, [r0, r2]
  lsr r1, r4
  and r1, #1
  mov r0, r1
  b end_get_pin_level

upper_get_pin_level:
  /* if pinNum > 32 -> pinNum / 32 = 1 */
  mov r2, #1
  mov r2, r2, LSL #4
  add r2, r2, #52
  ldr r1, [r0, r2]
  lsr r1, r4
  and r1, #1
  mov r0, r1

end_get_pin_level:
  bx lr
.endfunc

/* control led
 * set pin's output: manipulating GPSET-Register
 * GPSET0: pin(00-32) ; GPSET1: pin (32-53)
 * address of register = 4 * (7 + pinNum / 32)
 * each bit stand for one pin(0:low, 1:high(3.3V))
 */

/* blink led */
.global blink_yellow_led
.func blink_yellow_led
blink_yellow_led:
  mov r5, lr
  mov r4, r0
  mov r1, #(1 << (yellowLed % 32))
  str r1, [r4, #(4 * (7 + yellowLed / 32))]
  mov r0, #50
  bl wait
  mov r1, #(1 << (yellowLed % 32))
  str r1, [r4, #(4 * (10 + (yellowLed / 32)))]
  mov pc, r5
.endfunc

.global blink_red_led
.func blink_red_led
blink_red_led:
  mov r5, lr
  mov r4, r0
  mov r1, #(1 << (redLed % 32))
  str r1, [r4, #(4 * (7 + redLed / 32))]
  mov r0, #50
  bl wait
  mov r1, #(1 << (redLed % 32))
  str r1, [r4, #(4 * (10 + (redLed / 32)))]
  mov pc, r5
.endfunc

.global blink_all_leds
.func blink_all_leds
blink_all_leds:
  mov r5, lr
  mov r4, r0
  mov r1, #(1 << (yellowLed % 32))
  str r1, [r4, #(4 * (7 + yellowLed / 32))]
  mov r1, #(1 << (greenLed % 32))
  str r1, [r4, #(4 * (7 + greenLed / 32))]
  mov r1, #(1 << (redLed % 32))
  str r1, [r4, #(4 * (7 + redLed / 32))]
  mov r0, #200
  bl wait
  mov r1, #(1 << (yellowLed % 32))
  str r1, [r4, #(4 * (10 + (yellowLed / 32)))]
  mov r1, #(1 << (greenLed % 32))
  str r1, [r4, #(4 * (10 + (greenLed / 32)))]
  mov r1, #(1 << (redLed % 32))
  str r1, [r4, #(4 * (10 + (redLed / 32)))]
  mov pc, r5
.endfunc

/* idle_status: all leds off */
.global set_idle
.func set_idle
set_idle:
  mov r1, #(1 << (yellowLed % 32))
  str r1, [r0, #(4 * (10 + (yellowLed / 32)))]
  mov r1, #(1 << (greenLed % 32))
  str r1, [r0, #(4 * (10 + (greenLed / 32)))]
  mov r1, #(1 << (redLed % 32))
  str r1, [r0, #(4 * (10 + (redLed / 32)))]
  bx lr
.endfunc

/* use led as binary code to show result
 * args:  r0: GPIO_BASE
          r1: sum
          r2: lowest pinNum
   condition: pinNum < 32
 */
.global show_sum_led
.func show_sum_led
show_sum_led:
  mov r1, r1, LSL r2
  str r1, [r0, #28]
  bx lr
.endfunc

/* blink led to show result
 * args:  r0: GPIO_BASE
          r1: sum
 */
.global show_sum_blink
.func show_sum_blink
show_sum_blink:
  push {lr}
  mov r10, r1

blink_loop:
  cmp r10, #0
  beq end_blink_loop
  mov r0, r9
  bl blink_yellow_led
  mov r0, #100
  bl wait
  sub r10, r10, #1
  b blink_loop

end_blink_loop:
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
  /* end wait_loop2 */
  bx lr
.endfunc
