library ieee;
use ieee.std_logic_1164.all;

entity tb_inv_mix_columns is
end tb_inv_mix_columns;

architecture test of tb_inv_mix_columns is
	component mix_columns is
		port (
			ed: in std_logic; -- 1 for encryption, 0 for decryption
			data_in: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component mix_columns;

	constant data_in : std_logic_vector(127 downto 0) := X"4c7a9ae526d3198106f8cb662848e004";
	constant dout : std_logic_vector(127 downto 0) := X"e5f1ae309811525d2741b4bf1eb8e0d4"; 
	signal data_out: std_logic_vector(127 downto 0);
begin
	dut: mix_columns
		port map (
			ed => '0',
			data_in => data_in,
			data_out => data_out
		);

end test;
