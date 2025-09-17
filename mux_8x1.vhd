library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_8x1 is
    port (
            sel0, sel1, sel2 : in std_logic;
            entr2, entr4, entr6 : in std_logic;
            saida : out std_logic
    );
end entity mux_8x1;

architecture a_mux8x1 of mux_8x1 is
begin
    saida <=    entr2  when sel2 = '0' and sel1 = '1' and sel0 = '0' else
                entr4  when sel2 = '1' and sel1 = '0' and sel0 = '0' else
                entr6  when sel2 = '1' and sel1 = '1' and sel0 = '0' else
                --saidas sempre em 1
                '1'  when sel2 = '0' and sel1 = '1' and sel0 = '1' else
                '1'     when sel2 = '1' and sel1 = '1' and sel0 = '1' else
                '0';
end architecture;