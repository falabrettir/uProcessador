library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados_tb is
end entity maq_estados_tb;

architecture a_maq_estados_tb of maq_estados_tb is

    component maq_estados
        port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            estado : out unsigned(1 downto 0) 
        );
    end component;

    signal s_clk        : std_logic := '0';
    signal s_rst        : std_logic := '0';
    signal s_estado_out : unsigned(1 downto 0); --saída

    constant c_clk_period : time      := 100 ns; --periodo 
    signal s_finished     : std_logic := '0';    -- fim 

begin

    uut: maq_estados
        port map (
            clk    => s_clk,
            rst    => s_rst,
            estado => s_estado_out
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
        s_rst <= '1';                     -- reset
        wait for c_clk_period * 2;       
        s_rst <= '0';                     
        wait;                             
    end process reset_proc;

    sim_time_proc: process
    begin
        wait for c_clk_period * 10;       -- simula 10 clocks 
        s_finished <= '1';                -- fim
        wait;
    end process sim_time_proc;


end architecture a_maq_estados_tb;
