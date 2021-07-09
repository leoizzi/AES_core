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

/*FPGA Communication*/
#define AES_CORE_ID 			(   1)
#define SHARE_GEN_KEY_OPCODE 	(0x01)
#define ENCRYPT_OPCODE 			(0x02)
#define DECRYPT_OPCODE 			(0x03)
/*Return type declarations.*/
#define AES_FPGA_RES_OK				    ( 1)
#define AES_FPGA_RES_INVALID_ARGUMENT   (-1)
#define AES_FPGA_OPEN_ERROR 			(-2)
#define AES_KEY_INIT_ERROR 			    (-3)



/** \brief Initialize the context for the encription and/or decription operations..
 *  \param ctx Context to be initialized. (Free context).
 *  \param Key 256 bit Key.
 *  \param Clear_data plain text i.e. data to be encrypted.
 *  \result ctx context has been initialized.
 *  \return Returns AES_FPGA_RES_OK on success, error code on error.
 */
AES_FPGA_RETURN_CODE AES_FPGA_256_init(B5_tAesCtx *ctx, const uint8_t *Key);

/** \brief Encrypt data using FPGA accelaration.
 *  \param ctx Context already initialized.
 *  \param Clear_data plain text i.e. data to be encrypted.
 *  \result encr_data encrypted plain text.
 *  \return Returns AES_FPGA_RES_OK on success, error code on error.
 */
AES_FPGA_RETURN_CODE AES_FPGA_256_encrypt(B5_tAesCtx *ctx/*, const uint8_t *Key*/, const uint8_t *clear_data, uint8_t *encr_data);


/** \brief Decrypt data using FPGA accelaration.
 *  \param ctx Context already initialized.
 *  \param encr_data Encripted data pointer
 *  \result clear_data plain text.
 *  \return Returns AES_FPGA_RES_OK on success, error code on error.
 */
AES_FPGA_RETURN_CODE AES_FPGA_256_decrypt(B5_tAesCtx *ctx, uint8_t *encr_data, uint8_t *clear_data);
#endif /* INC_AES_FPGA_H_ */


