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

end architecture a_processador;
