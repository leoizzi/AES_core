library ieee;
use ieee.std_logic_1164.all;
use work.CONSTANTS.all;

package aes_states is
	constant IDLE : std_logic_vector(OPCODE_SIZE-1 downto 0) 			:= "000000";
	constant ALG_SEL: std_logic_vector(OPCODE_SIZE-1 downto 0) 			:= "000010";
	constant KEY_TRANSFER : std_logic_vector(OPCODE_SIZE-1 downto 0) 	:= "000100";
	constant KEY_WRITE : std_logic_vector(OPCODE_SIZE-1 downto 0) 		:= "000101"; 
	constant DATA_RX : std_logic_vector(OPCODE_SIZE-1 downto 0) 		:= "001000";
	constant ENCRYPTION : std_logic_vector(OPCODE_SIZE-1 downto 0) 		:= "010000";
	constant DECRYPTION : std_logic_vector(OPCODE_SIZE-1 downto 0) 		:= "010001";
	constant ENC_DATA_TX : std_logic_vector(OPCODE_SIZE-1 downto 0) 	:= "011000";
	constant DEC_DATA_TX : std_logic_vector(OPCODE_SIZE-1 downto 0) 	:= "011001"; 
	constant CORE_DONE : std_logic_vector(OPCODE_SIZE-1 downto 0) 		:= "100000";
	constant WAIT_TR_CLOSE : std_logic_vector(OPCODE_SIZE-1 downto 0)	:= "000001";   
end package aes_states;