library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
   port( clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado     : out unsigned(16 downto 0)
   );
end entity;

architecture a_rom of rom is

   type mem is array (0 to 127) of unsigned(16 downto 0);
   -- ISA:
   -- NOP:  0000_XXXX_XXXX_XXXX_X
   -- ADD:  0001_DEST_SRC1_SRC2_X
   -- SUB:  0010_DEST_SRC1_SRC2_X
   -- ADDI: 1000_DEST_SRC1_IMM5   (Usado para LD R, Imm e MOV R, R)
   -- SUBI: 1001_DEST_SRC1_IMM5
   -- JMP:  1111_ADDR13
   -- CMPR: 0011_XXXX_SRC1_SRC2_0 
   -- BLO:  1101_ADDR13 
   -- BNE:  1100_ADDR13
   
   -- Programa de Teste da RAM (lw/sw)
    -- Opcodes: ADDI(1000), sw(1011), lw(0111), JMP(1111)
    -- Formato LD: 1000 | R_Dest | R0 (0000) | Imm5
    -- Formato sw: 1011 | R_Data | R_Addr | XXXXX
    -- Formato lw: 0111 | R_Dest | R_Addr | XXXXX
   constant conteudo_rom : mem := (
      
        -- Carregar valores nos registradores 
        -- Formato: ADDI Rt, Imm5  (1000 | Rt | R0 | Imm5)
        0  => "10000001000000101", -- ADDI R1, 5   (Dado A)
        1  => "10000010000000010", -- ADDI R2, 2   (Endereço A)
        2  => "10000011000000111", -- ADDI R3, 7   (Dado B)
        3  => "10000100000000101", -- ADDI R4, 5   (Endereço B)
        4  => "10000101000001100", -- ADDI R5, 12  (Dado C)
        5  => "10000110000001001", -- ADDI R6, 9   (Endereço C)
        6  => "10000111000001111", -- ADDI R7, 15  (Dado D)
        7  => "10001000000001100", -- ADDI R8, 12  (Endereço D)

        -- Múltiplas escritas na RAM
        -- Formato: sw Rt, (Rs) (1011 | Rt(dado) | Rs(addr) | XXXXX)
        8  => "10110001001000000", -- sw R1, (R2)  (Escreve 5 no endereço 2)
        9  => "10110011010000000", -- sw R3, (R4)  (Escreve 7 no endereço 5)
        10 => "10110101011000000", -- sw R5, (R6)  (Escreve 12 no endereço 9)
        11 => "10110111100000000", -- sw R7, (R8)  (Escreve 15 no endereço 12)

        -- Limpar registradores de dados
        -- (Garante que a leitura da RAM é a nova fonte)
        12 => "10000001000000000", -- ADDI R1, 0  
        13 => "10000011000000000", -- ADDI R3, 0  
        14 => "10000101000000000", -- ADDI R5, 0  
        15 => "10000111000000000", -- ADDI R7, 0

        -- Ler da RAM para os registradores
        -- Formato: lw Rt, (Rs) (0111 | Rt(dest) | Rs(addr) | XXXXX)
        16 => "01110001001000000", -- lw R1, (R2)  (Lê do end 2 -> R1 deve ser 5)
        17 => "01110011010000000", -- lw R3, (R4)  (Lê do end 5 -> R3 deve ser 7)
        18 => "01110101011000000", -- lw R5, (R6)  (Lê do end 9 -> R5 deve ser 12)
        19 => "01110111100000000", -- lw R7, (R8)  (Lê do end 12 -> R7 deve ser 15)

      20 => "11110000000000000", -- JMP 0         (Loop infinito, sugestão de fim de programa)
      
      --NOP
      others => (others=>'0')
   );
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         dado <= conteudo_rom(to_integer(endereco));
      end if;
   end process;
end architecture a_rom;
