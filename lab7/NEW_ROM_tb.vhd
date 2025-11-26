library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NEW_ROM_tb is
end entity NEW_ROM_tb;

architecture a_NEW_ROM_tb of NEW_ROM_tb is
    signal addr : std_logic_vector(5 downto 0);
    signal data : std_logic;
    
    -- Lista de números primos de 2 a 32
    type prime_array is array (0 to 10) of integer;
    constant primes : prime_array := (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31);
    
begin
    uut: entity work.NEW_ROM
        port map (
            addr => addr,
            data => data
        );
    
    test_process: process
        variable is_prime : boolean;
    begin
        -- Testar todos os números de 0 a 32
        for i in 0 to 32 loop
            addr <= std_logic_vector(to_unsigned(i, 6));
            wait for 10 ns;
            
            -- Verificar se i está na lista de primos
            is_prime := false;
            for j in primes'range loop
                if primes(j) = i then
                    is_prime := true;
                end if;
            end loop;
            
            -- Verificar resultado
            if is_prime then
                assert data = '1'
                    report "ERRO: " & integer'image(i) & " deveria ser primo (data='1')"
                    severity error;
            else
                assert data = '0'
                    report "ERRO: " & integer'image(i) & " não deveria ser primo (data='0')"
                    severity error;
            end if;
            
            -- Imprimir resultado
            if data = '1' then
                report integer'image(i) & " é primo";
            end if;
        end loop;
        
        -- Testar endereço fora do intervalo
        addr <= std_logic_vector(to_unsigned(63, 6));
        wait for 10 ns;
        assert data = '0'
            report "ERRO: Endereço fora do intervalo deveria retornar '0'"
            severity error;
        
        report "Teste concluído com sucesso!";
        wait;
    end process;
    
end architecture a_NEW_ROM_tb;
