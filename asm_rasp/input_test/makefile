all: input

input: input.S gpio_functions.S read_temp.c libwiringpi.so 
		gcc input.S gpio_functions.S read_temp.c rpi.c -L. -lwiringpi -o input

clean:
		rm -rf *.o
		rm -rf input
