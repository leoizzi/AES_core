#ifndef INC_AES_FPGA_H_
#define INC_AES_FPGA_H_

#include <stdint.h>
#include <string.h>
#include "Fpgaipm.h"
#include "aes256.h"

#define AES_FPGA_RETURN_CODE int8_t

/* AES Operating modes */
typedef enum {
	 AES_OFB = B5_AES256_OFB,
	 AES_ECB_ENC = B5_AES256_ECB_ENC,
	 AES_ECB_DEC = B5_AES256_ECB_DEC,
	 AES_CBC_ENC = B5_AES256_CBC_ENC,
	 AES_CBC_DEC = B5_AES256_CBC_DEC,
	 AES_CFB_ENC = B5_AES256_CFB_ENC,
	 AES_CFB_DEC = B5_AES256_CFB_DEC,
	 AES_CTR = B5_AES256_CTR
}aes_mode_t;

/* AES OPERATING MODE */
enum aes_op_t {
	AES_OP_ENCRYPT,
	AES_OP_DECRYPT
};
typedef enum aes_op_t aes_op_t;

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
#define ALG_SEL_ADDR            (0x01 << 3)
#define WRITE_BASE_ADDR			(0x01 << 3)

#define SIZE_MASK (B5_AES_BLK_SIZE - 1)

/* RETURN TYPE */
#define AES_FPGA_RES_OK				    ( 1)
#define FPGA_TRANSACTION_OK				( 2)
#define AES_FPGA_RES_INVALID_ARGUMENT   (-1)
#define AES_FPGA_OPEN_ERROR 			(-2)
#define AES_FPGA_CLOSE_ERROR 			(-3)
#define AES_KEY_INIT_ERROR 			    (-4)
#define FPGA_ERROR						(-5)

/** \brief Initialize the context for the encryption.
 *  \param ctx Context to be initialized. (Free context).
 *  \param Key pointer.
 *  \param keySize 128,192 or 256 bit.
 *  \param aesMode AES mode.
 *  \result ctx context has been initialized.
 *  \return Returns AES_FPGA_RES_OK on success, error code on error.
 */
AES_FPGA_RETURN_CODE AES_FPGA_setup(B5_tAesCtx *ctx, const uint8_t *Key, int16_t keySize, aes_mode_t aes_mode);

/**
 *
 * @brief Set the IV for the current AES context.
 * @param ctx Pointer to the AES data structure to be initialized.
 * @param IV Pointer to the IV.
 * @return See aes256.h for the error codes
 */
int32_t AES_FPGA_SetIV(B5_tAesCtx *ctx, const uint8_t *IV);

/**
 *
 * @brief Encrypt/Decrypt data based on the status of current AES context. If the blocks do not fit in multiples of 128-bits it also performs padding.
 * @param ctx Pointer to the current AES context.
 * @param encData Encrypted data.
 * @param clrData Clear data.
 * @param nBlk Number of AES blocks to process.
 * @param data_len Size of the data to process.
 * @return Returns AES_FPGA_RES_OK on success, error code on error.
 */
AES_FPGA_RETURN_CODE AES_FPGA_update(B5_tAesCtx *ctx, uint8_t *encData, uint8_t *clrData, uint16_t nBlk, uint32_t data_len);

/**
 *
 * @brief Initialize the CMAC-AES context.
 * @param ctx Pointer to the CMAC-AES data structure to be initialized.
 * @param Key Pointer to the Key that must be used.
 * @param keySize Key size. See \ref cmacaesKeys for supported sizes.
 * @return See \ref cmacaesReturn .
 */
int32_t AES_FPGA_Cmac_Init(B5_tCmacAesCtx *ctx, const uint8_t *Key, int16_t keySize);

/**
 *
 * @brief Compute the CMAC-AES algorithm on input data depending on the current status of the CMAC-AES context.
 * @param ctx Pointer to the current CMAC-AES context.
 * @param data Pointer to the input data.
 * @param dataLen Bytes to be processed.
 * @return See \ref cmacaesReturn .
 */
int32_t AES_FPGA_Cmac_Update(B5_tCmacAesCtx *ctx, const uint8_t *data, int32_t dataLen);

/**
 *
 * @brief De-initialize the current CMAC-AES context.
 * @param ctx Pointer to the CMAC-AES context to de-initialize.
 * @param rSignature Pointer to a blank memory area that can store the computed output signature.
 * @return See \ref cmacaesReturn .
 */
int32_t AES_FPGA_Cmac_Finit(B5_tCmacAesCtx *ctx, uint8_t *rSignature);

/**
 *
 * @brief Reset the current CMAC-AES context.
 * @param ctx Pointer to the CMAC-AES context to reset.
 * @return See \ref cmacaesReturn .
 */
int32_t AES_FPGA_Cmac_Reset(B5_tCmacAesCtx *ctx);

/**
 *
 * @brief Compute the signature through the CMAC-AES algorithm.
 * @param data Pointer to the input data.
 * @param dataLen Input data length (in Bytes).
 * @param Key Pointer to the Key that must be used.
 * @param keySize Key size. See \ref cmacaesKeys for supported sizes.
 * @param rSignature Pointer to a blank memory area that can store the computed output signature.
 * @return See \ref cmacaesReturn .
 */
int32_t AES_FPGA_Cmac_Sign(const uint8_t *data, int32_t dataLen, const uint8_t *Key, int16_t keySize, uint8_t *rSignature);

#endif /* INC_AES_FPGA_H_ */


