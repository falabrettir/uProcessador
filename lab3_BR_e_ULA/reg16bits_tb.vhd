library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg16bits_tb is
end reg16bits_tb;

architecture a_reg16bits_tb of reg16bits_tb is  
    component reg16bits
        port(
            clk      : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            data_in  : in  unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    -- Sinais de teste
    signal s_clk      : std_logic;
    signal s_rst      : std_logic;
    signal s_wr_en    : std_logic;
    signal s_data_in  : unsigned(15 downto 0);
    signal s_data_out : unsigned(15 downto 0);

    signal s_finished : std_logic := '0'; --Fim da simulacao

    -- Constante para o período do clock, facilita a manutenção
    constant c_period : time := 100 ns;

begin
    -- Unidade sob Teste (UUT)
    uut: reg16bits port map(
        clk      => s_clk,
        rst      => s_rst,
        wr_en    => s_wr_en,
        data_in  => s_data_in,
        data_out => s_data_out
    );

    -- depende do sinal s_finished para parar
    clk_proc: process
    begin
        while s_finished /= '1' loop
            s_clk <= '0';
            wait for c_period / 2;
            s_clk <= '1';
            wait for c_period / 2;
        end loop;
        wait; -- para o processo do clock quando o loop terminar
    end process;

    -- define o tempo total de simulação
    sim_time_proc: process
    begin
        -- espera um tempo total maior que a soma de todos os testes
        wait for 1 us; -- 1 microsegundo é suficiente
        s_finished <= '1'; -- avisa aos outros processos para terminarem
        wait;
    end process;

    -- testes
    stim_proc: process
    begin
        s_rst <= '1';
        wait for 50 ns;
        s_rst <= '0';
        wait for 1 ns;
      
        s_data_in <= x"AAAA";
        s_wr_en   <= '1';
        wait for 100 ns;

        s_wr_en   <= '0';
        s_data_in <= x"BBBB";
        wait for 100 ns;

        s_data_in <= x"CCCC";
        s_wr_en   <= '1';
        wait for 100 ns;

        wait; -- para o processo de estímulos (ele já vai parar por causa do timeout)
    end process;
end architecture;
