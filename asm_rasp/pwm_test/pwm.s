	.arch armv6
	.eabi_attribute 27, 3
	.eabi_attribute 28, 1
	.fpu vfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 18, 4
	.file	"pwm.c"
	.comm	gpio,4,4
	.comm	pwm,4,4
	.comm	clk,4,4
	.section	.rodata
	.align	2
.LC0:
	.ascii	"/dev/mem\000"
	.align	2
.LC1:
	.ascii	"can't open /dev/mem \000"
	.align	2
.LC2:
	.ascii	"allocation error \000"
	.align	2
.LC3:
	.ascii	"mmap error %d\012\000"
	.text
	.align	2
	.global	mapRegisterMemory
	.type	mapRegisterMemory, %function
mapRegisterMemory:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	ldr	r3, .L6
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bne	.L2
	ldr	r0, .L6+4
	ldr	r1, .L6+8
	bl	open
	mov	r2, r0
	ldr	r3, .L6
	str	r2, [r3, #0]
	ldr	r3, .L6
	ldr	r3, [r3, #0]
	cmp	r3, #0
	bge	.L2
	ldr	r0, .L6+12
	bl	puts
	mvn	r0, #0
	bl	exit
.L2:
	ldr	r0, .L6+16
	bl	malloc
	mov	r3, r0
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bne	.L3
	ldr	r0, .L6+20
	bl	puts
	mvn	r0, #0
	bl	exit
.L3:
	ldr	r3, [fp, #-8]
	mov	r3, r3, asl #20
	mov	r3, r3, lsr #20
	cmp	r3, #0
	beq	.L4
	ldr	r3, [fp, #-8]
	mov	r3, r3, asl #20
	mov	r3, r3, lsr #20
	rsb	r3, r3, #4096
	ldr	r2, [fp, #-8]
	add	r3, r2, r3
	str	r3, [fp, #-8]
.L4:
	ldr	r3, .L6
	ldr	r3, [r3, #0]
	str	r3, [sp, #0]
	ldr	r3, [fp, #-16]
	str	r3, [sp, #4]
	ldr	r0, [fp, #-8]
	mov	r1, #4096
	mov	r2, #3
	mov	r3, #17
	bl	mmap
	str	r0, [fp, #-12]
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	bge	.L5
	ldr	r2, .L6+24
	ldr	r3, [fp, #-12]
	mov	r0, r2
	mov	r1, r3
	bl	printf
	mvn	r0, #0
	bl	exit
.L5:
	ldr	r3, [fp, #-12]
	mov	r0, r3
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L7:
	.align	2
.L6:
	.word	mem_fd.3244
	.word	.LC0
	.word	1052674
	.word	.LC1
	.word	8191
	.word	.LC2
	.word	.LC3
	.size	mapRegisterMemory, .-mapRegisterMemory
	.align	2
	.global	setupRegisterMemoryMappings
	.type	setupRegisterMemoryMappings, %function
setupRegisterMemoryMappings:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	ldr	r0, .L9
	bl	mapRegisterMemory
	mov	r2, r0
	ldr	r3, .L9+4
	str	r2, [r3, #0]
	ldr	r0, .L9+8
	bl	mapRegisterMemory
	mov	r2, r0
	ldr	r3, .L9+12
	str	r2, [r3, #0]
	ldr	r0, .L9+16
	bl	mapRegisterMemory
	mov	r2, r0
	ldr	r3, .L9+20
	str	r2, [r3, #0]
	ldmfd	sp!, {fp, pc}
.L10:
	.align	2
.L9:
	.word	1059061760
	.word	gpio
	.word	1059110912
	.word	pwm
	.word	1058017280
	.word	clk
	.size	setupRegisterMemoryMappings, .-setupRegisterMemoryMappings
	.align	2
	.global	setServo
	.type	setServo, %function
setServo:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
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
	ldr	r3, .L16+4
	ldr	r3, [r3, #0]
	add	r3, r3, #20
	ldr	r2, [fp, #-12]
	str	r2, [r3, #0]
	add	sp, fp, #0
	ldmfd	sp!, {fp}
	bx	lr
.L17:
	.align	2
.L16:
	.word	1374389535
	.word	pwm
	.size	setServo, .-setServo
	.section	.rodata
	.align	2
.LC4:
	.ascii	"idiv out of range: %x\012\000"
	.text
	.align	2
	.global	initHardware
	.type	initHardware, %function
initHardware:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	bl	setupRegisterMemoryMappings
	ldr	r3, .L21
	ldr	r3, [r3, #0]
	add	r3, r3, #4
	ldr	r2, .L21
	ldr	r2, [r2, #0]
	add	r2, r2, #4
	ldr	r2, [r2, #0]
	orr	r2, r2, #256
	str	r2, [r3, #0]
	ldr	r3, .L21+4
	ldr	r3, [r3, #0]
	add	r3, r3, #160
	ldr	r2, .L21+8
	str	r2, [r3, #0]
	mov	r0, #10
	bl	usleep
	mov	r3, #1200
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	ble	.L19
	ldr	r3, [fp, #-8]
	cmp	r3, #4096
	ble	.L20
.L19:
	ldr	r3, .L21+12
	mov	r0, r3
	ldr	r1, [fp, #-8]
	bl	printf
	mvn	r0, #0
	bl	exit
.L20:
	ldr	r3, .L21+4
	ldr	r3, [r3, #0]
	add	r3, r3, #164
	ldr	r2, [fp, #-8]
	mov	r2, r2, asl #12
	orr	r2, r2, #1509949440
	str	r2, [r3, #0]
	ldr	r3, .L21+4
	ldr	r3, [r3, #0]
	add	r3, r3, #160
	ldr	r2, .L21+16
	str	r2, [r3, #0]
	ldr	r3, .L21+20
	ldr	r3, [r3, #0]
	mov	r2, #0
	str	r2, [r3, #0]
	mov	r0, #10
	bl	usleep
	ldr	r3, .L21+20
	ldr	r3, [r3, #0]
	add	r3, r3, #16
	mov	r2, #320
	str	r2, [r3, #0]
	mov	r0, #0
	bl	setServo
	ldr	r3, .L21+20
	ldr	r3, [r3, #0]
	mov	r2, #3
	str	r2, [r3, #0]
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L22:
	.align	2
.L21:
	.word	gpio
	.word	clk
	.word	1509949472
	.word	.LC4
	.word	1509949457
	.word	pwm
	.size	initHardware, .-initHardware
	.align	2
	.global	main
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	bl	initHardware
.L24:
	mov	r0, #0
	bl	setServo
	mov	r0, #1
	bl	sleep
	mov	r0, #25
	bl	setServo
	mov	r0, #1
	bl	sleep
	mov	r0, #50
	bl	setServo
	mov	r0, #1
	bl	sleep
	mov	r0, #75
	bl	setServo
	mov	r0, #1
	bl	sleep
	mov	r0, #100
	bl	setServo
	mov	r0, #1
	bl	sleep
	b	.L24
	.size	main, .-main
	.local	mem_fd.3244
	.comm	mem_fd.3244,4,4
	.ident	"GCC: (Debian 4.6.3-14+rpi1) 4.6.3"
	.section	.note.GNU-stack,"",%progbits
