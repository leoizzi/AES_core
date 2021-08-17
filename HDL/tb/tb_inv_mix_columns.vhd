library ieee;
use ieee.std_logic_1164.all;

entity tb_inv_mix_columns is
end tb_inv_mix_columns;

architecture test of tb_inv_mix_columns is
	component dec_mix_columns is
		port (
			data_in: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component dec_mix_columns;

	constant data_in : std_logic_vector(127 downto 0) := X"2c21a820306f154ab712c75eee0da04f";
	constant dout : std_logic_vector(127 downto 0) := X"d1ed44fd1a0f3f2afa4ff27b7c332a69"; 
	signal data_out: std_logic_vector(127 downto 0);
begin
	dut: dec_mix_columns
		port map (
			data_in => data_in,
			data_out => data_out
		);

end test;
