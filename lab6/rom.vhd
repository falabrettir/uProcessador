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
   
-- ADDI R3, R0, 0  "1000_0011_0000_00000"--
-- ADDI R4, R0, 0  "1000_0100_0000_00000"--
-- ADD R4, R3, R4  "0001_0100_0011_0100_0"--
-- ADDI R3, R3, 1  "1000_0011_0011_00001"--
-- ADDI R2, R0, 30 "1000_0010_0000_11110"
-- CMPR RX, R3, R2 "0011_0000_0011_0010_0"
-- BLO R3, -4      "1101_1111111111110" --VOLTA PRA INSTRUCAO "C"
-- ADD R5, R4, R0  "0001_0101_0100_0000_0"

-- A. Carrega R3 (o registrador 3) com o valor 0
-- B. Carrega R4 com 0
-- C. Soma R3 com R4 e guarda em R4
-- D. Soma 1 em R3
-- E. Se R3<30 salta para a instrução do passo C * 
-- F. Copia valor de R4 para R5
   constant conteudo_rom : mem := (
      -- ADDI R3, R0, 0
      -- Opcode=1000, Dest=R3(0011), Src1=R0(0000), Imm5=0(00000)
      0  => "10000011000000000",

      -- ADDI R4, R0, 0
      -- Opcode=1000, Dest=R4(0100), Src1=R0(0000), Imm5=0(00000)
      1  => "10000100000000000",

      -- ADD R4, R3
      -- Opcode=0001, DestSRC=R4(0100), Src2=R3(0011), X=0
      2  => "00010100001100000", 

      -- ADDI R3, R3, 1
      -- Opcode=1000, Dest=R3(0011), Src1=R3(0011), Imm5=1(00001)
      3  => "10000011001100001",

      -- ADDI R2, R0, 30
      -- Opcode=1000, Dest=R2(0010), Src1=R0(0000), Imm5=30(11110)
      4  => "10000010000011110",

      -- CMPR R0, R3, R2
      -- Opcode=0011, Dest=R0(0000), Src1=R3(0011), Src2=R2(0010), X=0
      5  => "00110011001000000",

      -- BLO R3, -4
      -- Opcode=1101, Addr13=-4(1111111111100)
      6  => "11011111111111011",
      -- ADD R5, R4
      -- Opcode=0001, DestSRC=R5(0101), Src1=R4(0100), X=0
      7 => "10000101010000000",

      8 => "11110000000001000",

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
