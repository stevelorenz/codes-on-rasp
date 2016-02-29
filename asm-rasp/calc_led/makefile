all: calc_led

calc_led: main.S gpio_functions.S rpi.c 
		gcc -g main.S gpio_functions.S rpi.c -o calc_led 

clean:
		rm -rf *.o
		rm -rf button_led
