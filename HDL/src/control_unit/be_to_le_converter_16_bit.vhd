library ieee;
use ieee.std_logic_1164.all;

entity be_to_le_converter_16_bit is
	port (
		be_data: in std_logic_vector(127 downto 0);
		le_data: out std_logic_vector(127 downto 0)
	);
end entity be_to_le_converter_16_bit;

architecture dataflow of be_to_le_converter_16_bit is
	signal data0, data1, data2, data3, data4, data5, data6, data7: std_logic_vector(15 downto 0);
begin
	data0 <= be_data(15 downto 0);
	data1 <= be_data(31 downto 16);
	data2 <= be_data(47 downto 32);
	data3 <= be_data(63 downto 48);
	data4 <= be_data(79 downto 64);
	data5 <= be_data(95 downto 80);
	data6 <= be_data(111 downto 96);
	data7 <= be_data(127 downto 112);

	le_data(15 downto 0) <= data0(7 downto 0)&data0(15 downto 8);
	le_data(31 downto 16) <= data1(7 downto 0)&data1(15 downto 8);
	le_data(47 downto 32) <= data2(7 downto 0)&data2(15 downto 8);
	le_data(63 downto 48) <= data3(7 downto 0)&data3(15 downto 8);
	le_data(79 downto 64) <= data4(7 downto 0)&data4(15 downto 8);
	le_data(95 downto 80) <= data5(7 downto 0)&data5(15 downto 8);
	le_data(111 downto 96) <= data6(7 downto 0)&data6(15 downto 8);
	le_data(127 downto 112) <= data7(7 downto 0)&data7(15 downto 8);
end architecture dataflow;