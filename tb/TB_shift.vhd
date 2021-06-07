----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.05.2021 09:44:13
-- Design Name: 
-- Module Name: TB_shift - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_shift is
--  Port ( );
end TB_shift;

architecture Behavioral of TB_shift is
component shiftRows is
  Port (data_in : in std_logic_vector(127 downto 0);
        data_out: out std_logic_vector(127 downto 0));
 end component;
 
signal d_in, d_out: std_logic_vector(127 downto 0);
begin
DUT : shiftRows port map (d_in, d_out);
    process
    begin
    d_in <= x"30E5F1AE525D981141B4BF271EB8E0D4";
    --x"D4E0B81E27BFB44111985D52AEF1E530";
    WAIT;
    end process;


end Behavioral;
