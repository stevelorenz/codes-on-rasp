/* store01.s --> store some data in mem  */
 
/* -- Data Section -- */
.data
 
/* Ensure variable is 4-byte aligned */
.balign 4  /* .balign using byte as unit */
/* Define storage for myVar1 */
myVar1:
    .word 0 
 
/* Ensure variable is 4-byte aligned */
.balign 4
/* Define storage for myVar2 */
myVar2:
    .word 0
 
/* -- Code Section -- */
.text
 
/* Ensure code is 4 byte aligned */
.balign 4
.global main
.func main

main:
    /* store two numbers into mem */
    ldr r1, addr_of_myvar1
    mov r3, #3
    str r3, [r1]
    ldr r2, addr_of_myvar2
    mov r3, #4
    str r3, [r2]

    /* add two number from mem */
    ldr r1, addr_of_myvar1
    ldr r1, [r1]
    ldr r2, addr_of_myvar2
    ldr r2, [r2]
    add r0,r1,r2
    bx lr  /* return from main function */
 
/* Labels needed to access data */
addr_of_myvar1 : .word myVar1
addr_of_myvar2 : .word myVar2

