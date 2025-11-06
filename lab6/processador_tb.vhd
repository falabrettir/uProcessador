library ieee;
use ieee.std_logic_1164.all;

entity processador_tb is
end entity processador_tb;

architecture a_processador_tb of processador_tb is

    component processador is
        port (
            clk : in  std_logic;
            rst : in  std_logic
        );
    end component;

    signal s_clk : std_logic := '0';
    signal s_rst : std_logic := '0';

    constant c_clk_period : time      := 100 ns; -- Clock de 10 MHz
    signal s_finished     : std_logic := '0';

begin

    uut: processador
        port map (
            clk => s_clk,
            rst => s_rst
        );

    clk_proc: process
    begin
        while s_finished /= '1' loop
            s_clk <= '0';
            wait for c_clk_period / 2;
            s_clk <= '1';
            wait for c_clk_period / 2;
        end loop;
        wait;
    end process clk_proc;

    reset_proc: process
    begin
        s_rst <= '1';                     -- ativa o reset
        wait for c_clk_period * 2;        -- mantém por 2 ciclos
        s_rst <= '0';                     -- libera o reset
        wait;
    end process reset_proc;

    sim_time_proc: process
    begin
        -- deixa a simulação rodar por tempo suficiente para ver o loop
        wait for c_clk_period * 100; -- roda por 100 ciclos (10 us)
        s_finished <= '1';
        wait;
    end process sim_time_proc;

end architecture a_processador_tb;
