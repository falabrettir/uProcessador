library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processador is
  port(
      clk: in std_logic;
      rst: in std_logic
  );
end entity processador;

architecture a_processador of processador is 

    -- === COMPONENTES ===
    component pc is
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            wr_en   : in  std_logic;
            pc_in   : in  unsigned(16 downto 0);
            pc_out  : out unsigned(16 downto 0)
        );
    end component;
    
    component rom is
        port ( 
              clk      : in std_logic;
              endereco : in unsigned(6 downto 0);
              dado     : out unsigned(16 downto 0) 
        );
    end component;

    component ir is
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            wr_en   : in  std_logic;
            ir_in   : in  unsigned(16 downto 0);
            ir_out  : out unsigned(16 downto 0)
        );
    end component;

    component ula is
        port (
           a: in unsigned (15 downto 0);
           b: in unsigned (15 downto 0);
           chave: in std_logic_vector (1 downto 0);
           u_output: out unsigned (15 downto 0);
           f_zero: out std_logic;
           f_carry: out std_logic
        );
    end component;

    component banco_9_regs is  
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            wr_en        : in  std_logic;
            addr_wr      : in  std_logic_vector(3 downto 0);
            ra1          : in  std_logic_vector(3 downto 0);
            ra2          : in  std_logic_vector(3 downto 0);
            data_wr      : in  unsigned(15 downto 0);
            data_r1      : out unsigned(15 downto 0);
            data_r2      : out unsigned(15 downto 0)
        );
    end component;

    -- <<< DECLARAÇÃO DO COMPONENTE UC CORRIGIDA >>>
    component uc is
        port (
            clk           : in  std_logic;                      
            rst           : in  std_logic;             
            opcode_in     : in  unsigned(3 downto 0);
            pc_atual_in   : in  unsigned(16 downto 0);
            const_5bit_in : in  unsigned(4 downto 0);
            const_13bit_in: in  unsigned(12 downto 0);
            reg_src1_in   : in  std_logic_vector(3 downto 0);
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
    end component uc;

    component registrador_flags is 
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            wr_en   : in  std_logic;
            data_zero       : in  std_logic;
            data_carry : in std_logic;
            zero_out: out std_logic;
            carry_out: out std_logic
        );
    end component;

    -- === SINAIS ===
    signal s_pc_out      : unsigned(16 downto 0);
    signal s_rom_out     : unsigned(16 downto 0);
    signal s_ir_out      : unsigned(16 downto 0);
    signal s_next_pc     : unsigned(16 downto 0);

    -- instrucao fatiada
    signal s_opcode      : unsigned(3 downto 0);
    signal s_reg_dest    : std_logic_vector(3 downto 0);
    signal s_reg_src1    : std_logic_vector(3 downto 0);
    signal s_reg_src2    : std_logic_vector(3 downto 0);
    signal s_const_5bit  : unsigned(4 downto 0);
    signal s_const_13bit : unsigned(12 downto 0);

    -- dados
    signal s_dados_r1    : unsigned(15 downto 0);
    signal s_dados_r2    : unsigned(15 downto 0); 
    signal s_ula_out     : unsigned(15 downto 0);
    signal s_const_16bit : unsigned(15 downto 0); 
    signal s_mux_ula_b   : unsigned(15 downto 0);
    signal s_mux_reg_wr  : unsigned(15 downto 0);

    -- controle
    signal s_pc_wr_en    : std_logic;
    signal s_ir_wr_en    : std_logic; 
    signal s_reg_wr_en   : std_logic;
    signal s_ula_chave   : std_logic_vector(1 downto 0);
    signal s_sel_mux_ula_b: std_logic;
    signal s_sel_mux_reg_wr: std_logic;
    
    -- <<< SINAIS DE FLAG (SEM DUPLICADOS) >>>
    signal s_flags_wr_en : std_logic; -- UC -> wr_en do Reg. Flags
    signal s_flag_z_out  : std_logic; -- Reg. Flags -> UC
    signal s_flag_c_out  : std_logic; -- Reg. Flags -> UC

    -- Saídas da ULA para as Flags
    signal s_f_zero      : std_logic;
    signal s_f_carry     : std_logic;

begin 
 
-- fatiada na instrucao
  s_opcode      <= s_ir_out(16 downto 13);
  s_reg_dest    <= std_logic_vector(s_ir_out(12 downto 9));
  s_reg_src1    <= std_logic_vector(s_ir_out(8 downto 5));
  s_reg_src2    <= std_logic_vector(s_ir_out(4 downto 1));
  s_const_5bit  <= s_ir_out(4 downto 0);
  s_const_13bit <= s_ir_out(12 downto 0);

  s_const_16bit <= unsigned(resize(signed(s_const_5bit), 16)); --por causa dos negativos em cpl 2 

  s_mux_ula_b <= s_const_16bit when s_sel_mux_ula_b = '1' else 
                 s_dados_r2;

  s_mux_reg_wr <= s_const_16bit when s_sel_mux_reg_wr = '1' and s_reg_src1 = "0000" else -- Apenas para LD (ADDI R, R0, Imm)
                  s_ula_out; -- Para ADD, SUB, e MOV (ADDI R, R, 0)

  inst_pc: pc
        port map (
            clk     => clk,
            rst     => rst,
            wr_en   => s_pc_wr_en,
            pc_in   => s_next_pc,
            pc_out  => s_pc_out
        );

  inst_rom: rom
        port map (
            clk      => clk,
            endereco => s_pc_out(6 downto 0),
            dado     => s_rom_out
        );

  inst_ir: ir
        port map (
            clk     => clk,
            rst     => rst,
            wr_en   => s_ir_wr_en,
            ir_in   => s_rom_out,
            ir_out  => s_ir_out
        );

  inst_banco: banco_9_regs
        port map (
            clk     => clk,
            rst     => rst,
            wr_en   => s_reg_wr_en,
            addr_wr => s_reg_dest,
            ra1     => s_reg_src1,
            ra2     => s_reg_src2,
            data_wr => s_mux_reg_wr,
            data_r1 => s_dados_r1,
            data_r2 => s_dados_r2
        );

  inst_ula: ula
        port map (
            a        => s_dados_r1,
            b        => s_mux_ula_b,
            chave    => s_ula_chave,
            u_output => s_ula_out,    
            f_zero   => s_f_zero,     
            f_carry  => s_f_carry     
        );

  inst_flags: registrador_flags
        port map(
             clk        => clk,
             rst        => rst, 
             wr_en      => s_flags_wr_en,
             data_zero  => s_f_zero,
             data_carry => s_f_carry,
             zero_out   => s_flag_z_out,
             carry_out  => s_flag_c_out
        );

  -- <<< INSTÂNCIA UC CORRIGIDA >>>
  inst_uc: uc
        port map (
            clk                => clk,
            rst                => rst,
            opcode_in          => s_opcode,
            pc_atual_in        => s_pc_out,
            const_5bit_in      => s_const_5bit,
            const_13bit_in     => s_const_13bit,
            reg_src1_in        => s_reg_src1,
            flag_z_in          => s_flag_z_out,
            flag_c_in          => s_flag_c_out,
            pc_wr_en_out       => s_pc_wr_en,
            ir_wr_en_out       => s_ir_wr_en,
            reg_wr_en_out      => s_reg_wr_en,
            flags_wr_en_out    => s_flags_wr_en,
            ula_chave_out      => s_ula_chave,
            sel_mux_ula_b_out  => s_sel_mux_ula_b, 
            sel_mux_reg_wr_out => s_sel_mux_reg_wr,
            pc_in_out          => s_next_pc
        );

end architecture a_processador;
