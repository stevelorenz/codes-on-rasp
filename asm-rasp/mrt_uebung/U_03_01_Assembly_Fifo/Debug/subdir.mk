################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_UPPER_SRCS += \
../ringbuffer.S 

OBJS += \
./ringbuffer.o 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.S
	@echo 'Building file: $<'
	@echo 'Invoking: Cross GCC Assembler'
	arm-linux-gnueabihf-as -g -gstubs -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


