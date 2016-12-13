all: pwm_test

pwm_test: main.S gpio_functions.S pwm_settings.S pwm.c 
	gcc -g main.S gpio_functions.S pwm_settings.S pwm.c -o pwm_test

clean:
	rm -rf *.o
	rm -rf pwm_test
