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
  mv r1, #2
  mv r2, #1
  cmp r1, r2
  beq case_equal
case_diff:
  mv r0, #2
  b end
case_equal:
  mv r0, #1
end:
  bx lr  /* return from main function */
 
/* Labels needed to access data */
addr_of_myvar1 : .word myVar1

