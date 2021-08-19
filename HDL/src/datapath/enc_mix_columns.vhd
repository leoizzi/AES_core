library ieee;
use ieee.std_logic_1164.all;

-- Mix columns stage
entity enc_mix_columns is
	port (
		data_in: in std_logic_vector(127 downto 0);
		data_out: out std_logic_vector(127 downto 0)
	);
end enc_mix_columns;

architecture structural of enc_mix_columns is
	component enc_matrix_mul is
		port (
			col_in: in std_logic_vector(31 downto 0);
			col_out: out std_logic_vector(31 downto 0)
		);
	end component enc_matrix_mul;

	signal col0, col1, col2, col3: std_logic_vector(31 downto 0);
	signal enc_res0, enc_res1, enc_res2, enc_res3: std_logic_vector(31 downto 0);
	signal enc_res: std_logic_vector(127 downto 0);

begin

	-- split data_in into columns
	col0 <= data_in(31 downto 0);
	col1 <= data_in(63 downto 32);
	col2 <= data_in(95 downto 64);
	col3 <= data_in(127 downto 96);

	em0: enc_matrix_mul
		port map (
			col_in => col0,
			col_out => enc_res0
		);

	em1: enc_matrix_mul
		port map (
			col_in => col1,
			col_out => enc_res1
		);

	em2: enc_matrix_mul
		port map (
			col_in => col2,
			col_out => enc_res2
		);

	em3: enc_matrix_mul
		port map (
			col_in => col3,
			col_out => enc_res3
		);

	enc_res(31 downto 0) <= enc_res0;
	enc_res(63 downto 32) <= enc_res1;
	enc_res(95 downto 64) <= enc_res2;
	enc_res(127 downto 96) <= enc_res3;

	data_out <= enc_res;
end structural;
