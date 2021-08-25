library ieee;
use ieee.std_logic_1164.all;

-- AES encryption CU
entity aes_cu is
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
		last_round: out std_logic;

		-- set to 1 when the SubBytes has to start its computation
		start_block: out std_logic;
		-- set to 1 when the SubBytes has ended its computation
		end_block: in std_logic;

		-- enable for the register which is input to the SubBytes step
	    en_ff2: out std_logic;

		key_idx: out std_logic_vector(3 downto 0)
	);
end entity aes_cu;

architecture behavioral of aes_cu is
	component reg_en is
		generic (
			N: integer := 32
		);

		port (
			clk: in std_logic;
			rst: in std_logic;
			en: in std_logic;
			d: in std_logic_vector(N-1 downto 0);
			q: out std_logic_vector(N-1 downto 0)
		);
	end component reg_en;

	component adder is
		generic (
			N: integer := 16
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			o: out std_logic_vector(N-1 downto 0)
		);
	end component adder;

	type state is (IDLE, FIRST_ROUND0, MIDDLE_ROUND0, MIDDLE_ROUND1, MIDDLE_ROUND2, LAST_ROUND0, LAST_ROUND1, FINISH);

	constant one : std_logic_vector(3 downto 0) := "0001";

	signal curr_state, next_state: state;
	signal curr_round, next_round: std_logic_vector(3 downto 0);
	signal curr_n_rounds, next_n_rounds: std_logic_vector(3 downto 0);
	signal int_rst, rst_regs, en_rounds, en_n_rounds: std_logic;
begin
	int_rst <= rst or rst_regs;

	-- register used to index the keys and to count the rounds number 
	rounds_reg: reg_en
		generic map (
			N => 4
		)
		port map (
			clk => clk,
			rst => int_rst,
			en => en_rounds,
			d => next_round,
			q => curr_round
		);

	key_idx <= curr_round;

	rounds_add: adder
		generic map (
			N => 4
		)
		port map (
			a => curr_round,
			b => one,
			o => next_round
		);

	next_n_rounds <= n_rounds;

	-- sample the number of rounds to execute
	n_rounds_reg: reg_en
		generic map (
			N => 4
		)
		port map (
			clk => clk,
			rst => int_rst,
			en => en_n_rounds,
			d => next_n_rounds,
			q => curr_n_rounds
		);

	state_reg: process(clk)
	begin
		if (clk = '1'and clk'event) then
			if (rst = '1') then
				curr_state <= IDLE;
			else
				curr_state <= next_state;
			end if;
		end if;
	end process state_reg;

	comblogic: process(start, end_block, curr_state, curr_round, curr_n_rounds)
	begin
		next_state <= curr_state;

		en_rounds <= '0';
		en_n_rounds <= '0';
		rst_regs <= '0';

		done <= '0';
		first_round <= '0';
		last_round <= '0';
		start_block <= '0';
		en_ff2 <= '0';

		case (curr_state) is
			when IDLE =>
				rst_regs <= '1';
				if (start = '1') then
					next_state <= FIRST_ROUND0;
				end if;

			-- add round key with the plaintext
			when FIRST_ROUND0 => 
				first_round <= '1';
				en_ff2 <= '1';
				en_n_rounds <= '1';
				en_rounds <= '1';
				next_state <= MIDDLE_ROUND0;

			-- sub bytes
			when MIDDLE_ROUND0 => 
				-- sub bytes is multi-cycle, wait for its end
				if (end_block = '1') then
					next_state <= MIDDLE_ROUND1;
				else
					start_block <= '1';
				end if;

			-- shift rows + mix columns
			when MIDDLE_ROUND1 => 
				next_state <= MIDDLE_ROUND2;

			-- add round key
			when MIDDLE_ROUND2 => 
				en_rounds <= '1';
				if (curr_round = curr_n_rounds) then
					next_state <= LAST_ROUND0;
				else
					next_state <= MIDDLE_ROUND0;
				end if;

				en_ff2 <= '1';

			-- last sub bytes
			when LAST_ROUND0 => 
				if (end_block = '1') then
					next_state <= LAST_ROUND1;
				else
					start_block <= '1';
				end if;

				last_round <= '1';

			-- last shift rows + add round key
			when LAST_ROUND1 => 
				en_ff2 <= '1';
				next_state <= FINISH;
				last_round <= '1';

			-- tell the top CU we're done
			when FINISH => 
				done <= '1';
				next_state <= IDLE;

			when others =>
				next_state <= IDLE;
		end case;

	end process comblogic;
end architecture behavioral;