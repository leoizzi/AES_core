----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.05.2021 17:23:35
-- Design Name: 
-- Module Name: AES_subBytes - Behavioral
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

entity AES_subBytes_LUT is
  Port (--FSM data.
        rst: in std_logic;
        clk: in std_logic;
        start: in std_logic;
        end_block: out std_logic;
        en : out std_logic_vector(1 downto 0);
        --Entity input/output.
        data_in : in std_logic_vector(127 downto 0);
        data_out: out std_logic_vector(63 downto 0);
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
        look_7_data: in std_logic_vector(7 downto 0));
end AES_subBytes_LUT;

architecture Behavioral of AES_subBytes_LUT is
type state is (RESET, IDLE, LOOKUP);
signal c_state, n_state: state;
begin
    
    process(clk)
    begin       
        if (clk = '1' and clk'event) then
            if (rst = '1') then
                c_state <= RESET;
            else
                c_state <= n_state;
            end if;
        end if;
    end process;

    process(c_state, start, data_in, look_0_data, look_1_data, look_2_data, look_3_data, look_4_data, look_5_data, look_6_data, look_7_data)
    begin
    n_state <= c_state;
    data_out <= (others => '0');
    look_0_addr <= (others => '0');
    look_1_addr <= (others => '0');
    look_2_addr <= (others => '0');
    look_3_addr <= (others => '0');
    look_4_addr <= (others => '0');
    look_5_addr <= (others => '0');
    look_6_addr <= (others => '0');
    look_7_addr <= (others => '0');
    end_block <= '0';
    en <= "00";
    case c_state is 
        when RESET =>
            n_state <= IDLE;
            look_0_addr <= (others => '0');
            look_1_addr <= (others => '0');
            look_2_addr <= (others => '0');
            look_3_addr <= (others => '0');
            look_4_addr <= (others => '0');
            look_5_addr <= (others => '0');
            look_6_addr <= (others => '0');
            look_7_addr <= (others => '0');
            data_out <= (others => '0');
            end_block <= '0';
        when IDLE => 
            if (start = '1') then
                n_state <= LOOKUP;
                look_0_addr <= data_in(7 downto 0);
                look_1_addr <= data_in(15 downto 8);
                look_2_addr <= data_in(23 downto 16);
                look_3_addr <= data_in(31 downto 24);
                
                look_4_addr <= data_in(39 downto 32);
                look_5_addr <= data_in(47 downto 40);
                look_6_addr <= data_in(55 downto 48);
                look_7_addr <= data_in(63 downto 56);
                data_out <= look_7_data&look_6_data&look_5_data&look_4_data&look_3_data&look_2_data&look_1_data&look_0_data;
                en <= "10";
            else
                n_state <= c_state ;
                look_0_addr <= (others => '0');
                look_1_addr <= (others => '0');
                look_2_addr <= (others => '0');
                look_3_addr <= (others => '0');
                look_4_addr <= (others => '0');
                look_5_addr <= (others => '0');
                look_6_addr <= (others => '0');
                look_7_addr <= (others => '0');
                en <= "00";
            end if;
            end_block <= '0';
        when LOOKUP =>
                look_0_addr <= data_in(71 downto 64);
                look_1_addr <= data_in(79 downto 72);
                look_2_addr <= data_in(87 downto 80);
                look_3_addr <= data_in(95 downto 88);
                look_4_addr <= data_in(103 downto 96);
                look_5_addr <= data_in(111 downto 104);
                look_6_addr <= data_in(119 downto 112);
                look_7_addr <= data_in(127 downto 120);
                data_out <= look_7_data&look_6_data&look_5_data&look_4_data&look_3_data&look_2_data&look_1_data&look_0_data;
                en <= "01";
                end_block <= '1';
                n_state <= IDLE;
    end case;
    end process;
    
end Behavioral;
