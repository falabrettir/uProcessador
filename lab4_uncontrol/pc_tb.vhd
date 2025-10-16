library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end entity pc_tb;

architecture a_pc_tb of pc_tb is
    component pc
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            pc_in  : in  unsigned(16 downto 0);
            pc_out : out unsigned(16 downto 0)
        );
    end component;

    -- Sinais de teste
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal wr_en    : std_logic := '0';
    signal pc_in    : unsigned(16 downto 0) := (others => '0');
    signal pc_out   : unsigned(16 downto 0);

    -- Período do clock
    constant clk_period : time := 10 ns;
    signal finished     : std_logic := '0';

begin
    -- Instanciação do componente sob teste
    uut: pc
        port map (
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en,
            pc_in    => pc_in,
            pc_out   => pc_out
        );

    -- Gerador de clock
    clk_process: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    -- Processo de controle do tempo de simulação
    sim_time_proc: process
    begin
        wait for 200 ns;
        finished <= '1';
        wait;
    end process;

    -- Processo de estímulos
    stimulus_proc: process
    begin
        -- Inicialização
        wr_en <= '0';
        pc_in <= (others => '0');
        
        -- Reset ativo
        rst <= '1';
        wait for 20 ns;
        
        -- Libera reset
        rst <= '0';
        wait for 10 ns;
        
        -- Testa escrita no PC 
        wr_en <= '1';
        pc_in <= to_unsigned(100, 17); -- Escreve 100 (0x64)
        wait for clk_period;
        
        -- Escreve outro valor
        pc_in <= to_unsigned(255, 17); -- Escreve 255 (0xFF)
        wait for clk_period;
        
        -- Desabilita escrita - valor deve permanecer
        wr_en <= '0';
        pc_in <= to_unsigned(500, 17); -- Tenta escrever 500 (0x1F4)
        wait for 20 ns;
        
        -- Reabilita escrita
        wr_en <= '1';
        pc_in <= to_unsigned(1024, 17); -- Escreve 1024 (0x400)
        wait for clk_period;
        
        -- Testa reset durante operação
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        
        -- Verifica se zerou após reset
        wait for 10 ns;
        
        -- Escreve valor máximo para testar overflow
        wr_en <= '1';
        pc_in <= to_unsigned(131071, 17); -- Valor máximo para 17 bits (2^17 - 1)
        wait for clk_period;
        
        wr_en <= '0';
        wait for 20 ns;
        
        wait;
    end process;

end architecture a_pc_tb;