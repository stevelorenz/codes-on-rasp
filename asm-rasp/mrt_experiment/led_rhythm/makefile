all: led_rhythm

led_rhythm: main.S gpio_functions.S rpi.c 
		gcc -g main.S gpio_functions.S rpi.c -o led_rhythm 

clean:
		rm -rf *.o
		rm -rf led_rhythm
