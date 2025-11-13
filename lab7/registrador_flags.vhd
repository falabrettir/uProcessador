library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_flags is 
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        wr_en   : in  std_logic;
        data_zero       : in  std_logic;
        data_carry : in std_logic;

        zero_out: out std_logic;
        carry_out: out std_logic
    );
end entity registrador_flags; 

architecture a_registrador_flags of registrador_flags is
    signal s_zero_reg  : std_logic;
    signal s_carry_reg : std_logic;
begin
    
    process(clk, rst)
    begin
        if rst = '1' then
            s_zero_reg  <= '0';
            s_carry_reg <= '0';
        elsif rising_edge(clk) then
            if wr_en = '1' then
                s_zero_reg  <= data_zero;
                s_carry_reg <= data_carry;
            end if;
        end if;
    end process;

    zero_out  <= s_zero_reg;
    carry_out <= s_carry_reg;

end architecture a_registrador_flags;

