################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/FPGA.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_algo_Aes.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_algo_AesHmacSha256s.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_algo_HmacSha256.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_algo_sha256.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_communication_core.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_core.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_core_time.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_dispatcher_core.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_flash.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_keys.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_memory.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_security_core.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_sekey.c 

OBJS += \
./Src/Device/FPGA.o \
./Src/Device/se3_algo_Aes.o \
./Src/Device/se3_algo_AesHmacSha256s.o \
./Src/Device/se3_algo_HmacSha256.o \
./Src/Device/se3_algo_sha256.o \
./Src/Device/se3_communication_core.o \
./Src/Device/se3_core.o \
./Src/Device/se3_core_time.o \
./Src/Device/se3_dispatcher_core.o \
./Src/Device/se3_flash.o \
./Src/Device/se3_keys.o \
./Src/Device/se3_memory.o \
./Src/Device/se3_security_core.o \
./Src/Device/se3_sekey.o 

C_DEPS += \
./Src/Device/FPGA.d \
./Src/Device/se3_algo_Aes.d \
./Src/Device/se3_algo_AesHmacSha256s.d \
./Src/Device/se3_algo_HmacSha256.d \
./Src/Device/se3_algo_sha256.d \
./Src/Device/se3_communication_core.d \
./Src/Device/se3_core.d \
./Src/Device/se3_core_time.d \
./Src/Device/se3_dispatcher_core.d \
./Src/Device/se3_flash.d \
./Src/Device/se3_keys.d \
./Src/Device/se3_memory.d \
./Src/Device/se3_security_core.d \
./Src/Device/se3_sekey.d 


# Each subdirectory must supply rules for building sources it contributes
Src/Device/FPGA.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/FPGA.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/FPGA.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_algo_Aes.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_algo_Aes.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_algo_Aes.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_algo_AesHmacSha256s.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_algo_AesHmacSha256s.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_algo_AesHmacSha256s.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_algo_HmacSha256.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_algo_HmacSha256.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_algo_HmacSha256.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_algo_sha256.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_algo_sha256.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_algo_sha256.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_communication_core.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_communication_core.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_communication_core.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_core.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_core.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_core.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_core_time.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_core_time.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_core_time.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_dispatcher_core.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_dispatcher_core.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_dispatcher_core.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_flash.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_flash.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_flash.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_keys.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_keys.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_keys.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_memory.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_memory.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_memory.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_security_core.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_security_core.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_security_core.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Device/se3_sekey.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Device/se3_sekey.c Src/Device/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Device/se3_sekey.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

