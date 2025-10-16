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

   -- Programa de teste com JUMP para verificar o fluxo de controle
   constant conteudo_rom : mem := (
      0  => "00000000000000000", -- NOP
      1  => "00000000000000000", -- NOP
      2  => "11110000000000101", -- JUMP 5  
      3  => "00000000000000000", -- NOP (Nunca será executado)
      4  => "00000000000000000", -- NOP (Nunca será executado)
      5  => "00000000000000000", -- NOP jump
      6  => "11110000000000101", -- JUMP 5 loop
      
      -- O restante da memória contém NOPs (zeros) por padrão
      others => (others=>'0')
   );

begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         dado <= conteudo_rom(to_integer(endereco));
      end if;
   end process;
end architecture;
