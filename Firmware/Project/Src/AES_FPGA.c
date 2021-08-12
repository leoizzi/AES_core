/*
 * AES_FPGA.c
 *
 *  Created on: 9 giu 2021
 *      Author: lollo
 */


#include "AES_FPGA.h"
#include "aes256.h"
#include "Fpgaipm.h"

AES_FPGA_RETURN_CODE AES_FPGA_setup(B5_tAesCtx *ctx, const uint8_t *Key, int16_t keySize, uint8_t aes_mode){

	int8_t r;
	FPGA_IPM_ADDRESS base_addr = WRITE_BASE_ADDR;

	if (aes_mode == AES_MODE_ENCRYPT)
		r = B5_Aes256_Init(ctx, Key, keySize, B5_AES256_CBC_ENC);
	else if (aes_mode == AES_MODE_DECRYPT)
		r = B5_Aes256_Init(ctx, Key, keySize, B5_AES256_CBC_DEC);
	else
		return AES_KEY_INIT_ERROR;

	//Init the ctx structure.
	if (r != B5_AES256_RES_OK)
		return AES_KEY_INIT_ERROR;

//Select the OPERATING MODE OF THE FPGA: 128, 192, 256.

	//Open communication with FPGA.
	r = FPGA_IPM_open(AES_CORE_ID,		  //AES_ID.
					  ALG_SEL, 			  //ALGORITHM SELECTION OPCODE.
					  0,				  //POLLING MODE.
					  0);				  //NO ACK.
	if (r != 0)
		return  FPGA_ERROR;
	//Transaction correctly opened.

	FPGA_IPM_DATA algo_sel = (FPGA_IPM_DATA)(ctx->Nr + 1);

	//Write the algorithm selection.
	FPGA_IPM_write(AES_CORE_ID,			  //AES_ID.
				   ALG_SEL_ADDR,		  //FPGA ADDRESS.
				   &algo_sel);            //16-bit Data.

	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0)
		return FPGA_ERROR;

//Transfer the keys in the context.

	//Open communication with FPGA.
	r = FPGA_IPM_open(AES_CORE_ID,		  //AES_ID.
					  KEY_TRANSFER,       //SHARE KEY OPCODE.
					  0,				  //POLLING MODE.
					  0);				  //NO ACK.
	if (r != 0)
		return  FPGA_ERROR;

	FPGA_IPM_DATA rk_msb, rk_lsb;

	uint8_t key_cnt = 0;
	for (int i=0; i < (algo_sel << 2); i++){ //4*(Nr + 1)
		/* ctx-> rk[i] is 32-bit and IPM data is 16 bit */
		rk_msb = (FPGA_IPM_DATA) ((ctx->rk[i] >> 16) & 0x0000FFFF);
		rk_lsb = (FPGA_IPM_DATA) (ctx->rk[i] & 0x0000FFFF);

		FPGA_IPM_write(AES_CORE_ID,			  			  //AES_ID.
					  (base_addr + (key_cnt % 8)),		  //FPGA ADDRESS.
					   &rk_lsb);                          //16-bit Data.
		key_cnt ++;

		FPGA_IPM_write(AES_CORE_ID,			  			  //AES_ID.
					  (base_addr + (key_cnt % 8)),		  //FPGA ADDRESS.
					   &rk_msb);                          //16-bit Data.
		key_cnt ++;
	}
	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0)
		return FPGA_ERROR;

	//Return OK.
	return AES_FPGA_RES_OK;
}

AES_FPGA_RETURN_CODE AES_FPGA_encrypt(B5_tAesCtx *ctx, uint8_t *plaintext, uint8_t plaintextSize, uint8_t *cyphertext) {

	int8_t r;
	FPGA_IPM_ADDRESS base_addr = WRITE_BASE_ADDR;

	if (plaintextSize != 16) //plaintext must be 128 bit length.
		return AES_FPGA_RES_INVALID_ARGUMENT;

//Transmit the data to encrypt.
	//Open communication with FPGA.
	r = FPGA_IPM_open(AES_CORE_ID,		  //AES_ID.
					  DATA_TX,            //DATA TX OPCODE.
					  0,				  //POLLING MODE.
					  0);				  //NO ACK.
	if (r != 0)
		return  FPGA_ERROR;

	FPGA_IPM_DATA tx_data;

	//Transmit 128-bit data.
	for (int i=0; i<8; i++){
		tx_data = (FPGA_IPM_DATA) ( (plaintext[i] << 8) | plaintext[i+1] );
		FPGA_IPM_write(AES_CORE_ID,		   //AES_ID.
					  (base_addr + i),	   //FPGA ADDRESS.
					   &tx_data);		   //NO ACK.
	}
	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0)
		return FPGA_ERROR;
//Perform encription and read back the result from the FPGA.
	//Open communication with FPGA.
	r = FPGA_IPM_open(AES_CORE_ID,		  //AES_ID.
					  ENCRYPTION,         //ENCRYPTION OPCODE.
					  0,				  //POLLING MODE.
					  0);				  //NO ACK.
	if (r != 0)
		return  FPGA_ERROR;

	//Write the lock.
	FPGA_IPM_DATA lock = FPGA_LOCK;
	FPGA_IPM_write(AES_CORE_ID,		   //AES_ID.
			       LOCK_ADDR,	       //FPGA ADDRESS.
				   &lock);		       //NO ACK.

	//Wait until FPGA ends the encryption.
	while (lock != FPGA_LOCK)
		FPGA_IPM_read(AES_CORE_ID, LOCK_ADDR, &lock);

	//FPGA computation finished, read back the encrypted data.
	FPGA_IPM_DATA rcvd;
	for (int i=0; i<8; i++){
		FPGA_IPM_read(AES_CORE_ID, (base_addr + i), &rcvd);
		cyphertext[i]   = (uint8_t) ((rcvd >> 8) & 0x00FF);
		cyphertext[i+1] = (uint8_t) (rcvd & 0x00FF);
	}

	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0)
		return FPGA_ERROR;

	return AES_FPGA_RES_OK;

}


AES_FPGA_RETURN_CODE AES_FPGA_decrypt(B5_tAesCtx *ctx, uint8_t *cyphertext, uint8_t cyphertextSize, uint8_t *plaintext) {

	int8_t r;
	FPGA_IPM_ADDRESS base_addr = WRITE_BASE_ADDR;

	if (plaintextSize != 16) //plaintext must be 128 bit length.
		return AES_FPGA_RES_INVALID_ARGUMENT;

//Transmit the data to encrypt.
	//Open communication with FPGA.
	r = FPGA_IPM_open(AES_CORE_ID,		  //AES_ID.
					  DATA_TX,            //DATA TX OPCODE.
					  0,				  //POLLING MODE.
					  0);				  //NO ACK.
	if (r != 0)
		return  FPGA_ERROR;

	FPGA_IPM_DATA tx_data;

	//Transmit 128-bit data.
	for (int i=0; i<8; i++){
		tx_data = (FPGA_IPM_DATA) ( (cyphertextSize[i] << 8) | cyphertextSize[i+1] );
		FPGA_IPM_write(AES_CORE_ID,		   //AES_ID.
					  (base_addr + i),	   //FPGA ADDRESS.
					   &tx_data);		   //NO ACK.
	}
	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0)
		return FPGA_ERROR;
//Perform encription and read back the result from the FPGA.
	//Open communication with FPGA.
	r = FPGA_IPM_open(AES_CORE_ID,		  //AES_ID.
					  DECRYPTION,         //DECRYPTION OPCODE.
					  0,				  //POLLING MODE.
					  0);				  //NO ACK.
	if (r != 0)
		return  FPGA_ERROR;

	//Write the lock.
	FPGA_IPM_DATA lock = FPGA_LOCK;
	FPGA_IPM_write(AES_CORE_ID,		   //AES_ID.
				   LOCK_ADDR,	       //FPGA ADDRESS.
				   &lock);		       //NO ACK.

	//Wait until FPGA ends the encryption.
	while (lock != FPGA_LOCK)
		FPGA_IPM_read(AES_CORE_ID, LOCK_ADDR, &lock);

	//FPGA computation finished, read back the encrypted data.
	FPGA_IPM_DATA rcvd;
	for (int i=0; i<8; i++){
		FPGA_IPM_read(AES_CORE_ID, (base_addr + i), &rcvd);
		plaintext[i]   = (uint8_t) ((rcvd >> 8) & 0x00FF);
		plaintext[i+1] = (uint8_t) (rcvd & 0x00FF);
	}

	//Close transaction.
	if (FPGA_IPM_close(AES_CORE_ID) != 0)
		return FPGA_ERROR;

	return AES_FPGA_RES_OK;

}
