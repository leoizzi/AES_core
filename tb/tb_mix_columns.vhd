library ieee;
use ieee.std_logic_1164.all;

entity tb_mix_columns is
--  Port ( );
end tb_mix_columns;

architecture test of tb_mix_columns is
	component mix_columns is
		port (
			ed: in std_logic;
			data_in: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component mix_columns;

	signal data_in: std_logic_vector(127 downto 0) := X"E5F1AE309811525D2741B4BF1EB8E0D4";
	signal data_out: std_logic_vector(127 downto 0);
begin
	dut: mix_columns
		port map (
			ed => '1',
			data_in => data_in,
			data_out => data_out
		);

end test;
