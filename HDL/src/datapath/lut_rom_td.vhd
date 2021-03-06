-- VHDL netlist generated by SCUBA Diamond (64-bit) 3.12.0.240.2
-- Module  Version: 2.8
--C:\lscc\diamond\3.12\ispfpga\bin\nt64\scuba.exe -w -n lut_rom_td -lang vhdl -synth lse -bus_exp 7 -bb -arch xo2c00 -type rom -addr_width 8 -num_rows 256 -data_width 8 -outdata UNREGISTERED -memfile c:/users/lollo/documents/lattice/mem_file/mem_file/td4_8bit.mem -memformat hex 

-- Sat May 29 10:35:31 2021

library IEEE;
use IEEE.std_logic_1164.all;
-- synopsys translate_off
library MACHXO2;
use MACHXO2.components.all;
-- synopsys translate_on

entity lut_rom_td is
    port (
        Address: in  std_logic_vector(7 downto 0); 
        Q: out  std_logic_vector(7 downto 0));
end lut_rom_td;

architecture Structure of lut_rom_td is

    -- local component declarations
    component ROM256X1A
        generic (INITVAL : in std_logic_vector(255 downto 0));
        port (AD7: in  std_logic; AD6: in  std_logic; AD5: in  std_logic; 
            AD4: in  std_logic; AD3: in  std_logic; AD2: in  std_logic; 
            AD1: in  std_logic; AD0: in  std_logic; DO0: out  std_logic);
    end component;
    attribute NGD_DRC_MASK : integer;
    attribute NGD_DRC_MASK of Structure : architecture is 1;

begin
    -- component instantiation statements
    mem_0_7: ROM256X1A
        generic map (initval=> X"015057D3FA286156AF3152C24BB37FC247193377F0F0CB5664A46534F2DAFD48")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>Q(7));

    mem_0_6: ROM256X1A
        generic map (initval=> X"9B68A34AA647C842FE7B054BEB14DEF8811147420DBF3D2F5B28F323FC43E20D")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>Q(6));

    mem_0_5: ROM256X1A
        generic map (initval=> X"ABBA8EF7872D518C98C5572AAF7EF2A1862233241073622F95DE21DA4167A5F4")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>Q(5));

    mem_0_4: ROM256X1A
        generic map (initval=> X"94796CC45C368F8BDB67E21E7645B347242535634BDAD5C743A0248F2155E9B9")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>Q(4));

    mem_0_3: ROM256X1A
        generic map (initval=> X"C21A4F3CEDDCC8177B4DF9B4DA220CD1C67E14B661F51C623A33AB82E2758986")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>Q(3));

    mem_0_2: ROM256X1A
        generic map (initval=> X"D4ED0858CBA4D063A8174B51F4F76D70066ECB30FF317F9C914A87953BE14968")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>Q(2));

    mem_0_1: ROM256X1A
        generic map (initval=> X"08FB36349C4492694B3EDF05C519CFB1EAFCA1C41D80C095278AF97AA6FAED25")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>Q(1));

    mem_0_0: ROM256X1A
        generic map (initval=> X"BB23F64CBBBE99EB224883FB66F0853EBF6869447A703000FA244CC2C4F6F54A")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>Q(0));

end Structure;

-- synopsys translate_off
library MACHXO2;
configuration Structure_CON of lut_rom_td is
    for Structure
        for all:ROM256X1A use entity MACHXO2.ROM256X1A(V); end for;
    end for;
end Structure_CON;

-- synopsys translate_on
