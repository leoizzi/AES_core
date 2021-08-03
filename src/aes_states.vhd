library ieee;
use ieee.std_logic_1164.all;
use work.CONSTANTS.all;

package aes_states is
	constant IDLE : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000000";
	constant KEY_TRANSFER : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000010";
	constant KEY_WRITE : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000011"; 
	constant DATA_RX : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000100";
	constant ENC_AES_128 : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001000";
	constant DEC_AES_128 : std_logic_vector(OPCODE_SIZE-1 downto 0) := "010000";
	constant ENC_AES_192 : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001001";
	constant DEC_AES_192 : std_logic_vector(OPCODE_SIZE-1 downto 0) := "010001";
	constant ENC_AES_256 : std_logic_vector(OPCODE_SIZE-1 downto 0) := "101000";
	constant DEC_AES_256 : std_logic_vector(OPCODE_SIZE-1 downto 0) := "110000";
	constant ENC_DATA_TX : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000101";
	constant DEC_DATA_TX : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000110"; 
	constant CORE_DONE : std_logic_vector(OPCODE_SIZE-1 downto 0) := "100000";     
end package aes_states;