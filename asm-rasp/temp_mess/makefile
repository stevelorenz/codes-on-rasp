all: tmp_proc

tmp_proc: main.S gpio_functions.S read_temp.c rpi.c libwiringpi.so 
		gcc -g main.S gpio_functions.S read_temp.c rpi.c -L. -lwiringpi -o tmp_proc

clean:
		rm -rf *.o
		rm -rf tmp_proc
