library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity rom_tb;

architecture a_rom_tb of rom_tb is
    -- Componente da ROM
    component rom is
        port(
            clk      : in  std_logic;
            endereco : in  unsigned(6 downto 0);
            dado     : out unsigned(16 downto 0)
        );
    end component;

    -- Sinais de teste
    signal clk      : std_logic := '0';
    signal s_endereco : unsigned(6 downto 0) := (others => '0');
    signal s_dado     : unsigned(16 downto 0);
    
    -- Controle de simulação
    constant clk_period : time := 10 ns;
    signal finished : std_logic := '0';

begin
    -- Instancia a ROM
    dut: rom
        port map(
            clk      => clk,
            endereco => s_endereco,
            dado     => s_dado
        );

    -- Gerador de clock
    clk_process: process
    begin
        while finished = '0' loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 1 us; -- Espera um tempo maior que a soma de todos os testes
        finished <= '1'; -- Avisa aos outros processos para terminarem
        wait;
    end process;

    -- Casos de teste
    test_process: process
    begin
        -- Testa alguns endereços
        wait for clk_period;

        s_endereco <= "0000000"; -- Endereço 0, esperado 2
        wait for clk_period;

        s_endereco <= "0000001"; -- Endereço 1, esperado 32768
        wait for clk_period;

        s_endereco <= "0000010"; -- Endereço 2, esperado 0
        wait for clk_period;

        s_endereco <= "0000101"; -- Endereço 5, esperado 3
        wait for clk_period;

        s_endereco <= "0001010"; -- Endereço 10, esperado 0
        wait for clk_period;
        
        -- Finaliza simulação
        finished <= '1';
        wait;
    end process;

end architecture a_rom_tb;