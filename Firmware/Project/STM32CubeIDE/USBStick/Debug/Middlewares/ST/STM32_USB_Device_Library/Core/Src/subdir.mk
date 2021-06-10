################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.c \
C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.c 

OBJS += \
./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.o \
./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.o \
./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.o 

C_DEPS += \
./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.d \
./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.d \
./Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.c Middlewares/ST/STM32_USB_Device_Library/Core/Src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_core.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.c Middlewares/ST/STM32_USB_Device_Library/Core/Src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ctlreq.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.o: C:/Users/lollo/Documents/Progetti/Cybersecurity\ for\ embedded\ systems/SEcube-SDK-master/SEcube\ USBStick\ Firmware/Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.c Middlewares/ST/STM32_USB_Device_Library/Core/Src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DSTM32F429xx '-D__packed="__attribute__((__packed__))"' '-D__weak=__attribute__((weak))' -DUSE_HAL_DRIVER -DDEBUG -c -I../../../../Drivers/CMSIS/Include -I../../../../Drivers/STM32F4xx_HAL_Driver/Inc -I../../../../Drivers/STM32F4xx_HAL_Driver/Src -I../../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../../Middlewares/ST/STM32_USB_Device_Library/Core/Inc -I../../../../Project/Inc -I../../../../Project/Inc/Common -I../../../../Project/Inc/Device -I../../../../Drivers/CMSIS/Device/ST/STM32F4xx/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP -MF"Middlewares/ST/STM32_USB_Device_Library/Core/Src/usbd_ioreq.d" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

