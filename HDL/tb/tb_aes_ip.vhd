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
		X"0f0b07030e0a06020d0905010c080400",
		X"1f1b17131e1a16121d1915111c181410",
		X"9c93989fc0cec4c2727f7673a5a9a1a5",
		X"dec1dacdbaa4bea8405d4451061a0216",
		X"67fb68f015d51bdffc8ef18703a60fae",
		X"8d53924851eb4ff1b8f8a5e173756f6d",
		X"8bec177f594c9982d529a7566c6fc9c6",
		X"39b4e775cf9e753a07bf47e25427523d",
		X"2fa4485f1c45099087527bdcc1adc20b",
		X"0a338760824dd3a60a0db2f564301745",
		X"dff0541ca7bbfef761e6b4cfd213be7c",
		X"404a79fee66429faafa5a81ab3d7e7f0",
		X"0ad525711cbb00fe7213f5415a889b25",
		X"eaaae099cd2b4f66f857f25acd7ea94e",
		X"363ce9ccdec27979681a09fc6d37bf24"
		); 

	constant dec_rom_256 : rom_array_256 := (
		X"363ce9ccdec27979681a09fc6d37bf24",
		X"eaaae099cd2b4f66f857f25acd7ea94e",
		X"0ad525711cbb00fe7213f5415a889b25",
		X"404a79fee66429faafa5a81ab3d7e7f0",
		X"dff0541ca7bbfef761e6b4cfd213be7c",
		X"0a338760824dd3a60a0db2f564301745",
		X"2fa4485f1c45099087527bdcc1adc20b",
		X"39b4e775cf9e753a07bf47e25427523d",
		X"8bec177f594c9982d529a7566c6fc9c6",
		X"8d53924851eb4ff1b8f8a5e173756f6d",
		X"67fb68f015d51bdffc8ef18703a60fae",
		X"dec1dacdbaa4bea8405d4451061a0216",
		X"9c93989fc0cec4c2727f7673a5a9a1a5",
		X"1f1b17131e1a16121d1915111c181410",
		X"0f0b07030e0a06020d0905010c080400"
		);

	constant enc_rom_192 : rom_array_192 := (
		X"0f0b07030e0a06020d0905010c080400",
		X"fef91713f4f21612434615115c581410",
		X"fee9faf5f4e2f0fe4356474a5c485854",
		X"42b84db3b343bd49b7f0baf910481c40",
		X"0c4155ab08b5a55145ffa2e1627e0458",
		X"085df6b40ca9f84b41e302b566623a2a",
		X"3cca7e723ec68d85f3f1440187bd97f5",
		X"e09e6961f17c9b9751155110a33483e5",
		X"1e77162a059e0937124353a0ff7c991e",
		X"54426888c1c8ff0edc8f2f7ef9607edd",
		X"3a523d23d6295a5fefc08d9fbec07a85",
		X"320f2c78da80df1eae23bc60d8a227de",
		X"5d7109331dc2dc0aa4187897e3c41aa4"
		);

	constant dec_rom_192 : rom_array_192 := (
		X"5d7109331dc2dc0aa4187897e3c41aa4",
		X"320f2c78da80df1eae23bc60d8a227de",
		X"3a523d23d6295a5fefc08d9fbec07a85",
		X"54426888c1c8ff0edc8f2f7ef9607edd",
		X"1e77162a059e0937124353a0ff7c991e",
		X"e09e6961f17c9b9751155110a33483e5",
		X"3cca7e723ec68d85f3f1440187bd97f5",
		X"085df6b40ca9f84b41e302b566623a2a",
		X"0c4155ab08b5a55145ffa2e1627e0458",
		X"42b84db3b343bd49b7f0baf910481c40",
		X"fee9faf5f4e2f0fe4356474a5c485854",
		X"fef91713f4f21612434615115c581410",
		X"0f0b07030e0a06020d0905010c080400"
		);

	constant enc_rom_128 : rom_array_128 := (
		X"0f0b07030e0a06020d0905010c080400",
		X"fef1fafd76787274aba6afaad6dad2d6",
		X"fe00f10bb3c5bdcf309b3d9268be64b6",
		X"41bfbf4ebf0cc9746959c2ff046cd2b6",
		X"fdbc03bc8d323ef7056c35f7fdf99547",
		X"aa57ebe822af9da3f6f39faaad50a93c",
		X"6bc1967d1f3d920fa355a6390aa7f75e",
		X"264d8c1ac0dfe270a90a5ff94e44e314",
		X"d2f4b9357aba6587bf161c43aee0a447",
		X"4e9c68d197ed57322c938599be10f054",
		X"c58b177f30a74a1d2b0794114df3e313"
		);

	constant dec_rom_128 : rom_array_128 := (
		X"c58b177f30a74a1d2b0794114df3e313",
		X"4e9c68d197ed57322c938599be10f054",
		X"d2f4b9357aba6587bf161c43aee0a447",
		X"264d8c1ac0dfe270a90a5ff94e44e314",
		X"6bc1967d1f3d920fa355a6390aa7f75e",
		X"aa57ebe822af9da3f6f39faaad50a93c",
		X"fdbc03bc8d323ef7056c35f7fdf99547",
		X"41bfbf4ebf0cc9746959c2ff046cd2b6",
		X"fe00f10bb3c5bdcf309b3d9268be64b6",
		X"fef1fafd76787274aba6afaad6dad2d6",
		X"0f0b07030e0a06020d0905010c080400"
		); 

	constant plaintext: std_logic_vector(127 downto 0) := X"ffbb7733eeaa6622dd995511cc884400";
	constant cyphertext_256 : std_logic_vector(127 downto 0) := X"8990bfca604945b749fc67a24bea518e";
	constant cyphertext_192 : std_logic_vector(127 downto 0) := X"91a0e0a47170df7c0daf4ca9ec6e86dd"; 
	constant cyphertext_128 : std_logic_vector(127 downto 0) := X"5a8030d8c5b704e0b4cd7bc470d86a69"; 
		
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
		--write("000000", ALG_SEL & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		--write("001000", "000000000000"&AES_256_N_KEYS);
		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		--write("000000", KEY_TRANSFER & CONF_OPEN_TRANSACTION_POLMODE & "0000001");

		---- transfer the keys
		--for i in 0 to 14 loop
		--	for j in 0 to 7 loop
		--		addr := std_logic_vector(to_unsigned(j, 3));
		--		write("001"&addr, enc_rom_256(i)((j+1)*DATA_WIDTH-1 downto j*DATA_WIDTH));
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
		--	assert (result = cyphertext_256((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) report "WRONG ENCRYPTION" severity FAILURE;
		--end loop;

		--write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");




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
		write("000000", ALG_SEL & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		write("001000", "000000000000"&AES_128_N_KEYS);
		write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		write("000000", KEY_TRANSFER & CONF_OPEN_TRANSACTION_POLMODE & "0000001");

		-- transfer the keys
		for i in 0 to 10 loop
			for j in 0 to 7 loop
				addr := std_logic_vector(to_unsigned(j, 3));
				write("001"&addr, dec_rom_128(i)((j+1)*DATA_WIDTH-1 downto j*DATA_WIDTH));
			end loop;
		end loop;

		write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		write("000000", DATA_RX & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
		-- send the plaintext
		for i in 0 to 7 loop
			addr := std_logic_vector(to_unsigned(i, 3));
			write("001"&addr, cyphertext_128((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH));
		end loop;

		write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");

		write("000000", DECRYPTION & CONF_OPEN_TRANSACTION_POLMODE & "0000001");
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
			assert (result = plaintext((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) report "WRONG DECRYPTION" severity FAILURE;
		end loop;

		write("000000", IDLE & CONF_CLOSE_TRANSACTION_POLMODE & "0000001");
		wait;
	end process;
end test;
