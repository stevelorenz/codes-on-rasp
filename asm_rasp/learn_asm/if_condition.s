/* */
 
/* -- Data Section -- */
.data
 
/* Ensure variable is 4-byte aligned */
.balign 4  /* .balign using byte as unit */
/* Define storage for myVar1 */
myVar1:
  .word 3
 
/* -- Code Section -- */
.text
 
/* Ensure code is 4 byte aligned */
.balign 4
.global main
.func main

main:

  bx lr  /* return from main function */
 
/* Labels needed to access data */
addr_of_myvar1 : .word myVar1

