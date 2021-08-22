--  ******************************************************************************
--  * File Name          : FPGA_testbench.vhd
--  * Description        : Testbench for the IP Manager architecture
--  ******************************************************************************
--  *
--  * Copyright(c) 2016-present Blu5 Group <https://www.blu5group.com>
--  *
--  * This library is free software; you can redistribute it and/or
--  * modify it under the terms of the GNU Lesser General Public
--  * License as published by the Free Software Foundation; either
--  * version 3 of the License, or (at your option) any later version.
--  *
--  * This library is distributed in the hope that it will be useful,
--  * but WITHOUT ANY WARRANTY; without even the implied warranty of
--  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
--  * Lesser General Public License for more details.
--  *
--  * You should have received a copy of the GNU Lesser General Public
--  * License along with this library; if not, see <https://www.gnu.org/licenses/>.
--  *
--  ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CONSTANTS.all;
use work.aes_states.all;

entity FPGA_testbench is
end FPGA_testbench;

architecture test of FPGA_testbench is 

	-- TIME CONSTANTS (COMING FROM SETTINGS OF SOFTWARE)
	constant HCLK_PERIOD 		 : time    := 5555 ps; -- 180 MHz
	constant PRESCALER			 : integer := 3;
	constant FPGA_CLK_PERIOD	 : time    := HCLK_PERIOD*PRESCALER;
	constant ADDRESS_SETUP_TIME	 : integer := 6;
	constant DATA_SETUP_TIME	 : integer := 6;	
		
	-- CONSTANTS FOR BETTER DEFINING CONTROL WORD TO BE WRITTEN IN ROW_0
	constant CONF_OPEN_TRANSACTION_INTMODE  : std_logic_vector(2 downto 0) := "101";
	constant CONF_CLOSE_TRANSACTION_INTMODE : std_logic_vector(2 downto 0) := "100";
	constant CONF_OPEN_TRANSACTION_POLMODE  : std_logic_vector(2 downto 0) := "001";
	constant CONF_CLOSE_TRANSACTION_POLMODE : std_logic_vector(2 downto 0) := "000";
	constant CONF_OPEN_TRANSACTION_ACK      : std_logic_vector(2 downto 0) := "111";
	constant CONF_CLOSE_TRANSACTION_ACK     : std_logic_vector(2 downto 0) := "110";

	constant AES_128_N_KEYS : std_logic_vector(3 downto 0) := "1011"; 
	constant AES_192_N_KEYS : std_logic_vector(3 downto 0) := "1101"; 
	constant AES_256_N_KEYS : std_logic_vector(3 downto 0) := "1111"; 

	-- Expanded keys pre-computed by the CPU
	type rom_array_256 is array(0 to 14) of std_logic_vector(127 downto 0);
	type rom_array_192 is array(0 to 12) of std_logic_vector(127 downto 0);
	type rom_array_128 is array(0 to 10) of std_logic_vector(127 downto 0);

	constant enc_rom_256 : rom_array_256 := (
		X"0c0d0e0f08090a0b0405060700010203",
		X"1c1d1e1f18191a1b1415161710111213",
		X"a572c09ca97fce93a176c498a573c29f",
		X"0640bade1a5da4c10244beda1651a8cd",
		X"03fc1567a68ed5fb0ff11b68ae87dff0",
		X"73b8518d75f8eb536fa54f926de1f148",
		X"6cd5598b6f294cecc9a79917c656827f",
		X"5407cf3927bf9eb4524775e73de23a75",
		X"c1871c2fad5245a4c27b09480bdc905f",
		X"640a820a300d4d3317b2d38745f5a660",
		X"d261a7df13e6bbf0beb4fe547ccff71c",
		X"b3afe640d7a5644ae7a82979f01afafe",
		X"5a721c0a8813bbd59bf500252541fe71",
		X"cdf8cdea7e572baaa9f24fe04e5a6699",
		X"6d68de36371ac23cbf0979e924fc79cc"
		); 

	constant dec_rom_256 : rom_array_256 := (
		X"24fc79ccbf0979e9371ac23c6d68de36",
		X"4e5a6699a9f24fe07e572baacdf8cdea",
		X"2541fe719bf500258813bbd55a721c0a",
		X"f01afafee7a82979d7a5644ab3afe640",
		X"7ccff71cbeb4fe5413e6bbf0d261a7df",
		X"45f5a66017b2d387300d4d33640a820a",
		X"0bdc905fc27b0948ad5245a4c1871c2f",
		X"3de23a75524775e727bf9eb45407cf39",
		X"c656827fc9a799176f294cec6cd5598b",
		X"6de1f1486fa54f9275f8eb5373b8518d",
		X"ae87dff00ff11b68a68ed5fb03fc1567",
		X"1651a8cd0244beda1a5da4c10640bade",
		X"a573c29fa176c498a97fce93a572c09c",
		X"101112131415161718191a1b1c1d1e1f",
		X"000102030405060708090a0b0c0d0e0f"
		);

	constant enc_rom_192 : rom_array_192 := (
		X"000102030405060708090a0b0c0d0e0f",
		X"10111213141516175846f2f95c43f4fe",
		X"544afef55847f0fa4856e2e95c43f4fe",
		X"40f949b31cbabd4d48f043b810b7b342",
		X"58e151ab04a2a5557effb5416245080c",
		X"2ab54bb43a02f8f662e3a95d66410c08",
		X"f501857297448d7ebdf1c6ca87f33e3c",
		X"e510976183519b6934157c9ea351f1e0",
		X"1ea0372a995309167c439e77ff12051e",
		X"dd7e0e887e2fff68608fc842f9dcc154",
		X"859f5f237a8d5a3dc0c02952beefd63a",
		X"de601e7827bcdf2ca223800fd8aeda32",
		X"a4970a331a78dc09c418c271e3a41d5d"
		);

	constant dec_rom_192 : rom_array_192 := (
		X"a4970a331a78dc09c418c271e3a41d5d",
		X"de601e7827bcdf2ca223800fd8aeda32",
		X"859f5f237a8d5a3dc0c02952beefd63a",
		X"dd7e0e887e2fff68608fc842f9dcc154",
		X"1ea0372a995309167c439e77ff12051e",
		X"e510976183519b6934157c9ea351f1e0",
		X"f501857297448d7ebdf1c6ca87f33e3c",
		X"2ab54bb43a02f8f662e3a95d66410c08",
		X"58e151ab04a2a5557effb5416245080c",
		X"40f949b31cbabd4d48f043b810b7b342",
		X"544afef55847f0fa4856e2e95c43f4fe",
		X"10111213141516175846f2f95c43f4fe",
		X"000102030405060708090a0b0c0d0e0f"
		);

	constant enc_rom_128 : rom_array_128 := (
		X"000102030405060708090a0b0c0d0e0f",
		X"d6aa74fdd2af72fadaa678f1d6ab76fe",
		X"b692cf0b643dbdf1be9bc5006830b3fe",
		X"b6ff744ed2c2c9bf6c590cbf0469bf41",
		X"47f7f7bc95353e03f96c32bcfd058dfd",
		X"3caaa3e8a99f9deb50f3af57adf622aa",
		X"5e390f7df7a69296a7553dc10aa31f6b",
		X"14f9701ae35fe28c440adf4d4ea9c026",
		X"47438735a41c65b9e016baf4aebf7ad2",
		X"549932d1f08557681093ed9cbe2c974e",
		X"13111d7fe3944a17f307a78b4d2b30c5"
		);

	constant dec_rom_128 : rom_array_128 := (
		X"13111d7fe3944a17f307a78b4d2b30c5",
		X"549932d1f08557681093ed9cbe2c974e",
		X"47438735a41c65b9e016baf4aebf7ad2",
		X"14f9701ae35fe28c440adf4d4ea9c026",
		X"5e390f7df7a69296a7553dc10aa31f6b",
		X"3caaa3e8a99f9deb50f3af57adf622aa",
		X"47f7f7bc95353e03f96c32bcfd058dfd",
		X"b6ff744ed2c2c9bf6c590cbf0469bf41",
		X"b692cf0b643dbdf1be9bc5006830b3fe",
		X"d6aa74fdd2af72fadaa678f1d6ab76fe",
		X"000102030405060708090a0b0c0d0e0f"
		); 

	constant plaintext: std_logic_vector(127 downto 0) := X"eeffccddaabb88996677445522330011";
	constant cyphertext_256 : std_logic_vector(127 downto 0) := X"60894b494990eafc45bf5167b7ca8ea2";
	constant cyphertext_192 : std_logic_vector(127 downto 0) := X"dda97ca4864cdfe06eaf70a0ec0d7191"; 
	constant cyphertext_128 : std_logic_vector(127 downto 0) := X"69c4e0d86a7b0430d8cdb78070b4c55a"; 
		
	-- FPGA INTERFACE SIGNALS
	signal hclk		 : std_logic := '0';	
	signal fpga_clk  : std_logic := '0';
	signal reset     : std_logic := '0';
	signal data      : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => 'Z');
	signal address   : std_logic_vector(ADD_WIDTH-1 downto 0)  := (others => 'Z');
	signal noe		 : std_logic := '0';
	signal nwe		 : std_logic := '1';
	signal ne1		 : std_logic := '1';
	signal interrupt : std_logic;
   
begin
 
 
 
   dut: entity work.TOP_ENTITY
   	generic map(
   		ADDSET => ADDRESS_SETUP_TIME/PRESCALER,
   		DATAST => DATA_SETUP_TIME/PRESCALER
   	)
   	port map(
   		cpu_fpga_bus_a   => address,
   		cpu_fpga_bus_d   => data,
   		cpu_fpga_bus_noe => noe,
   		cpu_fpga_bus_nwe => nwe,
   		cpu_fpga_bus_ne1 => ne1,
   		cpu_fpga_clk     => fpga_clk,
   		cpu_fpga_int_n   => interrupt,
   		cpu_fpga_rst     => reset
   	);
 
 
 
   pll_osc : process
   begin
		hclk <= '1';
		wait for HCLK_PERIOD/2;
		hclk <= '0';
		wait for HCLK_PERIOD/2;		
	end process;
	
	
	
	fpga_osc : process
	begin
		fpga_clk <= '1';
		wait for FPGA_CLK_PERIOD/2;
		fpga_clk <= '0';
		wait for FPGA_CLK_PERIOD/2;
	end process;
	
	stimuli: process
		
		-- RESULT OF THE READING PROCEDURE
		variable result : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
		variable addr: std_logic_vector(2 downto 0) := (others => '0');
		
		-- R/W PROCEDURES EXECUTED BY THE MASTER (CPU THROUGH FMC) 
		procedure write(w_addr : in std_logic_vector(ADD_WIDTH-1 downto 0);
						w_data : in std_logic_vector(DATA_WIDTH-1 downto 0)) is
		begin
			wait for 15*HCLK_PERIOD;
			ne1 <= '0';
			noe <= '1';
			nwe <= '1';
			address <= w_addr;
			wait for ADDRESS_SETUP_TIME*HCLK_PERIOD;
			nwe <= '0';
			data <= w_data;
			wait for DATA_SETUP_TIME*HCLK_PERIOD;
			nwe <= '1';
			wait for HCLK_PERIOD;
			ne1 <= '1';
			noe <= '0';
		end write;
	
		procedure read(r_addr : in std_logic_vector(ADD_WIDTH-1 downto 0)) is
		begin
			wait for 15*HCLK_PERIOD;
			ne1 <= '0';
			noe <= '1';
			nwe <= '1';
			data <= (others => 'Z');
			address <= r_addr;
			wait for ADDRESS_SETUP_TIME*HCLK_PERIOD;
			noe <= '0'; 
			wait for  DATA_SETUP_TIME*HCLK_PERIOD;
			ne1 <= '1';
			noe <= '1';
			result := data;
		end read;
		
	begin
		reset <= '0', '1' after HCLK_PERIOD*2*PRESCALER, '0' after HCLK_PERIOD*4*PRESCALER;
		wait for HCLK_PERIOD*24; -- random number of cc before starting
		--------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------
		-- 												TESTBENCH PROGRAMS

		-- These programs make use of the read()/write() procedures emulating the software  in order to simulate one 
		-- of the possible scenario. Following, multiple of those are presented. Please uncomment JUST ONE AT ONCE 
		-- of the following when simulating. The first two programs are referred to an example adder core, the second
		-- to the SHA256 IP. Please go in TOP_ENTITY.vhd and comment/uncomment the IP referred to the executed 
		-- testbench.
		--------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------
		
		-- test 0: Encryption AES 256
		write("000000", ALG_SEL & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		write("001000", "000000000000"&AES_256_N_KEYS);
		write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		write("000000", KEY_TRANSFER & CONF_OPEN_TRANSACTION_POLMODE & "0000001");

		-- transfer the keys
		for i in 0 to 14 loop
			for j in 0 to 7 loop
				addr := std_logic_vector(to_unsigned(j, 3));
				write("001"&addr, enc_rom_256(i)((j+1)*DATA_WIDTH-1 downto j*DATA_WIDTH));
			end loop;
		end loop;

		write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		write("000000", DATA_RX & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		-- send the plaintext
		for i in 0 to 7 loop
			addr := std_logic_vector(to_unsigned(i, 3));
			write("001"&addr, plaintext((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH));
		end loop;

		write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		write("000000", ENCRYPTION & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		-- write the lock
		write("000001", X"FFFF");

		read("000001");
		while result = x"FFFF" loop
			read("000001");
		end loop;

		-- read the results
		for i in 0 to 7 loop
			addr := std_logic_vector(to_unsigned(i, 3));
			read("001"&addr);
			assert (result = cyphertext_256((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) report "WRONG ENCRYPTION" severity FAILURE;
		end loop;

		write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");




		-- test 1: Decryption AES 256
		--write("000000", ALG_SEL & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		--write("001000", "000000000000"&AES_256_N_KEYS);
		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", KEY_TRANSFER & CONF_OPEN_TRANSACTION_POLMODE & "0000001");

		---- transfer the keys
		--for i in 0 to 14 loop
		--	for j in 0 to 7 loop
		--		addr := std_logic_vector(to_unsigned(j, 3));
		--		write("001"&addr, dec_rom_256(i)((j+1)*DATA_WIDTH-1 downto j*DATA_WIDTH));
		--	end loop;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", DATA_RX & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		---- send the plaintext
		--for i in 0 to 7 loop
		--	addr := std_logic_vector(to_unsigned(i, 3));
		--	write("001"&addr, cyphertext_256((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH));
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", DECRYPTION & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		---- write the lock
		--write("000001", X"FFFF");

		--read("000001");
		--while result = x"FFFF" loop
		--	read("000001");
		--end loop;

		---- read the results
		--for i in 0 to 7 loop
		--	addr := std_logic_vector(to_unsigned(i, 3));
		--	read("001"&addr);
		--	assert (result = plaintext((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) report "WRONG DECRYPTION" severity FAILURE;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");




		-- test 2: Encryption AES 256
		--write("000000", ALG_SEL & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		--write("001000", "000000000000"&AES_192_N_KEYS);
		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", KEY_TRANSFER & CONF_OPEN_TRANSACTION_POLMODE & "0000001");

		---- transfer the keys
		--for i in 0 to 12 loop
		--	for j in 0 to 7 loop
		--		addr := std_logic_vector(to_unsigned(j, 3));
		--		write("001"&addr, enc_rom_192(i)((j+1)*DATA_WIDTH-1 downto j*DATA_WIDTH));
		--	end loop;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", DATA_RX & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		---- send the plaintext
		--for i in 0 to 7 loop
		--	addr := std_logic_vector(to_unsigned(i, 3));
		--	write("001"&addr, plaintext((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH));
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", ENCRYPTION & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		---- write the lock
		--write("000001", X"FFFF");

		--read("000001");
		--while result = x"FFFF" loop
		--	read("000001");
		--end loop;

		---- read the results
		--for i in 0 to 7 loop
		--	addr := std_logic_vector(to_unsigned(i, 3));
		--	read("001"&addr);
		--	assert (result = cyphertext_192((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) report "WRONG ENCRYPTION" severity FAILURE;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");




		-- test 3: Decryption AES 256
		--write("000000", ALG_SEL & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		--write("001000", "000000000000"&AES_192_N_KEYS);
		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", KEY_TRANSFER & CONF_OPEN_TRANSACTION_POLMODE & "0000001");

		---- transfer the keys
		--for i in 0 to 12 loop
		--	for j in 0 to 7 loop
		--		addr := std_logic_vector(to_unsigned(j, 3));
		--		write("001"&addr, dec_rom_192(i)((j+1)*DATA_WIDTH-1 downto j*DATA_WIDTH));
		--	end loop;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", DATA_RX & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		---- send the plaintext
		--for i in 0 to 7 loop
		--	addr := std_logic_vector(to_unsigned(i, 3));
		--	write("001"&addr, cyphertext_192((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH));
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", DECRYPTION & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		---- write the lock
		--write("000001", X"FFFF");

		--read("000001");
		--while result = x"FFFF" loop
		--	read("000001");
		--end loop;

		---- read the results
		--for i in 0 to 7 loop
		--	addr := std_logic_vector(to_unsigned(i, 3));
		--	read("001"&addr);
		--	assert (result = plaintext((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) report "WRONG DECRYPTION" severity FAILURE;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");




		-- test 4: Encryption AES 128
		--write("000000", ALG_SEL & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		--write("001000", "000000000000"&AES_128_N_KEYS);
		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", KEY_TRANSFER & CONF_OPEN_TRANSACTION_POLMODE & "0000001");

		---- transfer the keys
		--for i in 0 to 10 loop
		--	for j in 0 to 7 loop
		--		addr := std_logic_vector(to_unsigned(j, 3));
		--		write("001"&addr, enc_rom_128(i)((j+1)*DATA_WIDTH-1 downto j*DATA_WIDTH));
		--	end loop;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", DATA_RX & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		---- send the plaintext
		--for i in 0 to 7 loop
		--	addr := std_logic_vector(to_unsigned(i, 3));
		--	write("001"&addr, plaintext((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH));
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", ENCRYPTION & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		---- write the lock
		--write("000001", X"FFFF");

		--read("000001");
		--while result = x"FFFF" loop
		--	read("000001");
		--end loop;

		---- read the results
		--for i in 0 to 7 loop
		--	addr := std_logic_vector(to_unsigned(i, 3));
		--	read("001"&addr);
		--	assert (result = cyphertext_128((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) report "WRONG ENCRYPTION" severity FAILURE;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");




		-- test 5: Decryption AES 128
		--write("000000", ALG_SEL & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		--write("001000", "000000000000"&AES_128_N_KEYS);
		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", KEY_TRANSFER & CONF_OPEN_TRANSACTION_POLMODE & "0000001");

		---- transfer the keys
		--for i in 0 to 10 loop
		--	for j in 0 to 7 loop
		--		addr := std_logic_vector(to_unsigned(j, 3));
		--		write("001"&addr, dec_rom_128(i)((j+1)*DATA_WIDTH-1 downto j*DATA_WIDTH));
		--	end loop;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", DATA_RX & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		---- send the plaintext
		--for i in 0 to 7 loop
		--	addr := std_logic_vector(to_unsigned(i, 3));
		--	write("001"&addr, cyphertext_128((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH));
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", DECRYPTION & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		---- write the lock
		--write("000001", X"FFFF");

		--read("000001");
		--while result = x"FFFF" loop
		--	read("000001");
		--end loop;

		---- read the results
		--for i in 0 to 7 loop
		--	addr := std_logic_vector(to_unsigned(i, 3));
		--	read("001"&addr);
		--	assert (result = plaintext((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) report "WRONG DECRYPTION" severity FAILURE;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");
		--wait;
	end process;
end test;
