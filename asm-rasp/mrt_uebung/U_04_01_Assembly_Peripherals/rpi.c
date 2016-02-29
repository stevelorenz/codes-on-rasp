#include "rpi.h"
#include <fcntl.h>
 
struct bcm2835_peripheral gpio = {GPIO_BASE};
 
// Exposes the physical address defined in the passed structure using mmap on /dev/mem
volatile unsigned int * map_peripheral()
{
   // Open /dev/mem
   if ((gpio.mem_fd = open("/dev/mem", O_RDWR|O_SYNC) ) < 0) {
      printf("Failed to open /dev/mem, try checking permissions.\n");
      return -1;
   }
 
   gpio.map = mmap(
      NULL,
      BLOCK_SIZE,
      PROT_READ|PROT_WRITE,
      MAP_SHARED,
      gpio.mem_fd,      // File descriptor to physical memory virtual file '/dev/mem'
      gpio.addr_p       // Address in physical map that we want this memory block to expose
   );
 
   if (gpio.map == MAP_FAILED) {
        perror("mmap");
        return NULL;
   }
 
   return gpio.addr = (volatile unsigned int *)gpio.map;
}
 
void unmap_peripheral() {
    munmap(gpio.map, BLOCK_SIZE);
    close(gpio.mem_fd);
}
