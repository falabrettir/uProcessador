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



end architecture a_processador;
