all: t1
 
t1: t1.o
	gcc -o $@ $+
 
t1.o : t1.s
	as -o $@ $<
 
clean:
	rm -vf t1 *.o

