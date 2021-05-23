library ieee;
use ieee.std_logic_1164.all;

entity mix_columns is
	port (
		data_in: in std_logic_vector(127 downto 0);
		data_out: out std_logic_vector(127 downto 0)
	);
end mix_columns;

architecture structural of mix_columns is
	component matrix_mul is
		port (
			col_in: in std_logic_vector(31 downto 0);
			col_out: out std_logic_vector(31 downto 0)
		);
	end component matrix_mul;
	signal col0, col1, col2, col3: std_logic_vector(31 downto 0);
	signal res0, res1, res2, res3: std_logic_vector(31 downto 0);
begin
	col0 <= data_in(103 downto 96)&data_in(71 downto 64)&data_in(39 downto 32)&data_in(7 downto 0);
	col1 <= data_in(111 downto 104)&data_in(79 downto 72)&data_in(47 downto 40)&data_in(15 downto 8);
	col2 <= data_in(119 downto 112)&data_in(87 downto 80)&data_in(55 downto 48)&data_in(23 downto 16);
	col3 <= data_in(127 downto 120)&data_in(95 downto 88)&data_in(63 downto 56)&data_in(31 downto 24);

	m0: matrix_mul
		port map (
			col_in => col0,
			col_out => res0
		);

	m1: matrix_mul
		port map (
			col_in => col1,
			col_out => res1
		);

	m2: matrix_mul
		port map (
			col_in => col2,
			col_out => res2
		);

	m3: matrix_mul
		port map (
			col_in => col3,
			col_out => res3
		);

	data_out(31 downto 0) <= res3(7 downto 0)&res2(7 downto 0)&res1(7 downto 0)&res0(7 downto 0);
	data_out(63 downto 32) <= res3(15 downto 8)&res2(15 downto 8)&res1(15 downto 8)&res0(15 downto 8);
	data_out(95 downto 64) <= res3(23 downto 16)&res2(23 downto 16)&res1(23 downto 16)&res0(23 downto 16);
	data_out(127 downto 96) <= res3(31 downto 24)&res2(31 downto 24)&res1(31 downto 24)&res0(31 downto 24);
end structural;
