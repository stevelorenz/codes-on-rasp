/******************************************************************************
 * About  :
 * Date   : 2015-12-12 09:52:51
 * Author : Xiang, Zuo
 * Email  : xianglinks@gmail.com
 ******************************************************************************/

/* ---------------- Code Section ---------------- */
.text
.balign 4

.equ pwmPin, 12  /* BCM-pin 12 support hardware PWM */

/*
 * PWM_BASE = (BCM2835_PERI_BASE + 0x20C000) -> PWM controller
 * Bit Streams configured individually to output either PWM or serialised version of 32 bits
 * both modes clocked by clk_pwm, which is normally 100MHz, can be varied by the clock manager
 * PWN controller consist of two independent channels -> channel0 & channel1
 * two sub-modes in PWM controller: MSEN = 0(default) and MSEN = 1
 * hardware support PWM: BCM-pin 12: PWM0, alternate function 0(alt0)
 */

/* CLOCK_BASE = (BCM2835_PERI_BASE + 0x101000) -> CLOCK controller
 * base = 0x7e000000 clock 0x7e101000
 * genau infomations of address of register on BCM2835: http://elinux.org/BCM2835_registers
 * Page 105 -> GPIO general clock
 */

.extern usleep

/*
 * The address for CM_PWMCTL(PWM clock Controller) is 0x7e1010a0
 * BCM2835_PWMCLK_CNTL -> Offset .word 40(4 byte)
 * bcm2835_clk + BCM2835_PWMCLK_CNTL = BCM2835_CLOCK_BASE + (BCM2835_PWMCLK_CNTL * 4)
 * so the CM_PWMCTL = BCM2835_CLOCK_BASE + 160 */


.global set_clock_pwm
.func set_clock_pwm
/* para: base_addr(r0) */
set_clock_pwm:
  push {lr}

  /* stop the clock for trigger */
  ldr r3, =0x101000
  add r3, r3, r0  /* get BCM2835_CLOCK_BASE */
	add	r3, r3, #160 /* get CM_PWMCTL */
	ldr	r2, =1509949472
	str	r2, [r3, #0]
	mov	r0, #10
	bl	usleep

set_frequency:
/* set frequency
 * DIVI is the integer part of the divisor
 * the fractional part (DIVF) drops clock cycles to get the output frequency
 * 320 bits for one cycle of 20 milliseconds = 62.5 us per bit = 16 kHz */


  pop {pc}
.endfunc

/* ---------------- Data Section ---------------- */
.data
.balign 4
