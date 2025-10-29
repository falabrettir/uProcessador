library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end entity uc_tb;

architecture a_uc_tb of uc_tb is

    component uc is
        port (
            clk                : in  std_logic;
            rst                : in  std_logic;
            opcode_in          : in  unsigned(3 downto 0);
            pc_atual_in        : in  unsigned(16 downto 0);
            const_5bit_in      : in  unsigned(4 downto 0);
            const_13bit_in     : in  unsigned(12 downto 0);
            pc_wr_en_out       : out std_logic;
            ir_wr_en_out       : out std_logic;
            reg_wr_en_out      : out std_logic;
            ula_chave_out      : out std_logic_vector(1 downto 0);
            sel_mux_ula_b_out  : out std_logic;
            sel_mux_reg_wr_out : out std_logic;
            pc_in_out          : out unsigned(16 downto 0)
        );
    end component;

    signal s_clk                : std_logic := '0';
    signal s_rst                : std_logic := '0';
    signal s_opcode_in          : unsigned(3 downto 0) := (others => '0');
    signal s_pc_atual_in        : unsigned(16 downto 0) := (others => '0');
    signal s_const_5bit_in      : unsigned(4 downto 0) := (others => '0');
    signal s_const_13bit_in     : unsigned(12 downto 0) := (others => '0');
    signal s_pc_wr_en_out       : std_logic;
    signal s_ir_wr_en_out       : std_logic;
    signal s_reg_wr_en_out      : std_logic;
    signal s_ula_chave_out      : std_logic_vector(1 downto 0);
    signal s_sel_mux_ula_b_out  : std_logic;
    signal s_sel_mux_reg_wr_out : std_logic;
    signal s_pc_in_out          : unsigned(16 downto 0);

    constant c_clk_period : time      := 100 ns;
    signal s_finished     : std_logic := '0';

begin

    uut: uc
        port map (
            clk                => s_clk,
            rst                => s_rst,
            opcode_in          => s_opcode_in,
            pc_atual_in        => s_pc_atual_in,
            const_5bit_in      => s_const_5bit_in,
            const_13bit_in     => s_const_13bit_in,
            pc_wr_en_out       => s_pc_wr_en_out,
            ir_wr_en_out       => s_ir_wr_en_out,
            reg_wr_en_out      => s_reg_wr_en_out,
            ula_chave_out      => s_ula_chave_out,
            sel_mux_ula_b_out  => s_sel_mux_ula_b_out,
            sel_mux_reg_wr_out => s_sel_mux_reg_wr_out,
            pc_in_out          => s_pc_in_out
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
        wait for c_clk_period * 20; 
        s_finished <= '1';
        wait;
    end process sim_time_proc;

    stim_proc: process
    begin
        wait until s_rst = '0';
        wait for c_clk_period / 4; 

        --nop
        s_pc_atual_in <= (others => '0');
        s_opcode_in   <= "0000"; -- NOP
        -- Fetch 
        wait for c_clk_period; 
        -- Decode 
        wait for c_clk_period; 
        -- Execute 
        wait for c_clk_period; 

        -- ADDI R1, R0, 5 (LD R1, 5)
        s_pc_atual_in <= to_unsigned(1, 17);
        s_opcode_in   <= "1000"; -- ADDI
        s_const_5bit_in <= "00101"; 
        -- Fetch (State "00")
        wait for c_clk_period; -- ir_wr_en = '1'
        -- Decode (State "01")
        wait for c_clk_period; -- pc_wr_en = '1', pc_in = 2
        -- Execute (State "10")
        wait for c_clk_period; -- reg_wr_en='1', ula_chave="00", sel_mux_ula_b='1', sel_mux_reg_wr='1'

        -- ADD R2, R1, R1 at PC=2
        s_pc_atual_in <= to_unsigned(2, 17);
        s_opcode_in   <= "0001"; -- ADD
        -- Fetch 
        wait for c_clk_period; -- ir_wr_en = '1'
        -- Decode
        wait for c_clk_period; -- pc_wr_en = '1', pc_in = 3
        -- Execute
        wait for c_clk_period; -- reg_wr_en='1', ula_chave="00", sel_mux_ula_b='0', sel_mux_reg_wr='0'

        -- Jump 20
        s_pc_atual_in <= to_unsigned(3, 17);
        s_opcode_in   <= "1111"; -- jump
        s_const_13bit_in <= "0000000010100"; -- endereco
        -- Fetch 
        wait for c_clk_period; -- ir_wr_en = '1'
        -- Decode
        wait for c_clk_period; -- pc_wr_en = '1', pc_in = 20
        -- Execute
        wait for c_clk_period;

        -- NOP at PC=20
        s_pc_atual_in <= to_unsigned(20, 17);
        s_opcode_in   <= "0000"; -- NOP
        -- Fetch
        wait for c_clk_period; -- ir_wr_en = '1'
        -- Decode
        wait for c_clk_period; -- pc_wr_en = '1', pc_in = 21
        -- Execute
        wait for c_clk_period;

        wait;
    end process stim_proc;

end architecture a_uc_tb;
