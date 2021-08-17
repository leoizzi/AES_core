library ieee;
use ieee.std_logic_1164.all;

entity tb_mix_columns is
--  Port ( );
end tb_mix_columns;

architecture test of tb_mix_columns is
	component enc_mix_columns is
		port (
			data_in: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component enc_mix_columns;

	signal data_in: std_logic_vector(127 downto 0) := X"6353e08c0960e104cd70b751bacad0e7";
	signal data_out: std_logic_vector(127 downto 0);
begin
	dut: enc_mix_columns
		port map (
			data_in => data_in,
			data_out => data_out
		);

end test;
