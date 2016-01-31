.data				// data section
val: .word 98, 35		// example-values


.text				// code section
.globl main			// this directive allows the linker to see the "main" label which is our entry point


main:
	ldr R2, =val		// load addres of first word in R2
	/*
	...
	...			// load first word
	...			// load second word (adress of first word, plus offset #4)
	...
	*/


gcd:
	CMP R0, R1		// compare R0 and R1. if:
	/*
	...
	...
	...
	*/

	MOV R7, #1		// exit is syscall #1
	SWI #0			// invoke syscall [SWI = Software Interrupt]
