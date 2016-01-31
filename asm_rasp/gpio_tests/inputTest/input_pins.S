.section .init
.globl _start
_start:


b main

.section .text

main:   


/*
* Set the stack point to 0x8000.
*/

mov sp,#0x8000


/*
* Location of gpio controller
*/
ldr r0, =0x20200000

/*enable pin 23 as output*/
mov r1,#1
lsl r1,#9
str r1,[r0,#8]

/*enable pin 18 as output*/
mov r1,#1
lsl r1,#24
str r1,[r0,#4]

/*enable pin 17 as input*/
mov r1,#0
lsl r1,#21
str r1,[r0,#4]

/*enable pin 22 as input*/
mov r1,#0
lsl r1,#6
str r1,[r0,#8]

/*Enable ok light as output for status*/
mov r1,#1
lsl r1,#18
str r1,[r0,#4]

/*Endless Loop*/
loop$:

/*Turn ok light on (backwards)*/
ldr r0, =0x20200000
mov r1,#1
lsl r1,#16
str r1,[r0,#40]

/*if pin 17 input is high, change pin 18 high*/
/*input for pin 17 is gpio + 0x00000036 (#54), lone value #64*/
Pin18:
ldr r2, =0x20200036
ldr r0, =0x20200000
ldrb r1,[r2]
cmp r1, #64
bne Pin23
bl TurnPin18On
bl TurnPin23Off


/*if pin 22 input is high, change pin 23 high*/
/*input for pin 22 is gpio + 0x00000036 (#54), lone value #2*/
Pin23:
ldr r2, =0x20200036
ldr r0, =0x20200000
ldrb r1,[r2]
cmp r1, #2
bne
bl TurnPin23On
bl TurnPin18Off


/*if pin 22 input is high, change pin 23 high*/
/*input for pin 22 is gpio + 0x00000036 (#54), lone value #66*/
pin1823:
ldr r2, =0x20200036
ldr r0, =0x20200000
ldrb r1,[r2]
cmp r1, #66
bne NoPin
bl TurnPin23On
bl TurnPin18On

NoPin:
ldr r2, =0x20200036
ldr r0, =0x20200000
ldrb r1,[r2]
cmp r1, #0
bne Wait
bl TurnPin23On
bl TurnPin18On

Wait:
mov r2,#0x3F0000
wait1$:
sub r2,#1
cmp r2,#0
bne wait1$

/*Turn ok light off (backwards)*/
ldr r0, =0x20200000
mov r1,#1
lsl r1,#16
str r1,[r0,#28]

mov r2,#0x3F0000
wait2$:
sub r2,#1
cmp r2,#0
bne wait2$


b loop$

