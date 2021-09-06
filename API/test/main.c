/**
  ******************************************************************************
  * File Name          : main.c
  * Description        : Main program body
  ******************************************************************************
  *
  * COPYRIGHT(c) 2016 STMicroelectronics
  *
  * Redistribution and use in source and binary forms, with or without modification,
  * are permitted provided that the following conditions are met:
  *   1. Redistributions of source code must retain the above copyright notice,
  *      this list of conditions and the following disclaimer.
  *   2. Redistributions in binary form must reproduce the above copyright notice,
  *      this list of conditions and the following disclaimer in the documentation
  *      and/or other materials provided with the distribution.
  *   3. Neither the name of STMicroelectronics nor the names of its contributors
  *      may be used to endorse or promote products derived from this software
  *      without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  */
/* Includes ------------------------------------------------------------------*/

/**
 *  \file main.c
 *  \date 10/02/2021
 *  \version SEcube SDK 1.5.1
 *  \brief Device inizialization and main loop.
 */
#include <stdlib.h>

#include "stm32f4xx_hal.h"
#include "stm32f4xx_hal_rng.h"
#include "adc.h"
#include "crc.h"
#include "dma.h"
#include "i2c.h"
#include "rng.h"
#include "sdio.h"
#include "spi.h"
#include "tim.h"
#include "usart.h"
#include "usb_device.h"
#include "gpio.h"
#include "fmc.h"
#include "se3_sekey.h"
/* USER CODE BEGIN Includes */
#include "FPGA.h"
#include "Fpgaipm.h"
#include "AES_FPGA.h"
#include "se3_core.h"
#include "uart_debug.h"
/* USER CODE END Includes */

/* Private variables ---------------------------------------------------------*/
#define SIZE_256 256
#define SIZE_192 192
#define SIZE_128 128
/* USER CODE BEGIN PV */
/* Private variables ---------------------------------------------------------*/

//Add following tow lines when using Keil to flash the USBStick
//uint32_t 						vectorTable_RAM[256] __attribute__(( aligned (0x200ul) ));
//extern uint32_t 		__Vectors[];                             /* vector table ROM  */
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);


/* USER CODE BEGIN PFP */
/* Private function prototypes -----------------------------------------------*/
//ECB MODE.
static int test_ECB_256();
static int test_ECB_192();
static int test_ECB_128();
//CBC MODE.
static int test_CBC_256();
static int test_CBC_192();
static int test_CBC_128();
//CTR MODE.
static int test_CTR_256();
static int test_CTR_192();
static int test_CTR_128();
//CFB MODE.
static int test_CFB_256();
static int test_CFB_192();
static int test_CFB_128();
//OFB MODE.
static int test_OFB_256();
static int test_OFB_192();
static int test_OFB_128();
// CMAC
static int test_AES_CMAC();
/* USER CODE END PFP */

/* USER CODE BEGIN 0 */
char buffer[128];
B5_tAesCtx ctx;
extern RNG_HandleTypeDef hrng;

/*
 * Create random vectors of size bytes
 */
static void generate_rnd_vector(uint8_t *v, size_t size)
{
	srand(HAL_GetTick());
	for (size_t i = 0; i < size; i++) {
		v[i] = (uint8_t)rand();
	}
}


/* USER CODE END 0 */

int main(void)
{

	/* USER CODE BEGIN 1 */
	// Init SEcube structures
	//uint8_t a,b,c;

	/* USER CODE END 1 */
	/* MCU Configuration----------------------------------------------------------*/

	/* Reset of all peripherals, Initializes the Flash interface and the Systick. */
	HAL_Init();

	/* Configure the system clock */
	SystemClock_Config();

	//Add following lines when using Keil to flash the USBStick
	// Remapping Interrupt Vector (overload the USB Loader Interrupt Vector)		
//	uint32_t i;
//	for (i = 0; i < 256; i++) {
//		vectorTable_RAM[i] = __Vectors[i];            /* copy vector table to RAM */
//	}
//
//  __disable_irq();
//  SCB->VTOR = (uint32_t)&vectorTable_RAM;
//  __DSB();
//  __enable_irq();
	
	
	/* Initialize all configured peripherals */
	MX_GPIO_Init();
	MX_USART1_UART_Init();
	MX_DMA_Init();
	MX_ADC1_Init();
	// MX_FMC_Init();
	MX_I2C2_Init();
	MX_SDIO_SD_Init();
	MX_SPI5_Init();
	MX_TIM4_Init();
	// MX_USART1_UART_Init();
	// MX_USART6_SMARTCARD_Init();
	// MX_USB_DEVICE_Init();
	MX_CRC_Init();
	MX_RNG_Init();
	/* USER CODE BEGIN */
	uint8_t rcvd = 0;
	while (rcvd != 'a'){
		PRINT_DBG(huart1, buffer, sizeof(buffer), "Insert 'a' to start: \r");
		HAL_UART_Receive(&huart1, &rcvd, 1, HAL_MAX_DELAY);
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "\r\n");

	PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA initialization\n\r");
	FPGA_IPM_init();

	PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA programming\n\r");
	// B5_FPGA_Programming();
	HAL_GPIO_WritePin(GPIOG, FPGA_RST_Pin, GPIO_PIN_SET);
	HAL_GPIO_WritePin(GPIOG, FPGA_RST_Pin, GPIO_PIN_RESET);

	HAL_Delay(500);
	PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA programmed\n\r");

//ECB MODE TEST SUITE.
	if (test_ECB_256() == 0)
		return 0;
	if (test_ECB_192() == 0)
		return 0;
	if (test_ECB_128() == 0)
		return 0;

//CBC MODE TEST SUITE.
	if (test_CBC_256() == 0)
		return 0;
	if (test_CBC_192() == 0)
		return 0;
	if (test_CBC_128() == 0)
		return 0;
//CTR MODE TEST SUITE.
	if (test_CTR_256() == 0)
		return 0;
	if (test_CTR_192() == 0)
		return 0;
	if (test_CTR_128() == 0)
		return 0;
//CFB MODE TEST SUITE.
	if (test_CFB_256() == 0)
		return 0;
	if (test_CFB_192() == 0)
		return 0;
	if (test_CFB_128() == 0)
		return 0;
//CFB MODE TEST SUITE.
	if (test_OFB_256() == 0)
		return 0;
	if (test_OFB_192() == 0)
		return 0;
	if (test_OFB_128() == 0)
		return 0;
// CMAC TEST SUITE
	if (test_AES_CMAC() == 0)
		return 0;
	/*device_init();
	device_loop();*/
	/* USER CODE END  */
	return 0;
}





/** System Clock Configuration
*/
void SystemClock_Config(void)
{


	RCC_OscInitTypeDef RCC_OscInitStruct;
	RCC_ClkInitTypeDef RCC_ClkInitStruct;

	__PWR_CLK_ENABLE();
	__HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

	RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
	RCC_OscInitStruct.HSEState = RCC_HSE_ON;
	RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
	RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
	RCC_OscInitStruct.PLL.PLLM = 16;
	RCC_OscInitStruct.PLL.PLLN = 336;
	RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
	RCC_OscInitStruct.PLL.PLLQ = 7;
	HAL_RCC_OscConfig(&RCC_OscInitStruct);

	RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
							  |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
	RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
	RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
	RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
	RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;
	HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5);

	HAL_RCC_MCOConfig(RCC_MCO1, RCC_MCO1SOURCE_PLLCLK, RCC_MCODIV_2);

	HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq()/1000);

	HAL_SYSTICK_CLKSourceConfig(SYSTICK_CLKSOURCE_HCLK);

	/* SysTick_IRQn interrupt configuration */
	HAL_NVIC_SetPriority(SysTick_IRQn, 0, 0);
}

/* USER CODE BEGIN 4 */
// ECB MODE TESTS.
int test_ECB_256(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES ECB 256\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_256];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_256, AES_ECB_ENC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_256, B5_AES256_ECB_ENC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_256, AES_ECB_DEC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_256, B5_AES256_ECB_DEC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_ECB_192(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES ECB 192\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_192];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_192, AES_ECB_ENC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_192, B5_AES256_ECB_ENC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_192, AES_ECB_DEC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_192, B5_AES256_ECB_DEC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_ECB_128(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES ECB 128\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_256];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_128, AES_ECB_ENC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_128, B5_AES256_ECB_ENC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_128, AES_ECB_DEC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_128, B5_AES256_ECB_DEC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

//CBC MODE TESTS.
int test_CBC_256(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES CBC 256\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_256];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_256, AES_CBC_ENC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_256, B5_AES256_CBC_ENC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
		return 0;
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_256, AES_CBC_DEC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_256, B5_AES256_CBC_DEC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_CBC_192(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES CBC 192\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_192];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_192, AES_CBC_ENC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_192, B5_AES256_CBC_ENC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
		return 0;
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_192, AES_CBC_DEC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_192, B5_AES256_CBC_DEC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_CBC_128(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES CBC 128\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_128];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_128, AES_CBC_ENC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_128, B5_AES256_CBC_ENC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
		return 0;
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_128, AES_CBC_DEC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_128, B5_AES256_CBC_DEC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

//CTR MODE TESTS.
int test_CTR_256(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES CTR 256\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_256];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_256, AES_CTR) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_256, B5_AES256_CTR) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_256, AES_CTR) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_256, B5_AES256_CTR) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_CTR_192(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES CTR 192\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_192];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_192, AES_CTR) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_192, B5_AES256_CTR) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_192, AES_CTR) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_192, B5_AES256_CTR) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_CTR_128(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES CTR 128\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_128];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_128, AES_CTR) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_128, B5_AES256_CTR) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_128, AES_CTR) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_128, B5_AES256_CTR) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

//CFB MODE TESTS.
int test_CFB_256(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES CFB 256\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_256];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_256, AES_CFB_ENC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_256, B5_AES256_CFB_ENC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_256, AES_CFB_DEC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_256, B5_AES256_CFB_DEC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_CFB_192(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES CFB 192\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_192];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_192, AES_CFB_ENC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_192, B5_AES256_CFB_ENC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_192, AES_CFB_DEC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_192, B5_AES256_CFB_DEC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_CFB_128(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES CFB 128\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_128];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_128, AES_CFB_ENC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_128, B5_AES256_CFB_ENC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_128, AES_CFB_DEC) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_128, B5_AES256_CFB_DEC) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

//OFB MOTE TESTS.

int test_OFB_256(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES OFB 256\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_256];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_256, AES_OFB) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_256, B5_AES256_OFB) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_256, AES_OFB) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_256, B5_AES256_OFB) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_OFB_192(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES OFB 192\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_192];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_192, AES_OFB) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_192, B5_AES256_OFB) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_192, AES_OFB) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_192, B5_AES256_OFB) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_OFB_128(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES OFB 128\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_128];
	uint8_t IV[B5_AES_IV_SIZE];
	B5_tAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// generate IV
	generate_rnd_vector(IV, B5_AES_IV_SIZE);

	// setup encryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_128, AES_OFB) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_128, B5_AES256_OFB) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// IV setup

	if (AES_FPGA_SetIV(&fpga_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA IV setup failed\n\r");
	}

	if (B5_Aes256_SetIV(&sw_ctx, IV) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW IV setup failed\n\r");
	}

	// Encrypt

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA encryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW encryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Encryption successful\n\r");

	// setup decryption

	if (AES_FPGA_init(&fpga_ctx, key, B5_AES_128, AES_OFB) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_Aes256_Init(&sw_ctx, key, B5_AES_128, B5_AES256_OFB) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// decryption

	if (AES_FPGA_update(&fpga_ctx, fpga_output, fpga_input, SIZE_256/B5_AES_BLK_SIZE, SIZE_256) != AES_FPGA_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA decryption failed\n\r");
		return 0;
	}

	if (B5_Aes256_Update(&sw_ctx, sw_output, sw_input, SIZE_256/B5_AES_BLK_SIZE) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW decryption failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_input = 0x%02x while sw_input = 0x%02x\n\r", i, fpga_input[i], sw_input[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Decryption successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}

int test_AES_CMAC(){
	PRINT_DBG(huart1, buffer, sizeof(buffer), "Start test AES CMAC\n\r");
	uint8_t fpga_input[SIZE_256], sw_input[SIZE_256];
	uint8_t fpga_output[SIZE_256], sw_output[SIZE_256];
	uint8_t key[B5_AES_256];
	B5_tCmacAesCtx fpga_ctx, sw_ctx;

	// generate the keys
	generate_rnd_vector(key, B5_AES_256);

	// generate plain text
	generate_rnd_vector(fpga_input, SIZE_256);
	memcpy(fpga_input, sw_input, SIZE_256);

	// setup encryption
	if (AES_FPGA_Cmac_Init(&fpga_ctx, key, B5_AES_256) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA setup failed\n\r");
		return 0;
	}

	if (B5_CmacAes256_Init(&sw_ctx, key, B5_AES_256) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW setup failed\n\r");
		return 0;
	}

	// Encrypt

	if (AES_FPGA_Cmac_Update(&fpga_ctx, fpga_input, SIZE_256) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA update failed\n\r");
		return 0;
	}

	if (B5_CmacAes256_Update(&sw_ctx, sw_input, SIZE_256) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW update failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_input[i] != sw_input[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Update successful\n\r");

	if (AES_FPGA_Cmac_Sign(fpga_input, SIZE_256, key, B5_AES_256, fpga_output) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA signature failed\n\r");
		return 0;
	}

	if (B5_CmacAes256_Sign(sw_input, SIZE_256, key, B5_AES_256, sw_output) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW signature failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	if (AES_FPGA_Cmac_Finit(&fpga_ctx, fpga_output) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "FPGA finit failed\n\r");
		return 0;
	}

	if (B5_CmacAes256_Finit(&sw_ctx, sw_output) != B5_AES256_RES_OK) {
		PRINT_DBG(huart1, buffer, sizeof(buffer), "SW finit failed\n\r");
		return 0;
	}

	for (int i = 0; i < SIZE_256; i++) {
		if (fpga_output[i] != sw_output[i]) {
			PRINT_DBG(huart1, buffer, sizeof(buffer), "Data %d, fpga_output = 0x%02x while sw_output = 0x%02x\n\r", i, fpga_output[i], sw_output[i]);
			return 0;
		}
	}

	PRINT_DBG(huart1, buffer, sizeof(buffer), "Finit successful\n\r");
	PRINT_DBG(huart1, buffer, sizeof(buffer), "\n\r");
	return 1;
}
#ifdef USE_FULL_ASSERT

/**
   * @brief Reports the name of the source file and the source line number
   * where the assert_param error has occurred.
   * @param file: pointer to the source file name
   * @param line: assert_param error line source number
   * @retval None
   */
void assert_failed(uint8_t* file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
    ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */

}

#endif

/**
  * @}
  */ 

/**
  * @}
*/ 

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
