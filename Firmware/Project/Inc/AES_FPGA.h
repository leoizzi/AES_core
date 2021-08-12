/*
 * AES_FPGA.h
 *
 *  Created on: 9 giu 2021
 *      Author: lollo
 */

#ifndef INC_AES_FPGA_H_
#define INC_AES_FPGA_H_

#include <stdint.h>
#include <string.h>
#include "Fpgaipm.h"
#include "aes256.h"

#define AES_FPGA_RETURN_CODE int8_t

/* AES OPERATING MODE */
#define AES_MODE_ENCRYPT (0x00)
#define AES_MODE_DECRYPT (0x01)

/* COSTANTS */
#define FPGA_LOCK 0xFFFF

/* FPGA Communication */
#define AES_CORE_ID 			(1)

/* OPCODES */
#define IDLE 					(0x00)
#define WAIT_TR_CLOSE			(0x01)
#define ALG_SEL					(0x02)
#define KEY_TRANSFER			(0x04)
#define KEY_WRITE				(0x05)
#define DATA_TX					(0x08)
#define ENCRYPTION				(0x10)
#define DECRYPTION				(0x11)
#define ENC_DATA_TX				(0x18)
#define DEC_DATA_TX				(0x19)
#define CORE_DONE				(0x20)

/* FPGA ADDRESSES */
#define LOCK_ADDR				(0x01)
#define ALG_SEL_ADDR            (0x08)
#define WRITE_BASE_ADDR			(0x01 << 3)

/* RETURN TYPE */
#define AES_FPGA_RES_OK				    ( 1)
#define FPGA_TRANSACTION_OK				( 2)
#define AES_FPGA_RES_INVALID_ARGUMENT   (-1)
#define AES_FPGA_OPEN_ERROR 			(-2)
#define AES_FPGA_CLOSE_ERROR 			(-3)
#define AES_KEY_INIT_ERROR 			    (-4)
#define FPGA_ERROR						(-5)




/** \brief Initialize the context for the encription.
 *  \param ctx Context to be initialized. (Free context).
 *  \param Key pointer.
 *  \param keySize 128,192 or 256 bit. This parameter is used to identify the AES MODE.
 *  \param aes_mode AES operating mode. Supported values are: AES_MODE_ENCRPT for encryption and AES_MODE_DECRYPT for decryption.
 *  \result ctx context has been initialized.
 *  \return Returns AES_FPGA_RES_OK on success, error code on error.
 */
AES_FPGA_RETURN_CODE AES_FPGA_setup(B5_tAesCtx *ctx, const uint8_t *Key, int16_t keySize, uint8_t aes_mode);

/** \brief Encrypt data using FPGA accelaration.
 *  \param  ctx Context already initialized.
 *  \param  plaintext 128 bit plain text.
 *  \result cyphertext 128 bit cypher text.
 *  \return Returns AES_FPGA_RES_OK on success, error code on error.
 */
AES_FPGA_RETURN_CODE AES_FPGA_encrypt(B5_tAesCtx *ctx, uint8_t *plaintext, uint8_t plaintextSize, uint8_t *cyphertext);


/** \brief Decrypt data using FPGA accelaration.
 *  \param  ctx Context already initialized.
 *  \param  cyphertext 128 bit cypher text.
 *  \result plaintext 128 bit plain text.
 *  \return Returns AES_FPGA_RES_OK on success, error code on error.
 */
AES_FPGA_RETURN_CODE AES_FPGA_decrypt(B5_tAesCtx *ctx, uint8_t *cyphertext, uint8_t cyphertextSize,uint8_t *plaintext);
#endif /* INC_AES_FPGA_H_ */


