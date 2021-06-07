library ieee;
use ieee.std_logic_1164.all;

entity aes_dec_unit is
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
end entity aes_dec_unit;

architecture structural of aes_dec_unit is
	component aes_cu_dec is
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- start a computation
			start: in std_logic;
			-- number of *middle* AES rounds to execute
			n_rounds: in std_logic_vector(3 downto 0);

			-- set to 1 when the computation has finished
			done: out std_logic;

			first_round: out std_logic;
			--last_round: out std_logic;

			-- set to 1 when the SubBytes has to start its computation
			start_block: out std_logic;
			-- set to 1 when the SubBytes has ended its computation
			end_block: in std_logic;

			-- enable for the register which is input to the SubBytes step
		    en_ff1: out std_logic;

			key_idx: out std_logic_vector(3 downto 0)
		);
	end component aes_cu_dec;

	component dec_datapath is
		port (
			clk: in std_logic;
			rst: in std_logic;
			
			start: in std_logic;
		    end_block: out std_logic;

		    first_round: in std_logic;
		    --last_round: in std_logic;

		    -- enable for the register which is input to the SubBytes step
		    en_ff1: in std_logic;

			data_in: in std_logic_vector(127 downto 0);
			key: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component dec_datapath;

	signal first_round, last_round, start_block, end_block, en_ff1: std_logic;
begin
	cu: aes_cu_dec
		port map (
			clk => clk,
			rst => rst,
			start => start,
			n_rounds => n_rounds,
			done => done,
			first_round => first_round,
			--last_round => last_round,
			start_block => start_block,
			end_block => end_block,
		    en_ff1 => en_ff1,
			key_idx => key_idx
		);

	dp: dec_datapath
		port map (
			clk => clk,
			rst => rst,
			start => start_block,
			end_block => end_block,
			first_round => first_round,
			--last_round => last_round,
			en_ff1 => en_ff1,
			data_in => data_in,
			key => key,
			data_out => data_out
		);
	
end architecture structural;