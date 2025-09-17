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
  f_carry: out std_logic  --flags de zero e carry
      );
end entity;

architecture a_ula of ula is
  signal r_s: std_logic_vector (15 downto 0); --resultado da op
  signal r_sub: std_logic_vector (15 downto 0); --resultado da op
  signal r_and: std_logic_vector (15 downto 0); --resultado da op
  signal r_or: std_logic_vector (15 downto 0); --resultado da op

  signal soma_temp: std_logic_vector(16 downto 0);
  signal temp: std_logic_vector(15 downto 0);

begin
  soma_temp <= std_logic_vector(signed(('0' & a)) + signed(('0' & b))); --pro carry
  r_s <= soma_temp (15 downto 0);
  r_sub <= std_logic_vector(signed(a) - signed(b));
  r_and<= a and b;
  r_or <= a or b;

  temp <= r_s when chave = "00" else
          r_sub when chave = "01" else
          r_and when chave = "10" else --mux
          r_or when chave = "11" else
          (others => '0');

  f_zero <= '1' when temp="0000000000000000" else '0';
  f_carry <= soma_temp(16) when chave="00" else --recebe o msb de soma_temp pra saber se teve carry
             '1' when (chave="01" and a < b) else --recebe 1 se teve borrow (a < b)
             '0';
  u_output <= temp;

end architecture;
  

