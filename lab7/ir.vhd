library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- registrador de instrucoes
entity ir is 
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        wr_en   : in  std_logic;
        ir_in   : in  unsigned(16 downto 0); -- próximo
        ir_out  : out unsigned(16 downto 0)  --  atual 
    );
end entity ir; 

architecture a_ir of ir is
    signal ir_reg: unsigned(16 downto 0) := (others => '0');
begin
    -- processo do reg
    process(clk, rst)
    begin
        if rst = '1' then
            ir_reg <= (others => '0');
        elsif wr_en = '1' and rising_edge(clk) then
            -- valor de ir_in
            ir_reg <= ir_in;
        end if;
    end process;

    -- valor armazenado no reg
    ir_out <= ir_reg;
    
end architecture a_ir;
