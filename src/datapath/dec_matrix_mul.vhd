library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.or_reduce;

entity dec_matrix_mul is
	port (
		col_in: in std_logic_vector(31 downto 0);
		col_out: out std_logic_vector(31 downto 0)
	);
end dec_matrix_mul;

architecture behavioral of dec_matrix_mul is
	component xtime is
		port(
			data_in: in std_logic_vector(7 downto 0);
			data_out: out std_logic_vector(7 downto 0)
		);
	end component xtime;

	signal pp0, pp1, pp2, pp3: std_logic_vector(31 downto 0);

	signal xt_out00_0, xt_out00_1, xt_out00_2: std_logic_vector(7 downto 0);
	signal xt_out01_0, xt_out01_1, xt_out01_2: std_logic_vector(7 downto 0);
	signal xt_out02_0, xt_out02_1, xt_out02_2: std_logic_vector(7 downto 0);
	signal xt_out03_0, xt_out03_1, xt_out03_2: std_logic_vector(7 downto 0);

	signal xt_out10_0, xt_out10_1, xt_out10_2: std_logic_vector(7 downto 0);
	signal xt_out11_0, xt_out11_1, xt_out11_2: std_logic_vector(7 downto 0);
	signal xt_out12_0, xt_out12_1, xt_out12_2: std_logic_vector(7 downto 0);
	signal xt_out13_0, xt_out13_1, xt_out13_2: std_logic_vector(7 downto 0);

	signal xt_out20_0, xt_out20_1, xt_out20_2: std_logic_vector(7 downto 0);
	signal xt_out21_0, xt_out21_1, xt_out21_2: std_logic_vector(7 downto 0);
	signal xt_out22_0, xt_out22_1, xt_out22_2: std_logic_vector(7 downto 0);
	signal xt_out23_0, xt_out23_1, xt_out23_2: std_logic_vector(7 downto 0);

	signal xt_out30_0, xt_out30_1, xt_out30_2: std_logic_vector(7 downto 0);
	signal xt_out31_0, xt_out31_1, xt_out31_2: std_logic_vector(7 downto 0);
	signal xt_out32_0, xt_out32_1, xt_out32_2: std_logic_vector(7 downto 0);
	signal xt_out33_0, xt_out33_1, xt_out33_2: std_logic_vector(7 downto 0);

begin
	-- multiplication with the 1st row [14 11 13 9]
	-- 14: xtime8 ^ xtime4 ^ xtime2

	-- xtime2
	xt00_0: xtime
		port map(
			data_in => col_in(7 downto 0),
			data_out => xt_out00_0
		);

	-- xtime4
	xt00_1: xtime
		port map (
			data_in => xt_out00_0,
			data_out => xt_out00_1
		);

	--xtime8
	xt00_2: xtime
		port map (
			data_in => xt_out00_1,
			data_out => xt_out00_2
		);

	pp0(7 downto 0) <= xt_out00_0 xor xt_out00_1 xor xt_out00_2;

	-- 11: xtime8 ^ xtime2 ^ data
	-- xtime2
	xt01_0: xtime
		port map(
			data_in => col_in(15 downto 8),
			data_out => xt_out01_0
		);

	-- xtime4
	xt01_1: xtime
		port map (
			data_in => xt_out01_0,
			data_out => xt_out01_1
		);

	--xtime8
	xt01_2: xtime
		port map (
			data_in => xt_out01_1,
			data_out => xt_out01_2
		);

	pp0(15 downto 8) <= xt_out01_2 xor xt_out01_0 xor col_in(15 downto 8);

	-- 13: xtime8 ^ xtime4 ^ data
	-- xtime2
	xt02_0: xtime
		port map(
			data_in => col_in(23 downto 16),
			data_out => xt_out02_0
		);

	-- xtime4
	xt02_1: xtime
		port map (
			data_in => xt_out02_0,
			data_out => xt_out02_1
		);

	--xtime8
	xt02_2: xtime
		port map (
			data_in => xt_out02_1,
			data_out => xt_out02_2
		);

	pp0(23 downto 16) <= xt_out02_2 xor xt_out02_1 xor col_in(23 downto 16);

	-- 9: xtime8 ^ data
	-- xtime2
	xt03_0: xtime
		port map(
			data_in => col_in(31 downto 24),
			data_out => xt_out03_0
		);

	-- xtime4
	xt03_1: xtime
		port map (
			data_in => xt_out03_0,
			data_out => xt_out03_1
		);

	--xtime8
	xt03_2: xtime
		port map (
			data_in => xt_out03_1,
			data_out => xt_out03_2
		);

	pp0(31 downto 24) <= xt_out03_2 xor col_in(31 downto 24);


	-- multiplication with the 2nd row [9 14 11 13]

	-- 9: xtime8 ^ data

	-- xtime2
	xt10_0: xtime
		port map(
			data_in => col_in(7 downto 0),
			data_out => xt_out10_0
		);

	-- xtime4
	xt10_1: xtime
		port map (
			data_in => xt_out10_0,
			data_out => xt_out10_1
		);

	--xtime8
	xt10_2: xtime
		port map (
			data_in => xt_out10_1,
			data_out => xt_out10_2
		);

	pp1(7 downto 0) <= xt_out10_2 xor col_in(7 downto 0);

	-- 14: xtime8 ^ xtime4 ^ xtime2
	-- xtime2
	xt11_0: xtime
		port map(
			data_in => col_in(15 downto 8),
			data_out => xt_out11_0
		);

	-- xtime4
	xt11_1: xtime
		port map (
			data_in => xt_out11_0,
			data_out => xt_out11_1
		);

	--xtime8
	xt11_2: xtime
		port map (
			data_in => xt_out11_1,
			data_out => xt_out11_2
		);

	pp1(15 downto 8) <= xt_out11_2 xor xt_out11_1 xor xt_out11_0;

	-- 11: xtime8 ^ xtime2 ^ data
	-- xtime2
	xt12_0: xtime
		port map(
			data_in => col_in(23 downto 16),
			data_out => xt_out12_0
		);

	-- xtime4
	xt12_1: xtime
		port map (
			data_in => xt_out12_0,
			data_out => xt_out12_1
		);

	--xtime8
	xt12_2: xtime
		port map (
			data_in => xt_out12_1,
			data_out => xt_out12_2
		);

	pp1(23 downto 16) <= xt_out12_2 xor xt_out12_0 xor col_in(23 downto 16);

	-- 13: xtime8 ^ xtime4 ^ data
	-- xtime2
	xt13_0: xtime
		port map(
			data_in => col_in(31 downto 24),
			data_out => xt_out13_0
		);

	-- xtime4
	xt13_1: xtime
		port map (
			data_in => xt_out13_0,
			data_out => xt_out13_1
		);

	--xtime8
	xt13_2: xtime
		port map (
			data_in => xt_out13_1,
			data_out => xt_out13_2
		);

	pp1(31 downto 24) <= xt_out13_2 xor xt_out13_1 xor col_in(31 downto 24);
	

	-- multiplication with the 3rd row [13 9 14 11]
	-- 13: xtime8 ^ xtime4 ^ data

	-- xtime2
	xt20_0: xtime
		port map(
			data_in => col_in(7 downto 0),
			data_out => xt_out20_0
		);

	-- xtime4
	xt20_1: xtime
		port map (
			data_in => xt_out20_0,
			data_out => xt_out20_1
		);

	--xtime8
	xt20_2: xtime
		port map (
			data_in => xt_out20_1,
			data_out => xt_out20_2
		);

	pp2(7 downto 0) <= xt_out20_2 xor xt_out20_1 xor col_in(7 downto 0);

	-- 9: xtime8 ^ data
	-- xtime2
	xt21_0: xtime
		port map(
			data_in => col_in(15 downto 8),
			data_out => xt_out21_0
		);

	-- xtime4
	xt21_1: xtime
		port map (
			data_in => xt_out21_0,
			data_out => xt_out21_1
		);

	--xtime8
	xt21_2: xtime
		port map (
			data_in => xt_out21_1,
			data_out => xt_out21_2
		);

	pp2(15 downto 8) <= xt_out21_2 xor col_in(15 downto 8);

	-- 14: xtime8 ^ xtime4 ^ xtime2
	-- xtime2
	xt22_0: xtime
		port map(
			data_in => col_in(23 downto 16),
			data_out => xt_out22_0
		);

	-- xtime4
	xt22_1: xtime
		port map (
			data_in => xt_out22_0,
			data_out => xt_out22_1
		);

	--xtime8
	xt22_2: xtime
		port map (
			data_in => xt_out22_1,
			data_out => xt_out22_2
		);

	pp2(23 downto 16) <= xt_out22_2 xor xt_out22_1 xor xt_out22_0;

	-- 11: xtime8 ^ xtime2 ^ data
	-- xtime2
	xt23_0: xtime
		port map(
			data_in => col_in(31 downto 24),
			data_out => xt_out23_0
		);

	-- xtime4
	xt23_1: xtime
		port map (
			data_in => xt_out23_0,
			data_out => xt_out23_1
		);

	--xtime8
	xt23_2: xtime
		port map (
			data_in => xt_out23_1,
			data_out => xt_out23_2
		);

	pp2(31 downto 24) <= xt_out23_2 xor xt_out23_0 xor col_in(31 downto 24);
	
	
	-- multiplication with the 4th row [11 13 9 14]

	-- 11: xtime8 ^ xtime2 ^ data

	-- xtime2
	xt30_0: xtime
		port map(
			data_in => col_in(7 downto 0),
			data_out => xt_out30_0
		);

	-- xtime4
	xt30_1: xtime
		port map (
			data_in => xt_out30_0,
			data_out => xt_out30_1
		);

	--xtime8
	xt30_2: xtime
		port map (
			data_in => xt_out30_1,
			data_out => xt_out30_2
		);

	pp3(7 downto 0) <= xt_out30_2 xor xt_out30_0 xor col_in(7 downto 0);

	-- 13: xtime8 ^ xtime4 ^ data
	-- xtime2
	xt31_0: xtime
		port map(
			data_in => col_in(15 downto 8),
			data_out => xt_out31_0
		);

	-- xtime4
	xt31_1: xtime
		port map (
			data_in => xt_out31_0,
			data_out => xt_out31_1
		);

	--xtime8
	xt31_2: xtime
		port map (
			data_in => xt_out31_1,
			data_out => xt_out31_2
		);

	pp3(15 downto 8) <= xt_out31_2 xor xt_out31_1 xor col_in(15 downto 8);

	-- 9: xtime8 ^ data
	-- xtime2
	xt32_0: xtime
		port map(
			data_in => col_in(23 downto 16),
			data_out => xt_out32_0
		);

	-- xtime4
	xt32_1: xtime
		port map (
			data_in => xt_out32_0,
			data_out => xt_out32_1
		);

	--xtime8
	xt32_2: xtime
		port map (
			data_in => xt_out32_1,
			data_out => xt_out32_2
		);

	pp3(23 downto 16) <= xt_out32_2 xor col_in(23 downto 16);

	-- 14: xtime8 ^ xtime4 ^ xtime2
	-- xtime2
	xt33_0: xtime
		port map(
			data_in => col_in(31 downto 24),
			data_out => xt_out33_0
		);

	-- xtime4
	xt33_1: xtime
		port map (
			data_in => xt_out33_0,
			data_out => xt_out33_1
		);

	--xtime8
	xt33_2: xtime
		port map (
			data_in => xt_out33_1,
			data_out => xt_out33_2
		);

	pp3(31 downto 24) <= xt_out33_2 xor xt_out33_1 xor xt_out33_0;

	-- addition of the partial products
	col_out(7 downto 0) <= (pp0(7 downto 0) xor pp0(15 downto 8)) xor (pp0(23 downto 16) xor pp0(31 downto 24));
	col_out(15 downto 8) <= (pp1(7 downto 0) xor pp1(15 downto 8)) xor (pp1(23 downto 16) xor pp1(31 downto 24));
	col_out(23 downto 16) <= (pp2(7 downto 0) xor pp2(15 downto 8)) xor (pp2(23 downto 16) xor pp2(31 downto 24));
	col_out(31 downto 24) <= (pp3(7 downto 0) xor pp3(15 downto 8)) xor (pp3(23 downto 16) xor pp3(31 downto 24));
end behavioral;
