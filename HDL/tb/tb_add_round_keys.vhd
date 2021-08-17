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

	signal data_in: std_logic_vector(127 downto 0) := X"046681e5e0cb199a48f8d37a2806264c";
	signal key: std_logic_vector(127 downto 0) := X"a0fafe1788542cb123a339392a6c7605";
	signal expected_data: std_logic_vector(127 downto 0) := X"a49c7ff2689f352b6b5bea43026a5049";
	signal data_out: std_logic_vector(127 downto 0);
begin
	dut: add_round_keys
		port map (
			data_in => data_in,
			key => key,
			data_out => data_out
		);

	process
	begin
		wait for 1 ns;
		assert (data_out = expected_data) report "WRONG ADD ROUND KEY" severity FAILURE;
		wait;
	end process

end test;
