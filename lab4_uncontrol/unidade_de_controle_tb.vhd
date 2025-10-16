library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_de_controle_tb is
end entity unidade_de_controle_tb;

architecture a_uc_tb of unidade_de_controle_tb is
    component unidade_de_controle is
        port (
            clk           : in  std_logic;
            rst           : in  std_logic;
            instrucao_in  : in  unsigned(16 downto 0);
            pc_atual_in   : in  unsigned(16 downto 0);
            pc_out        : out unsigned(16 downto 0);
            pc_wr_en_out  : out std_logic
        );
    end component;

    signal clk_s           : std_logic := '0';
    signal rst_s           : std_logic := '0';
    signal instrucao_in_s  : unsigned(16 downto 0) := (others => '0');
    signal pc_atual_in_s   : unsigned(16 downto 0) := (others => '0');
    signal pc_out_s        : unsigned(16 downto 0);
    signal pc_wr_en_out_s  : std_logic;

    constant period_time : time := 100 ns;
    signal finished      : std_logic := '0';

begin
    uut: unidade_de_controle port map (
        clk           => clk_s,
        rst           => rst_s,
        instrucao_in  => instrucao_in_s,
        pc_atual_in   => pc_atual_in_s,
        pc_out        => pc_out_s,
        pc_wr_en_out  => pc_wr_en_out_s
    );
    
    -- clock, reset e fim
    clk_proc: process begin while finished /= '1' loop clk_s <= '0'; wait for period_time/2; clk_s <= '1'; wait for period_time/2; end loop; wait; end process;
    reset_global: process begin rst_s <= '1'; wait for period_time*2; rst_s <= '0'; wait; end process;
    sim_time_proc: process begin wait for 1 us; finished <= '1'; wait; end process;

    stimulus_proc: process
    begin
        wait for period_time * 2;

        -- Teste 1: Instrução NOP.
        -- PC Atual = 16 (em 17 bits)
        pc_atual_in_s  <= "00000000000010000"; 
        instrucao_in_s <= (others => '0'); -- NOP

        -- Ciclo de Fetch
        wait for period_time;
        
        -- Ciclo de Execute
        wait for period_time;

        -- Teste 2: Instrução JUMP.
        -- PC Atual = 42 (em 17 bits)
        pc_atual_in_s  <= "00000000000101010"; 
        instrucao_in_s <= "11110000000000101"; -- JUMP 5

        -- Ciclo de Fetch
        wait for period_time;
        
        -- Ciclo de Execute
        wait for period_time;
        
        -- Fim do processo de teste
        wait;
    end process stimulus_proc;

end architecture a_uc_tb;
