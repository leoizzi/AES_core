----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.05.2021 09:32:35
-- Design Name: 
-- Module Name: shiftRows - Dataflow
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EncShiftRows is
  Port (data_in : in std_logic_vector(127 downto 0);
        data_out: out std_logic_vector(127 downto 0));
 end EncShiftRows;

architecture Dataflow of EncShiftRows is

begin
--Row 0.
data_out (31 downto 0) <= data_in(31 downto 0);
--Row 1.
data_out(63 downto 32) <= data_in(39 downto 32)&data_in(63 downto 40);
--Row 2.
data_out(95 downto 64) <= data_in(79 downto 64)&data_in(95 downto 80);
--Row 3.
data_out(127 downto 96) <= data_in(119 downto 96)&data_in(127 downto 120);
end Dataflow;
