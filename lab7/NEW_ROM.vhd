library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ROM que armazena os números de 2 a 32 como potencialmente primos
-- Para cada endereço de 2 a 32, retorna '1' se o número é primo, '0' caso contrário
-- Primos de 2 a 32: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31

entity NEW_ROM is
    port (
        addr    : in  std_logic_vector(5 downto 0);  -- Endereço (0 a 63, mas usamos 2 a 32)
        data    : out std_logic                      -- '1' se primo, '0' se não primo
    );
end entity NEW_ROM;

architecture a_NEW_ROM of NEW_ROM is
    type rom_type is array (0 to 32) of std_logic;
    
    -- ROM com os números de 2 a 32 como potencialmente primos
    -- Índice corresponde ao número, valor '1' indica primo
    constant rom : rom_type := (
        0  => '0',  -- 0 não é primo
        1  => '0',  -- 1 não é primo
        2  => '1',  -- 2 é primo
        3  => '1',  -- 3 é primo
        4  => '0',  -- 4 não é primo
        5  => '1',  -- 5 é primo
        6  => '0',  -- 6 não é primo
        7  => '1',  -- 7 é primo
        8  => '0',  -- 8 não é primo
        9  => '0',  -- 9 não é primo
        10 => '0',  -- 10 não é primo
        11 => '1',  -- 11 é primo
        12 => '0',  -- 12 não é primo
        13 => '1',  -- 13 é primo
        14 => '0',  -- 14 não é primo
        15 => '0',  -- 15 não é primo
        16 => '0',  -- 16 não é primo
        17 => '1',  -- 17 é primo
        18 => '0',  -- 18 não é primo
        19 => '1',  -- 19 é primo
        20 => '0',  -- 20 não é primo
        21 => '0',  -- 21 não é primo
        22 => '0',  -- 22 não é primo
        23 => '1',  -- 23 é primo
        24 => '0',  -- 24 não é primo
        25 => '0',  -- 25 não é primo
        26 => '0',  -- 26 não é primo
        27 => '0',  -- 27 não é primo
        28 => '0',  -- 28 não é primo
        29 => '1',  -- 29 é primo
        30 => '0',  -- 30 não é primo
        31 => '1',  -- 31 é primo
        32 => '0'   -- 32 não é primo
    );

begin
    process(addr)
        variable addr_int : integer;
    begin
        addr_int := to_integer(unsigned(addr));
        if addr_int >= rom'low and addr_int <= rom'high then
            data <= rom(addr_int);
        else
            data <= '0';  -- Endereço fora do intervalo retorna '0'
        end if;
    end process;
end architecture a_NEW_ROM;
