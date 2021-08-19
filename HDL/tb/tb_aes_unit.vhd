library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_aes_unit is
end entity tb_aes_unit;

architecture tb of tb_aes_unit is
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

	type rom_array is array(0 to 14) of std_logic_vector(127 downto 0);

	constant enc_rom : rom_array := (
		X"0f0e0d0c0b0a09080706050403020100",
		X"1f1e1d1c1b1a19181716151413121110",
		X"9cc072a593ce7fa998c476a19fc273a5",
		X"deba4006c1a45d1adabe4402cda85116",
		X"6715fc03fbd58ea6681bf10ff0df87ae",
		X"8d51b87353ebf875924fa56f48f1e16d",
		X"8b59d56cec4c296f1799a7c97f8256c6",
		X"39cf0754b49ebf27e7754752753ae23d",
		X"2f1c87c1a44552ad48097bc25f90dc0b",
		X"0a820a64334d0d3087d3b21760a6f545",
		X"dfa761d2f0bbe61354feb4be1cf7cf7c",
		X"40e6afb34a64a5d77929a8e7fefa1af0",
		X"0a1c725ad5bb13882500f59b71fe4125",
		X"eacdf8cdaa2b577ee04ff2a999665a4e",
		X"36de686d3cc21a37e97909bfcc79fc24"
		); 

	constant dec_rom : rom_array := (
		X"36de686d3cc21a37e97909bfcc79fc24",
		X"eacdf8cdaa2b577ee04ff2a999665a4e",
		X"0a1c725ad5bb13882500f59b71fe4125",
		X"40e6afb34a64a5d77929a8e7fefa1af0",
		X"dfa761d2f0bbe61354feb4be1cf7cf7c",
		X"0a820a64334d0d3087d3b21760a6f545",
		X"2f1c87c1a44552ad48097bc25f90dc0b",
		X"39cf0754b49ebf27e7754752753ae23d",
		X"8b59d56cec4c296f1799a7c97f8256c6",
		X"8d51b87353ebf875924fa56f48f1e16d",
		X"6715fc03fbd58ea6681bf10ff0df87ae",
		X"deba4006c1a45d1adabe4402cda85116",
		X"9cc072a593ce7fa998c476a19fc273a5",
		X"1f1e1d1c1b1a19181716151413121110",
		X"0f0e0d0c0b0a09080706050403020100"
		--X"24fc79ccbf0979e9371ac23c6d68de36",
		--X"4e5a6699a9f24fe07e572baacdf8cdea",
		--X"2541fe719bf500258813bbd55a721c0a",
		--X"f01afafee7a82979d7a5644ab3afe640",
		--X"7ccff71cbeb4fe5413e6bbf0d261a7df",
		--X"45f5a66017b2d387300d4d33640a820a",
		--X"0bdc905fc27b0948ad5245a4c1871c2f",
		--X"3de23a75524775e727bf9eb45407cf39",
		--X"c656827fc9a799176f294cec6cd5598b",
		--X"6de1f1486fa54f9275f8eb5373b8518d",
		--X"ae87dff00ff11b68a68ed5fb03fc1567",
		--X"1651a8cd0244beda1a5da4c10640bade",
		--X"a573c29fa176c498a97fce93a572c09c",
		--X"101112131415161718191a1b1c1d1e1f",
		--X"000102030405060708090a0b0c0d0e0f"

		--X"63ed86d6c32ca1739e9790fbcc97cf42",
		--X"aedc8fdcaab275e70ef42f9a9966a5e4",
		--X"a0c127a55dbb318852005fb917ef1452",
		--X"046efa3ba4465a7d97928a7eefafa10f",
		--X"fd7a162d0fbb6e3145ef4bebc17ffcc7",
		--X"a028a04633d4d003783d2b71066a5f54",
		--X"f2c1781c4a5425da8490b72cf509cdb0",
		--X"93fc70454be9fb727e57742557a32ed3",
		--X"b8955dc6cec492f671997a9cf728656c",
		--X"d8158b3735be8f5729f45af6841f1ed6",
		--X"7651cf30bf5de86a86b11ff00ffd78ea",
		--X"edab04601c4ad5a1adeb4420dc8a1561",
		--X"c90c275a39ecf79a894c671af92c375a",
		--X"f1e1d1c1b1a191817161514131211101",
		--X"f0e0d0c0b0a090807060504030201000"
		); 


	signal clk, rst, start, done0, done1: std_logic;
	signal n_rounds_enc, n_rounds_dec, key_idx0, key_idx1: std_logic_vector(3 downto 0);
	signal data_in0, data_in1, key0, key1, data_out0, data_out1: std_logic_vector(127 downto 0);
begin
	key0 <= enc_rom(to_integer(unsigned(key_idx0)));
	key1 <= dec_rom(to_integer(unsigned(key_idx1)));
	
	enc_dut: aes_enc_unit
		port map (
			clk => clk,
			rst => rst,
			start => start,
			n_rounds => n_rounds_enc,
			done => done0,
			key_idx => key_idx0,
			data_in => data_in0,
			key => key0,
			data_out => data_out0
		);

	dec_dut: aes_dec_unit
		port map (
			clk => clk,
			rst => rst,
			start => start,
			n_rounds => n_rounds_dec,
			done => done1,
			key_idx => key_idx1,
			data_in => data_in1,
			key => key1,
			data_out => data_out1
		);

	clk_proc: process
	begin
		clk <= '1';
		wait for 5 ns;
		clk <= '0';
		wait for 5 ns;
	end process clk_proc;

	test_proc: process
	begin
		rst <= '1';
		start <= '0';
		n_rounds_enc <= std_logic_vector(to_unsigned(13, 4));
		n_rounds_dec <= std_logic_vector(to_unsigned(14, 4));
		data_in0 <= X"ffeeddccbbaa99887766554433221100";
		--data_in1 <= X"8990BFCA604945B749FC67A24BEA518E";
		--data_in1 <= X"8960494B9049FCEABF456751CAB7A28E";
		data_in1 <= X"8960494b9049fceabf456751cab7a28e";
		wait for 15 ns;
		rst <= '0';
		wait for 20 ns;
		start <= '1';
		wait for 10 ns;
		start <= '0';
		wait;
	end process test_proc;
	
end architecture tb;