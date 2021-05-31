library ieee;
use ieee.std_logic_1164.all;

entity synthesis_unit is
	port (
		clk: in std_logic;
		rst: in std_logic;
		start: in std_logic;
	    first_round: in std_logic;
	    last_round: in std_logic;
		end_block0: out std_logic;
		end_block1: out std_logic;
		end_block2: out std_logic;
		end_block3: out std_logic;
		--k: in std_logic_vector(15 downto 0);
		data_out: out std_logic_vector(63 downto 0)
	);
end synthesis_unit;

architecture structural of synthesis_unit is
	component enc_datapath is
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
	end component enc_datapath;
	
	component dec_datapath is
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
	end component dec_datapath;

	constant din : std_logic_vector(127 downto 0) := X"6369616f6369616f6369616f6369616f";
	constant key: std_logic_vector(127 downto 0) := X"21e3384a4055d31787bbc84654da268f";

	--signal din : std_logic_vector(127 downto 0);
	--signal key : std_logic_vector(127 downto 0);
	signal tmp_out0, tmp_out1, tmp_out2, tmp_out3: std_logic_vector(127 downto 0);
begin
	--din <= data_in&data_in&data_in&data_in&data_in&data_in&data_in&data_in;
--	key <= k&k&k&k&k&k&k&k;
	
	dp0: enc_datapath
		port map (
			clk => clk,
			rst => rst,

			start => start,
			end_block => end_block0,

			first_round => first_round,
			last_round => last_round,

			data_in => din,
			key => key,
			data_out => tmp_out0
		);
		
	dp1: dec_datapath
		port map (
			clk => clk,
			rst => rst,

			start => start,
			end_block => end_block1,

			first_round => first_round,
			last_round => last_round,

			data_in => din,
			key => key,
			data_out => tmp_out1
		);

	data_out <= (tmp_out0(127 downto 64) or tmp_out1(127 downto 64)) xor (tmp_out0(63 downto 0) or tmp_out1(63 downto 0));
end structural;
