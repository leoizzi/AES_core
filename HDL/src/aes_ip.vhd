library ieee;
use ieee.std_logic_1164.all;
use work.CONSTANTS.all;

entity aes_ip is
	port (
		clk: in std_logic;
		rst: in std_logic;
		-- DEBUG
		int_opcode: out std_logic_vector(5 downto 0);

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
		ipm_data_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end entity aes_ip;

architecture behavioral of aes_ip is
	component aes_top_cu is
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
	end component aes_top_cu;

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

	component keys_ram is
		port (
	        Clock: in  std_logic; 
	        ClockEn: in  std_logic; 
	        Reset: in  std_logic; 
	        WE: in  std_logic; 
	        Address: in  std_logic_vector(3 downto 0); 
	        Data: in  std_logic_vector(127 downto 0); 
	        Q: out  std_logic_vector(127 downto 0)
	    );
	end component keys_ram;

	signal start_enc, start_dec, done_enc, done_dec, ram_we: std_logic;
	signal n_rounds, key_idx_enc, key_idx_dec, ram_addr: std_logic_vector(3 downto 0);
	signal core_enc_data_out, core_dec_data_out, core_data_in, ram_data_in, ram_data_out: std_logic_vector(127 downto 0);
begin
	cu: aes_top_cu
		port map (
			clk => clk,
			rst => rst,

			-- DEBUG
			int_opcode => int_opcode,

			-- IP manager signals
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

			-- AES cores signals
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

			-- Round keys RAM signals
			ram_we => ram_we,
			ram_addr => ram_addr,
			ram_data_in => ram_data_in
		);

	eu: aes_enc_unit
		port map (
			clk => clk,
			rst => rst,

			-- CU signals
			start => start_enc,
			n_rounds => n_rounds,
			done => done_enc,
			key_idx => key_idx_enc,

			-- DP signals
			data_in => core_data_in,
			key => ram_data_out,
			data_out => core_enc_data_out
		);

	du: aes_dec_unit
		port map (
			clk => clk,
			rst => rst,

			-- CU signals
			start => start_dec,
			n_rounds => n_rounds,
			done => done_dec,
			key_idx => key_idx_dec,

			-- DP signals
			data_in => core_data_in,
			key => ram_data_out,
			data_out => core_dec_data_out
		);

	kr: keys_ram
		port map (
			Clock => clk,
	        ClockEn => '1', 
	        Reset => rst, 
	        WE => ram_we,
	        Address => ram_addr, 
	        Data => ram_data_in, 
	        Q => ram_data_out
		);

end architecture behavioral;