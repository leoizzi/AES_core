#include "AES_FPGA.h"
#include "uart_debug.h"

static char buffer[128];
extern UART_HandleTypeDef huart1;

/** \brief Process data using FPGA acceleration. The caller must guarantee that input_text and output_text are both valid 128 bits vectors
 *  \param  128 bits input text.
 *  \result 128 bits output text.
 *  \return Returns AES_FPGA_RES_OK on success, error code on error.
 */
static AES_FPGA_RETURN_CODE AES_FPGA_blk_process(uint8_t *input_text, uint8_t *output_text, aes_op_t aes_op);

AES_FPGA_RETURN_CODE AES_FPGA_setup(B5_tAesCtx *ctx, const uint8_t *Key, int16_t keySize, aes_mode_t aes_mode){
	int8_t r;

	if (B5_Aes256_Init(ctx, Key, keySize, aes_mode) != B5_AES256_RES_OK)
		return AES_KEY_INIT_ERROR;

	//Select the OPERATING MODE OF THE FPGA: 128, 192, 256.
	//Open communication with FPGA.
	r = FPGA_IPM_open(AES_CORE_ID, ALG_SEL, 0, 0);
	if (r != 0)
		return  FPGA_ERROR;
	//Transaction correctly opened.

	FPGA_IPM_DATA algo_sel = (FPGA_IPM_DATA)(ctx->Nr + 1);
	//Write the algorithm selection.
	if (FPGA_IPM_write(AES_CORE_ID, ALG_SEL_ADDR, &algo_sel)) {
		return FPGA_ERROR;
	}

	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0)
		return FPGA_ERROR;

//Transfer the keys in the context.

	//Open communication with FPGA.
	r = FPGA_IPM_open(AES_CORE_ID, KEY_TRANSFER, 0, 0);
	if (r != 0)
		return  FPGA_ERROR;

	FPGA_IPM_DATA* pt = (FPGA_IPM_DATA*)ctx->rk;

	for (int i=0; i < (algo_sel << 2) << 1; i++){ //4*(Nr + 1)
		if (FPGA_IPM_write(AES_CORE_ID, WRITE_BASE_ADDR + (i & 0x7), &pt[i])) {
			return FPGA_ERROR;
		}
	}

	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0)
		return FPGA_ERROR;

	//Return OK.
	return AES_FPGA_RES_OK;
}

int32_t AES_FPGA_SetIV(B5_tAesCtx *ctx, const uint8_t *IV)
{
	return B5_Aes256_SetIV(ctx, IV);
}

static AES_FPGA_RETURN_CODE AES_FPGA_blk_process(uint8_t *input_text, uint8_t *output_text, aes_op_t aes_op) {

	int8_t r;

	//Transmit the data to be processed.
	//Open communication with FPGA.
	r = FPGA_IPM_open(AES_CORE_ID, DATA_TX, 0, 0);
	if (r != 0)
		return  FPGA_ERROR;

	FPGA_IPM_DATA *tx_data = (FPGA_IPM_DATA *)input_text;

	//Transmit 128-bit data.
	for (int i=0; i < (B5_AES_BLK_SIZE >> 1); i++){
		if (FPGA_IPM_write(AES_CORE_ID, WRITE_BASE_ADDR + i, &tx_data[i])) {
			return FPGA_ERROR;
		}
	}

	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0)
		return FPGA_ERROR;

	//Read back the result from the FPGA.
	//Open communication with FPGA.
	if (aes_op == AES_OP_ENCRYPT) {
		r = FPGA_IPM_open(AES_CORE_ID, ENCRYPTION, 0, 0);
	} else { // AES_OP_DECRYPT
		r = FPGA_IPM_open(AES_CORE_ID, DECRYPTION, 0, 0);
	}

	if (r != 0)
		return  FPGA_ERROR;

	//Write the lock.
	FPGA_IPM_DATA lock = FPGA_LOCK;
	if (FPGA_IPM_write(AES_CORE_ID, LOCK_ADDR, &lock)) {
		return FPGA_ERROR;
	}

	//Wait until FPGA ends the encryption.
	while (lock == FPGA_LOCK) {
		if (FPGA_IPM_read(AES_CORE_ID, LOCK_ADDR, &lock)) {
			return FPGA_ERROR;
		}
	}

	//FPGA computation finished, read back the output data.
	FPGA_IPM_DATA *rx_data = (FPGA_IPM_DATA *)output_text;
	for (int i=0; i < (B5_AES_BLK_SIZE >> 1); i++){
		FPGA_IPM_read(AES_CORE_ID, WRITE_BASE_ADDR + i, &rx_data[i]);
	}

	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0)
		return FPGA_ERROR;

	return AES_FPGA_RES_OK;

}

AES_FPGA_RETURN_CODE AES_FPGA_Update(B5_tAesCtx *ctx, uint8_t *encData, uint8_t *clrData, uint16_t nBlk, uint32_t data_len)
{
	int16_t    i, j, cb;
	uint8_t    tmp[B5_AES_BLK_SIZE];
	AES_FPGA_RETURN_CODE r;

	if(ctx == NULL)
		return  AES_FPGA_RES_INVALID_ARGUMENT;

	if((encData == NULL) || (clrData == NULL))
		return AES_FPGA_RES_INVALID_ARGUMENT;

	if (data_len & SIZE_MASK) {
		return AES_FPGA_RES_INVALID_ARGUMENT;
	}

	switch(ctx->mode) {
		case B5_AES256_CTR:
		{
			for (i = 0; i < nBlk; i++) {
				r = AES_FPGA_blk_process(ctx->InitVector, encData, AES_OP_ENCRYPT);
				if (r != AES_FPGA_RES_OK) {
					return r;
				}

				for (j = 0; j < B5_AES_BLK_SIZE; j++) {
					*encData = *encData ^ *clrData;
					encData++;
					clrData++;
				}

				j = 15;
				do {
					ctx->InitVector[j]++;
					cb = ctx->InitVector[j] == 0;
				} while(j-- && cb);
			}

			break;
		}


		case B5_AES256_OFB:
		{
			for (i = 0; i < nBlk; i++) {
				r = AES_FPGA_blk_process(ctx->InitVector, ctx->InitVector, AES_OP_ENCRYPT);
				if (r != AES_FPGA_RES_OK) {
					return r;
				}

				for (j = 0; j < B5_AES_BLK_SIZE; j++) {
					*encData++ = *clrData++ ^ ctx->InitVector[j];
				}
			}

			break;
		}



		case B5_AES256_ECB_ENC:
		{
			for (i = 0; i < nBlk; i++) {
				r = AES_FPGA_blk_process(clrData, encData, AES_OP_ENCRYPT);
				if (r != AES_FPGA_RES_OK) {
					return r;
				}

				clrData += B5_AES_BLK_SIZE;
				encData += B5_AES_BLK_SIZE;
			}

			break;
		}


		case B5_AES256_ECB_DEC:
		{
			for (i = 0; i < nBlk; i++) {
				r = AES_FPGA_blk_process(encData, clrData, AES_OP_DECRYPT);
				if (r != AES_FPGA_RES_OK) {
					return r;
				}

				clrData += B5_AES_BLK_SIZE;
				encData += B5_AES_BLK_SIZE;
			}

			break;
		}


		case B5_AES256_CBC_ENC:
		{
			for (i = 0; i < nBlk; i++) {
				for (j = 0; j < B5_AES_BLK_SIZE; j++) {
					tmp[j] = clrData[j] ^ ctx->InitVector[j];
				}

				r = AES_FPGA_blk_process(tmp, encData, AES_OP_ENCRYPT);
				if (r != AES_FPGA_RES_OK) {
					return r;
				}

				for (j = 0; j < B5_AES_BLK_SIZE; j++) {
					ctx->InitVector[j] = encData[j];
				}

				clrData += B5_AES_BLK_SIZE;
				encData += B5_AES_BLK_SIZE;
			}

			break;
		}


		case B5_AES256_CBC_DEC:
		{
			for (i = 0; i < nBlk; i++) {
				for (j = 0; j < B5_AES_BLK_SIZE; j++) {
					tmp[j] = encData[j];
				}

				r = AES_FPGA_blk_process(encData, clrData, AES_OP_DECRYPT);
				if (r != AES_FPGA_RES_OK) {
					return r;
				}

				for (j = 0; j < B5_AES_BLK_SIZE; j++) {
					clrData[j] ^= ctx->InitVector[j];
					ctx->InitVector[j] = tmp[j];
				}

				clrData += B5_AES_BLK_SIZE;
				encData += B5_AES_BLK_SIZE;
			}

			break;
		}


		case B5_AES256_CFB_ENC:
		{
			for (i = 0; i < nBlk; i++) {
				r = AES_FPGA_blk_process(ctx->InitVector, tmp, AES_OP_DECRYPT);
				if (r != AES_FPGA_RES_OK) {
					return r;
				}

				for (j = 0; j < B5_AES_BLK_SIZE; j++) {
					encData[j] = clrData[j] ^ tmp[j];
					ctx->InitVector[j] = encData[j];
				}


				clrData += B5_AES_BLK_SIZE;
				encData += B5_AES_BLK_SIZE;
			}

			break;
		}


		case B5_AES256_CFB_DEC:
		{
			for (i = 0; i < nBlk; i++) {
				r = AES_FPGA_blk_process(ctx->InitVector, tmp, AES_OP_DECRYPT);
				if (r != AES_FPGA_RES_OK) {
					return r;
				}

				for (j = 0; j < B5_AES_BLK_SIZE; j++) {
					ctx->InitVector[j] = encData[j];
					clrData[j] = encData[j] ^ tmp[j];
				}

				clrData += B5_AES_BLK_SIZE;
				encData += B5_AES_BLK_SIZE;
			}

			break;
		}


		default:
		{

			return B5_AES256_RES_INVALID_MODE;
		}

	}

	return AES_FPGA_RES_OK;
}
