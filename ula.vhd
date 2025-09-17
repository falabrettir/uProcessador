library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is 
  port(

  a: in unsigned (15 downto 0); --entrada a 
  b: in unsigned (15 downto 0); --entrada b
  chave: in unsigned (1 downto 0); --chave de selecao

  u_output: out unsigned (15 downto 0); --output da ula
  f_zero: out std_logic;
  f_carry: out std_logic  --flags de zero e carry
      );
end entity;

architecture a_ula of ula is
  signal r_s: unsigned (15 downto 0); --resultado da op
  signal r_sub: unsigned (15 downto 0); --resultado da op
  signal r_and: unsigned (15 downto 0); --resultado da op
  signal r_or: unsigned (15 downto 0); --resultado da op
  signal soma_temp: unsigned(16 downto 0);

begin
  soma_temp <= ('0' & a) + ('0' & b); --pro carry
  r_s <= soma_temp (15 down to 0);
  r_sub <= a - b;
  r_and<= a and b;
  r_or <= a or b;

  with chave select
    u_output <= r_s when chave="00" else
         r_sub when chave="01" else
         r_and when chave="10" else --mux
         r_or when chave="11" else
         others => '0' when others;

  f_zero <= '1' when u_output="0000000000000000" else '0';
  f_carry <= soma_temp(16) when chave="00" else --recebe o msb de soma_temp pra saber se teve carry
             '1' when (chave="01" and a < b) else --recebe 1 se teve borrow (a < b)
             '0';

end architecture;
  

