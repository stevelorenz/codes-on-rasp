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
  mov r1, #1
  mov r2, #2
loop:
  cmp r2, #22
  bgt end
  add r1, r1, r2
  add r2, r2, #1
  b loop
end:
  mov r0, r1
  bx lr  /* return from main function */
 
/* Labels needed to access data */
addr_of_myvar1 : .word myVar1

