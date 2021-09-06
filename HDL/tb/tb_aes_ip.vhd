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
		X"6d68de36371ac23cbf0979e924fc79cc",
		X"2558016efce9e25fbfceaa2f34f1d1ff",
		X"dc80e6847571b746384c350a5e1648eb",
		X"d9b1e331432748708b3f7bd0c8a30580",
		X"a9f151c24d3d824c665a7de1b5708e13",
		X"9a96ab41c81833a0439c7e5074da7ba3",
		X"e4ccd38e2b67ffadd32af3f23ca69715",
		X"528e98e18b844df0374605f3f85fc4f3",
		X"cfab2c23f84d0c5fef8c64e7de69409a",
		X"d90ad511bcc24803cf19c100aed55816",
		X"37e6207c17c168b831e5247d15c668bd",
		X"65c89d1273db890361cc99167fd7850f",
		X"202748c426244cc524234cc02a2840c9",
		X"16131411121710151e1b1c191a1f181d",
		X"0c0d0e0f08090a0b0405060700010203"
	);

	constant enc_rom_192 : rom_array_192 := (
		X"0c0d0e0f08090a0b0405060700010203",
		X"5c43f4fe5846f2f91415161710111213",
		X"5c43f4fe4856e2e95847f0fa544afef5",
		X"10b7b34248f043b81cbabd4d40f949b3",
		X"6245080c7effb54104a2a55558e151ab",
		X"66410c0862e3a95d3a02f8f62ab54bb4",
		X"87f33e3cbdf1c6ca97448d7ef5018572",
		X"a351f1e034157c9e83519b69e5109761",
		X"ff12051e7c439e77995309161ea0372a",
		X"f9dcc154608fc8427e2fff68dd7e0e88",
		X"beefd63ac0c029527a8d5a3d859f5f23",
		X"d8aeda32a223800f27bcdf2cde601e78",
		X"e3a41d5dc418c2711a78dc09a4970a33"
	);

	constant dec_rom_192 : rom_array_192 := (
		X"e3a41d5dc418c2711a78dc09a4970a33",
		X"3e021bb94db07380c209ea49d6bebd0d",
		X"85c68c72c7f9d89d73b268398fb999c9",
		X"14b757445378317f423f54eff77d6ec1",
		X"fc0bf1f09b0ece8d47cf663b11476590",
		X"b5423a2ecc5c194a67053f7ddcc1a8b6",
		X"568803aba4055fbe791e2364c6deb0ab",
		X"bbc497cb8a49ab1df28d5c15dd1b7cda",
		X"bfc093cf9655b701318d3cd678c4f708",
		X"2f9620cf62dbef15299524ce60dcef10",
		X"4949cbde5752d7c74d4dcfda4b4ecbdb",
		X"4949cbde4742c7d71e1b1c191a1f181d",
		X"0c0d0e0f08090a0b0405060700010203"
	);

	constant enc_rom_128 : rom_array_128 := (
		X"0c0d0e0f08090a0b0405060700010203",
		X"d6ab76fedaa678f1d2af72fad6aa74fd",
		X"6830b3febe9bc500643dbdf1b692cf0b",
		X"0469bf416c590cbfd2c2c9bfb6ff744e",
		X"fd058dfdf96c32bc95353e0347f7f7bc",
		X"adf622aa50f3af57a99f9deb3caaa3e8",
		X"0aa31f6ba7553dc1f7a692965e390f7d",
		X"4ea9c026440adf4de35fe28c14f9701a",
		X"aebf7ad2e016baf4a41c65b947438735",
		X"be2c974e1093ed9cf0855768549932d1",
		X"4d2b30c5f307a78be3944a1713111d7f"
	);

	constant dec_rom_128 : rom_array_128 := (
		X"4d2b30c5f307a78be3944a1713111d7f",
		X"00f7bf03f770f5809c8faff613aa29be",
		X"f7874a836bff5a768f2586481362a463",
		X"9c7810f5e4dadc3e9c47222b8d82fc74",
		X"78a2cccb789dfe1511c5de5f72e3098d",
		X"003f32de6958204a6326d7d22ec41027",
		X"696712940a7ef7984de2c7f5a8a2f504",
		X"6319e50c479c306de54032f1c7c6e391",
		X"2485d561a2dc029c2286d160a0db0299",
		X"8659d7fd805ad3fc825dd3f98c56dff0",
		X"0c0d0e0f08090a0b0405060700010203"
	);

	constant plaintext: std_logic_vector(127 downto 0) := X"ffeeddccbbaa99887766554433221100";
	constant cyphertext_256 : std_logic_vector(127 downto 0) := X"8960494b9049fceabf456751cab7a28e";
	constant cyphertext_192 : std_logic_vector(127 downto 0) := X"91710deca070af6ee0df4c86a47ca9dd"; 
	constant cyphertext_128 : std_logic_vector(127 downto 0) := X"5ac5b47080b7cdd830047b6ad8e0c469";
		
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




		-- test 2: Encryption AES 192
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




		-- test 3: Decryption AES 192
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
