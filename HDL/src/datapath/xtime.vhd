library ieee;
use ieee.std_logic_1164.all;

-- Apply the Galois field multiplication corrective factor if needed
entity xtime is
	port(
		data_in: in std_logic_vector(7 downto 0);
		data_out: out std_logic_vector(7 downto 0)
	);
end entity xtime;

architecture behavioral of xtime is
	constant divisor : std_logic_vector(7 downto 0) := X"1B"; 
begin
	
	with data_in(7) select data_out <= 
		data_in(6 downto 0)&'0' when '0',
		data_in(6 downto 0)&'0' xor divisor when others;

end architecture behavioral;