// this directive allows the linker to see the "main" label which is our entry point
.globl main

// this directive allows the eclipse gdb to see a function called "main"
.func main

main:


/*

int fibonacci ( int x) {
  if(x<=0) return 0;
  if(x==1) return 1;
  return fibN(x-1)1 + fibN(x-2);
}

*/




	MOV R3, #23			// R3 = input register
	BL calc				// calc( R3 )

	MOV R7, #1			// exit is syscall #1
	SWI #0				// invoke syscall [SWI = Software Interrupt]

calc:
	STMED SP!, { R1, R2, R3, R14 }	// push to stack

	/*
	...
	...
	...
	*/

	LDMED SP!, { R1, R2, R3, R14 }	// restore registers
	MOV PC, R14			// jump back


get_0:					// exit calc() and return 0
	MOV R0, #0
	LDMED SP!, {  R1, R2, R3, R14 }
	MOV PC, R14

get_1:					// exit calc() and return 1
	MOV R0, #1
	LDMED SP!, {  R1, R2, R3,  R14 }
	MOV PC, R14



