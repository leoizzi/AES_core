library ieee;
use ieee.std_logic_1164.all;

entity synthesis_unit is
	port (
		clk: in std_logic;
		rst: in std_logic;
		start: in std_logic;
		n_rounds: in std_logic_vector(3 downto 0);
		done0, done1: out std_logic;
		key_idx0, key_idx1: out std_logic_vector(3 downto 0);
		--k: in std_logic_vector(15 downto 0);
		data_out: out std_logic_vector(63 downto 0)
	);
end synthesis_unit;

architecture structural of synthesis_unit is
	component aes_dec_unit is
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- CU signals
			start: in std_logic;
			n_rounds: in std_logic_vector(3 downto 0);
			done: out std_logic;
			key_idx: out std_logic_vector(3 downto 0);

			-- DP signals
			data_in: in std_logic_vector(127 downto 0);
			key: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component aes_dec_unit;
	
	component aes_enc_unit is
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- CU signals
			start: in std_logic;
			n_rounds: in std_logic_vector(3 downto 0);
			done: out std_logic;
			key_idx: out std_logic_vector(3 downto 0);

			-- DP signals
			data_in: in std_logic_vector(127 downto 0);
			key: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component aes_enc_unit;

	constant din : std_logic_vector(127 downto 0) := X"6369616f6369616f6369616f6369616f";
	constant key: std_logic_vector(127 downto 0) := X"21e3384a4055d31787bbc84654da268f";

	--signal din : std_logic_vector(127 downto 0);
	--signal key : std_logic_vector(127 downto 0);
	signal tmp_out0, tmp_out1: std_logic_vector(127 downto 0);
begin
	--din <= data_in&data_in&data_in&data_in&data_in&data_in&data_in&data_in;
--	key <= k&k&k&k&k&k&k&k;
	
	dp0: aes_dec_unit
		port map (
			clk => clk,
			rst => rst,

			start => start,
			n_rounds => n_rounds,
			done => done0,
			key_idx => key_idx0,

			data_in => din,
			key => key,
			data_out => tmp_out0
		);
		
	dp1: aes_enc_unit
		port map (
			clk => clk,
			rst => rst,

			start => start,
			n_rounds => n_rounds,
			done => done1,
			key_idx => key_idx1,

			data_in => din,
			key => key,
			data_out => tmp_out1
		);

	data_out <= (tmp_out0(127 downto 64) xor tmp_out0(63 downto 0)) and (tmp_out1(127 downto 64) xor tmp_out1(63 downto 0));
	--data_out <= tmp_out1(127 downto 64) xor tmp_out1(63 downto 0);
end structural;
