################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Common/aes256.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Common/crc16.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Common/pbkdf2.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Common/se3_common.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Common/sha256.c 

OBJS += \
./Src/Common/aes256.o \
./Src/Common/crc16.o \
./Src/Common/pbkdf2.o \
./Src/Common/se3_common.o \
./Src/Common/sha256.o 

C_DEPS += \
./Src/Common/aes256.d \
./Src/Common/crc16.d \
./Src/Common/pbkdf2.d \
./Src/Common/se3_common.d \
./Src/Common/sha256.d 


# Each subdirectory must supply rules for building sources it contributes
Src/Common/aes256.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Common/aes256.c Src/Common/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Common/aes256.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Common/crc16.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Common/crc16.c Src/Common/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Common/crc16.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Common/pbkdf2.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Common/pbkdf2.c Src/Common/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Common/pbkdf2.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Common/se3_common.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Common/se3_common.c Src/Common/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Common/se3_common.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Src/Common/sha256.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Project/Src/Common/sha256.c Src/Common/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Src/Common/sha256.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

