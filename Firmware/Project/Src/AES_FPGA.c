/*
 * AES_FPGA.c
 *
 *  Created on: 9 giu 2021
 *      Author: lollo
 */


#include "AES_FPGA.h"
#include "aes256.h"
#include "Fpgaipm.h"

AES_FPGA_RETURN_CODE AES_FPGA_256_init(B5_tAesCtx *ctx, const uint8_t *Key){
	//Init the ctx structure.
	if (B5_Aes256_Init(&ctx, (uint8_t*) &Key, sizeof(Key), B5_AES256_CTR) != B5_AES256_RES_OK)
		return AES_KEY_INIT_ERROR;
	//Return OK.
	return AES_FPGA_RES_OK;
}

AES_FPGA_RETURN_CODE AES_FPGA_256_encrypt(B5_tAesCtx *ctx, const uint8_t *clear_data, uint8_t *encr_data){

	int8_t r;

	//Here the ctx contains all key for the encription.
	//Open communication with FPGA.
	r = FPGA_IPM_open(
			AES_CORE_ID,		  //AES_ID.
			SHARE_GEN_KEY_OPCODE, //SHARE GENERATED KEY OPERATION.
			0,					  //POLLING MODE.
			0);				      //NO ACK.
	if (r == 0)
		return  AES_FPGA_OPEN_ERROR;

	//COM correctly opened.
	//TODO - SEND ALL KEYS ACCORDING WITH FPGA.
	FPGA_IPM_write(AES_CORE_ID, 0, &ctx->rk);

	FPGA_IPM_close(AES_CORE_ID);

	r = FPGA_IPM_open(
				AES_CORE_ID,		  //AES_ID.
				ENCRYPT_OPCODE,       //ENCRYPT OPERATION.
				0,					  //POLLING MODE.
				0);				      //NO ACK.
	if (r == 0)
		return  AES_FPGA_OPEN_ERROR;

	//COM correctly opened.
	//TODO - SEND ALL DATA SECTION ACCORDING WITH FPGA AND READ THE RESPONSE.
	FPGA_IPM_write(AES_CORE_ID, 0, &clear_data);
	FPGA_IPM_read(AES_CORE_ID, 0, &encr_data);
	FPGA_IPM_close(AES_CORE_ID);

	return AES_FPGA_RES_OK;

}


AES_FPGA_RETURN_CODE AES_FPGA_256_decrypt(B5_tAesCtx *ctx, uint8_t *encr_data, uint8_t *clear_data){

	int8_t r;

	//Here the ctx contains all key for the encription.
	//Open communication with FPGA.
	r = FPGA_IPM_open(
			AES_CORE_ID,		  //AES_ID.
			SHARE_GEN_KEY_OPCODE, //SHARE GENERATED KEY OPERATION.
			0,					  //POLLING MODE.
			0);				      //NO ACK.
	if (r == 0)
		return  AES_FPGA_OPEN_ERROR;

	//COM correctly opened.
	//TODO - SEND ALL KEYS ACCORDING WITH FPGA.
	FPGA_IPM_write(AES_CORE_ID, 0, &ctx->rk);

	FPGA_IPM_close(AES_CORE_ID);

	r = FPGA_IPM_open(
				AES_CORE_ID,		  //AES_ID.
				DECRYPT_OPCODE,       //DECRYPT OPERATION.
				0,					  //POLLING MODE.
				0);				      //NO ACK.
	if (r == 0)
		return  AES_FPGA_OPEN_ERROR;

	//COM correctly opened.
	//TODO - SEND ALL DATA SECTION ACCORDING WITH FPGA AND READ THE RESPONSE.
	FPGA_IPM_write(AES_CORE_ID, 0, &encr_data);
	FPGA_IPM_read(AES_CORE_ID, 0, &clear_data);
	FPGA_IPM_close(AES_CORE_ID);

	return AES_FPGA_RES_OK;
}
