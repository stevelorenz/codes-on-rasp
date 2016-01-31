/* loop2 for 3*n + 1 */
 
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
  mov r1, #123
  mov r2, #0  /* r2 count the step */
loop:
  cmp r1, #1
  beq end
  /* judge even or odd number */
  and r3, r1, #1
  cmp r3, #0
  beq even
odd:
  add r1, r1, r1, LSL #1
  add r1, r1, #1
  b end_loop
even:
  mov r1, r1, ASR #1  /* r1<-(r1>>1) */
  b end_loop
end_loop:
  add r2, r2, #1
  b loop

end:
  mov r0, r2
  bx lr  /* return from main function */
 
/* Labels needed to access data */
addr_of_myvar1 : .word myVar1

