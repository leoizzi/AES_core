library ieee;
use ieee.std_logic_1164.all;

entity tb_mix_columns is
end tb_mix_columns;

architecture test of tb_mix_columns is
	component enc_mix_columns is
		port (
			data_in: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component enc_mix_columns;
	
	component dec_mix_columns is
		port (
			data_in: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component dec_mix_columns;

	constant enc_data_in: std_logic_vector(127 downto 0) := X"e7d0caba51b770cd04e160098ce05363";
	signal dec_data_in, dec_data_out: std_logic_vector(127 downto 0);
begin
	emc: enc_mix_columns
		port map (
			data_in => enc_data_in,
			data_out => dec_data_in
		);
		
	dmc: dec_mix_columns
		port map (
			data_in => dec_data_in,
			data_out => dec_data_out
		);
		
	test_proc: process
	begin
	   wait for 1 ns;
	   assert enc_data_in = dec_data_out report "WRONG" severity FAILURE;
	end process test_proc;

end test;
