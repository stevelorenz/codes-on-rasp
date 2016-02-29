all: inputPinTest

inputPinTest: inputPinTest.o
	gcc inputPinTest.o rpi.c -o inputPinTest

inputPinTest.o: inputPinTest.S
	as -o inputPinTest.o inputPinTest.S

clean:
	rm -rf inputPinTest *.o
