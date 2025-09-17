library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity ula_tb is
end ula_tb;

architecture a_ula_tb of ula_tb is 

    -- Componente da uut
    component ula

    port(

        a: in std_logic_vector (15 downto 0); --entrada a 
        b: in std_logic_vector (15 downto 0); --entrada b
        chave: in std_logic_vector (1 downto 0); --chave de selecao

        u_output: out std_logic_vector (15 downto 0); --output da ula
        f_zero: out std_logic;
        f_carry: out std_logic  --flags de zero e carry
      );
    end component;
    
    --Sinais internos, nao lembro se preciso deles ou nao pq ja tao na architecture da ula, mas deixei aqui comentados
    --signal r_s: unsigned (15 down to 0); --resultado da op
    --signal r_sub: unsigned (15 down to 0); --resultado da op
    --signal r_and: unsigned (15 down to 0); --resultado da op
    --signal r_or: unsigned (15 down to 0); --resultado da op
    --signal soma_temp: unsigned(16 down to 0);
    
    --Sinais de input
    signal a: std_logic_vector (15 downto 0) := (others => '0'); --entrada a
    signal b: std_logic_vector (15 downto 0) := (others => '0'); --entrada b
    signal chave: std_logic_vector (1 downto 0) := (others => '0'); --chave de selecao  
    
    --Sinais de output
    signal u_output: std_logic_vector (15 downto 0); --output da ula
    signal f_zero: std_logic; --flags de zero e carry
    signal f_carry: std_logic;

begin
    uut: ula port map (
        a => a,
        b => b,
        chave => chave,
        u_output => u_output,
        f_zero => f_zero,
        f_carry => f_carry
    );
    --Processo de teste
    process
    begin
        -- Teste 1: Soma positiva
        a <= std_logic_vector(to_signed(10, 16)); -- +10 0x000A 0000 0000 0000 1010
        b <= std_logic_vector(to_signed(5, 16));  -- +5  0x0005 0000 0000 0000 0101
                                                -- +15 0x000F 0000 0000 0000 1111
        chave <= "00"; -- Soma    
        wait for 50 ns;

        -- Teste 2: Soma negativa
        a <= std_logic_vector(to_signed(-10, 16)); -- -10 0xFFF6 1111 1111 1111 0110
        b <= std_logic_vector(to_signed(-5, 16));  -- -5  0xFFFB 1111 1111 1111 1011
                                                -- -15 0xFFF1 1111 1111 1111 0001
        chave <= "00"; -- Soma
        wait for 50 ns;

        -- Teste 3: Soma positivo + negativo
        a <= std_logic_vector(to_signed(10, 16));    -- +10 0x000A 0000 0000 0000 1010
        b <= std_logic_vector(to_signed(-5, 16));    -- -5  0xFFFB 1111 1111 1111 1011
                                                -- +5  0x0005 0000 0000 0000 0101
        chave <= "00"; -- Soma
        wait for 50 ns;

        -- Teste 4: Subtracao positiva
        a <= std_logic_vector(to_signed(15, 16)); -- +15 0x000F 0000 0000 0000 1111
        b <= std_logic_vector(to_signed(7, 16));  -- +7  0x0007 0000 0000 0000 0111
                                                -- +8  0x0008 0000 0000 0000 1000
        chave <= "01"; -- Subtracao
        wait for 50 ns;

        -- Teste 5: Subtracao negativa
        a <= std_logic_vector(to_signed(-8, 16)); -- -8  0xFFF8 1111 1111 1111 1000
        b <= std_logic_vector(to_signed(-2, 16)); -- -2  0xFFFE 1111 1111 1111 1110
                                                -- -6  0xFFFA 1111 1111 1111 1010
        chave <= "01"; -- Subtracao
        wait for 50 ns;

        -- Teste 6: Subtracao positivo - negativo
        a <= std_logic_vector(to_signed(10, 16));    -- +10 0x000A 0000 0000 0000 1010
        b <= std_logic_vector(to_signed(-5, 16));    -- -5  0xFFFB 1111 1111 1111 1011
                                                -- +15 0x000F 0000 0000 0000 1111
        chave <= "01"; -- Subtracao
        wait for 50 ns;

        -- Teste 7: AND
        a <= std_logic_vector(to_signed(6, 16)); -- +6  0x0006 0000 0000 0000 0110
        b <= std_logic_vector(to_signed(3, 16)); -- +3  0x0003 0000 0000 0000 0011
                                                -- +2  0x0002 0000 0000 0000 0010
        chave <= "10"; -- AND
        wait for 50 ns;

        -- Teste 8: OR
        a <= std_logic_vector(to_signed(8, 16)); -- +8  0x0008 0000 0000 0000 1000
        b <= std_logic_vector(to_signed(2, 16)); -- +2  0x0002 0000 0000 0000 0010
                                                -- +10 0x000A 0000 0000 0000 1010
        chave <= "11"; -- OR
        wait for 50 ns;

        -- Teste 9: Overflow positivo
        a <= std_logic_vector(to_signed(32767, 16)); -- +32767  0111 1111 1111 1111 (max signed)
        b <= std_logic_vector(to_signed(1, 16));     -- +1      0000 0000 0000 0001
                                                -- -32768  1000 0000 0000 0000 (overflow)
        chave <= "00"; -- Soma
        wait for 50 ns;

        -- Teste 10: Overflow negativo
        a <= std_logic_vector(to_signed(-32768, 16)); -- -32768  1000 0000 0000 0000 (min signed)
        b <= std_logic_vector(to_signed(-1, 16));     -- -1      1111 1111 1111 1111
                                                -- +32767  0111 1111 1111 1111 (overflow)
        chave <= "00"; -- Soma
        wait for 50 ns;

        -- Teste 11: Subtracao resultando zero
        a <= std_logic_vector(to_signed(20, 16)); -- +20  0000 0000 0001 0100
        b <= std_logic_vector(to_signed(20, 16)); -- +20  0000 0000 0001 0100
                                                --   0  0000 0000 0000 0000
        chave <= "01"; -- Subtracao
        wait for 50 ns;

        -- Teste 12: Subtracao negativo - negativo = zero
        a <= std_logic_vector(to_signed(-20, 16)); -- -20  1111 1111 1111 0100
        b <= std_logic_vector(to_signed(-20, 16)); -- -20  1111 1111 1111 0100
                                                --   0  0000 0000 0000 0000
        chave <= "01"; -- Subtracao
        wait for 50 ns;

        wait;
    end process;
end a_ula_tb;



