library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity ula_tb is
end ula_tb;

architecture a_ula_tb of ula_tb is 

    -- Declaração do componente atualizado
    component ula
    port(
        a: in unsigned (15 downto 0);
        b: in unsigned (15 downto 0);
        chave: in std_logic_vector (1 downto 0);
        u_output: out unsigned (15 downto 0);
        f_zero: out std_logic;
        f_carry: out std_logic
      );
    end component;

    -- Sinais com os tipos atualizados
    signal s_a: unsigned (15 downto 0) := (others => '0');
    signal s_b: unsigned (15 downto 0) := (others => '0');
    signal s_chave: std_logic_vector (1 downto 0) := (others => '0');
    
    -- Sinais de output com nomes e tipos atualizados
    signal s_u_output: unsigned (15 downto 0);
    signal s_f_zero: std_logic;
    signal s_f_carry: std_logic;

begin
    -- Instanciação da UUT com a porta de carry
    uut: ula port map (
        a => s_a,
        b => s_b,
        chave => s_chave,
        u_output => s_u_output,
        f_zero => s_f_zero,
        f_carry => s_f_carry
    );

    -- Processo com estímulos de teste para aritmética unsigned
    process
    begin
        -- Teste 1: Soma simples (f_carry deve ser '0')
        s_a <= to_unsigned(100, 16);
        s_b <= to_unsigned(50, 16);
        s_chave <= "00"; -- Soma
        wait for 50 ns;

        -- Teste 2: Subtração simples (f_carry deve ser '0')
        s_a <= to_unsigned(150, 16);
        s_b <= to_unsigned(70, 16);
        s_chave <= "01"; -- Subtração
        wait for 50 ns;

        -- Teste 3: AND
        s_a <= to_unsigned(12, 16); -- 1100
        s_b <= to_unsigned(10, 16); -- 1010  (Resultado: 1000 -> 8)
        s_chave <= "10"; -- AND
        wait for 50 ns;

        -- Teste 4: OR
        s_a <= to_unsigned(12, 16); -- 1100
        s_b <= to_unsigned(10, 16); -- 1010  (Resultado: 1110 -> 14)
        s_chave <= "11"; -- OR
        wait for 50 ns;

        -- Teste 5: Carry na Soma (f_carry deve ser '1')
        s_a <= to_unsigned(65535, 16); -- Valor máximo
        s_b <= to_unsigned(1, 16);
        s_chave <= "00"; -- Soma
        wait for 50 ns;

        -- Teste 6: Carry (Borrow) na Subtração (f_carry deve ser '1')
        s_a <= to_unsigned(10, 16);
        s_b <= to_unsigned(20, 16);
        s_chave <= "01"; -- Subtração
        wait for 50 ns;
        
        -- Teste 7: Zero na Subtração (f_zero deve ser '1')
        s_a <= to_unsigned(200, 16);
        s_b <= to_unsigned(200, 16);
        s_chave <= "01"; -- Subtração
        wait for 50 ns;
        
        -- Teste 8: Zero na Soma (f_zero deve ser '1')
        s_a <= to_unsigned(0, 16);
        s_b <= to_unsigned(0, 16);
        s_chave <= "00"; -- Soma
        wait for 50 ns;

        wait; -- Fim da simulação
    end process;
end a_ula_tb;
