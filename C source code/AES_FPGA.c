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
			PRINT_DBG(huart1, buffer, sizeof(buffer), "crash 0\n\r");
			return FPGA_ERROR;
		}

		uint16_t v;
		FPGA_IPM_read(AES_CORE_ID, WRITE_BASE_ADDR+i, &v);
	}

	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0) {
		return FPGA_ERROR;
	}

	//Read back the result from the FPGA.
	//Open communication with FPGA.
	if (aes_op == AES_OP_ENCRYPT) {
		r = FPGA_IPM_open(AES_CORE_ID, ENCRYPTION, 0, 0);
	} else { // AES_OP_DECRYPT
		r = FPGA_IPM_open(AES_CORE_ID, DECRYPTION, 0, 0);
	}

	if (r != 0) {
		return  FPGA_ERROR;
	}

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

AES_FPGA_RETURN_CODE AES_FPGA_update(B5_tAesCtx *ctx, uint8_t *encData, uint8_t *clrData, uint16_t nBlk, uint32_t data_len)
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
				r = AES_FPGA_blk_process(ctx->InitVector, tmp, AES_OP_ENCRYPT);
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
				r = AES_FPGA_blk_process(ctx->InitVector, tmp, AES_OP_ENCRYPT);
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

int32_t AES_FPGA_Cmac_Init(B5_tCmacAesCtx *ctx, const uint8_t *Key, int16_t keySize)
{
	uint8_t    Z[16];
	uint8_t    L[16];
	uint8_t    Rb16[16]={0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x87};
	int32_t    i;

	if(Key == NULL)
		return B5_CMAC_AES256_RES_INVALID_ARGUMENT;

	if(ctx == NULL)
		return  B5_CMAC_AES256_RES_INVALID_CONTEXT;

	memset(ctx, 0, sizeof(B5_tCmacAesCtx));
	memset(Z, 0x00, sizeof(Z));

	// Init AES to prepare K1 and K2 subKeys
	AES_FPGA_setup(&ctx->aesCtx, Key, keySize, AES_ECB_ENC);
	AES_FPGA_update(&ctx->aesCtx, L, Z, 1, B5_AES_BLK_SIZE);

	// Prepare K1
	for (i=0; i < (B5_AES_BLK_SIZE-1); i++)
		ctx->K1[i] = (L[i] << 1) + (L[i+1] >> 7);
	ctx->K1[i] = L[i] << 1;

	if ((L[0] & 0x80) == 0x80) {
		for (i=0; i < B5_AES_BLK_SIZE; i++)
			ctx->K1[i] ^= Rb16[i];
	}

	// Prepare K2
	for (i=0; i < (B5_AES_BLK_SIZE-1); i++)
		ctx->K2[i] = (ctx->K1[i] << 1) + (ctx->K1[i+1] >> 7);
	ctx->K2[i] = ctx->K1[i] << 1;

	if ((ctx->K1[0] & 0x80) == 0x80) {
		for (i=0; i < B5_AES_BLK_SIZE; i++)
			ctx->K2[i] ^= Rb16[i];
	}

	memcpy(ctx->C, Z, sizeof(Z));
	ctx->tmpBlkLen = 0;
	return B5_CMAC_AES256_RES_OK;
}

int32_t AES_FPGA_Cmac_Update(B5_tCmacAesCtx *ctx, const uint8_t *data, int32_t dataLen)
{
	int32_t i;

	if(ctx == NULL)
		return  B5_CMAC_AES256_RES_INVALID_CONTEXT;

	if((data == NULL) || (dataLen < 0))
		return B5_CMAC_AES256_RES_INVALID_ARGUMENT;

	if(dataLen == 0)
		return B5_CMAC_AES256_RES_OK;

	if(ctx->tmpBlkLen > 0) {
		// Not enough
		if((dataLen + ctx->tmpBlkLen) <= B5_AES_BLK_SIZE) {
			memcpy(&ctx->tmpBlk[ctx->tmpBlkLen], data, dataLen);
			ctx->tmpBlkLen += dataLen;
			return B5_CMAC_AES256_RES_OK;
		}

		// Process the first block (merging tmpBlk and data) and adjust data pointer
		memcpy(&ctx->tmpBlk[ctx->tmpBlkLen], data, B5_AES_BLK_SIZE-ctx->tmpBlkLen);
		for (i=0; i < B5_AES_BLK_SIZE; i++)
			ctx->C[i] ^= ctx->tmpBlk[i];
		AES_FPGA_update(&ctx->aesCtx, ctx->C, ctx->C, 1, B5_AES_BLK_SIZE);
		data += (B5_AES_BLK_SIZE-ctx->tmpBlkLen);
		dataLen -= (B5_AES_BLK_SIZE-ctx->tmpBlkLen);
		ctx->tmpBlkLen = 0;
	}

	// Other Blocks
	while (dataLen > B5_AES_BLK_SIZE) {
		for (i=0; i < B5_AES_BLK_SIZE; i++)
			ctx->C[i] ^= data[i];
		AES_FPGA_update(&ctx->aesCtx, ctx->C, ctx->C, 1, B5_AES_BLK_SIZE);
		dataLen -= B5_AES_BLK_SIZE;
		data += B5_AES_BLK_SIZE;
	}

	memcpy(&ctx->tmpBlk[0], data, dataLen);
	ctx->tmpBlkLen = dataLen;
	return B5_CMAC_AES256_RES_OK;
}

int32_t AES_FPGA_Cmac_Finit(B5_tCmacAesCtx *ctx, uint8_t *rSignature)
{
	int32_t i;
	uint8_t MN[B5_AES_BLK_SIZE];

	if(ctx == NULL)
		return B5_CMAC_AES256_RES_INVALID_CONTEXT;

	if(rSignature == NULL)
		return B5_CMAC_AES256_RES_INVALID_ARGUMENT;

	// Last Block
	if(ctx->tmpBlkLen == B5_AES_BLK_SIZE) {
		for (i=0; i < ctx->tmpBlkLen; i++)
			MN[i] = ctx->K1[i] ^ ctx->tmpBlk[i];
	} else {
		for (i=0; i < B5_AES_BLK_SIZE; i++)
			MN[i] = ctx->K2[i];
		for (i=0; i < ctx->tmpBlkLen; i++)
			MN[i] ^= ctx->tmpBlk[i];
		MN[ctx->tmpBlkLen] ^= 0x80;
	}

	for (i=0; i < B5_AES_BLK_SIZE; i++)
		ctx->C[i] ^= MN[i];

	AES_FPGA_update(&ctx->aesCtx, rSignature, ctx->C, 1, B5_AES_BLK_SIZE);
	return B5_CMAC_AES256_RES_OK;
}

int32_t AES_FPGA_Cmac_Reset(B5_tCmacAesCtx *ctx)
{
	if(ctx == NULL)
		return B5_CMAC_AES256_RES_INVALID_CONTEXT;

	memset(ctx->C, 0, sizeof(ctx->C));
	ctx->tmpBlkLen = 0;
	return B5_CMAC_AES256_RES_OK;
}

int32_t AES_FPGA_Cmac_Sign(const uint8_t *data, int32_t dataLen, const uint8_t *Key, int16_t keySize, uint8_t *rSignature)
{
	uint8_t K1[B5_AES_BLK_SIZE], K2[B5_AES_BLK_SIZE];
	uint8_t L[B5_AES_BLK_SIZE], C[B5_AES_BLK_SIZE], Z[B5_AES_BLK_SIZE];
	uint8_t MN[B5_AES_BLK_SIZE];
	uint8_t Rb16[16]={0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x87};
	int32_t i;
	B5_tAesCtx aesCtx;

	if((data == NULL) || (dataLen < 0) || (Key == NULL) || (rSignature == NULL))
		return B5_CMAC_AES256_RES_INVALID_ARGUMENT;

	if((keySize != B5_CMAC_AES_128) && (keySize != B5_CMAC_AES_192) && (keySize != B5_CMAC_AES_256))
		return B5_CMAC_AES256_RES_INVALID_KEY_SIZE;

	memset(Z, 0x00, sizeof(Z));

	// Init AES to prepare K1 and K2 subKeys
	AES_FPGA_setup(&aesCtx, Key, keySize, AES_ECB_ENC);
	AES_FPGA_update(&aesCtx, L, Z, 1, B5_AES_BLK_SIZE);

	// Prepare K1
	for (i=0; i < (B5_AES_BLK_SIZE-1); i++)
		K1[i] = (L[i] << 1) + (L[i+1] >> 7);
	K1[i] = L[i] << 1;

	if ((L[0] & 0x80) == 0x80) {
		for (i=0; i < B5_AES_BLK_SIZE; i++)
			K1[i] ^= Rb16[i];
	}

	// Prepare K2
	for (i=0; i < (B5_AES_BLK_SIZE-1); i++)
		K2[i] = (K1[i] << 1) + (K1[i+1] >> 7);
	K2[i] = K1[i] << 1;

	if ((K1[0] & 0x80) == 0x80) {
		for (i=0; i < B5_AES_BLK_SIZE; i++)
			K2[i] ^= Rb16[i];
	}

	// Calculate MAC (from 1 to N-1 blk)
	memcpy(C, Z, sizeof(Z));
	while(dataLen > B5_AES_BLK_SIZE) {
		for (i=0; i < B5_AES_BLK_SIZE; i++)
			C[i] ^= data[i];

		AES_FPGA_update(&aesCtx, C, C, 1, B5_AES_BLK_SIZE);

		dataLen -= B5_AES_BLK_SIZE;
		data += B5_AES_BLK_SIZE;
	}

	// Last Block
	if(dataLen == B5_AES_BLK_SIZE) {
		for (i=0; i < dataLen; i++)
			MN[i] = K1[i] ^ data[i];
	} else {
		for (i=0; i < B5_AES_BLK_SIZE; i++)
			MN[i] = K2[i];
		for (i=0; i < dataLen; i++)
			MN[i] ^= data[i];
		MN[dataLen] ^= 0x80;
	}

	for (i=0; i<B5_AES_BLK_SIZE; i++)
		C[i] ^= MN[i];

	AES_FPGA_update(&aesCtx, rSignature, C, 1, B5_AES_BLK_SIZE);
	return B5_CMAC_AES256_RES_OK;
}
