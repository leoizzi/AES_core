library ieee;
use ieee.std_logic_1164.all;

-- Matrix multiplication
entity enc_matrix_mul is
	port (
		col_in: in std_logic_vector(31 downto 0);
		col_out: out std_logic_vector(31 downto 0)
	);
end enc_matrix_mul;

architecture behavioral of enc_matrix_mul is
	constant divisor : std_logic_vector(7 downto 0) := X"1B";

	-- in ppx only the multiplications by 2 and 3 are stored
	signal pp0, pp1, pp2, pp3: std_logic_vector(15 downto 0);
begin
	-- multiplication for the 1st row [2 3 1 1]
	
	with col_in(7) select pp0(7 downto 0) <= 
		col_in(6 downto 0)&'0' when '0',
		col_in(6 downto 0)&'0' xor divisor when others;

	with col_in(15) select pp0(15 downto 8) <= 
		col_in(14 downto 8)&'0' xor col_in(15 downto 8) when '0',
		col_in(14 downto 8)&'0' xor col_in(15 downto 8) xor divisor when others;

	-- multiplication for the 2nd row [1 2 3 1]
	
	with col_in(15) select pp1(7 downto 0) <= 
		col_in(14 downto 8)&'0' when '0',
		col_in(14 downto 8)&'0' xor divisor when others;

	with col_in(23) select pp1(15 downto 8) <= 
		col_in(22 downto 16)&'0' xor col_in(23 downto 16) when '0',
		col_in(22 downto 16)&'0' xor col_in(23 downto 16) xor divisor when others;
	
	-- multiplication for the 3rd row [1 1 2 3]
	
	with col_in(23) select pp2(7 downto 0) <= 
		col_in(22 downto 16)&'0' when '0',
		col_in(22 downto 16)&'0' xor divisor when others;

	with col_in(31) select pp2(15 downto 8) <= 
		col_in(30 downto 24)&'0' xor col_in(31 downto 24) when '0',
		col_in(30 downto 24)&'0' xor col_in(31 downto 24) xor divisor when others;

	-- multiplication for the 4th row [3 1 1 2]
	
	with col_in(31) select pp3(15 downto 8) <= 
		col_in(30 downto 24)&'0' when '0',
		col_in(30 downto 24)&'0' xor divisor when others;

	with col_in(7) select pp3(7 downto 0) <= 
		col_in(6 downto 0)&'0' xor col_in(7 downto 0) when '0',
		col_in(6 downto 0)&'0' xor col_in(7 downto 0) xor divisor when others;

	-- addition of the partial products
	col_out(7 downto 0) <= (pp0(7 downto 0) xor pp0(15 downto 8)) xor (col_in(23 downto 16) xor col_in(31 downto 24));
	col_out(15 downto 8) <= (col_in(7 downto 0) xor pp1(7 downto 0)) xor (pp1(15 downto 8) xor col_in(31 downto 24));
	col_out(23 downto 16) <= (col_in(7 downto 0) xor col_in(15 downto 8)) xor (pp2(7 downto 0) xor pp2(15 downto 8));
	col_out(31 downto 24) <= (pp3(7 downto 0) xor col_in(15 downto 8)) xor (col_in(23 downto 16) xor pp3(15 downto 8));
end behavioral;
