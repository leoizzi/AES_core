################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_bot.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_data.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_scsi.c 

OBJS += \
./Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc.o \
./Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_bot.o \
./Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_data.o \
./Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_scsi.o 

C_DEPS += \
./Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc.d \
./Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_bot.d \
./Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_data.d \
./Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_scsi.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc.c Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_bot.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_bot.c Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_bot.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_data.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_data.c Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_data.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_scsi.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_scsi.c Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Src/usbd_msc_scsi.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

