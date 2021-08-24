library ieee;
use ieee.std_logic_1164.all;
use work.CONSTANTS.all;
use work.aes_states.all;

-- AES top CU which interfaces with the encryption and decryption CUs,
-- as well as the IP manager
entity aes_top_cu is
	port (
		clk: in std_logic;
		rst: in std_logic;

		-- DEBUG
		int_opcode: out std_logic_vector(5 downto 0);

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
end entity aes_top_cu;

architecture behavioral of aes_top_cu is
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

	component be_to_le_converter_32_bit is
		port (
			be_data: in std_logic_vector(127 downto 0);
			le_data: out std_logic_vector(127 downto 0)
		);
	end component be_to_le_converter_32_bit;

	constant AES_128_N_KEYS : std_logic_vector(3 downto 0) := "1011"; 
	constant AES_192_N_KEYS : std_logic_vector(3 downto 0) := "1101"; 
	constant AES_256_N_KEYS : std_logic_vector(3 downto 0) := "1111"; 

	constant ENC_AES_128_ROUNDS : std_logic_vector(3 downto 0) := "1001";
	constant ENC_AES_192_ROUNDS : std_logic_vector(3 downto 0) := "1011";
	constant ENC_AES_256_ROUNDS : std_logic_vector(3 downto 0) := "1101";
	constant DEC_AES_128_ROUNDS : std_logic_vector(3 downto 0) := "1010";
	constant DEC_AES_192_ROUNDS : std_logic_vector(3 downto 0) := "1100";
	constant DEC_AES_256_ROUNDS : std_logic_vector(3 downto 0) := "1110"; 

	signal curr_state, next_state: std_logic_vector(OPCODE_SIZE-1 downto 0);
	signal curr_data_reg_en, next_data_reg_en: std_logic_vector(8 downto 0);
	signal data_reg_out: std_logic_vector(127 downto 0);
	signal key_le_data_reg_out: std_logic_vector(127 downto 0);
	signal data_reg_sample: std_logic;
	signal data_reg_sample_vec: std_logic_vector(7 downto 0);
	signal curr_buf_addr, next_buf_addr: std_logic_vector(2 downto 0);
	signal buf_addr_en: std_logic;
	signal curr_ram_addr, next_ram_addr: std_logic_vector(3 downto 0);
	signal ram_addr_en: std_logic;
	signal rst_int: std_logic;
	signal rst_buf_addr: std_logic;
	signal curr_n_keys: std_logic_vector(3 downto 0);
	signal n_keys_en: std_logic;
begin
	rst_buf_addr <= rst or rst_int;

	-- these FFs are used to create a 128 bits word from the Data Buffer's 16 bits data
	data_comb_reg_loop : for i in 0 to (128/DATA_WIDTH)-1 generate
	   data_reg_sample_vec(i) <= curr_data_reg_en(i) and data_reg_sample;
	   
		data_reg: reg_en
			generic map (
				N => DATA_WIDTH
			)
			port map (
				clk => clk,
				rst => rst,
				en => data_reg_sample_vec(i),
				d => ipm_data_in,
				q => data_reg_out(((i+1) * DATA_WIDTH)-1 downto i*DATA_WIDTH)
			);
	end generate data_comb_reg_loop;

	-- the keys sent by the CPU needs to be reversed 32 bits at the time
	key_in_be_to_le: be_to_le_converter_32_bit
		port map (
			be_data => data_reg_out,
			le_data => key_le_data_reg_out
		);

	core_data_in <= data_reg_out;
	ram_data_in <= key_le_data_reg_out;

	-- en_data controls which data_reg must sample from the Data Buffer
	en_data_reg: reg_en
		generic map (
			N => 9
		)
		port map (
			clk => clk,
			rst => rst,
			en => '1',
			d => next_data_reg_en,
			q => curr_data_reg_en
		);

	-- generate the next data_buffer address for transfer operations
	buf_addr_adder: adder
		generic map (
			N => 3
		)
		port map (
			a => curr_buf_addr,
			b => "001",
			o => next_buf_addr
		);

	buf_add_reg: reg_en
		generic map (
			N => 3
		)
		port map (
			clk => clk,
			rst => rst_buf_addr,
			en => buf_addr_en,
			d => next_buf_addr,
			q => curr_buf_addr
		);

	-- generate the next RAM address where to store a key
	ram_addr_adder: adder
		generic map (
			N => 4
		)
		port map (
			a => curr_ram_addr,
			b => "0001",
			o => next_ram_addr
		);

	ram_add_reg: reg_en
		generic map (
			N => 4
		)
		port map (
			clk => clk,
			rst => rst_buf_addr,
			en => ram_addr_en,
			d => next_ram_addr,
			q => curr_ram_addr
		);

	-- store the number of keys to be read
	n_keys_reg: reg_en
		generic map (
			N => 4
		)
		port map (
			clk => clk,
			rst => rst,
			en => n_keys_en,
			d => ipm_data_in(3 downto 0),
			q => curr_n_keys
		);

	state_reg: process(clk)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '1') then
				curr_state <= IDLE;
			else
				curr_state <= next_state;
			end if;
		end if;
	end process state_reg;

	int_opcode <= curr_state;

	comblogic: process(curr_state, curr_buf_addr, curr_data_reg_en, curr_ram_addr, curr_n_keys,
		en, opcode, ack, int_polling, cpu_write_completed, cpu_read_completed,
		ipm_data_in, done_enc, done_dec, key_idx_enc, key_idx_dec, core_enc_data_out,
		core_dec_data_out)
	begin
		next_state <= curr_state;
		next_data_reg_en <= curr_data_reg_en;
		rst_int <= '0';
		buf_en <= '0';
		buf_rw <= '0';
		int <= '0';
		err <= '0';
		ipm_data_out <= (others => '0');
		start_enc <= '0';
		start_dec <= '0';
		ram_we <= '0';
		ram_addr <= (others => '0');
		buf_addr_en <= '0';
		ram_addr_en <= '0';
		n_keys_en <= '0';
		-- reg_en by default resets to 0, however we cannot use address 0 since it's reserved.
		-- for this reason we generate the read address by concatenating the offset to "001"
		buf_addr <= "001"&curr_buf_addr;
		data_reg_sample <= '0';
		n_rounds <= (others => '0');

		if (int_polling = '1') then
			err <= '1';
		end if;

		case(curr_state) is
			when IDLE => 
				if (en = '1' and int_polling = '0') then
					next_state <= opcode;
				end if;

				next_data_reg_en <= (0 => '1', others => '0');
				rst_int <= '1';

			when ALG_SEL => 
				buf_en <= '1';
				if (cpu_write_completed = '1') then
					n_keys_en <= '1';
					next_state <= WAIT_TR_CLOSE;
				end if;

			when KEY_TRANSFER =>
			    data_reg_sample <= '1';
			    buf_en <= '1';
				if (curr_data_reg_en(8) = '1') then
					next_state <= KEY_WRITE;
				end if;

				if (curr_ram_addr = curr_n_keys) then
					next_state <= WAIT_TR_CLOSE;
				end if;

				if (cpu_write_completed = '1') then
					buf_addr_en <= '1';
					next_data_reg_en <= curr_data_reg_en(7 downto 0)&curr_data_reg_en(8);
				end if;

			when KEY_WRITE => 
			    -- data_reg_sample <= '1';
				ram_addr <= curr_ram_addr;
				ram_addr_en <= '1';
				ram_we <= '1';
				next_state <= KEY_TRANSFER;
				next_data_reg_en <= (0 => '1', others => '0');

			when DATA_RX => 
				buf_en <= '1';
				if (cpu_write_completed = '1') then
					buf_addr_en <= '1';
					data_reg_sample <= '1';
					next_data_reg_en <= curr_data_reg_en(7 downto 0)&curr_data_reg_en(8);
				end if;

				if (curr_data_reg_en(8) = '1') then
					next_state <= WAIT_TR_CLOSE;
				end if;

			when ENCRYPTION => 
				start_enc <= '1';
				ram_addr <= key_idx_enc;
				case (curr_n_keys) is
					when AES_128_N_KEYS => 
						n_rounds <= ENC_AES_128_ROUNDS;

					when AES_192_N_KEYS => 
						n_rounds <= ENC_AES_192_ROUNDS;

					when AES_256_N_KEYS => 
						n_rounds <= ENC_AES_256_ROUNDS;

					when others => 
						err <= '1';
						next_state <= WAIT_TR_CLOSE;
				end case;

				if (done_enc = '1') then
					next_state <= ENC_DATA_TX;
				end if;

			when DECRYPTION => 
				start_dec <= '1';
				ram_addr <= key_idx_dec;
				case (curr_n_keys) is
					when AES_128_N_KEYS => 
						n_rounds <= DEC_AES_128_ROUNDS;

					when AES_192_N_KEYS => 
						n_rounds <= DEC_AES_192_ROUNDS;

					when AES_256_N_KEYS => 
						n_rounds <= DEC_AES_256_ROUNDS;

					when others => 
						err <= '1';
						next_state <= WAIT_TR_CLOSE;
				end case;
				
				if (done_dec = '1') then
					next_state <= DEC_DATA_TX;
				end if;

			when ENC_DATA_TX => 
				buf_addr_en <= '1';
				buf_en <= '1';
				buf_rw <= '1';
				case(curr_buf_addr) is
					when "000" => 
						ipm_data_out <= core_enc_data_out(15 downto 0);

					when "001" => 
						ipm_data_out <= core_enc_data_out(31 downto 16);

					when "010" => 
						ipm_data_out <= core_enc_data_out(47 downto 32);

					when "011" => 
						ipm_data_out <= core_enc_data_out(63 downto 48);

					when "100" => 
						ipm_data_out <= core_enc_data_out(79 downto 64);

					when "101" => 
						ipm_data_out <= core_enc_data_out(95 downto 80);

					when "110" => 
						ipm_data_out <= core_enc_data_out(111 downto 96);

					when "111" => 
						ipm_data_out <= core_enc_data_out(127 downto 112);
						next_state <= CORE_DONE;
						rst_int <= '1';

					when others =>
						next_state <= WAIT_TR_CLOSE;
						err <= '1';
				end case;

			when DEC_DATA_TX => 
				buf_addr_en <= '1';
				buf_en <= '1';
				buf_rw <= '1';
				case(curr_buf_addr) is
					when "000" => 
						ipm_data_out <= core_dec_data_out(15 downto 0);

					when "001" => 
						ipm_data_out <= core_dec_data_out(31 downto 16);

					when "010" => 
						ipm_data_out <= core_dec_data_out(47 downto 32);

					when "011" => 
						ipm_data_out <= core_dec_data_out(63 downto 48);

					when "100" => 
						ipm_data_out <= core_dec_data_out(79 downto 64);

					when "101" => 
						ipm_data_out <= core_dec_data_out(95 downto 80);

					when "110" => 
						ipm_data_out <= core_dec_data_out(111 downto 96);

					when "111" => 
						ipm_data_out <= core_dec_data_out(127 downto 112);
						next_state <= CORE_DONE;
						rst_int <= '1';

					when others =>
						next_state <= WAIT_TR_CLOSE;
						err <= '1';
				end case;

			when CORE_DONE => 
				buf_addr_en <= '1';
				buf_en <= '1';
				buf_rw <= '1';
				buf_addr <= "000001";
				if (en = '0') then
					next_state <= IDLE;
				end if;

			when WAIT_TR_CLOSE => 
				if (en = '0') then
					next_state <= IDLE;
				end if;

			when others => 
				next_state <= IDLE;
		end case;
	end process comblogic;
end architecture behavioral;