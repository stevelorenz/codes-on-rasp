/******************************************************************************
 * About  : Functions for interaction with GPIO-pins on Rpi
 * Date   : 2015-12-11 16:00:37
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
.equ pwmPin, 12
.equ ledPin, 13
.equ btnPin, 15

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

/* set pin(btnPin) as input */
.global set_gpio_input
.func set_gpio_input
set_gpio_input:
  push {lr}
	ldr r1, [r0, #(4 * (btnPin / 10))]
	and r1, #~(7 << ((btnPin % 10) * 3))  /* set pin-bits to 000 */
	str r1, [r0, #(4 * (btnPin / 10))]
  pop {pc}
.endfunc

.global set_led_on
.func set_led_on
set_led_on:
  push {lr}
  mov r1, #(1 << (ledPin % 32))
  str r1, [r0, #(4 * (7 + ledPin / 32))]
  pop {pc}
.endfunc

/* idle_status: all led off */
.global set_led_off
.func set_led_off
set_led_off:
  push {lr}
	mov r1, #(1 << (ledPin % 32))
	str r1, [r0, #(4*(10 + (ledPin / 32)))]
  pop {pc}
.endfunc

/* get pin(btnPin) volt-level: reading GPLEV-Register
 * address of register = base + #(51 + 4 * (pinNum / 32))
 * each bit stand for volt-level of the pin(0:low, 1:high(3.3V))
 */
.global get_pin_level
.func get_pin_level
get_pin_level:
  push {lr}
  ldr r1, [r0, #(52 + 4 * (btnPin / 32))]
  lsr r1, #btnPin
  and r1, #1
  mov r0, r1  /* r0 as return value */
  pop {pc}
.endfunc

/* set pin(ledPin) as output */
.global set_gpio_output
.func set_gpio_output
set_gpio_output:
  push {lr}
	ldr r1, [r0, #(4 * (ledPin / 10))]
	and r1, #~(7 << ((ledPin % 10) * 3))  /* set pin-bits to 000 */
	orr r1, #(1 << ((ledPin % 10) * 3))   /* set pin-bits to 001 */
	str r1, [r0, #(4 * (ledPin / 10))]
  pop {pc}
.endfunc

/*
 * PWM_BASE = (BCM2708_PERI_BASE + 0x20C000) -> PWM controller
 * Bit Streams configured individually to output either PWM or serialised version of 32 bits
 * both modes clocked by clk_pwm, which is normally 100MHz, can be varied by the clock manager
 * PWN controller consist of two independent channels -> channel0 & channel1
 * two sub-modes in PWM controller: MSEN = 0(default) and MSEN = 1
 * hardware support PWM: BCM-pin 12: PWM0, alternate function 0(alt0)
 */

.global set_pin_pwm
.func set_pin_pwm
set_pin_pwm:
  push {lr}
	ldr r1, [r0, #(4 * (pwmPin / 10))]
	and r1, #~(7 << ((pwmPin % 10) * 3))  /* set pin-bits to 000 */
	orr r1, #(4 << ((pwmPin % 10) * 3))   /* set pin-bits to 100 -> alt func 0 */
	str r1, [r0, #(4 * (pwmPin / 10))]
  pop {pc}
.endfunc
