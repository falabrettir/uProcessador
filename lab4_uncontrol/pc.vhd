library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is 
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        wr_en   : in  std_logic;
        pc_in   : in  unsigned(16 downto 0);
        pc_out  : out unsigned(16 downto 0)
    );
end entity pc; 

    architecture a_pc of pc is
        component protouncontrol
            port(
                data_in  : in  std_logic_vector(16 downto 0);  
                data_out : out std_logic_vector(16 downto 0)
            );
        end component;
        signal pc_reg, data_s: unsigned(16 downto 0) := (others => '0');
    
    begin
        process(clk, rst)
        begin
            if rst = '1' then
                pc_reg <= (others => '0');
            elsif wr_en = '1'  then
                if rising_edge(clk) then
                    pc_reg <= pc_in;
                    data_s <= pc_out;
                end if;
            end if;
        end process;
        pc_out <= pc_reg;
        data_out <= data_s;
    end a_pc;