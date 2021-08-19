library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Shift rows stage
entity EncShiftRows is
    Port (data_in : in std_logic_vector(127 downto 0);
          data_out: out std_logic_vector(127 downto 0));
 end EncShiftRows;

architecture Dataflow of EncShiftRows is
    signal res0, res1, res2, res3: std_logic_vector(31 downto 0);
    signal row0, row1, row2, row3: std_logic_vector(31 downto 0);
begin

    -- TODO: i dati arrivano per colonne quindi tocca adattare lo shift
    --    c3       c2       c1       c0
    -- a0fafe17 88542cb1 23a33939 2a6c7605

    row0 <= data_in(103 downto 96)&data_in(71 downto 64)&data_in(39 downto 32)&data_in(7 downto 0);
    row1 <= data_in(111 downto 104)&data_in(79 downto 72)&data_in(47 downto 40)&data_in(15 downto 8);
    row2 <= data_in(119 downto 112)&data_in(87 downto 80)&data_in(55 downto 48)&data_in(23 downto 16);
    row3 <= data_in(127 downto 120)&data_in(95 downto 88)&data_in(63 downto 56)&data_in(31 downto 24);
    
    --Row 0.
    res0 <= row0;
    --Row 1.
    res1 <= row1(7 downto 0)&row1(31 downto 8);
    --Row 2.
    res2 <= row2(15 downto 0)&row2(31 downto 16);
    --Row 3.
    res3 <= row3(23 downto 0)&row3(31 downto 24);

    data_out(127 downto 96) <= res3(31 downto 24)&res2(31 downto 24)&res1(31 downto 24)&res0(31 downto 24);
    data_out(95 downto 64) <= res3(23 downto 16)&res2(23 downto 16)&res1(23 downto 16)&res0(23 downto 16);
    data_out(63 downto 32) <= res3(15 downto 8)&res2(15 downto 8)&res1(15 downto 8)&res0(15 downto 8);
    data_out(31 downto 0) <= res3(7 downto 0)&res2(7 downto 0)&res1(7 downto 0)&res0(7 downto 0);
end Dataflow;
