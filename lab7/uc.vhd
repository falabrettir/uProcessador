library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port (
        clk           : in  std_logic;                      
        rst           : in  std_logic;                      
    -- ir e pc
        opcode_in     : in  unsigned(3 downto 0);          -- opcode [16:13] 
        pc_atual_in   : in  unsigned(16 downto 0);          -- pc
        const_5bit_in : in  unsigned(4 downto 0);          -- constante [4:0] 
        const_13bit_in: in  unsigned(12 downto 0);         -- endereço [12:0] pro jump 
        reg_src1_in: in std_logic_vector (3 downto 0);
        flag_z_in : in std_logic; 
        flag_c_in: in std_logic;
--saidas
        pc_wr_en_out  : out std_logic;                      -- escrita no PC
        ir_wr_en_out  : out std_logic;                      -- escrita no IR
        reg_wr_en_out : out std_logic;                      -- escrita no banco
        ula_chave_out : out std_logic_vector(1 downto 0);   -- operação da ula
        sel_mux_ula_b_out : out std_logic;                  -- entrada B da ula
        sel_mux_reg_wr_out: out std_logic_vector(1 downto 0);-- dado a escrever no banco, 0 ula 1 banco 2 ram
        ram_wr_en_out : out std_logic;                      -- escrita na RAM
        flags_wr_en_out: out std_logic;
        pc_in_out     : out unsigned(16 downto 0)           -- próximo pc
    );
end entity uc;

architecture a_uc of uc is

  component maq_estados is
    port ( 
        clk,rst: in std_logic;
        estado: out unsigned(1 downto 0)
    );
  end component;

 signal s_pc_offset_ext : unsigned(16 downto 0); 
 signal s_estado_atual: unsigned(1 downto 0);

begin

state_instance: maq_estados
  port map (
          clk => clk,
          rst => rst,
          estado => s_estado_atual
    );

  s_pc_offset_ext <= unsigned(resize(signed(const_13bit_in), 17));

  ir_wr_en_out <= '1' when s_estado_atual = "01" else '0'; --fetch

  pc_wr_en_out <= '1' when s_estado_atual = "10" else '0'; --decode

pc_in_out <= ("0000" & const_13bit_in) when (s_estado_atual = "10" and opcode_in = "1111") else 
             (pc_atual_in + 1 + s_pc_offset_ext) when (s_estado_atual = "10" and opcode_in = "1100" and flag_z_in = '0') else 
             (pc_atual_in + 1 + s_pc_offset_ext) when (s_estado_atual = "10" and opcode_in = "1101" and flag_c_in = '1') else 
             (pc_atual_in + 1) when (s_estado_atual = "10") else 
             pc_atual_in;

flags_wr_en_out <= '1' when (s_estado_atual = "10" and (opcode_in = "0011" or 
                     opcode_in = "0001" or opcode_in = "0010"))  
                   '0';

  --controle do banco
  reg_wr_en_out <= '1' when (s_estado_atual = "10") and
                   (opcode_in = "0001" or --add 
                    opcode_in = "0010" or --sub 
                    opcode_in = "1000" or --addi
                    opcode_in = "1001" or --subi
                    opcode_in = "0111")   --lw 
                  else '0';
    
    --controle da ula 
ula_chave_out <= "00" when (s_estado_atual = "10") and (opcode_in = "0001" or opcode_in = "1000") else --add e addi 
                 "01" when (s_estado_atual = "10") and (opcode_in = "0010" or -- sub
                  opcode_in = "1001" or -- subi 
                  opcode_in = "0011") else 
                  "00"; -- nop, jump etc
                   
    --mux da ula
    sel_mux_ula_b_out <= '1' when (s_estado_atual = "10") and 
                         (opcode_in = "1000" or -- addi
                         opcode_in = "1001") -- subi
                       else '0'; --por padrao pega do registrador
    -- controle da ram
    ram_wr_en_out <= '1' when (s_estado_atual = "10" and opcode_in = "1011") -- sw
                       else '0';

    --mux do banco 
      sel_mux_reg_wr_out <= "01" when (s_estado_atual = "10" and -- Constante 
                                   opcode_in = "1000" and 
                                   reg_src1_in = "0000") else
                        "10" when (s_estado_atual = "10" and -- Dado da RAM (lw)
                                   opcode_in = "0111") else
                        "00"; -- Padrão: saida da ula

end architecture a_uc;
