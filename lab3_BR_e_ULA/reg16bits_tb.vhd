library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg16bits_tb is
end reg16bits_tb;

architecture a_reg16bits_tb of reg16bits_tb is  
  component reg16bits
    port(
        clk     : in  std_logic;
        rst     : in  std_logic;
        wr_en   : in  std_logic;
        data_in       : in  unsigned(15 downto 0);
        data_out      : out unsigned(15 downto 0)
      );
  end component;
  --inputs
  signal s_clk:     std_logic;
  signal s_rst:     std_logic;
  signal s_wr_en:     std_logic;
  signal s_data_in: unsigned(15 downto 0);
--outputs
  signal s_data_out:    unsigned(15 downto 0);

begin
  --Unidade sob Teste (UUT)
  uut: reg16bits port map(

  clk => s_clk,
  rst => s_rst,
  wr_en => s_wr_en,
  data_in => s_data_in,

  data_out => s_data_out
); 

process
  clk <= '0';
    wait for 50 ns;
  clk <= '1';
    wait for 50 ns;
end process
process
  rst <= '1'
    wait for 50 ns;
  rst <= '0'
    wait for 1 ns;
  
  s_data_in <= x"AAAA";
  s_wr_en <= '1';
    wait for 100 ns;

  s_wr_en <= '0';
  s_data_in <= x"BBBB";
    wait for 100 ns;
  s_data_in <=x"CCCC";
  s_wr_en <= '1';
  wait for 100 ns;
wait
end process;
