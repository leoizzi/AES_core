library ieee;
use ieee.std_logic_1164.all;
use work.CONSTANTS.all;

entity be_to_le_converter is
	port (
		be_data: in std_logic_vector(127 downto 0);
		le_data: out std_logic_vector(127 downto 0)
	);
end entity be_to_le_converter;

architecture dataflow of be_to_le_converter is
	signal data0, data1, data2, data3: std_logic_vector(31 downto 0);
begin
	data0 <= be_data(31 downto 0);
	data1 <= be_data(63 downto 32);
	data2 <= be_data(95 downto 64);
	data3 <= be_data(127 downto 96);

	le_data(31 downto 0) <= data0(7 downto 0)&data0(15 downto 8)&data0(23 downto 16)&data0(31 downto 24);
	le_data(63 downto 32) <= data1(7 downto 0)&data1(15 downto 8)&data1(23 downto 16)&data1(31 downto 24);
	le_data(95 downto 64) <= data2(7 downto 0)&data2(15 downto 8)&data2(23 downto 16)&data2(31 downto 24);
	le_data(127 downto 96) <= data3(7 downto 0)&data3(15 downto 8)&data3(23 downto 16)&data3(31 downto 24);
end architecture dataflow;