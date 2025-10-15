library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is 
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        wr_en   : in  std_logic;
        data_in       : in  unsigned(16 downto 0);
        data_out  : out unsigned(16 downto 0)
    );
end entity pc; 

    architecture a_pc of pc is
        signal pc_reg : unsigned(16 downto 0) := (others => '0');
    begin
        process(clk, rst)
        begin
            if rst = '1' then
                pc_reg <= (others => '0');
            elsif wr_en = '1'  then
                if and rising_edge(clk) then
                    pc_reg <= data_in;
                end if;
            end if;
        end process;
        data_out <= pc_reg;
    end a_pc;