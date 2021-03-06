library ieee;
use ieee.std_logic_1164.all;

-- AES decryption datapath
entity dec_datapath is
	port (
		clk: in std_logic;
		rst: in std_logic;
		
		start: in std_logic;
	   	end_block: out std_logic;

	   	first_round: in std_logic;
	   	last_round: in std_logic;

	   	-- enable for the register which is input to the SubBytes step
	   	en_ff2: in std_logic;

		data_in: in std_logic_vector(127 downto 0);
		key: in std_logic_vector(127 downto 0);
		data_out: out std_logic_vector(127 downto 0)
	);
end dec_datapath;

architecture structural of dec_datapath is
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
	
	component lut_rom is
		port (
	        Address: in  std_logic_vector(7 downto 0); 
			Q: out  std_logic_vector(7 downto 0)
	    );
	end component lut_rom;
	
	component lut_rom_td is
        port (
            Address: in  std_logic_vector(7 downto 0); 
            Q: out  std_logic_vector(7 downto 0));
    end component;
	
	--SubBytesLUT anticipates the ROM output by 1 cc. 
	component AES_subBytes_LUT is
      Port (--FSM data.
        rst: in std_logic;
        clk: in std_logic;
        start: in std_logic;
        end_block: out std_logic;
        en : out std_logic_vector(1 downto 0);
        --Entity input/output.
        data_in : in std_logic_vector(127 downto 0);
        data_out: out std_logic_vector(63 downto 0);
        --Lookup memory interface.
        look_0_addr: out std_logic_vector(7 downto 0);
        look_0_data: in std_logic_vector(7 downto 0);
        look_1_addr: out std_logic_vector(7 downto 0);
        look_1_data: in std_logic_vector(7 downto 0);
        look_2_addr: out std_logic_vector(7 downto 0);
        look_2_data: in std_logic_vector(7 downto 0);
        look_3_addr: out std_logic_vector(7 downto 0);
        look_3_data: in std_logic_vector(7 downto 0);
        
        look_4_addr: out std_logic_vector(7 downto 0);
        look_4_data: in std_logic_vector(7 downto 0);
        look_5_addr: out std_logic_vector(7 downto 0);
        look_5_data: in std_logic_vector(7 downto 0);
        look_6_addr: out std_logic_vector(7 downto 0);
        look_6_data: in std_logic_vector(7 downto 0);
        look_7_addr: out std_logic_vector(7 downto 0);
        look_7_data: in std_logic_vector(7 downto 0));
    end component AES_subBytes_LUT;

	component DecShiftRows is
        Port (
            data_in : in std_logic_vector(127 downto 0);
            data_out: out std_logic_vector(127 downto 0)
        );
    end component DecShiftRows;

	component dec_mix_columns is
		port (
			data_in: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component dec_mix_columns;

	component add_round_keys is
		port (
			data_in: in std_logic_vector(127 downto 0);
			key: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component add_round_keys;
	
	signal sub_bytes_en: std_logic_vector(1 downto 0);
	signal look_0_addr, look_1_addr, look_2_addr, look_3_addr: std_logic_vector(7 downto 0);
   	signal look_4_addr, look_5_addr, look_6_addr, look_7_addr: std_logic_vector(7 downto 0);
    
   	signal look_0_data, look_1_data, look_2_data, look_3_data: std_logic_vector(7 downto 0);
	signal look_4_data, look_5_data, look_6_data, look_7_data: std_logic_vector(7 downto 0);
	signal sub_bytes_data_out: std_logic_vector(63 downto 0);
	signal sub_bytes_data_in: std_logic_vector(127 downto 0);
	signal shift_rows_data_in, shift_rows_data_out: std_logic_vector(127 downto 0);
	signal mix_column_in, mix_column_out: std_logic_vector(127 downto 0);
	signal add_round_key_in, add_round_key_out: std_logic_vector(127 downto 0);
	signal ff1_out, ff2_out: std_logic_vector(127 downto 0);
	signal add_rk_in_ctrl: std_logic_vector(1 downto 0);
begin
	-- Inverse sub bytes LUTs instantiation
	dec_rom_0: lut_rom_td
		port map (
			Address => look_0_addr,
			Q => look_0_data
		);
		
	dec_rom_1: lut_rom_td
		port map (
			Address => look_1_addr,
			Q => look_1_data
		);
		
	dec_rom_2: lut_rom_td
		port map (
			address => look_2_addr,
			q => look_2_data
		);
		
	dec_rom_3: lut_rom_td
		port map (
			Address => look_3_addr,
			Q => look_3_data
		);
		
		
    dec_rom_4: lut_rom_td
		port map (
			Address => look_4_addr,
			Q => look_4_data
		);
		
	dec_rom_5: lut_rom_td
		port map (
			address => look_5_addr,
			q => look_5_data
		);
		
	dec_rom_6: lut_rom_td
		port map (
			Address => look_6_addr,
			Q => look_6_data
		);
		
    dec_rom_7: lut_rom_td
		port map (
			Address => look_7_addr,
			Q => look_7_data
		);
		
	isb: AES_subBytes_LUT
		port map (
			rst => rst,
			clk => clk,
			start => start,
			end_block => end_block,
			en => sub_bytes_en,
			--Entity input/output.
			data_in => ff2_out,
			data_out => sub_bytes_data_out,
			--Lookup memory interface.
			look_0_addr => look_0_addr,
			look_0_data => look_0_data,
			look_1_addr => look_1_addr,
			look_1_data => look_1_data,
			look_2_addr => look_2_addr,
			look_2_data => look_2_data,
			look_3_addr => look_3_addr,
			look_3_data => look_3_data,

			look_4_addr => look_4_addr,
			look_4_data => look_4_data,
			look_5_addr => look_5_addr,
			look_5_data => look_5_data,
			look_6_addr => look_6_addr,
			look_6_data => look_6_data,
			look_7_addr => look_7_addr,
			look_7_data => look_7_data
		);
	  ff0_0: reg_en
		generic map (
			N => 64
		)
		port map (
			clk => clk,
			rst => rst,
			en => sub_bytes_en(0),
			d => sub_bytes_data_out,
			q => shift_rows_data_in(63 downto 0)
		);

	ff0_1: reg_en
		generic map (
			N => 64
		)
		port map (
			clk => clk,
			rst => rst,
			en => sub_bytes_en(1),
			d => sub_bytes_data_out,
			q => shift_rows_data_in(127 downto 64)
		);

	isr: DecShiftRows
		port map (
			data_in => shift_rows_data_in,
			data_out => shift_rows_data_out
		);

	imc: dec_mix_columns
		port map (
			data_in => shift_rows_data_out,
			data_out => mix_column_out
		);

	ff1: reg_en
		generic map (
			N => 128
		)
		port map (
			clk => clk,
			rst => rst,
			en => '1',
			d => mix_column_out,
			q => ff1_out
		);

	-- Add round key input depends on which round we're in
	add_rk_in_ctrl <= last_round&first_round;

	-- "00" -> middle rounds: the input comes from the mix columns stage
	-- "01" -> first round: the input is the plaintext
	-- "10" -> last round: the input comes from the shift rows stage
	-- "11" -> reserved: it should never happen
	with add_rk_in_ctrl select add_round_key_in <= 
		ff1_out when "00",
		data_in when "01",
		shift_rows_data_out when "10",
		ff1_out when others;

	ark: add_round_keys
		port map (
			data_in => add_round_key_in,
			key => key,
			data_out => add_round_key_out
		);
	
	ff2: reg_en
		generic map (
			N => 128
		)
		port map (
			clk => clk,
			rst => rst,
			en => en_ff2,
			d => add_round_key_out,
			q => ff2_out
		);

	-- the plaintext comes from the add round key stage
	data_out <= ff2_out;

end structural;