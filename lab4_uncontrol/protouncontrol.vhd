library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   

entity protouncontrol is 
    port(
        data_in  : in  unsigned(16 downto 0);  
        data_out : out unsigned(16 downto 0)
    )
end entity protouncontrol;

architecture a_protouncontrol of protouncontrol is

    data_out <= data_in + "00000000000000001";

end architecture a_protouncontrol;