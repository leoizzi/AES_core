library ieee;
use ieee.std_logic_1164.all;

entity enc_datapath is
	port (
		clk: in std_logic;
		rst: in std_logic;
		
		start: in std_logic;
	    end_block: out std_logic;

	    first_round: in std_logic;
	    last_round: in std_logic;

		data_in: in std_logic_vector(127 downto 0);
		key: in std_logic_vector(127 downto 0);
		data_out: out std_logic_vector(127 downto 0)
	);
end enc_datapath;

architecture structural of enc_datapath is
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
	
	
	
	component SubByte_16_LUT is
        Port (
        --Entity input/output.
        data_in : in std_logic_vector(127 downto 0);
        data_out: out std_logic_vector(127 downto 0);
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
        look_7_data: in std_logic_vector(7 downto 0);
        
        look_8_addr: out std_logic_vector(7 downto 0);
        look_8_data: in std_logic_vector(7 downto 0);
        look_9_addr: out std_logic_vector(7 downto 0);
        look_9_data: in std_logic_vector(7 downto 0);
        look_10_addr: out std_logic_vector(7 downto 0);
        look_10_data: in std_logic_vector(7 downto 0);
        look_11_addr: out std_logic_vector(7 downto 0);
        look_11_data: in std_logic_vector(7 downto 0);
        
        look_12_addr: out std_logic_vector(7 downto 0);
        look_12_data: in std_logic_vector(7 downto 0);
        look_13_addr: out std_logic_vector(7 downto 0);
        look_13_data: in std_logic_vector(7 downto 0);
        look_14_addr: out std_logic_vector(7 downto 0);
        look_14_data: in std_logic_vector(7 downto 0);
        look_15_addr: out std_logic_vector(7 downto 0);
        look_15_data: in std_logic_vector(7 downto 0));
end component;


    component EncShiftRows is
    	port (
    		data_in : in std_logic_vector(127 downto 0);
        	data_out: out std_logic_vector(127 downto 0)
        );
    end component EncShiftRows;

    component enc_mix_columns is
    	port (
			data_in: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
    end component enc_mix_columns;

	component add_round_keys is
		port (
			data_in: in std_logic_vector(127 downto 0);
			key: in std_logic_vector(127 downto 0);
			data_out: out std_logic_vector(127 downto 0)
		);
	end component add_round_keys;
	
	signal sub_bytes_en: std_logic_vector(3 downto 0);
	signal look_0_addr, look_1_addr, look_2_addr, look_3_addr: std_logic_vector(7 downto 0);
    signal look_4_addr, look_5_addr, look_6_addr, look_7_addr: std_logic_vector(7 downto 0);
    signal look_8_addr, look_9_addr, look_10_addr, look_11_addr: std_logic_vector(7 downto 0);
    signal look_12_addr, look_13_addr, look_14_addr, look_15_addr: std_logic_vector(7 downto 0);
    
    signal look_0_data, look_1_data, look_2_data, look_3_data: std_logic_vector(7 downto 0);
	signal look_4_data, look_5_data, look_6_data, look_7_data: std_logic_vector(7 downto 0);
	signal look_8_data, look_9_data, look_10_data, look_11_data: std_logic_vector(7 downto 0);
	signal look_12_data, look_13_data, look_14_data, look_15_data: std_logic_vector(7 downto 0);
	
	
	signal sub_bytes_data_out: std_logic_vector(127 downto 0);
	signal sub_bytes_data_in: std_logic_vector(127 downto 0);
	signal shift_rows_data_in, shift_rows_data_out: std_logic_vector(127 downto 0);
	signal mix_column_in, mix_column_out: std_logic_vector(127 downto 0);
	signal add_round_key_in, add_round_key_out: std_logic_vector(127 downto 0);
	signal ff1_out, ff2_out: std_logic_vector(127 downto 0);
	signal add_rk_in_ctrl: std_logic_vector(1 downto 0);
begin
		
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
		
		
		
    enc_rom_4: lut_rom
		port map (
			Address => look_4_addr,
			Q => look_4_data
		);
		
	enc_rom_5: lut_rom
		port map (
			address => look_5_addr,
			q => look_5_data
		);
		
	enc_rom_6: lut_rom
		port map (
			Address => look_6_addr,
			Q => look_6_data
		);
		
    enc_rom_7: lut_rom
		port map (
			Address => look_7_addr,
			Q => look_7_data
		);
		
    enc_rom_8: lut_rom
		port map (
			Address => look_8_addr,
			Q => look_8_data
		);
		
	enc_rom_9: lut_rom
		port map (
			Address => look_9_addr,
			Q => look_9_data
		);
		
	enc_rom_10: lut_rom
		port map (
			address => look_10_addr,
			q => look_10_data
		);
		
	enc_rom_11: lut_rom
		port map (
			Address => look_11_addr,
			Q => look_11_data
		);	
		
    enc_rom_12: lut_rom
		port map (
			Address => look_12_addr,
			Q => look_12_data
		);
		
	enc_rom_13: lut_rom
		port map (
			Address => look_13_addr,
			Q => look_13_data
		);
		
	enc_rom_14: lut_rom
		port map (
			address => look_14_addr,
			q => look_14_data
		);
		
	enc_rom_15: lut_rom
		port map (
			Address => look_15_addr,
			Q => look_15_data
		);
		
	sb: SubByte_16_LUT
		port map (
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
	        look_7_data => look_7_data,
	        
	        look_8_addr => look_8_addr,
	        look_8_data => look_8_data,
	        look_9_addr => look_9_addr,
	        look_9_data => look_9_data,
	        look_10_addr => look_10_addr,
	        look_10_data => look_10_data,
	        look_11_addr => look_11_addr,
	        look_11_data => look_11_data,
	        
	        look_12_addr => look_12_addr,
	        look_12_data => look_12_data,
	        look_13_addr => look_13_addr,
	        look_13_data => look_13_data,
	        look_14_addr => look_14_addr,
	        look_14_data => look_14_data,
	        look_15_addr => look_15_addr,
	        look_15_data => look_15_data
		);
    ff0: reg_en
		generic map (
			N => 128
		)
		port map (
			clk => clk,
			rst => rst,
			en => '1',
			d => sub_bytes_data_out,
			q => shift_rows_data_in
		);
	
	sr: EncShiftRows
		port map (
			data_in => shift_rows_data_in,
			data_out => shift_rows_data_out
		);

	mc: enc_mix_columns
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

	add_rk_in_ctrl <= last_round&first_round;

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
			en => '1',
			d => add_round_key_out,
			q => ff2_out
		);

	data_out <= ff2_out;

end structural;