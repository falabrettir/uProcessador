library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is 
  port(

  a: in unsigned (15 downto 0);
  b: in unsigned (15 downto 0);
  chave: in std_logic_vector (1 downto 0);

  u_output: out unsigned (15 downto 0);
  f_zero: out std_logic; f_carry: out std_logic
      );
end entity;

architecture a_ula of ula is
  signal r_s_ext: unsigned (16 downto 0);
  signal r_s: unsigned (15 downto 0);
  signal r_sub: unsigned (15 downto 0);
  signal r_and: unsigned (15 downto 0);
  signal r_or: unsigned (15 downto 0);

  signal temp: unsigned(15 downto 0);
begin
  r_s_ext <= ('0' & a) + ('0' & b);
  r_s <= r_s_ext(15 downto 0);
  r_sub <= a - b;
  r_and<= a and b;
  r_or <= a or b;

  temp <= r_s when chave = "00" else
          r_sub when chave = "01" else
          r_and when chave = "10" else
          r_or when chave = "11" else
          (others => '0');
          
f_zero <= '1' when temp = "0000000000000000" else '0';
  
  f_carry <= r_s_ext(16) when chave = "00" else
             '1' when chave = "01" and a < b else
             '0';

  u_output <= temp;

end architecture;
