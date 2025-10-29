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
 --componentes
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

    component ir is --registrador de instrucoes
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

    component uc is
        port (
            clk           : in  std_logic;                      
            rst           : in  std_logic;                      
        -- ir e pc
            opcode_in     : in  unsigned(3 downto 0);          -- opcode [16:13] 
            pc_atual_in   : in  unsigned(16 downto 0);          -- pc
            const_5bit_in : in  unsigned(4 downto 0);          -- constante [4:0] 
            const_13bit_in: in  unsigned(12 downto 0);         -- endereço [12:0] pro jump 
            reg_src1_in: in std_logic_vector(3 downto 0);
    --saidas
            pc_wr_en_out  : out std_logic;                      -- escrita no PC
            ir_wr_en_out  : out std_logic;                      -- escrita no IR
            reg_wr_en_out : out std_logic;                      -- escrita no banco
            ula_chave_out : out std_logic_vector(1 downto 0);   -- operação da ula
            sel_mux_ula_b_out : out std_logic;                  -- entrada B da ula
            sel_mux_reg_wr_out: out std_logic;                 -- dado a escrever no banco, 0 ula 1 banco
            pc_in_out     : out unsigned(16 downto 0)           -- próximo pc
    );
end component uc;

    signal s_pc_out      : unsigned(16 downto 0); -- PC -> Endereço ROM e PC atual UC
    signal s_rom_out     : unsigned(16 downto 0); -- ROM -> IR
    signal s_ir_out      : unsigned(16 downto 0); -- IR -> fatiador de instrucoes e entradas UC
    signal s_next_pc     : unsigned(16 downto 0); -- UC -> PC prox

    -- instrucao fatiada
    signal s_opcode      : unsigned(3 downto 0);          -- [16:13] -> UC
    signal s_reg_dest    : std_logic_vector(3 downto 0);  -- [12:9]  -> endereco escrita banco
    signal s_reg_src1    : std_logic_vector(3 downto 0);  -- [8:5]   -> endereco leitura 1
    signal s_reg_src2    : std_logic_vector(3 downto 0);  -- [4:1]   -> endereco leitura 2 
    signal s_const_5bit  : unsigned(4 downto 0);          -- [4:0]   -> UC
    signal s_const_13bit : unsigned(12 downto 0);         -- [12:0]  -> UC

    -- dados
    signal s_dados_r1    : unsigned(15 downto 0); -- 1 -> ULA
    signal s_dados_r2    : unsigned(15 downto 0); -- 2 -> MUX B ULA
    signal s_ula_out     : unsigned(15 downto 0); -- ULA -> MUX escrita banco
    signal s_const_16bit : unsigned(15 downto 0); -- 5 bits estendida -> MUX B ULA e MUX banco
    signal s_mux_ula_b   : unsigned(15 downto 0); -- MUX B ULA -> B ULA
    signal s_mux_reg_wr  : unsigned(15 downto 0); -- MUX escrita banco -> escrita banco

    -- controle
    signal s_pc_wr_en    : std_logic; -- UC -> PC wr_en
    signal s_ir_wr_en    : std_logic; -- UC -> IR wr_en
    signal s_reg_wr_en   : std_logic; -- UC -> banco wr_en
    signal s_ula_chave   : std_logic_vector(1 downto 0); -- UC -> ULA Chave
    signal s_sel_mux_ula_b: std_logic; -- UC -> MUX B ULA
    signal s_sel_mux_reg_wr: std_logic; -- UC -> Seletor MUX Escrita Banco

    signal s_f_zero: std_logic;
    signal s_f_carry:std_logic;
begin 
 
-- fatiada na instrucao
  s_opcode <= s_ir_out (16 downto 13);
  s_reg_dest <= std_logic_vector(s_ir_out(12 downto 9));
  s_reg_src1 <= std_logic_vector(s_ir_out(8 downto 5));
  s_reg_src2 <= std_logic_vector(s_ir_out(4 downto 1));
  s_const_5bit <= s_ir_out(4 downto 0);
  s_const_13bit <= s_ir_out (12 downto 0);

  s_const_16bit <=unsigned(resize(signed(s_const_5bit), 16)); --por causa dos negativos em cpl 2 

  s_mux_ula_b <= s_const_16bit when s_sel_mux_ula_b = '1' else 
                 s_dados_r2;

  s_mux_reg_wr <=s_const_16bit when s_sel_mux_reg_wr = '1' else 
                 s_ula_out;

  inst_pc: pc
        port map (
            clk     => clk,
            rst     => rst,
            wr_en   => s_pc_wr_en,
            pc_in   => s_next_pc, -- vem da UC
            pc_out  => s_pc_out   -- vai pra ROM e UC
        );

    inst_rom: rom
        port map (
            clk      => clk,
            endereco => s_pc_out(6 downto 0), -- usa apenas os bits necessários para a ROM atual
            dado     => s_rom_out           -- vai pro IR
        );

    inst_ir: ir
        port map (
            clk     => clk,
            rst     => rst,
            wr_en   => s_ir_wr_en, -- vem da UC
            ir_in   => s_rom_out,  -- vem da ROM
            ir_out  => s_ir_out    -- vai para fatiamento e UC
        );

    inst_banco: banco_9_regs
        port map (
            clk     => clk,
            rst     => rst,
            wr_en   => s_reg_wr_en,            -- vem da UC
            addr_wr => s_reg_dest,             -- vem do IR fatiado
            ra1     => s_reg_src1,             -- vem do IR fatiado
            ra2     => s_reg_src2,             -- vem do IR fatiado
            data_wr => s_mux_reg_wr,           -- vem do MUX de escrita
            data_r1 => s_dados_r1,             -- vai para ULA entrada A
            data_r2 => s_dados_r2              -- vai para MUX B da ULA
        );

    inst_ula: ula
        port map (
            a        => s_dados_r1,    -- vem do Banco (leitura 1)
            b        => s_mux_ula_b,   -- vem do MUX B
            chave    => s_ula_chave,   -- vem da UC
            u_output => s_ula_out,     -- vai para MUX de escrita do Banco
            f_zero   => s_f_zero,      -- flag (não usada ainda, mas conectada)
            f_carry  => s_f_carry      -- flag (não usada ainda, mas conectada)
        );

    inst_uc: uc
        port map (
            clk                => clk,
            rst                => rst,
            opcode_in          => s_opcode,      -- vem do IR fatiado
            pc_atual_in        => s_pc_out,      -- vem do PC
            const_5bit_in      => s_const_5bit,  -- vem do IR fatiado
            const_13bit_in     => s_const_13bit, -- vem do IR fatiado
            pc_wr_en_out       => s_pc_wr_en,    -- vai para PC
            ir_wr_en_out       => s_ir_wr_en,    -- vai para IR
            reg_wr_en_out      => s_reg_wr_en,   -- vai para Banco
            ula_chave_out      => s_ula_chave,   -- vai para ULA
            sel_mux_ula_b_out  => s_sel_mux_ula_b, -- vai para controle do MUX B ULA
            sel_mux_reg_wr_out => s_sel_mux_reg_wr, -- vai para controle do MUX Escrita Banco
            pc_in_out          => s_next_pc,      -- vai para entrada PC
            reg_src1_in => s_reg_src1
        );



end architecture a_processador;
