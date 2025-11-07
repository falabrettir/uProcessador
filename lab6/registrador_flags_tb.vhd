library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_flags_tb is
end entity registrador_flags_tb;

architecture a_registrador_flags_tb of registrador_flags_tb is

    component registrador_flags is
        port (
            clk        : in  std_logic;
            rst        : in  std_logic;
            wr_en      : in  std_logic;
            data_zero  : in  std_logic;
            data_carry : in  std_logic;
            zero_out   : out std_logic;
            carry_out  : out std_logic
        );
    end component;

    signal s_clk        : std_logic := '0';
    signal s_rst        : std_logic := '0';
    signal s_wr_en      : std_logic := '0';
    signal s_data_zero  : std_logic := '0';
    signal s_data_carry : std_logic := '0';
    signal s_zero_out   : std_logic;
    signal s_carry_out  : std_logic;

    constant c_clk_period : time      := 100 ns;
    signal s_finished     : std_logic := '0';

begin

    uut: registrador_flags
        port map (
            clk        => s_clk,
            rst        => s_rst,
            wr_en      => s_wr_en,
            data_zero  => s_data_zero,
            data_carry => s_data_carry,
            zero_out   => s_zero_out,
            carry_out  => s_carry_out
        );

    clk_proc: process
    begin
        while s_finished /= '1' loop
            s_clk <= '0'; wait for c_clk_period / 2;
            s_clk <= '1'; wait for c_clk_period / 2;
        end loop;
        wait;
    end process clk_proc;

    reset_proc: process
    begin
        s_rst <= '1';
        wait for c_clk_period * 2;
        s_rst <= '0';
        wait;
    end process reset_proc;

    sim_time_proc: process
    begin
        wait for c_clk_period * 10;
        s_finished <= '1';
        wait;
    end process sim_time_proc;

    stim_proc: process
    begin
        wait until s_rst = '0';
        wait for c_clk_period / 4;

        s_wr_en      <= '1';
        s_data_zero  <= '1';
        s_data_carry <= '0';
        wait for c_clk_period;

        s_wr_en      <= '0';
        s_data_zero  <= '0';
        s_data_carry <= '1';
        wait for c_clk_period;

        s_wr_en      <= '1';
        wait for c_clk_period;

        s_wr_en      <= '0';
        s_data_zero  <= '1';
        wait for c_clk_period;
        
        wait;
    end process stim_proc;

end architecture a_registrador_flags_tb;
