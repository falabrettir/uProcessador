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
   constant conteudo_rom : mem := (
      -- caso endereco => conteudo
      0  => "00000000000000010", -- 2
      1  => "10000000000000000", -- 32768
      2  => "00000000000000000", -- 0
      3  => "00000000000000000", -- 0
      4  => "10000000000000000", -- 32768
      5  => "00000000000000011", -- 3
      6  => "11100000011000000", -- 57344
      7  => "00000000010000000", -- 32768
      8  => "00000000010000000", -- 32768
      9  => "00000000000000000", -- 0
      10 => "00000000000000000", -- 0
      -- abaixo: casos omissos => (zero em todos os bits)
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