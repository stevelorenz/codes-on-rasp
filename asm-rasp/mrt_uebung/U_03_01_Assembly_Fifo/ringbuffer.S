.data

.equ RB_SIZE, 16 /* ring buffer size, power of 2 */

.balign RB_SIZE*4 	/* alignment auf "gerade" addresse verordnen */
RB_DATA:			/* ring buffer memory space */
.space RB_SIZE*4

.balign 4

.text
.balign 4
.global main
.func main

main:
	bl sub_rb_init
	mov r0, #1
	bl sub_rb_push
	bl sub_rb_push
	bl sub_rb_push
	bl sub_rb_pop
	bl sub_rb_pop

	bx lr

/* r10 holds write-ptr, r11 holds read-ptr */
sub_rb_init:
	ldr r10, ADDR_RB_DATA
	ldr r11, ADDR_RB_DATA
	bx lr

/* Determine if ring buffer is empty
 * returns 1 if empty, 0 if at least one element in r0
 */
sub_rb_is_empty:
	cmp r10, r11
	moveq r0, #1
	movne r0, #0
	bx lr

/* Determine the number of elements in ring buffer
 * returns number of elements in r0
 */
sub_rb_noElements:
	sub r0, r11, r10
	and r0, #RB_SIZE-1
	bx lr

/* r0 holds the value to be pushed to the ring buffer
 * Attention 1: does not check for overflows
 * Attention 2: write-ptr manipulation is not atomic
 * returns: nothing
 * side effects: destroys r1
 */
sub_rb_push:
	str r0, [r10], #4			/* store r0 to [r10], then add 4 to r10 */
	ands r1, r10, #RB_SIZE-1     /* check for overflow */
	ldreq r10, ADDR_RB_DATA		/* reset to start of buffer */
	bx lr

/* r0 returns the status, r1 the value popped from the ring buffer
 * returns in r0: 0 ok, 1 empty
 */

sub_rb_pop:
	cmp r10, r11				/* check if empty */
	beq sub_rb_pop_empty
	ldr r1, [r11], #4			/* load r1 from [r11], then add 4 to r11 */
	ands r1, r11, #RB_SIZE-1     /* check for overflow */
	ldreq r11, ADDR_RB_DATA		/* reset to start of buffer */
	mov r0, #0
	bal sub_rb_pop_return

sub_rb_pop_empty:
	mov r0, #1					/* set flag for empty buffer */
	bal sub_rb_pop_return

sub_rb_pop_return:
	bx lr

/* Address labels */
ADDR_RB_DATA: .word RB_DATA
