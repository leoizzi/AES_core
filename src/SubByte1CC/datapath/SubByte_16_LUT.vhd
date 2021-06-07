----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.06.2021 09:11:38
-- Design Name: 
-- Module Name: SubByte_16_LUT - Dataflow
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

entity SubByte_16_LUT is
        Port (
        --Entity input/output.
        data_in : in std_logic_vector(127 downto 0);
        data_out: out std_logic_vector(127 downto 0);
        --Lookup memory interface.
        look_0_addr: out std_logic_vector(7 downto 0);
        look_0_data: in std_logic_vector(7 downto 0);
        look_1_addr: out std_logic_vector(7 downto 0);
        look_1_data: in std_logic_vector(7 downto 0);
        look_2_addr: out std_logic_vector(7 downto 0);
        look_2_data: in std_logic_vector(7 downto 0);
        look_3_addr: out std_logic_vector(7 downto 0);
        look_3_data: in std_logic_vector(7 downto 0);
        
        look_4_addr: out std_logic_vector(7 downto 0);
        look_4_data: in std_logic_vector(7 downto 0);
        look_5_addr: out std_logic_vector(7 downto 0);
        look_5_data: in std_logic_vector(7 downto 0);
        look_6_addr: out std_logic_vector(7 downto 0);
        look_6_data: in std_logic_vector(7 downto 0);
        look_7_addr: out std_logic_vector(7 downto 0);
        look_7_data: in std_logic_vector(7 downto 0);
        
        look_8_addr: out std_logic_vector(7 downto 0);
        look_8_data: in std_logic_vector(7 downto 0);
        look_9_addr: out std_logic_vector(7 downto 0);
        look_9_data: in std_logic_vector(7 downto 0);
        look_10_addr: out std_logic_vector(7 downto 0);
        look_10_data: in std_logic_vector(7 downto 0);
        look_11_addr: out std_logic_vector(7 downto 0);
        look_11_data: in std_logic_vector(7 downto 0);
        
        look_12_addr: out std_logic_vector(7 downto 0);
        look_12_data: in std_logic_vector(7 downto 0);
        look_13_addr: out std_logic_vector(7 downto 0);
        look_13_data: in std_logic_vector(7 downto 0);
        look_14_addr: out std_logic_vector(7 downto 0);
        look_14_data: in std_logic_vector(7 downto 0);
        look_15_addr: out std_logic_vector(7 downto 0);
        look_15_data: in std_logic_vector(7 downto 0));
end SubByte_16_LUT;

architecture Dataflow of SubByte_16_LUT is

begin
look_0_addr <= data_in(7 downto 0);
look_1_addr <= data_in(15 downto 8);
look_2_addr <= data_in(23 downto 16);
look_3_addr <= data_in(31 downto 24);

look_4_addr <= data_in(39 downto 32);
look_5_addr <= data_in(47 downto 40);
look_6_addr <= data_in(55 downto 48);
look_7_addr <= data_in(63 downto 56);
                    
look_8_addr <= data_in(71 downto 64);
look_9_addr <= data_in(79 downto 72);
look_10_addr <= data_in(87 downto 80);
look_11_addr <= data_in(95 downto 88);

look_12_addr <= data_in(103 downto 96);
look_13_addr <= data_in(111 downto 104);
look_14_addr <= data_in(119 downto 112);
look_15_addr <= data_in(127 downto 120);

data_out <= look_15_data&look_14_data&look_13_data&look_12_data&look_11_data&look_10_data&look_9_data&look_8_data&look_7_data&look_6_data&look_5_data&look_4_data&look_3_data&look_2_data&look_1_data&look_0_data;
end Dataflow;
