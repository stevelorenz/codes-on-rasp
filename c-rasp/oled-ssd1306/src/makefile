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
HEADER = -I./include  # header files
LIBB = -L./ -lXXX  # lib in current dir
LIBRA = -l  # lib in lib_path

# Compiling rules
all: object-file

object-file: main.o
		$(CC) main.o $(LIBB) $(LIBRA) -o object-file

main.o: main.cpp
		$(CC) $(CFLAGS) $(HEADER) main.cpp

clean:
		rm *.o
