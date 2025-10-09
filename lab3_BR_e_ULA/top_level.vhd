library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is 
  port (
  --controle global
    clk: in std_logic;
    rst: in std_logic;
--controle da ula
    chave: in std_logic_vector(1 downto 0);
--banco de regs 
    wr_en: in std_logic; 
    ra1: in std_logic_vector(3 downto 0);
    ra2: in std_logic_vector(3 downto 0);
    addr_wr: in std_logic_vector(3 downto 0);
--pro caso de addi    
    const: in unsigned (15 downto 0);
    addi_control: in std_logic;
--outputs da ula
    f_zero: out std_logic;
    f_carry: out std_logic

       );
     end entity top_level;
architecture a_top_level of top_level is

component ula is
  port(

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

 signal s_dados_lidos_1: unsigned(15 downto 0);
    signal s_dados_lidos_2: unsigned(15 downto 0);
    signal s_resultado_ula: unsigned(15 downto 0);
    signal s_entrada_b_ula: unsigned(15 downto 0);

begin

    -- lógica do Multiplexador para a segunda entrada da ULA
    -- se addi_control = '1', a ULA recebe a constante. Senão, recebe o dado do registrador.
    s_entrada_b_ula <= const when addi_control = '1' else s_dados_lidos_2;

    
    --banco
    banco_inst: banco_9_regs
        port map (
            clk     => clk,
            rst     => rst,
            wr_en   => wr_en,
            addr_wr => addr_wr,
            ra1     => ra1,
            ra2     => ra2,
            data_wr => s_resultado_ula,  -- volta para a escrita do banco
            data_r1 => s_dados_lidos_1,  -- vai para a ULA
            data_r2 => s_dados_lidos_2   -- vai para o MUX
        );

    -- Instância da ULA
    ula_inst: ula
        port map (
            a        => s_dados_lidos_1,    -- leitura 1 do banco
            b        => s_entrada_b_ula,    -- saída do MUX
            chave    => chave,
            u_output => s_resultado_ula,  -- escrita do banco
            f_zero   => f_zero,
            f_carry  => f_carry
        );

end architecture a_top_level;
