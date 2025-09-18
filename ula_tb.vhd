library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity ula_tb is
end ula_tb;

architecture a_ula_tb of ula_tb is 

    -- Declaração do componente que vamos testar
    component ula
    port(
        a: in std_logic_vector (15 downto 0);
        b: in std_logic_vector (15 downto 0);
        chave: in std_logic_vector (1 downto 0);
        u_output: out std_logic_vector (15 downto 0);
        f_zero: out std_logic;
        f_overflow: out std_logic  -- Atualizado de f_carry para f_overflow
      );
    end component;

    -- Sinais de input para conectar ao componente
    signal s_a: std_logic_vector (15 downto 0) := (others => '0');
    signal s_b: std_logic_vector (15 downto 0) := (others => '0');
    signal s_chave: std_logic_vector (1 downto 0) := (others => '0');
    
    -- Sinais de output para ler os resultados do componente
    signal s_u_output: std_logic_vector (15 downto 0);
    signal s_f_zero: std_logic;
    signal s_f_overflow: std_logic; -- Atualizado de f_overflow

begin
    -- Instanciação da Unidade Sob Teste (UUT)
    uut: ula port map (
        a => s_a,
        b => s_b,
        chave => s_chave,
        u_output => s_u_output,
        f_zero => s_f_zero,
        f_overflow => s_f_overflow -- Atualizado de f_carry para f_overflow
    );

    -- Processo que gera os estímulos de teste
    process
    begin
        -- Teste 1: Soma positiva
        s_a <= std_logic_vector(to_signed(10, 16));
        s_b <= std_logic_vector(to_signed(5, 16));
        s_chave <= "00"; -- Soma    
        wait for 50 ns;

        -- Teste 2: Soma negativa
        s_a <= std_logic_vector(to_signed(-10, 16));
        s_b <= std_logic_vector(to_signed(-5, 16));
        s_chave <= "00"; -- Soma
        wait for 50 ns;

        -- Teste 3: Soma positivo + negativo
        s_a <= std_logic_vector(to_signed(10, 16));
        s_b <= std_logic_vector(to_signed(-5, 16));
        s_chave <= "00"; -- Soma
        wait for 50 ns;

        -- Teste 4: Subtracao positiva
        s_a <= std_logic_vector(to_signed(15, 16));
        s_b <= std_logic_vector(to_signed(7, 16));
        s_chave <= "01"; -- Subtracao
        wait for 50 ns;

        -- Teste 5: Subtracao negativa
        s_a <= std_logic_vector(to_signed(-8, 16));
        s_b <= std_logic_vector(to_signed(-2, 16));
        s_chave <= "01"; -- Subtracao
        wait for 50 ns;

        -- Teste 6: Subtracao positivo - negativo
        s_a <= std_logic_vector(to_signed(10, 16));
        s_b <= std_logic_vector(to_signed(-5, 16));
        s_chave <= "01"; -- Subtracao
        wait for 50 ns;

        -- Teste 7: AND
        s_a <= std_logic_vector(to_signed(6, 16));
        s_b <= std_logic_vector(to_signed(3, 16));
        s_chave <= "10"; -- AND
        wait for 50 ns;

        -- Teste 8: OR
        s_a <= std_logic_vector(to_signed(8, 16));
        s_b <= std_logic_vector(to_signed(2, 16));
        s_chave <= "11"; -- OR
        wait for 50 ns;

        -- Teste 9: Overflow positivo (f_overflow deve ser '1')
        s_a <= std_logic_vector(to_signed(32767, 16));
        s_b <= std_logic_vector(to_signed(1, 16));
        s_chave <= "00"; -- Soma
        wait for 50 ns;

        -- Teste 10: Overflow negativo (f_overflow deve ser '1')
        s_a <= std_logic_vector(to_signed(-32768, 16));
        s_b <= std_logic_vector(to_signed(-1, 16));
        s_chave <= "00"; -- Soma
        wait for 50 ns;

        -- Teste 11: Subtracao resultando zero (f_zero deve ser '1')
        s_a <= std_logic_vector(to_signed(20, 16));
        s_b <= std_logic_vector(to_signed(20, 16));
        s_chave <= "01"; -- Subtracao
        wait for 50 ns;

        -- Teste 12: Subtracao negativo - negativo = zero (f_zero deve ser '1')
        s_a <= std_logic_vector(to_signed(-20, 16));
        s_b <= std_logic_vector(to_signed(-20, 16));
        s_chave <= "01"; -- Subtracao
        wait for 50 ns;

        wait; -- Fim da simulação
    end process;
end a_ula_tb;
