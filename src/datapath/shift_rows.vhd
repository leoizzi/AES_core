----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2021 10:18:09
-- Design Name: 
-- Module Name: shift_rows - Structural
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

entity shift_rows is
  Port (en_dec: in std_logic;
        data_in : in std_logic_vector(127 downto 0);
        data_out: out std_logic_vector(127 downto 0));
end shift_rows;

architecture Structural of shift_rows is

component EncShiftRows is
  Port (data_in : in std_logic_vector(127 downto 0);
        data_out: out std_logic_vector(127 downto 0));
end component;

component DecShiftRows is
  Port (data_in : in std_logic_vector(127 downto 0);
        data_out: out std_logic_vector(127 downto 0));
end component;

signal out_shift_en, out_shift_dec: std_logic_vector(127 downto 0);
begin
encription_shift_row: EncShiftRows port map (data_in, out_shift_en);
decription_shift_row: DecShiftRows port map (data_in, out_shift_dec);


data_out <= out_shift_en when en_dec = '1' else
            out_shift_dec;
end Structural;
