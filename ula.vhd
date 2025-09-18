library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is 
  port(

  a: in std_logic_vector (15 downto 0); --entrada a 
  b: in std_logic_vector (15 downto 0); --entrada b
  chave: in std_logic_vector (1 downto 0); --chave de selecao

  u_output: out std_logic_vector (15 downto 0); --output da ula
  f_zero: out std_logic;
  f_overflow: out std_logic  --flags de zero e overflow
      );
end entity;

architecture a_ula of ula is
  signal r_s: std_logic_vector (15 downto 0); --resultado da op
  signal r_sub: std_logic_vector (15 downto 0); --resultado da op
  signal r_and: std_logic_vector (15 downto 0); --resultado da op
  signal r_or: std_logic_vector (15 downto 0); --resultado da op

  signal temp: std_logic_vector(15 downto 0);

begin
  r_s <= std_logic_vector(signed(a) + signed(b));
  r_sub <= std_logic_vector(signed(a) - signed(b));
  r_and<= a and b;
  r_or <= a or b;

  temp <= r_s when chave = "00" else
          r_sub when chave = "01" else
          r_and when chave = "10" else --mux
          r_or when chave = "11" else
          (others => '0');

  f_zero <= '1' when temp="0000000000000000" else '0';
 f_overflow <= '1' when (chave = "00" and a(15) = b(15) and r_s(15) /= a(15)) else   -- Overflow da Soma
                '1' when (chave = "01" and a(15) /= b(15) and r_sub(15) /= a(15)) else   -- Overflow da Subtração
                '0'; -- Para todas as outras operações
  u_output <= temp;

end architecture;
  

