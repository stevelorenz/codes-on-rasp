/* Assembly Intro
 * Simple assembler testbed with data and text section
 *
 * Created: 12.10.2015
 * Author:  Chris Iatrou (Chris_Paul.Iatrou@tu-dresden.de)
 */

.data                   /* .data tells the assembler to open a Data Section */
.balign 4               /* data shall be word aligned */
MYVAR1:                 /* This label defines the name of the variable */
.word 0x89ABCDEF        /* .word reserves 4 bytes (i.e. a word) and initializes it to some value */

.text                   /* .text tells the assembler to begin the Code Section */
.balign 4               /* the ARM-Architecture requires that instructions are word-alignd */
.global main            /* we need to export the function main for the linker */
.func   main

main:
        ldr r1, MYVAR1_ADDR /* r1 = &MYVAR */
        ldr r1, [r1]        /* r1 = *MYVAR */
        mov r2, #16
        str r2, [r1]	    /* *MYVAR = 16 */
        bx lr


/* Address labels */
MYVAR1_ADDR: .word MYVAR1
