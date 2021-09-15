#ifndef UART_DEBUG_H
#define UART_DEBUG_H

#include <memory.h>
#include <stdio.h>

#include "usart.h"

#define PRINT_DBG(huart, buffer, buf_size, format, ...) \
	do { \
		memset((buffer), 0, (buf_size)); \
		sprintf((buffer), (format), ##__VA_ARGS__); \
		HAL_UART_Transmit(&(huart), (uint8_t*) (buffer), sizeof(buffer), HAL_MAX_DELAY); \
	} while (0)
#endif // UART_DEBUG_H
