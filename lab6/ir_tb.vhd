
-- ir_tb.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ir_tb is
end entity ir_tb;

architecture a_ir_tb of ir_tb is
    -- 1. Declaração do Componente sob Teste (UUT)
    component ir is
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            wr_en   : in  std_logic;
            ir_in   : in  unsigned(16 downto 0);
            ir_out  : out unsigned(16 downto 0)
        );
    end component;

    -- 2. Sinais para conectar ao UUT
    signal clk_s   : std_logic := '0';
    signal rst_s   : std_logic := '0';
    signal wr_en_s : std_logic := '0';
    signal ir_in_s : unsigned(16 downto 0) := (others => '0');
    signal ir_out_s: unsigned(16 downto 0);

    -- Sinais de controle do testbench
    constant period_time : time := 100 ns;
    signal finished      : std_logic := '0';

begin
    -- 3. Instanciação do UUT
    uut: ir port map (
        clk     => clk_s,
        rst     => rst_s,
        wr_en   => wr_en_s,
        ir_in   => ir_in_s,
        ir_out  => ir_out_s
    );

    -- 4. Processos de Geração de Clock, Reset e Fim de Simulação
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
    begin
        -- espera um tempo total maior que a soma de todos os testes
        wait for 1 us; 
        finished <= '1'; -- avisa ao clk_proc para parar
        wait;
    end process sim_time_proc;

    stim_proc: process
-- 5. Processo de Estímulo (Casos de Teste)
begin
    -- Espera o reset terminar
    wait for period_time * 2;

    -- Teste 1: Habilita escrita.
    -- Atribui o valor 10 (decimal) usando uma string binária de 17 bits.
    wr_en_s <= '1';
    ir_in_s <= "00000000000001010"; -- 17 bits para o valor 10
    wait for period_time;

    -- Teste 2: Desabilita escrita. ir deve manter o valor anterior.
    wr_en_s <= '0';
    -- O valor de entrada agora é 65535, mas não deve ser carregado.
    ir_in_s <= "00001111111111111"; -- 17 bits para o valor 65535
    wait for period_time;

    -- Teste 3: Habilita escrita novamente. ir deve carregar o novo valor.
    wr_en_s <= '1';
    wait for period_time;

    -- Fim do teste
    wait;
end process stim_proc;

end architecture a_ir_tb;
