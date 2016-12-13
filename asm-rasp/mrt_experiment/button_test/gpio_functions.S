/******************************************************************************
 * About  : Functions for interaction with GPIO-pins on Rpi
 * Date   : 2015-12-14 12:26:40
 * Author : Xiang,Zuo
 * Email  : xianglinks@gmail.com
 ******************************************************************************/

/* -- Code Section -- */
.text
.balign 4

.equ yellowPin, 19
.equ greenPin, 20
.equ redPin, 21
.equ btnPin1, 14

/* function to caculate 32-bit unsigned division
 * args  : r0 contains numerator
 *         r1 contains divisor
 * return: r2 contains the quotient */
.global unsigned_division
.func unsigned_division
unsigned_division:
  mov r3, r1                   /* r3 <- r1 */
  cmp r3, r0, LSR #1           /* update cpsr with r3 - r0 / 2 */
  .Lloop2:
    movls r3, r3, LSL #1       /* if r3 <= 2 * r0 ( C=0 or Z=1 ) then r3 <- r3 * 2 */
    cmp r3, r0, LSR #1         /* update cpsr with r3 - (r0 / 2) */
    bls .Lloop2                /* branch to .Lloop2 if r3 <= 2 * r0 ( C=0 or Z=1 ) */

  mov r2, #0                   /* init quotient r2 <- 0 */

  .Lloop3:
    cmp r0, r3                 /* update cpsr with r0 - r3 */
    subhs r0, r0, r3           /* if r0 >= r3 ( C=1 ) then r0 <- r0 - r3 */
    adc r2, r2, r2             /* r2 <- r2 + r2 + C.
                                  Note that if r0 >= r3 then C=1, C=0 otherwise */

    mov r3, r3, LSR #1         /* r3 <- r3 / 2 */
    cmp r3, r1                 /* update cpsr with r3 - r1 */
    bhs .Lloop3                /* if r3 >= r1 branch to .Lloop3 */
  bx lr
.endfunc

/* function to caculate 32-bit unsigned division
 * args  : r0 the number to be modulated
           r1 the quotient of division 10
 * return: r0 contains the result */
.global mod_ten
.func mod_ten
mod_ten:
  mov r2, #0
start_mod_ten:
  cmp r1, #0
  beq end_mod_ten
  add r2, r2, #10
  sub r1, r1, #1
end_mod_ten:
  sub r0, r0, r2
  bx lr
.endfunc



/* note: detailed information about GPIO-Registers
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

/* function to set a gpio_pin as input
 * args  : r0 GPIO_BASE
 *         r1 BCM-Pin Number */
.global set_pin_input
.func set_pin_input
set_pin_input:
  mov r3, r0  /* backup GPIO_BASE */
  mov r4, r1  /* backup BCM-Pin Number */

  mov r0, r1
  mov r1, #10
  bl unsigned_division  /* calc Pin / 10, quotient in r2 */
  mov r5, r2, LSL #4  /* r5 = r2 * 4 */
  ldr r1, [r3, r5]
  mov r6, r1  /* put the value in GPFSEL in r6 */
  /* calc pinNum mod 10 */
  mov r0, r4
  mov r1, r2  /* put the quotient in mod_ten function */
  bl mod_ten

  add r0, r0, LSL #2  /* r0 = 3 * r0 */
  mov r1, #7
  mov r1, r1, LSL r0  /* r1 = 7 << (pinNum % 10) * 3 */
  mov r2, #4294967295
  eor r1, r1, r2
  and r1, r6, r1
  str r1, [r3, r5]
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
  ldr r1, [r0, #(52 + 4 * (btnPin1 / 32))]
  lsr r1, #btnPin1
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

.global set_led_off
.func set_led_off
set_led_off:
  mov r1, #(1 << (redPin% 32))
  str r1, [r0, #(4*(10 + (redPin/ 32)))]
  bx lr
.endfunc

/* on_status: all leds on */
.global set_led_on
.func set_led_on
set_led_on:
  mov r1, #(1 << (redPin% 32))
  str r1, [r0, #(4 * (7 + redPin/ 32))]
  bx lr
.endfunc
