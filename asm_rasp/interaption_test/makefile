all: button_led

button_led: main.S gpio_functions.S rpi.c 
		gcc -g main.S gpio_functions.S rpi.c -o button_led 

clean:
		rm -rf *.o
		rm -rf button_led
