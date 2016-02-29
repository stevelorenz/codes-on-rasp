
// GPIO_SET2
// #define GPIO_SET2  *(gpio.addr + 8)	// sets bits which are 1 ignores bits which are 0
.globl ext_gpio_set2					// allows the linker to see the "ext_gpio_set2" label
.func ext_gpio_set2						// allows the eclipse gdb to see a function called "ext_gpio_set2"
ext_gpio_set2:

	/*
	...
	...
	...
	*/

.endfunc


// GPIO_CLR2
// #define GPIO_CLR2 *(gpio.addr + 11) 	// clears bits which are 1 ignores bits which are 0
.globl ext_gpio_clr2
.func ext_gpio_clr2
ext_gpio_clr2:

	/*
	...
	...
	...
	*/

.endfunc





// READ_GPIO
// #define READ_GPIO(g) *(gpio.addr + ((g)/10))
.globl ext_read_gpio
.func ext_read_gpio
ext_read_gpio:

	/*
	...
	...
	...
	*/

.endfunc




// GPIO_SET
// #define GPIO_SET  *(gpio.addr + 7)
.globl ext_gpio_set
.func ext_gpio_set
ext_gpio_set:

	/*
	...
	...
	...
	*/

.endfunc


// GPIO_CLR
// #define GPIO_CLR *(gpio.addr + 10) 	// clears bits which are 1 ignores bits which are 0
.globl ext_gpio_clr
.func ext_gpio_clr
ext_gpio_clr:

	/*
	...
	...
	...
	*/

.endfunc



// INP_GPIO
// #define INP_GPIO(g)   *(gpio.addr + ((g)/10)) &= ~(7<<(((g)%10)*3))
.globl ext_inp_gpio
.func ext_inp_gpio
ext_inp_gpio:

	/*
	...
	...
	...
	*/

.endfunc






// OUT_GPIO
// #define OUT_GPIO(g)   *(gpio.addr + ((g)/10)) |= (1<<(((g)%10)*3))
.globl ext_out_gpio
.func ext_out_gpio
ext_out_gpio:

	/*
	...
	...
	...
	*/

.endfunc





// GPIO_READ
// #define GPIO_READ(g)  *(gpio.addr + 13) &= (1<<(g))
.globl ext_gpio_read
.func ext_gpio_read
ext_gpio_read:

	/*
	...
	...
	...
	*/

.endfunc








// SET_GPIO_ALT
// #define SET_GPIO_ALT(g,a) *(gpio.addr + (((g)/10))) |= (((a)<=3?(a) + 4:(a)==4?3:2)<<(((g)%10)*3))
.globl ext_set_gpio_alt
.func ext_set_gpio_alt
ext_set_gpio_alt:

	/*
	...
	...
	...
	*/

.endfunc

