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
                data_in  : in  unsigned(16 downto 0);  
                data_out : out unsigned(16 downto 0)
            );
        end component;
        signal pc_reg, pc_out_s, data_s: unsigned(16 downto 0) := (others => '0');
    
    begin

        pc_out_s <= pc_in;
        
        port_map_protouncontrol: protouncontrol port map (data_in => pc_out_s, data_out => data_s);

        process(clk, rst)
        begin
            if rst = '1' then
                pc_reg <= (others => '0');
            elsif wr_en = '1'  then
                if rising_edge(clk) then
                    pc_reg <= data_s;
                end if;
            end if;
        end process;
        pc_out <= pc_reg;
    end a_pc;