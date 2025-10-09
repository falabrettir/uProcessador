library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity top_level_tb;

architecture a_top_level_tb of top_level_tb is

    component top_level is
        port ( 
    clk: in std_logic;
    rst: in std_logic;
    chave: in std_logic_vector(1 downto 0);
    wr_en: in std_logic; 
    ra1: in std_logic_vector(3 downto 0);
    ra2: in std_logic_vector(3 downto 0);
    addr_wr: in std_logic_vector(3 downto 0);
    const: in unsigned (15 downto 0);
    addi_control: in std_logic;
    f_zero: out std_logic;
    f_carry: out std_logic
  );
    end component;

    -- Sinais para conectar ao top_level
    signal s_clk        : std_logic;
    signal s_rst        : std_logic;
    signal s_wr_en      : std_logic;
    signal s_ula_chave  : std_logic_vector(1 downto 0);
    signal s_sel_ula_b  : std_logic;
    signal s_addr_wr    : std_logic_vector(3 downto 0);
    signal s_addr_r1    : std_logic_vector(3 downto 0);
    signal s_addr_r2    : std_logic_vector(3 downto 0);
    signal s_const_in   : unsigned(15 downto 0);
    signal s_flag_zero  : std_logic;
    signal s_flag_carry : std_logic;
    --fim da sim
    constant c_period   : time := 100 ns;
    signal s_finished   : std_logic := '0';

begin
    -- uut do top level
    uut: top_level port map (
        clk => s_clk, rst => s_rst, wr_en => s_wr_en, chave => s_ula_chave, addi_control => s_sel_ula_b,
        addr_wr => s_addr_wr, ra1 => s_addr_r1, ra2 => s_addr_r2, const => s_const_in,
        f_zero => s_flag_zero, f_carry => s_flag_carry
    );

    clk_proc: process
    begin
        while s_finished /= '1' loop
            s_clk <= '0';
            wait for c_period/2;
            s_clk <= '1';
            wait for c_period/2;
        end loop;
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 1 us; -- Espera um tempo maior que a soma de todos os testes
        s_finished <= '1'; -- Avisa aos outros processos para terminarem
        wait;
    end process;

    -- processo de Estímulos
    stim_proc: process
    begin
        -- Reset
        s_rst <= '1';
        wait for c_period;
        s_rst <= '0';
        wait for c_period;

        -- "ADDI R1, R0, 10"
        s_wr_en     <= '1';
        s_ula_chave <= "00"; 
        s_sel_ula_b <= '1'; 
        s_addr_wr   <= "0001"; 
        s_addr_r1   <= "0000"; 
        s_const_in  <= to_unsigned(10, 16);
        wait for c_period;

        -- "ADDI R2, R0, 20"
        s_addr_wr   <= "0010";
        s_const_in  <= to_unsigned(20, 16);
        wait for c_period;
        
        -- "ADD R1, R2"
        s_sel_ula_b <= '0'; 
        s_addr_wr   <= "0001";
        s_addr_r1   <= "0001";
        s_addr_r2   <= "0010";
        wait for c_period;

        -- "SUB R2, R1"
        s_ula_chave <= "01";
        s_addr_wr   <= "0010";
        s_addr_r1   <= "0010";
        s_addr_r2   <= "0001";
        wait for c_period;

        -- fim
        s_wr_en <= '0'; 
        wait;
    end process;

end architecture a_top_level_tb;
