library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Behavioral adder which doesn't consider cin or cout
entity adder is
	generic (
		N: integer := 16
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		o: out std_logic_vector(N-1 downto 0)
	);
end adder;

architecture behavioral of adder is
begin
	o <= std_logic_vector(unsigned(a) + unsigned(b));
end behavioral;
