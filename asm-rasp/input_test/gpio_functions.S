/******************************************************************************
 * About  : Functions for interaction with GPIO-pins on Rpi
 * Date   : 2015-12-07 09:49:43
 * Author : Xiang,Zuo
 * Email  : xianglinks@gmail.com
 ******************************************************************************/

/* -- Code Section -- */
.text
.balign 4

/* def for bcm-pins */
.equ bluePin, 12
.equ greenPin, 47
.equ redPin, 14
.equ btnPin, 15

/* set pin's mode: manipulating GPFSEL-Register
 * addr of register = base + 4 * ( pinNum / 10 )
 * mode addr of pin = (pinNum % 10) * 3 */

.global set_gpio_input
.func set_gpio_input
set_gpio_input:
	ldr r1, [r0, #(4 * (btnPin / 10))]
	and r1, #~(7 << ((btnPin % 10) * 3))  /* set pin-bits to 000 */
	str r1, [r0, #(4 * (btnPin / 10))]
.endfunc

.global set_gpio_output
.func set_gpio_output
/* set pin as output */
set_gpio_output:
	ldr r1, [r0, #(4 * (bluePin / 10))]
	and r1, #~(7 << ((bluePin % 10) * 3))  /* set pin-bits to 000 */
	orr r1, #(1 << ((bluePin % 10) * 3))   /* set pin-bits to 001 */
	str r1, [r0, #(4 * (bluePin / 10))]

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

/* control leds
 * set pin's output: manipulating GPSET-Register
 * GPSET0 - 0x7E20001C pin 00-32 ; GPSET1 - 0x7E200020 pin 32-53
 * register addr = 4 * (7 + pinNum/32) */

.global blue_led
.func blue_led
blue_led:
  mov r1, #(1 << (bluePin % 32))
  str r1, [r0, #(4 * (7 + bluePin / 32))]

	mov r1, #(1 << (greenPin % 32))
	str r1, [r0, #(4*(10 + (greenPin / 32)))]

	mov r3, #(1 << (redPin % 32))
	str r3, [r0, #(4*(10 + (redPin / 32)))]

  bx lr
.endfunc

.global green_led
.func green_led
green_led:
  mov r1, #(1 << (greenPin % 32))
  str r1, [r0, #(4 * (7 + greenPin / 32))]

	mov r1, #(1 << (bluePin % 32))
	str r1, [r0, #(4*(10 + (bluePin / 32)))]

	mov r3, #(1 << (redPin % 32))
	str r3, [r0, #(4*(10 + (redPin / 32)))]

  bx lr
.endfunc

.global red_led
.func red_led
/* red on and blue, green off */
red_led:
  mov r1, #(1 << (redPin % 32))
  str r1, [r0, #(4 * (7 + redPin / 32))]

	mov r1, #(1 << (bluePin % 32))
	str r1, [r0, #(4*(10 + (bluePin / 32)))]

	mov r3, #(1 << (greenPin % 32))
	str r3, [r0, #(4*(10 + (greenPin / 32)))]

  bx lr
.endfunc
