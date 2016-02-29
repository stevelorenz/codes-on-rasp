#include <stdio.h>
 
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
 
#include <unistd.h>
 
//RPi 1 #define BCM2708_PERI_BASE       0x20000000
#define BCM2708_PERI_BASE 	0x3f000000

#define GPIO_BASE	(BCM2708_PERI_BASE + 0x200000)	// GPIO controller
 
#define BLOCK_SIZE	(4*1024)
 
// IO Access
struct bcm2835_peripheral {
    unsigned long addr_p;				/* the physical base address */
    int mem_fd;							/* the file descriptor for /dev/mem */
    void *map;							/* the pointer to the map from mmap for later use with munmap */
    volatile unsigned int *addr;		/* the address in user space where we will find the mapped memory */
};
 
extern struct bcm2835_peripheral gpio;  // They have to be found somewhere, but can't be in the header

// GPIO setup macros. Always use INP_GPIO(x) before using OUT_GPIO(x)
#define READ_GPIO(g) *(gpio.addr + ((g)/10))
#define INP_GPIO(g)   *(gpio.addr + ((g)/10)) &= ~(7<<(((g)%10)*3))
#define OUT_GPIO(g)   *(gpio.addr + ((g)/10)) |=  (1<<(((g)%10)*3))
#define SET_GPIO_ALT(g,a) *(gpio.addr + (((g)/10))) |= (((a)<=3?(a) + 4:(a)==4?3:2)<<(((g)%10)*3))
 
#define GPIO_SET  *(gpio.addr + 7)  // sets   bits which are 1 ignores bits which are 0
#define GPIO_SET2  *(gpio.addr + 8)  // sets   bits which are 1 ignores bits which are 0
#define GPIO_CLR  *(gpio.addr + 10) // clears bits which are 1 ignores bits which are 0
#define GPIO_CLR2 *(gpio.addr + 11) // clears bits which are 1 ignores bits which are 0
 
#define GPIO_READ(g)  *(gpio.addr + 13) &= (1<<(g))
