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
HEADER = -I./  # header files
LIBRA = -lwiringPi  # lib in lib_path

# Compiling rules
# ---------------------------------------------------------
all: hello-world

hello-world: hello_world.o ssd1306_i2c.o
		$(CC) hello_world.o ssd1306_i2c.o $(LIBRA) -o hello-world

hello_world.o: hello_world.c
		$(CC) $(CFLAGS) $(HEADER) hello_world.c

ssd1306_i2c.o: ssd1306_i2c.c
		$(CC) $(CFLAGS) $(HEADER) ssd1306_i2c.c

clean:
		rm *.o
		rm hello-world
# ---------------------------------------------------------
