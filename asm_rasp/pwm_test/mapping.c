// Rpi1 #define BCM2708_PERI_BASE	0x20000000
#define BCM2708_PERI_BASE   0x3f000000  // Rpi2
#define GPIO_BASE		(BCM2708_PERI_BASE + 0x200000)  /* GPIO controller */
#define PWM_BASE		(BCM2708_PERI_BASE + 0x20C000)  /* PWM controller */
#define CLOCK_BASE		(BCM2708_PERI_BASE + 0x101000)  /* CLOCK controller */

#define	PWM_CTL  0
#define	PWM_RNG1 4
#define	PWM_DAT1 5

#define	PWMCLK_CNTL 40  // PWM CLOCK controller
#define	PWMCLK_DIV  41  // PWM CLOCK Divisor

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
volatile unsigned *peri_base;
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
    peri_base = mapRegisterMemory(BCM2708_PERI_BASE);
	gpio = mapRegisterMemory(GPIO_BASE);
	pwm = mapRegisterMemory(PWM_BASE);
	clk = mapRegisterMemory(CLOCK_BASE);
}

// functions to get the addr
int returnBCMPeriBaseAddr(void)
{
    peri_base = mapRegisterMemory(BCM2708_PERI_BASE);
    return (volatile unsigned int *)peri_base;
}

int returnGPIOBaseAddr(void)
{
    gpio = mapRegisterMemory(GPIO_BASE);
    return (volatile unsigned int *)gpio;
}

int returnPWMBaseAddr(void)
{
    pwm = mapRegisterMemory(PWM_BASE);
    return (volatile unsigned int *)pwm;
}


int returnCLKBaseAddr(void)
{
    clk = mapRegisterMemory(CLOCK_BASE);
    return (volatile unsigned int *)clk;
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
