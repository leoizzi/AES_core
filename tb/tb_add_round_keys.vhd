library ieee;
use ieee.std_logic_1164.all;

entity tb_add_round_keys is
end tb_add_round_keys;

architecture test of tb_add_round_keys is
	component add_round_keys is
		port (
			data_in: in std_logic_vector(127 downto 0);
			key: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component add_round_keys;

	signal data_in: std_logic_vector(127 downto 0) := X"4c7a9ae526d3198106f8cb662848e004";
	signal key: std_logic_vector(127 downto 0) := X"0539b11776392cfe6ca354fa2a2388a0";
	signal data_out: std_logic_vector(127 downto 0);
begin
	dut: add_round_keys
		port map (
			data_in => data_in,
			key => key,
			data_out => data_out
		);

end test;
