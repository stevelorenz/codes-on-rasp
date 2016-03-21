# Compiler
CC = gcc

# Compiling options
CFLAGS = -c -Wall

# Option for Debug & Release 
ifeq ($(BUILD), debug)   
# "Debug" build - no optimization, and debugging symbols
# $ make BUILD=debug
CFLAGS += -O0 -g
else
# "Release" build - optimization, and no debug symbols
# $ make
CFLAGS += -O2 -s -DNDEBUG
endif

# Compiling header and libs
HEADER = -I.  # headers
LIBRA = -lwiringPi  # libs in lib_path

# Compiling rules
# ---------------------------------------------------------------
all: test_oled

test_oled: test_oled.o ssd1306_i2c.o
		$(CC) test_oled.o ssd1306_i2c.o $(LIBRA) -o test_oled

test_oled.o: test_oled.c
		$(CC) $(CFLAGS) $(HEADER) test_oled.c ssd1306_i2c.c

ssd1306_i2c.o: ssd1306_i2c.c
		$(CC) $(CFLAGS) $(HEADER) ssd1306_i2c.c

clean:
		rm *.o
		rm -rf test_oled
# ---------------------------------------------------------------
