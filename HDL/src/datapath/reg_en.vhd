library ieee;
use ieee.std_logic_1164.all;

-- Generic synchronous enable-register implementation
entity reg_en is
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
end reg_en;

architecture structural of reg_en is
begin
	state: process(clk, en)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '1') then
				q <= (others => '0');
			elsif (en = '1') then
				q <= d;
			end if;
		end if;
	end process state;
end structural;
