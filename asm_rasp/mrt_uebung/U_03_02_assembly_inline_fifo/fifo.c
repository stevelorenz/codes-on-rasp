

typedef struct{
					int values[4];									// where we store and read values
					int write_offset;								// next to overwrite value in array
					int read_offset;								// next to read value in array

					int isFull;										// 0 = false, 1 = true
					int isEmpty;									// sorry, but there is no 'bool' in C. wait for C++

					int mutex;										// mutex. Needed for thread-safety...
																	// mutex == 1 -> locked
																	// mutex == 0 -> unlocked

										}Buffer;

void write_value(int input, Buffer * in_buffer){

	asm("mov r6, #1");												// 0 and 1 will be needed more than one time...
	asm("mov r7, #0");

	// checking Mutex:
	register int p_mutex asm("r5") = &(in_buffer->mutex);			// safe pointer to 'mutex' in r5
	/*
	...
	...
	...
	*/

	// buffer is not locked (anymore?)... lock it now:
	/*
	...
	...
	...
	*/

	//store new value
	register int _input asm("r0") = input;							// r0 = input
	register int p_write asm("r1") = &(in_buffer->write_offset);	// r1 = pointer write_offset
	register int buffer_base_addr asm("r3") = &(in_buffer->values);	// r3 = base-address of array
	/*
	...
	...
	...
	*/

	// update write-offset
	/*
	...
	...
	...
	*/

	//! status handling:
	//after writing something, the buffer can not be empty...
	register int p_IsFull asm("r0") = &(in_buffer->isEmpty);		// r0 = pointer to 'isEmpty'
	/*
	...
	...
	...
	*/

	// but the buffer might be full. need to check that...
	register int p_read asm("r1") = &(in_buffer->read_offset);		// r1 = pointer to 'read_offset'
	register int p_isEmpty asm("r3") = &(in_buffer->isFull);		// r3 = pointer to 'isFull'
	/*
	...
	...
	...
	*/

	// unlock mutex:
	/*
	...
	...
	...
	*/

}


int read_value(Buffer * in_buffer){

	asm("mov r6, #1");
	asm("mov r7, #0");

	// checking Mutex:
	register int p_mutex asm("r5") = &(in_buffer->mutex);
	/*
	...
	...
	...
	*/

	// buffer is not locked (anymore?)... lock it now:
	/*
	...
	...
	...
	*/

	// read value
	register int output asm("r0");									// will be returned later
	register int p_read asm("r1") = &(in_buffer->read_offset);		// r1 = pointer to 'read_offset'
	register int buffer_base_addr asm("r3") = &(in_buffer->values);	// r3 = base-address
	/*
	...
	...
	...
	*/

	// update read-offset
	/*
	...
	...
	...
	*/


	//! status handling:
	//buffer can not be full after reading...
	register int p_isFull asm("r1")  = &(in_buffer->isFull);		// r1 = pointer to 'isFull'
	/*
	...
	...
	...
	*/

	// check if buffer is empty
	register int p_write asm("r1") = &(in_buffer->write_offset);	// r1 = pointer to 'write_offset'
	register int p_isEmpty asm("r3") = &(in_buffer->isEmpty);		// r3 = pointer to 'isEmpty'
	/*
	...
	...
	...
	*/

	// unlock mutex:
	/*
	...
	...
	...
	*/

	return output;													// return value
}

int main(){

	Buffer buffer;													// generate and init new buffer
	buffer.read_offset = 0;
	buffer.write_offset = 0;
	buffer.isEmpty = 1;
	buffer.isFull = 0;
	buffer.mutex = 0;

	int value = -1;

	write_value( 4, &buffer );										// write and read some numbers
	write_value( 8, &buffer );

	value = read_value( &buffer );

	write_value( 15, &buffer );

	value = read_value( &buffer );
	value = read_value( &buffer );

	write_value( 16, &buffer );
	write_value( 23, &buffer );
	write_value( 42, &buffer );

	value = read_value( &buffer );
	value = read_value( &buffer );
	value = read_value( &buffer );


	return value;
}
