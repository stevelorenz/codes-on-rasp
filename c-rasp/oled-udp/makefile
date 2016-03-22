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
HEADER = -I.  # header files
LIBRA = -lwiringPi  # lib in lib_path

# Compiling rules
# ---------------------------------------------------------
all: server-udp client-udp

server-udp: server.o ssd1306_i2c.o
		$(CC) server.o ssd1306_i2c.o $(LIBRA) -o server-udp

server.o: server.c
		$(CC) $(CFLAGS) $(HEADER) server.c

ssd1306_i2c.o: ssd1306_i2c.c
		$(CC) $(CFLAGS) $(HEADER) ssd1306_i2c.c

client-udp: client.o
		$(CC) client.o $(LIBRA) -o client-udp

client.o: client.c
		$(CC) $(CFLAGS) client.c

clean:
		rm *.o
		rm server-udp
		rm client-udp
# ---------------------------------------------------------
