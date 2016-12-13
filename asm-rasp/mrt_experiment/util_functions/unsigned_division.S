/******************************************************************************
 * About  : Caculate the 32-bit unsigned division
 * Date   : 2015-12-16 17:50:16
 * Author : Xiang,Zuo
 * Email  : xianglinks@gmail.com
 ******************************************************************************/

/* ---------------- Code Section ---------------- */
.text
.balign 4

/* Args:
 *    r0 contains numerator
 *    r1 contains divisor
 *    r2 contains the quotient */
.global unsigned_division
.func unsigned_division
unsigned_division:
  mov r3, r1                   /* r3 <- r1 */
  cmp r3, r0, LSR #1           /* update cpsr with r3 - r0 / 2 */
  .Lloop2:
    movls r3, r3, LSL #1       /* if r3 <= 2 * r0 ( C=0 or Z=1 ) then r3 <- r3 * 2 */
    cmp r3, r0, LSR #1         /* update cpsr with r3 - (r0 / 2) */
    bls .Lloop2                /* branch to .Lloop2 if r3 <= 2 * r0 ( C=0 or Z=1 ) */

  mov r2, #0                   /* init quotient r2 <- 0 */

  .Lloop3:
    cmp r0, r3                 /* update cpsr with r0 - r3 */
    subhs r0, r0, r3           /* if r0 >= r3 ( C=1 ) then r0 <- r0 - r3 */
    adc r2, r2, r2             /* r2 <- r2 + r2 + C.
                                  Note that if r0 >= r3 then C=1, C=0 otherwise */

    mov r3, r3, LSR #1         /* r3 <- r3 / 2 */
    cmp r3, r1                 /* update cpsr with r3 - r1 */
    bhs .Lloop3                /* if r3 >= r1 branch to .Lloop3 */
  bx lr
.endfunc
