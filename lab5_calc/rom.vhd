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
   
   constant conteudo_rom : mem := (
      -- ADDI R3, R0, 5
      -- Opcode=1000, Dest=R3(0011), Src1=R0(0000), Imm5=5(00101)
      0  => "10000011000000101",
      
      -- ADDI R4, R0, 8
      -- Opcode=1000, Dest=R4(0100), Src1=R0(0000), Imm5=8(01000)
      1  => "10000100000001000",
      
      -- ADD R5, R3, R4
      -- Opcode=0001, Dest=R5(0101), Src1=R3(0011), Src2=R4(0100), X=0
      2  => "00010101001101000", --
      
      -- SUBI R5, R5, 1
      -- Opcode=1001, Dest=R5(0101), Src1=R5(0101), Imm5=1(00001)
      3  => "10010101010100001",
      
      -- JUMP 20
      -- Opcode=1111, Addr13=20(000000010100)
      4  => "11110000000010100",
      
      -- NOP
      5  => "00000000000000000",
      
      -- NOP
      6 to 19 => (others => '0'),
      
      -- MOV R3, R5 -> ADDI R3, R5, 0
      -- Opcode=1000, Dest=R3(0011), Src1=R5(0101), Imm5=0(00000)
      20 => "10000011010100000",
      
      -- JUMP 2
      -- Opcode=1111, Addr13=2(0000000000010)
      21 => "11110000000000010",
      
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
