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
  signal s_clk: in std_logic;
  signal s_rst: in std_logic;
  signal wr_en: in std_logic;
  signal s_data_in: in unsigned(15 downto 0);

  signal s_data_out: out unsigned(15 downto 0); 
