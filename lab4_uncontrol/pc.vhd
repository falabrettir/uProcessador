library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is 
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        wr_en   : in  std_logic;
        pc_in   : in  unsigned(16 downto 0); -- próximo
        pc_out  : out unsigned(16 downto 0)  --  atual 
    );
end entity pc; 

architecture a_pc of pc is
    signal pc_reg: unsigned(16 downto 0) := (others => '0');
begin
    -- processo do reg
    process(clk, rst)
    begin
        if rst = '1' then
            pc_reg <= (others => '0');
        elsif wr_en = '1' and rising_edge(clk) then
            -- valor de pc_in
            pc_reg <= pc_in;
        end if;
    end process;

    -- valor armazenado no reg
    pc_out <= pc_reg;
    
end architecture a_pc;
