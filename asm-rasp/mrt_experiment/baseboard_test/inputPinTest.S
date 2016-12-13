/*
 * About  : Set Pin 16 as Output and Toggle the value(0V, 3.3V)
 * Date   : 2015-12-02 22:25:30
 * Author : Xiang, Zuo
 * Email  : xianglinks@gmail.com
 */

/* -- Data Section -- */
.data
.balign 4
msg1: .asciz "Mapping finished...\n"
msg2: .asciz "Pin mode setting finished...\n"
msg3: .asciz "Set BCM-Pin 16 to 3.3V...\n"
msg4: .asciz "Set BCM-Pin 16 to 0V...\n"

/* -- Code Section -- */
.text
.balign 4
.extern printf
.extern map_peripheral
.extern sleep /* function for sleep using value in r0 */
.equ pinNum, 16  /* BCM Pin Number */
.global main
.func main

main:
  push {r4-r11, lr}

  /* initialize memory mapping */
  bl map_peripheral
  mov r9, r0  /* put base addr in r9 */
  /* print debugging message */
  ldr r0, =msg1
  bl printf

  /* set pin 16 to output
   * manipulating GPFSEL-Register
   * addr of register = base + 4 * ( pinNum / 10 )
   * mode addr of pin = (pinNum % 10) * 3
   */
	ldr r3, [r9, #(4 * (pinNum / 10))]		/* read GPFSEL-Register to R3 */
	and r3, #~(7 << ((pinNum % 10) * 3))		/* set select-bits to 000 -> input */
	str r3, [r9, #(4 * (pinNum / 10))]
	orr r3, #(1 << ((pinNum % 10) * 3))		/* set select-bits to 001 -> output */
	str r3, [r9, #(4 * (pinNum / 10))]		/* write R3 to GPFSEL-Register */
  ldr r0, =msg2
  bl printf

/* main toggle loop */
loop:

  /* clear pin 16
   * GPSCLR-Register 4 * (10 + (pinNum/32))
   * one bit stand for one pin
   * pin_addr = pinNum % 32
   */
  mov r3, #(1 << (pinNum % 32))
  str r3, [r9, #(4 * (10 + pinNum/32))]

  ldr r0, =msg4
  bl printf
  mov r0, #3
  bl sleep

  /* set pin 16 to 1
   * manipulating GPSET0-Register
   * GPSET0 - 0x7E20001C pin 00-32
   * GPSET1 - 0x7E200020 pin 32-53
   * one bit is stand for a pin
   * register addr = 4 * (7 + pinNum/32)
   */
  mov r3, #(1 << (pinNum % 32))
  str r3, [r9, #(4 * (7 + pinNum/32))]

  ldr r0, =msg3
  bl printf
  mov r0, #3
  bl sleep

  b loop  /* a immer loop */

end_main:
  mov r0, #0
  pop {r4-r11, pc}
