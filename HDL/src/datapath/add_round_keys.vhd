library ieee;
use ieee.std_logic_1164.all;

-- Add round key stage
entity add_round_keys is
	port (
		data_in: in std_logic_vector(127 downto 0);
		key: in std_logic_vector(127 downto 0);
		data_out: out std_logic_vector(127 downto 0)
	);
end add_round_keys;

architecture behavioral of add_round_keys is
	signal col0, col1, col2, col3: std_logic_vector(31 downto 0);
	signal pk0, pk1, pk2, pk3: std_logic_vector(31 downto 0);
	signal res0, res1, res2, res3: std_logic_vector(31 downto 0);
begin

	-- split data_in and key into columns for code readability
	col0 <= data_in(31 downto 0);
	col1 <= data_in(63 downto 32);
	col2 <= data_in(95 downto 64);
	col3 <= data_in(127 downto 96);

	pk0 <= key(31 downto 0);
	pk1 <= key(63 downto 32);
	pk2 <= key(95 downto 64);
	pk3 <= key(127 downto 96);

	res0 <= col0 xor pk0;
	res1 <= col1 xor pk1;
	res2 <= col2 xor pk2;
	res3 <= col3 xor pk3;

	-- assign the output
	data_out(31 downto 0) <= res0;
	data_out(63 downto 32) <= res1;
	data_out(95 downto 64) <= res2;
	data_out(127 downto 96) <= res3;
end behavioral;
