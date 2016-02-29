.extern sleep
.extern map_peripheral
.equ LED, 47
.text
.balign 4
.global main
.func main


main:
	/* save registers and return address */
	push {r4-r11, lr}
	/* call routine to initialize memory mapping */
	bl map_peripheral
	mov r9, r0

	/* set GPIO 47 to output */
	ldr r3, [r9, #(4 * (47/10))]
	and r3, #~(7 << (7*3))
	str r3, [r9, #(4 * (47/10))]
	orr r3, #(1 << (7*3))
	str r3, [r9, #(4 * (47/10))]

	/* set LED 47 */
	movs r3, #(1 << (47-32))
	str r3, [r9, #(4*8)]

end_main: /* restore registers and return */
	mov r0, #0
	pop {r4-r11, pc}
