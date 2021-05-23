library ieee;
use ieee.std_logic_1164.all;

entity datapath is
	port (
		clk: in std_logic;
		rst: in std_logic;
		
		start: in std_logic;
	    end_block: out std_logic;

		data_in: in std_logic_vector(127 downto 0);
		key: in std_logic_vector(127 downto 0);
		data_out: out std_logic_vector(127 downto 0)
	);
end datapath;

architecture structural of datapath is
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

	component enc_sub_bytes_rom is
		port (
	        Address: in  std_logic_vector(7 downto 0); 
	        OutClock: in  std_logic; 
	        OutClockEn: in  std_logic; 
	        Reset: in  std_logic; 
	        Q: out  std_logic_vector(7 downto 0)
	    );
	end component enc_sub_bytes_rom;
	
	component lut_rom is
		port (
	        Address: in  std_logic_vector(7 downto 0); 
			Q: out  std_logic_vector(7 downto 0)
	    );
	end component lut_rom;
	
	component lut_rom_reg is
		port (
			Address: in  std_logic_vector(7 downto 0); 
			OutClock: in  std_logic; 
			OutClockEn: in  std_logic; 
			Reset: in  std_logic; 
			Q: out  std_logic_vector(7 downto 0)
		);
	end component lut_rom_reg;
	
	

	component AES_subBytes is
		Port (--FSM data.
	        rst: in std_logic;
	        clk: in std_logic;
	        start: in std_logic;
	        end_block: out std_logic;
	        en : out std_logic_vector(3 downto 0);
	        --Entity input/output.
	        data_in : in std_logic_vector(127 downto 0);
	        data_out: out std_logic_vector(31 downto 0);
	        --Lookup memory interface.
	        look_0_addr: out std_logic_vector(7 downto 0);
	        look_0_data: in std_logic_vector(7 downto 0);
	        look_1_addr: out std_logic_vector(7 downto 0);
	        look_1_data: in std_logic_vector(7 downto 0);
	        look_2_addr: out std_logic_vector(7 downto 0);
	        look_2_data: in std_logic_vector(7 downto 0);
	        look_3_addr: out std_logic_vector(7 downto 0);
	        look_3_data: in std_logic_vector(7 downto 0)
	    );
	end component AES_subBytes;

	component shiftRows is
		 Port (
		 	data_in : in std_logic_vector(127 downto 0);
        	data_out: out std_logic_vector(127 downto 0)
       	);
	end component shiftRows;

	component mix_columns is
		port (
			data_in: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component mix_columns;

	component add_round_keys is
		port (
			data_in: in std_logic_vector(127 downto 0);
			key: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component add_round_keys;
	
	signal sub_bytes_en: std_logic_vector(3 downto 0);
	signal look_0_addr, look_0_data, look_1_addr, look_1_data, look_2_addr, look_2_data, look_3_addr, look_3_data: std_logic_vector(7 downto 0);
	signal sub_bytes_data_out: std_logic_vector(31 downto 0);
	signal sub_bytes_data_in: std_logic_vector(127 downto 0);
	signal shift_rows_data_in, shift_rows_data_out: std_logic_vector(127 downto 0);
	signal mix_column_in, mix_column_out: std_logic_vector(127 downto 0);
	signal add_round_key_in, add_round_key_out: std_logic_vector(127 downto 0);
begin
	ff0: reg_en
		generic map (
			N => 128
		)
		port map (
			clk => clk,
			rst => rst,
			en => '1',
			d => data_in,
			q => sub_bytes_data_in
		);

	--enc_rom_0: lut_rom_reg --enc_sub_bytes_rom
		--port map (
			--Address => look_0_addr,
	        --OutClock => clk,
	        --OutClockEn => '1', 
	        --Reset => rst,
	        --Q => look_0_data
		--);

	--enc_rom_1: lut_rom_reg --enc_sub_bytes_rom
		--port map (
			--Address => look_1_addr,
	        --OutClock => clk,
	        --OutClockEn => '1', 
	        --Reset => rst,
	        --Q => look_1_data
		--);

	--enc_rom_2: lut_rom_reg --enc_sub_bytes_rom
		--port map (
			--Address => look_2_addr,
	        --OutClock => clk,
	        --OutClockEn => '1', 
	        --Reset => rst,
	        --Q => look_2_data
		--);

	--enc_rom_3: lut_rom_reg --enc_sub_bytes_rom
		--port map (
			--Address => look_3_addr,
	        --OutClock => clk,
	        --OutClockEn => '1', 
	        --Reset => rst,
	        --Q => look_3_data
		--);
		
	enc_rom_0: lut_rom
		port map (
			Address => look_0_addr,
			Q => look_0_data
		);
		
	enc_rom_1: lut_rom
		port map (
			Address => look_1_addr,
			Q => look_1_data
		);
		
	enc_rom_2: lut_rom
		port map (
			address => look_2_addr,
			q => look_2_data
		);
		
	enc_rom_3: lut_rom
		port map (
			Address => look_3_addr,
			Q => look_3_data
		);

	sb: AES_subBytes
		port map (
			rst => rst,
	        clk => clk,
	        start => start,
	        end_block => end_block,
	        en => sub_bytes_en,
	        --Entity input/output.
	        data_in => sub_bytes_data_in,
	        data_out => sub_bytes_data_out,
	        --Lookup memory interface.
	        look_0_addr => look_0_addr,
	        look_0_data => look_0_data,
	        look_1_addr => look_1_addr,
	        look_1_data => look_1_data,
	        look_2_addr => look_2_addr,
	        look_2_data => look_2_data,
	        look_3_addr => look_3_addr,
	        look_3_data => look_3_data
		);

	ff1_0: reg_en
		generic map (
			N => 32
		)
		port map (
			clk => clk,
			rst => rst,
			en => sub_bytes_en(0),
			d => sub_bytes_data_out,
			q => shift_rows_data_in(31 downto 0)
		);

	ff1_1: reg_en
		generic map (
			N => 32
		)
		port map (
			clk => clk,
			rst => rst,
			en => sub_bytes_en(1),
			d => sub_bytes_data_out,
			q => shift_rows_data_in(63 downto 32)
		);


	ff1_2: reg_en
		generic map (
			N => 32
		)
		port map (
			clk => clk,
			rst => rst,
			en => sub_bytes_en(2),
			d => sub_bytes_data_out,
			q => shift_rows_data_in(95 downto 64)
		);

	ff1_3: reg_en
		generic map (
			N => 32
		)
		port map (
			clk => clk,
			rst => rst,
			en => sub_bytes_en(3),
			d => sub_bytes_data_out,
			q => shift_rows_data_in(127 downto 96)
		);

	sr: shiftRows
		port map (
			data_in => shift_rows_data_in,
			data_out => shift_rows_data_out
		);

	mc: mix_columns
		port map (
			data_in => shift_rows_data_out,
			data_out => mix_column_out
		);

	ff2: reg_en
		generic map (
			N => 128
		)
		port map (
			clk => clk,
			rst => rst,
			en => '1',
			d => mix_column_out,
			q => add_round_key_in
		);

	ark: add_round_keys
		port map (
			data_in => add_round_key_in,
			key => key,
			data_out => add_round_key_out
		);

	ff3: reg_en
		generic map (
			N => 128
		)
		port map (
			clk => clk,
			rst => rst,
			en => '1',
			d => add_round_key_out,
			q => data_out
		);

end structural;
