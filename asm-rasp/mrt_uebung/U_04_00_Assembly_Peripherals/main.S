.extern sleep			/* external function for sleeping */
.extern map_peripheral	/* external function for mapping the GPIO peripherals */
.equ GPIO_PIN, 47		/* The GREEN LED is connected to GPIO_PIN 47 on the PI+ plattforms */

.text
.balign 4
.global main
.func main

main:
	/* Step 1: save registers and return address */
	push {r4-r11, lr}

	/* Step 2: map_peripheral returns the base address of the GPIO registers in r0 */
	bl map_peripheral
	mov r9, r0

	/* Step 3: set GPIO LED to output by manipulating the GPFSEL-register
	 * with a read-modify-write pattern. Each 32bit-GPFSEL-Register contains 10 pins, so
	 * the address of the register is simply calculated as BASE + 4 * (PinNumber/10).
	 * The Function Select of each pin is 3 bits wide (000=Input, 001=Output), that is
	 * bits 21-23 hold the mode of the x-7th pin (see BCM2835 ARM peripherals datasheet, page 89 ff.) */
	ldr r3, [r9, #(4 * (GPIO_PIN/10))]		/* read GPFSEL4 to R3 */
	and r3, #~(7 << ((GPIO_PIN%10)*3))		/* set bits 21-23 to 000, i.e. set pin as input */
	str r3, [r9, #(4 * (GPIO_PIN/10))]		/* do we really need this intermediate write to GPFSEL4? */
	orr r3, #(1 << ((GPIO_PIN%10)*3))		/* set bits 21-23 to 001, i.e. set pin as output */
	str r3, [r9, #(4 * (GPIO_PIN/10))]		/* write R3 to GPFSEL4 */

	/* Step 4: toggle bits every second */
loop:
	/* Step 4.1: set LED and wait a second. Every 1 in the GPSET0/1 register sets the according pin, 0 are ignored
	 * GPSET0 holds pins 0-31, GPSET1 pins 32-54. The bit position is the remainder of PinNumber / 32, the
	 * address BASE + 7 + PinNumber / 32. */
	mov r3, #(1 << (GPIO_PIN%32))
	str r3, [r9, #(4*(7 + (GPIO_PIN/32))]
	mov r0, #1
	bl sleep
	
	/* Step 4.2: CLEAR LED 47 for a second. Every 1 in the GPSCLR0/1 register clears the according pin, zeros are ignored */
	mov r3, #(1 << (GPIO_PIN%32))
	str r3, [r9, #(4*(10 + (GPIO_PIN/32))]
  	mov r0, #1
   	bl sleep
   	
   	/* Step 4.3: continue for ever */
	bal loop
	
	/* Step 5: restore registers and return by popping the saved lr to pc */
end_main:
	mov r0, #0							/* this is our return code by convention */
	pop {r4-r11, pc}
