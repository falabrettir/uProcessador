library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maqestados_tb is
end entity maqestados_tb;

architecture a_maqestados_tb of maqestados_tb is
    component maqestados
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            data_in  : in  std_logic;
            data_out : out std_logic
        );
    end component;

    -- Sinais de teste
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal data_in  : std_logic := '0';
    signal data_out : std_logic;

    -- Período do clock
    constant clk_period : time := 10 ns;
    signal finished     : std_logic := '0';

begin
    -- Instanciação do componente sob teste
    uut: maqestados
        port map (
            clk      => clk,
            rst      => rst,
            data_out => data_out
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
        data_in <= '0';
        
        -- Reset ativo
        rst <= '1';
        wait for 20 ns;
        
        -- Libera reset e observa funcionamento
        rst <= '0';
        wait for 40 ns;
        
        -- Testa reset durante operação
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 30 ns;
        
        wait;
    end process;

end architecture a_maqestados_tb;