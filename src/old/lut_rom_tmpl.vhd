-- VHDL module instantiation generated by SCUBA Diamond (64-bit) 3.12.0.240.2
-- Module  Version: 2.8
-- Sun May 23 16:09:14 2021

-- parameterized module component declaration
component lut_rom
    port (Address: in  std_logic_vector(7 downto 0); 
        Q: out  std_logic_vector(7 downto 0));
end component;

-- parameterized module component instance
__ : lut_rom
    port map (Address(7 downto 0)=>__, Q(7 downto 0)=>__);
