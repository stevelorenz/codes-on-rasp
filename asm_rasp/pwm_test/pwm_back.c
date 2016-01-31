// PWM example, based on code from http://elinux.org/RPi_Low-level_peripherals for the mmap part
// and http://www.raspberrypi.org/phpBB3/viewtopic.php?t=8467&p=124620 for PWM initialization
//
// compile with "gcc pwm.c -o pwm", test with "./pwm" (needs to be root for /dev/mem access)
//
// Frank Buss, 2012

// Rpi1 #define BCM2708_PERI_BASE	0x20000000
#define BCM2708_PERI_BASE   0x3f000000
#define GPIO_BASE		(BCM2708_PERI_BASE + 0x200000)  /* GPIO controller */
#define PWM_BASE		(BCM2708_PERI_BASE + 0x20C000)  /* PWM controller */
#define CLOCK_BASE		(BCM2708_PERI_BASE + 0x101000)  /* CLOCK controller */

#define	PWM_CTL  0
#define	PWM_RNG1 4
#define	PWM_DAT1 5

#define	PWMCLK_CNTL 40
#define	PWMCLK_DIV  41

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>
#include <fcntl.h>
#include <assert.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <unistd.h>

#define PAGE_SIZE (4*1024)
#define BLOCK_SIZE (4*1024)

// I/O access
volatile unsigned *gpio;
volatile unsigned *pwm;
volatile unsigned *clk;

// GPIO setup macros. Always use INP_GPIO(x) before using OUT_GPIO(x) or SET_GPIO_ALT(x,y)
#define INP_GPIO(g) *(gpio+((g)/10)) &= ~(7<<(((g)%10)*3))
#define OUT_GPIO(g) *(gpio+((g)/10)) |=  (1<<(((g)%10)*3))
#define SET_GPIO_ALT(g,a) *(gpio+(((g)/10))) |= (((a)<=3?(a)+4:(a)==4?3:2)<<(((g)%10)*3))

#define GPIO_SET *(gpio+7)  // sets   bits which are 1 ignores bits which are 0
#define GPIO_CLR *(gpio+10) // clears bits which are 1 ignores bits which are 0

// map 4k register memory for direct access from user space and return a user space pointer to it
volatile unsigned *mapRegisterMemory(int base)
{
	static int mem_fd = 0;
	char *mem, *map;

	/* open /dev/mem */
	if (!mem_fd) {
		if ((mem_fd = open("/dev/mem", O_RDWR|O_SYNC) ) < 0) {
			printf("can't open /dev/mem \n");
			exit (-1);
		}
	}

	/* mmap register */

	// Allocate MAP block
	if ((mem = malloc(BLOCK_SIZE + (PAGE_SIZE-1))) == NULL) {
		printf("allocation error \n");
		exit (-1);
	}

	// Make sure pointer is on 4K boundary
	if ((unsigned long)mem % PAGE_SIZE)
		mem += PAGE_SIZE - ((unsigned long)mem % PAGE_SIZE);

	// Now map it
	map = (char *)mmap(
		(caddr_t)mem,
		BLOCK_SIZE,
		PROT_READ|PROT_WRITE,
		MAP_SHARED|MAP_FIXED,
		mem_fd,
		base
	);

	if ((long)map < 0) {
		printf("mmap error %d\n", (int)map);
		exit (-1);
	}

	// Always use volatile pointer!
	return (volatile unsigned *)map;
}

// set up a memory regions to access GPIO, PWM and the clock manager
void setupRegisterMemoryMappings()
{
	gpio = mapRegisterMemory(GPIO_BASE);
	pwm = mapRegisterMemory(PWM_BASE);
	clk = mapRegisterMemory(CLOCK_BASE);
}

void setServo(int percent)
{
	int bitCount;
	unsigned int bits = 0;

	// 32 bits = 2 milliseconds
	bitCount = 16 + 16 * percent / 100;
	if (bitCount > 32) bitCount = 32;
	if (bitCount < 1) bitCount = 1;
	bits = 0;
	while (bitCount) {
		bits <<= 1;
		bits |= 1;
		bitCount--;
	}
	*(pwm + PWM_DAT1) = bits;
}

// init hardware
void initHardware()
{
	// mmap register space
	setupRegisterMemoryMappings();

	// set PWM alternate function for GPIO18
	SET_GPIO_ALT(12, 0);

	// stop clock and waiting for busy flag doesn't work, so kill clock
    *(clk + PWMCLK_CNTL) = 0x5A000000 | (1 << 5);
    usleep(10);

	// set frequency
	// DIVI is the integer part of the divisor
	// the fractional part (DIVF) drops clock cycles to get the output frequency, bad for servo motors
	// 320 bits for one cycle of 20 milliseconds = 62.5 us per bit = 16 kHz
	int idiv = (int) (19200000.0f / 16000.0f);
	if (idiv < 1 || idiv > 0x1000) {
		printf("idiv out of range: %x\n", idiv);
		exit(-1);
	}
	*(clk + PWMCLK_DIV)  = 0x5A000000 | (idiv<<12);

	// source=osc and enable clock
	*(clk + PWMCLK_CNTL) = 0x5A000011;

	// disable PWM
	*(pwm + PWM_CTL) = 0;

	// needs some time until the PWM module gets disabled, without the delay the PWM module crashs
	usleep(10);

	// filled with 0 for 20 milliseconds = 320 bits
	*(pwm + PWM_RNG1) = 320;

	// 32 bits = 2 milliseconds, init with 1 millisecond
	setServo(0);

	// start PWM0 in serializer mode
	*(pwm + PWM_CTL) = 3;
}

int main(int argc, char **argv)
{
	// init PWM module for GPIO pin 18 with 50 Hz frequency
	initHardware();

	// servo test, position in percent: 0 % = 1 ms, 100 % = 2 ms
	while (1) {
		setServo(20);
		sleep(1);
		setServo(30);
		sleep(1);
		setServo(40);
		sleep(1);
		setServo(50);
		sleep(1);
	}
	return 0;
}
