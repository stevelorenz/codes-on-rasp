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

/* import c fuctions for addr_mapping */
.extern usleep
.extern sleep

/* import asm functions */
.extern get_pin_level
.extern set_pin_pwm


/* main function */
.global main
.func main
main:
  push {r4-r11, lr}

  /* GPIO_BASE in r9 */
  bl returnGPIOBaseAddr
  mov r9, r0
  bl set_pin_pwm

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

set_pwm_clock:
  /* get CLOCK_BASE in r8 */
  bl returnCLKBaseAddr
  mov r8, r0
	add	r3, r8, #160 /* addr CM_PWMCLK_CNTL */
  /* *(clk + PWMCLK_CNTL) = 0x5A000000 | (1 << 5) */
	ldr	r2, =1509949472
	str	r2, [r3, #0]
	mov	r0, #10
	bl	usleep

set_frequency:
/* set frequency
	DIVI is the integer part of the divisor
  the fractional part (DIVF) drops clock cycles to get the output frequency, bad for leds
  320 bits for one cycle of 20 milliseconds = 62.5 us per bit = 16 kHz
  * the frequency of the source = 19200000Hz
  * the frequency we want = 16kHz
  * the idiv = 19200000Hz / 16000 = 1200
*/

	/* *(clk + PWMCLK_DIV)  = 0x5A000000 | (idiv<<12) */
  add r3, r8, #164 /* addr PMCLK_DIV */
  mov r2, #1200
	mov	r2, r2, asl #12 /* idiv << 12 */
  orr r2, r2, #1509949440
  str r2, [r3, #0]

enable_clock:
	add	r3, r8, #160 /* addr CM_PWMCLK_CNTL */
	/* *(clk + PWMCLK_CNTL) = 0x5A000011;*/
  ldr r2, =0x5A000011
  str r2, [r3, #0]

disable_pwm:
  /* put PWM_BASE in r7 */
  bl returnPWMBaseAddr
  mov r7, r0
  mov r2, #0
  str r2, [r7, #0]
	/* needs some time until the PWM module gets disabled, without the delay the PWM module crashs */
  mov r0, #10
  bl usleep

set_pwm_registers:
  /* RNG1 register */
  add r3, r7, #16
  mov r2, #320
  str r2, [r3, #0]

  /* init Duty Cycle with 0 */
  mov r0, #0
  bl setServo

start_pwm_serialized_mode:
  mov r2, #3
  str r2, [r7, #0]

/* main loop */
main_loop:
  mov r0, #10
  bl setServo
  mov r0, #1
  bl sleep

  mov r0, #20
  bl setServo
  mov r0, #1
  bl sleep

b main_loop

end_main:
  mov r0, #0
  pop {r4-r11, pc}
.endfunc


.global setDutyCycle
.func setDutyCycle
setDutyCycle:
/* arg1: int percent(r0), arg2: PWM_BASE(r1)
 * 32 bit = 2 milliseconds
 * set PWM_DAT1 Register: Offset = 5 * 4 = 20
 */
  push {lr}
  mov r7, r1
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	str	r0, [fp, #-16]
	mov	r3, #0
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-16]
	mov	r3, r3, asl #4
	ldr	r2, .L16
	smull	r1, r2, r2, r3
	mov	r2, r2, asr #5
	mov	r3, r3, asr #31
	rsb	r3, r3, r2
	add	r3, r3, #16
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-8]
	cmp	r3, #32
	ble	.L12
	mov	r3, #32
	str	r3, [fp, #-8]
.L12:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bgt	.L13
	mov	r3, #1
	str	r3, [fp, #-8]
.L13:
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L14
.L15:
	ldr	r3, [fp, #-12]
	mov	r3, r3, asl #1
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-12]
	orr	r3, r3, #1
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L14:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bne	.L15
	add	r3, r7, #20
	ldr	r2, [fp, #-12]
	str	r2, [r3, #0]
	add	sp, fp, #0
	ldmfd	sp!, {fp}
.L17:
	.align	2
.L16:
	.word	1374389535
	.align	2
  pop {pc}
.endfunc

/* ---------------- Data Section ---------------- */
.data
.balign 4

/* definations for strings */
errMsg1: .ascii "addr_mapping do not work. aborting...\n"
