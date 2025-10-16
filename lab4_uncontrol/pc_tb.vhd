-- pc_tb.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end entity pc_tb;

architecture a_pc_tb of pc_tb is
    -- 1. Declaração do Componente sob Teste (UUT)
    component pc is
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            wr_en   : in  std_logic;
            pc_in   : in  unsigned(16 downto 0);
            pc_out  : out unsigned(16 downto 0)
        );
    end component;

    -- 2. Sinais para conectar ao UUT
    signal clk_s   : std_logic := '0';
    signal rst_s   : std_logic := '0';
    signal wr_en_s : std_logic := '0';
    signal pc_in_s : unsigned(16 downto 0) := (others => '0');
    signal pc_out_s: unsigned(16 downto 0);

    -- Sinais de controle do testbench
    constant period_time : time := 100 ns;
    signal finished      : std_logic := '0';

begin
    -- 3. Instanciação do UUT
    uut: pc port map (
        clk     => clk_s,
        rst     => rst_s,
        wr_en   => wr_en_s,
        pc_in   => pc_in_s,
        pc_out  => pc_out_s
    );

    -- 4. Processos de Geração de Clock, Reset e Fim de Simulação [cite: 102, 111, 117, 121]
    clk_proc: process
    begin
        while finished /= '1' loop
            clk_s <= '0';
            wait for period_time / 2;
            clk_s <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    reset_global: process
    begin
        rst_s <= '1';
        wait for period_time * 2;
        rst_s <= '0';
        wait;
    end process reset_global;

    sim_time_proc: process
-- 5. Processo de Estímulo (Casos de Teste)
begin
    -- Espera o reset terminar
    wait for period_time * 2;

    -- Teste 1: Habilita escrita.
    -- Atribui o valor 10 (decimal) usando uma string binária de 17 bits.
    wr_en_s <= '1';
    pc_in_s <= "00000000000001010"; -- 17 bits para o valor 10
    wait for period_time;

    -- Teste 2: Desabilita escrita. PC deve manter o valor anterior.
    wr_en_s <= '0';
    -- O valor de entrada agora é 65535, mas não deve ser carregado.
    pc_in_s <= "00001111111111111"; -- 17 bits para o valor 65535
    wait for period_time;

    -- Teste 3: Habilita escrita novamente. PC deve carregar o novo valor.
    wr_en_s <= '1';
    wait for period_time;

    -- Fim do teste
    wait;
end process sim_time_proc;

end architecture a_pc_tb;
