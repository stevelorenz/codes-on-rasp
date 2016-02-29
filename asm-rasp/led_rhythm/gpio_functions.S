/******************************************************************************
 * About  : Functions for interaction with GPIO-pins on Rpi
 * Date   : 2015-12-14 12:26:40
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
 */

.equ yellowPin, 12
.equ greenPin, 13
.equ redPin, 14
.equ btnPin, 15

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

/* set pin as input */
.global set_pin_input
.func set_pin_input
set_pin_input:
	ldr r1, [r0, #(4 * (btnPin / 10))]
	and r1, #~(7 << ((btnPin % 10) * 3))  /* set pin-bits to 000 */
	str r1, [r0, #(4 * (btnPin / 10))]
  bx lr
.endfunc

/* set pin as output */
.global set_pin_output
.func set_pin_output
set_pin_output:
	ldr r1, [r0, #(4 * (yellowPin / 10))]
	and r1, #~(7 << ((yellowPin % 10) * 3))  /* set pin-bits to 000 */
	orr r1, #(1 << ((yellowPin % 10) * 3))   /* set pin-bits to 001 */
	str r1, [r0, #(4 * (yellowPin / 10))]
	ldr r1, [r0, #(4 * (greenPin / 10))]
	and r1, #~(7 << ((greenPin % 10) * 3))
	orr r1, #(1 << ((greenPin % 10) * 3))
	str r1, [r0, #(4 * (greenPin / 10))]
	ldr r1, [r0, #(4 * (redPin / 10))]
	and r1, #~(7 << ((redPin % 10) * 3))
	orr r1, #(1 << ((redPin % 10) * 3))
	str r1, [r0, #(4 * (redPin / 10))]
  bx lr
.endfunc

/* get pin(btnPin) volt-level: reading GPLEV-Register
 * address of register = base + #(51 + 4 * (pinNum / 32))
 * each bit stand for volt-level of the pin(0:low, 1:high(3.3V))
 */
.global get_pin_level
.func get_pin_level
get_pin_level:
  ldr r1, [r0, #(52 + 4 * (btnPin / 32))]
  lsr r1, #btnPin
  and r1, #1
  mov r0, r1  /* r0 as return value */
  bx lr
.endfunc

/* control led
 * set pin's output: manipulating GPSET-Register
 * GPSET0: pin(00-32) ; GPSET1: pin (32-53)
 * address of register = 4 * (7 + pinNum / 32)
 * each bit stand for one pin(0:low, 1:high(3.3V))
 */

/* idle_status: all leds off */
.global set_idle
.func set_idle
set_idle:
	mov r1, #(1 << (yellowPin % 32))
	str r1, [r0, #(4 * (10 + (yellowPin / 32)))]
	mov r1, #(1 << (greenPin % 32))
	str r1, [r0, #(4 * (10 + (greenPin / 32)))]
	mov r1, #(1 << (redPin % 32))
	str r1, [r0, #(4 * (10 + (redPin / 32)))]
  bx lr
.endfunc

/* on_status: all leds on */
.global set_all_on
.func set_all_on
set_all_on:
  mov r1, #(1 << (yellowPin % 32))
  str r1, [r0, #(4 * (7 + yellowPin / 32))]
  mov r1, #(1 << (greenPin % 32))
  str r1, [r0, #(4 * (7 + greenPin / 32))]
  mov r1, #(1 << (redPin % 32))
  str r1, [r0, #(4 * (7 + redPin / 32))]
  bx lr
.endfunc

/* functions to set the single led on */
.global set_yellow_on
.func set_yellow_on
set_yellow_on:
  mov r1, #(1 << (yellowPin % 32))
  str r1, [r0, #(4 * (7 + yellowPin / 32))]
  mov r1, #(1 << (greenPin % 32))
  str r1, [r0, #(4 * (10 + greenPin / 32))]
  mov r1, #(1 << (redPin % 32))
  str r1, [r0, #(4 * (10 + redPin / 32))]
  bx lr
.endfunc

.global set_green_on
.func set_green_on
set_green_on:
  mov r1, #(1 << (yellowPin % 32))
  str r1, [r0, #(4 * (10 + yellowPin / 32))]
  mov r1, #(1 << (greenPin % 32))
  str r1, [r0, #(4 * (7 + greenPin / 32))]
  mov r1, #(1 << (redPin % 32))
  str r1, [r0, #(4 * (10 + redPin / 32))]
  bx lr
.endfunc

.global set_red_on
.func set_red_on
set_red_on:
  mov r1, #(1 << (yellowPin % 32))
  str r1, [r0, #(4 * (10 + yellowPin / 32))]
  mov r1, #(1 << (greenPin % 32))
  str r1, [r0, #(4 * (10 + greenPin / 32))]
  mov r1, #(1 << (redPin % 32))
  str r1, [r0, #(4 * (7 + redPin / 32))]
  bx lr
.endfunc
