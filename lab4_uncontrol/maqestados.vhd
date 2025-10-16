library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maqestados is 
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        data_out      : out std_logic
    );
end entity maqestados; 

    architecture a_maqestados of maqestados is
        signal dado_s : std_logic := '0';
    begin
        process(clk, rst)
        begin
            if rst = '1' then
                dado_s <= '0';
            elsif rising_edge(clk) then
                    dado_s <= not dado_s;
            end if;
        end process;
        data_out <= dado_s;
    end a_maqestados;

