library ieee;
use ieee.std_logic_1164.all;

entity top_level_tb is
end entity top_level_tb;

architecture a_pr_tb of top_level_tb is
    component top_level is
        port (
            clk : in  std_logic;
            rst : in  std_logic
        );
    end component;

    signal clk_s : std_logic := '0';
    signal rst_s : std_logic := '0';

    constant period_time : time := 100 ns;
    signal finished      : std_logic := '0';

begin
    uut: top_level port map (
        clk => clk_s,
        rst => rst_s
    );
    
    -- Processos padrão de Clock, Reset e Fim da Simulação
    clk_proc: process begin while finished /= '1' loop clk_s <= '0'; wait for period_time/2; clk_s <= '1'; wait for period_time/2; end loop; wait; end process;
    reset_global: process begin rst_s <= '1'; wait for 2*period_time; rst_s <= '0'; wait; end process;
    sim_time_proc: process 
    begin 
        -- Simula por tempo suficiente para ver o loop na ROM
        wait for 20 * period_time; 
        finished <= '1'; wait; 
    end process;
    
end architecture a_pr_tb;
