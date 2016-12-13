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
.equ ledPin, 14
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

/* set pin(btnPin) as input */
.global set_pin_input
.func set_pin_input
set_pin_input:
  ldr r1, [r0, #(4 * (btnPin / 10))]
  and r1, #~(7 << ((btnPin % 10) * 3))  /* set pin-bits to 000 */
  str r1, [r0, #(4 * (btnPin / 10))]
  bx lr
.endfunc

/* set pin(ledPin) as output */
.global set_pin_output
.func set_pin_output
set_pin_output:
  and r1, #~(7 << ((ledPin % 10) * 3))  /* set pin-bits to 000 */
  orr r1, #(1 << ((ledPin % 10) * 3))   /* set pin-bits to 001 */
  str r1, [r0, #(4 * (ledPin / 10))]
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
.global set_led_off
.func set_led_off
set_led_off:
  mov r1, #(1 << (ledPin % 32))
  str r1, [r0, #(4*(10 + (ledPin / 32)))]
  bx lr
.endfunc

/* on_status: all leds on */
.global set_led_on
.func set_led_on
set_led_on:
  mov r1, #(1 << (ledPin % 32))
  str r1, [r0, #(4 * (7 + ledPin / 32))]
  bx lr
.endfunc
