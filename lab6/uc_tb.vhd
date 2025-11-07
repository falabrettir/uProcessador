library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end entity uc_tb;

architecture a_uc_tb of uc_tb is

    component uc is
        port (
            clk           : in  std_logic;
            rst           : in  std_logic;
            opcode_in     : in  unsigned(3 downto 0);
            pc_atual_in   : in  unsigned(16 downto 0);
            const_5bit_in : in  unsigned(4 downto 0);
            const_13bit_in: in  unsigned(12 downto 0);
            reg_src1_in   : in  std_logic_vector (3 downto 0);
            flag_z_in     : in  std_logic; 
            flag_c_in     : in  std_logic;
            pc_wr_en_out  : out std_logic;
            ir_wr_en_out  : out std_logic;
            reg_wr_en_out : out std_logic;
            flags_wr_en_out: out std_logic; 
            ula_chave_out : out std_logic_vector(1 downto 0);
            sel_mux_ula_b_out : out std_logic;
            sel_mux_reg_wr_out: out std_logic;
            pc_in_out     : out unsigned(16 downto 0)
        );
    end component;

    signal s_clk                : std_logic := '0';
    signal s_rst                : std_logic := '0';
    signal s_opcode_in          : unsigned(3 downto 0) := (others => '0');
    signal s_pc_atual_in        : unsigned(16 downto 0) := (others => '0');
    signal s_const_5bit_in      : unsigned(4 downto 0) := (others => '0');
    signal s_const_13bit_in     : unsigned(12 downto 0) := (others => '0');
    signal s_reg_src1_in        : std_logic_vector (3 downto 0) := (others => '0');
    signal s_flag_z_in          : std_logic := '0';
    signal s_flag_c_in          : std_logic := '0'; 
    signal s_pc_wr_en_out       : std_logic;
    signal s_ir_wr_en_out       : std_logic;
    signal s_reg_wr_en_out      : std_logic;
    signal s_flags_wr_en_out    : std_logic;
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
            reg_src1_in        => s_reg_src1_in,
            flag_z_in          => s_flag_z_in,
            flag_c_in          => s_flag_c_in,
            pc_wr_en_out       => s_pc_wr_en_out,
            ir_wr_en_out       => s_ir_wr_en_out,
            reg_wr_en_out      => s_reg_wr_en_out,
            flags_wr_en_out    => s_flags_wr_en_out,
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
        wait for c_clk_period * 30;
        s_finished <= '1';
        wait;
    end process sim_time_proc;

    stim_proc: process
    begin
        wait until s_rst = '0';
        wait for c_clk_period / 4; 

        -- Teste NOP (PC=0) 
        s_pc_atual_in <= to_unsigned(0, 17);
        s_opcode_in   <= "0000";
        wait for c_clk_period * 3; 

        -- ADDI (LD R1, 5)
        s_pc_atual_in <= to_unsigned(1, 17);
        s_opcode_in   <= "1000"; -- ADDI
        s_reg_src1_in <= "0000"; -- R0
        s_const_5bit_in <= "00101"; -- 5
        wait for c_clk_period * 3;

        -- CMPR 
        s_pc_atual_in <= to_unsigned(2, 17);
        s_opcode_in   <= "0011"; -- CMPR
        wait for c_clk_period * 3;

        -- BNE não salta
        s_flag_z_in <= '1'; 
        s_flag_c_in <= '0';
        s_pc_atual_in <= to_unsigned(3, 17);
        s_opcode_in   <= "1100"; -- BNE
        s_const_13bit_in <= "0000000000101"; 
        wait for c_clk_period * 3;
        
        -- BNE salta
        s_flag_z_in <= '0';
        s_flag_c_in <= '0';
        s_pc_atual_in <= to_unsigned(4, 17);
        s_opcode_in   <= "1100"; -- BNE
        s_const_13bit_in <= "0000000000101";
        wait for c_clk_period * 3;

        -- Teste BLO não salta
        s_flag_z_in <= '0';
        s_flag_c_in <= '1';
        s_pc_atual_in <= to_unsigned(10, 17);
        s_opcode_in   <= "1101"; -- BLO 
        s_const_13bit_in <= "1111111111011"; 
        wait for c_clk_period * 3;

        -- BLO salta 
        s_flag_z_in <= '0';
        s_flag_c_in <= '0';
        s_pc_atual_in <= to_unsigned(11, 17);
        s_opcode_in   <= "1101"; -- BLO
        s_const_13bit_in <= "1111111111011"; 
        wait for c_clk_period * 3;

        wait;
    end process stim_proc;

end architecture a_uc_tb;
