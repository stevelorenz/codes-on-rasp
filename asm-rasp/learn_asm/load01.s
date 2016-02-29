/* load01.s -- how to load data from memory */
 
/* -- Data Section -- */
.data
 
/* Ensure variable is 4-byte aligned */
.balign 4  /* .balign using byte as unit */
/* Define storage for myVar1 */
myVar1:
    .word 3
 
/* Ensure variable is 4-byte aligned */
.balign 4
/* Define storage for myVar2 */
myVar2:
    .word 4
 
/* -- Code Section -- */
.text
 
/* Ensure code is 4 byte aligned */
.balign 4
.global main
.func main

main:
    ldr r1, addr_of_myvar1
    ldr r1, [r1]
    ldr r2, addr_of_myvar2
    ldr r2, [r2]
    add r0,r1,r2
    bx lr  /* return from main function */
 
/* Labels needed to access data -- relocation */
addr_of_myvar1 : .word myVar1
addr_of_myvar2 : .word myVar2

