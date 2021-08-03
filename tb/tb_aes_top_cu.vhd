library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;
use work.aes_states.all;

entity tb_aes_top_cu is
end entity tb_aes_top_cu;

architecture test of tb_aes_top_cu is
	component aes_top_cu is
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- IP manager signals
			en: in std_logic;
			opcode: in std_logic_vector(OPCODE_SIZE-1 downto 0);
			ack: in std_logic;
			int_polling: in std_logic;
			cpu_write_completed: in std_logic;
			cpu_read_completed: in std_logic;
			buf_en: out std_logic;
			buf_rw: out std_logic;
			buf_addr: out std_logic_vector(ADD_WIDTH-1 downto 0);
			int: out std_logic;
			err: out std_logic;
			ipm_data_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
			ipm_data_out: out std_logic_vector(DATA_WIDTH-1 downto 0);

			-- AES cores signals
			start_enc: out std_logic;
			start_dec: out std_logic;
			n_rounds: out std_logic_vector(3 downto 0);
			done_enc: in std_logic;
			done_dec: in std_logic;
			key_idx_enc: in std_logic_vector(3 downto 0);
			key_idx_dec: in std_logic_vector(3 downto 0);
			core_data_in: out std_logic_vector(127 downto 0);
			core_enc_data_out: in std_logic_vector(127 downto 0);
			core_dec_data_out: in std_logic_vector(127 downto 0);

			-- Round keys RAM signals
			ram_we: out std_logic;
			ram_addr: out std_logic_vector(3 downto 0);
			ram_data_in: out std_logic_vector(127 downto 0)
		);
	end component aes_top_cu;

	constant period : time := 10 ns;

	signal clk, rst, en, ack, int_polling, cpu_write_completed, cpu_read_completed, buf_en, buf_rw, int, err, start_enc, start_dec, done_enc, done_dec, ram_we: std_logic;
	signal opcode: std_logic_vector(OPCODE_SIZE-1 downto 0);
	signal buf_addr: std_logic_vector(ADD_WIDTH-1 downto 0);
	signal ipm_data_in, ipm_data_out: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal n_rounds, key_idx_enc, key_idx_dec, ram_addr: std_logic_vector(3 downto 0);
	signal core_data_in, core_enc_data_out, core_dec_data_out, ram_data_in: std_logic_vector(127 downto 0);
begin
	dut: aes_top_cu
		port map (
			clk => clk,
			rst => rst,
			en => en,
			opcode => opcode,
			ack => ack,
			int_polling => int_polling,
			cpu_write_completed => cpu_write_completed,
			cpu_read_completed => cpu_read_completed,
			buf_en => buf_en,
			buf_rw => buf_rw,
			buf_addr => buf_addr,
			int => int,
			err => err,
			ipm_data_in => ipm_data_in,
			ipm_data_out => ipm_data_out,
			start_enc => start_enc,
			start_dec => start_dec,
			n_rounds => n_rounds,
			done_enc => done_enc,
			done_dec => done_dec,
			key_idx_enc => key_idx_enc,
			key_idx_dec => key_idx_dec,
			core_data_in => core_data_in,
			core_enc_data_out => core_enc_data_out,
			core_dec_data_out => core_dec_data_out,
			ram_we => ram_we,
			ram_addr => ram_addr,
			ram_data_in => ram_data_in
		);

	clk_proc: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_proc;

	test_proc: process
		variable idx: integer := 0;
	begin
		en <= '0';
		opcode <= IDLE;
		ack <= '0';
		int_polling <= '0';
		cpu_write_completed <= '0';
		cpu_read_completed <= '0';
		ipm_data_in <= (others => '0');
		done_enc <= '0';
		done_dec <= '0';
		key_idx_enc <= (others => '0');
		key_idx_dec <= (others => '0');
		core_enc_data_out <= (others => '0');
		core_dec_data_out <= (others => '0');
		rst <= '1';
		wait for period + period/2;
		rst <= '0';

		-- nothing should happen
		wait for 5*period;

		-- again, we should remain in idle
		en <= '1';
		wait for 2*period;

		opcode <= KEY_TRANSFER;
		wait for period;

		-- check the transfer of 2 keys
		for i in 0 to 1 loop
			for j in 0 to 7 loop
				ipm_data_in <= std_logic_vector(to_unsigned(j + 4369 * (i+1), DATA_WIDTH));
				cpu_write_completed <= '1';
				wait for period;
				cpu_write_completed <= '0';
				wait for 3*period;
			end loop;
		end loop;

		-- the cu should stop its operations
		wait for 10*period;

		opcode <= DATA_RX;
		wait for period;

		-- first thing to do is to have opcode = IDLE for when the data transfer is ended
		opcode <= IDLE;
		-- write the data to encrypt/decrypt
		for i in 0 to 7 loop
			ipm_data_in <= std_logic_vector(to_unsigned(10 * (i + 2), DATA_WIDTH));
			cpu_write_completed <= '1';
			wait for period;
			cpu_write_completed <= '0';
			wait for 3*period;
		end loop;

		opcode <= ENC_AES_192;
		wait for period;
		opcode <= IDLE;

		for i in 0 to 11 loop
			key_idx_enc <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		done_enc <= '1';
		core_enc_data_out <= X"AABBCCDDEEFF00112233445566778899";
		wait for period;
		done_enc <= '0';
		wait;
	end process test_proc;
end architecture test;