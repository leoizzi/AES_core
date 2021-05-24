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
	constant divisor : std_logic_vector(7 downto 0) := X"1B";

	signal pp0, pp1, pp2, pp3: std_logic_vector(31 downto 0);
begin
	-- multiplication with the 1st row [14 11 13 9]

	with or_reduce(col_in(7 downto 5)) select pp0(7 downto 0) <= 
		col_in(4 downto 0)&"000" xor col_in(5 downto 0)&"00" xor col_in(6 downto 0)&'0' when '0',
		(col_in(4 downto 0)&"000" xor col_in(5 downto 0)&"00") xor (col_in(6 downto 0)&'0' xor divisor) when others;

	with or_reduce(col_in(15 downto 13)) select pp0(15 downto 8) <= 
		col_in(12 downto 8)&"000" xor col_in(14 downto 8)&'0' xor col_in(15 downto 8) when '0',
		(col_in(12 downto 8)&"000" xor col_in(14 downto 8)&'0') xor (col_in(15 downto 8) xor divisor) when others;

	with or_reduce(col_in(23 downto 21)) select pp0(23 downto 16) <= 
		col_in(20 downto 16)&"000" xor col_in(21 downto 16)&"00" xor col_in(23 downto 16) when '0',
		(col_in(20 downto 16)&"000" xor col_in(21 downto 16)&"00") xor (col_in(23 downto 16) xor divisor) when others;

	with or_reduce(col_in(31 downto 29)) select pp0(31 downto 24) <= 
		col_in(28 downto 24)&"000" xor col_in(31 downto 24) when '0',
		col_in(28 downto 24)&"000" xor col_in(31 downto 24) xor divisor when others;

	-- multiplication with the 2nd row [9 14 11 13]

	with or_reduce(col_in(7 downto 5)) select pp1(7 downto 0) <= 
		col_in(4 downto 0)&"000" xor col_in(7 downto 0) when '0',
		col_in(4 downto 0)&"000" xor col_in(7 downto 0) xor divisor when others;

	with or_reduce(col_in(15 downto 13)) select pp1(15 downto 8) <= 
		col_in(12 downto 8)&"000" xor col_in(13 downto 8)&"00" xor col_in(14 downto 8)&'0' when '0',
		(col_in(12 downto 8)&"000" xor col_in(13 downto 8)&"00") xor (col_in(14 downto 8)&'0' xor divisor) when others;

	with or_reduce(col_in(23 downto 21)) select pp1(23 downto 16) <= 
		col_in(20 downto 16)&"000" xor col_in(22 downto 16)&'0' xor col_in(23 downto 16) when '0',
		(col_in(20 downto 16)&"000" xor col_in(22 downto 16)&'0') xor (col_in(23 downto 16) xor divisor) when others;

	with or_reduce(col_in(31 downto 29)) select pp1(31 downto 24) <= 
		col_in(28 downto 24)&"000" xor col_in(29 downto 24)&"00" xor col_in(31 downto 24) when '0',
		(col_in(28 downto 24)&"000" xor col_in(29 downto 24)&"00") xor (col_in(31 downto 24) xor divisor) when others;

	-- multiplication with the 3rd row [13 9 14 11]
	
	with or_reduce(col_in(7 downto 5)) select pp2(7 downto 0) <= 
		col_in(4 downto 0)&"000" xor col_in(5 downto 0)&"00" xor col_in(7 downto 0) when '0',
		(col_in(4 downto 0)&"000" xor col_in(5 downto 0)&"00") xor (col_in(7 downto 0) xor divisor) when others;

	with or_reduce(col_in(15 downto 13)) select pp2(15 downto 8) <= 
		col_in(12 downto 8)&"000" xor col_in(15 downto 8) when '0',
		col_in(12 downto 8)&"000" xor col_in(15 downto 8) xor divisor when others;

	with or_reduce(col_in(23 downto 21)) select pp2(23 downto 16) <= 
		col_in(20 downto 16)&"000" xor col_in(21 downto 16)&"00" xor col_in(22 downto 16)&'0' when '0',
		(col_in(20 downto 16)&"000" xor col_in(21 downto 16)&"00") xor (col_in(22 downto 16)&'0' xor divisor) when others;

	with or_reduce(col_in(31 downto 29)) select pp2(31 downto 24) <= 
		col_in(28 downto 24)&"000" xor col_in(30 downto 24)&'0' xor col_in(31 downto 24) when '0',
		(col_in(28 downto 24)&"000" xor col_in(30 downto 24)&'0') xor (col_in(31 downto 24) xor divisor) when others;

	-- multiplication with the 4th row [11 13 9 14]

	with or_reduce(col_in(7 downto 5)) select pp3(7 downto 0) <= 
		col_in(4 downto 0)&"000" xor col_in(6 downto 0)&'0' xor col_in(7 downto 0) when '0',
		(col_in(4 downto 0)&"000" xor col_in(6 downto 0)&'0') xor (col_in(7 downto 0) xor divisor) when others;

	with or_reduce(col_in(15 downto 13)) select pp3(15 downto 8) <= 
		col_in(12 downto 8)&"000" xor col_in(13 downto 8)&"00" xor col_in(15 downto 8) when '0',
		(col_in(12 downto 8)&"000" xor col_in(13 downto 8)&"00") xor (col_in(15 downto 8) xor divisor) when others;

	with or_reduce(col_in(23 downto 21)) select pp3(23 downto 16) <= 
		col_in(20 downto 16)&"000" xor col_in(23 downto 16) when '0',
		col_in(20 downto 16)&"000" xor col_in(23 downto 16) xor divisor when others;

	with or_reduce(col_in(31 downto 29)) select pp3(31 downto 24) <= 
		col_in(28 downto 24)&"000" xor col_in(29 downto 24)&"00" xor col_in(30 downto 24)&'0' when '0',
		(col_in(28 downto 24)&"000" xor col_in(29 downto 24)&"00") xor (col_in(30 downto 24)&'0' xor divisor) when others;

	-- addition of the partial products
	col_out(7 downto 0) <= (pp0(7 downto 0) xor pp0(15 downto 8)) xor (pp0(23 downto 16) xor pp0(31 downto 24));
	col_out(15 downto 8) <= (pp1(7 downto 0) xor pp1(15 downto 8)) xor (pp1(23 downto 16) xor pp1(31 downto 24));
	col_out(23 downto 16) <= (pp2(7 downto 0) xor pp2(15 downto 8)) xor (pp2(23 downto 16) xor pp2(31 downto 24));
	col_out(31 downto 24) <= (pp3(7 downto 0) xor pp3(15 downto 8)) xor (pp3(23 downto 16) xor pp3(31 downto 24));
end behavioral;
