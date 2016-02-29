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
