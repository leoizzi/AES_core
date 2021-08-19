library ieee;
use ieee.std_logic_1164.all;

-- Inverse mix columns stage
entity dec_mix_columns is
	port (
		data_in: in std_logic_vector(127 downto 0);
		data_out: out std_logic_vector(127 downto 0)
	);
end dec_mix_columns;

architecture structural of dec_mix_columns is
	component dec_matrix_mul is
		port (
			col_in: in std_logic_vector(31 downto 0);
			col_out: out std_logic_vector(31 downto 0)
		);
	end component dec_matrix_mul;

	signal col0, col1, col2, col3: std_logic_vector(31 downto 0);
	signal dec_res0, dec_res1, dec_res2, dec_res3: std_logic_vector(31 downto 0);
	signal dec_res: std_logic_vector(127 downto 0);

begin

	-- split data_in into columns
	col0 <= data_in(31 downto 0);
	col1 <= data_in(63 downto 32);
	col2 <= data_in(95 downto 64);
	col3 <= data_in(127 downto 96);

	dm0: dec_matrix_mul
		port map (
			col_in => col0,
			col_out => dec_res0
		);

	dm1: dec_matrix_mul
		port map (
			col_in => col1,
			col_out => dec_res1
		);

	dm2: dec_matrix_mul
		port map (
			col_in => col2,
			col_out => dec_res2
		);

	dm3: dec_matrix_mul
		port map (
			col_in => col3,
			col_out => dec_res3
		);

	-- switch the output back to row representation
	dec_res(31 downto 0) <= dec_res0;
	dec_res(63 downto 32) <= dec_res1;
	dec_res(95 downto 64) <= dec_res2;
	dec_res(127 downto 96) <= dec_res3;

	data_out <= dec_res;
end structural;
