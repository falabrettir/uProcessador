library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_9_regs is 
    port (
        clk          : in  std_logic;    -- Sinal de clock
        rst          : in  std_logic;    -- Sinal de reset
        wr_en        : in  std_logic; -- Sinal de escrita
        addr_wr       : in  std_logic_vector(3 downto 0); -- Endereço de escrita
        ra1          : in  std_logic_vector(3 downto 0); -- Endereço do registrador de leitura 1
        ra2          : in  std_logic_vector(3 downto 0); -- Endereço do registrador de leitura 2
        data_wr      : in  unsigned(15 downto 0); -- Dados a serem escritos
        data_r1      : out unsigned(15 downto 0); -- Dados lidos do registrador 1
        data_r2      : out unsigned(15 downto 0)  -- Dados lidos do registrador 2
    );
end entity banco_9_regs;

architecture a_banco_9_regs of banco_9_regs is
    component reg16bits
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            wr_en   : in  std_logic;
            data_in : in  unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;
    signal reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9 : unsigned(15 downto 0);
    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7, wr_en8 : std_logic;

    begin
        -- Decodificação do endereço de escrita
        wr_en0 <= wr_en when addr_wr = "0000" else '0';
        wr_en1 <= wr_en when addr_wr = "0001" else '0';
        wr_en2 <= wr_en when addr_wr = "0010" else '0';
        wr_en3 <= wr_en when addr_wr = "0011" else '0';
        wr_en4 <= wr_en when addr_wr = "0100" else '0';
        wr_en5 <= wr_en when addr_wr = "0101" else '0';
        wr_en6 <= wr_en when addr_wr = "0110" else '0';
        wr_en7 <= wr_en when addr_wr = "0111" else '0';
        wr_en8 <= wr_en when addr_wr = "1000" else '0';

        -- Lógica de leitura
        port_map_reg1: reg16bits port map (clk=>clk, rst=>rst, wr_en => wr_en0, data_in => data_wr, data_out => reg1);
        port_map_reg2: reg16bits port map (clk=>clk, rst=>rst, wr_en => wr_en1, data_in => data_wr, data_out => reg2);
        port_map_reg3: reg16bits port map (clk=>clk, rst=>rst, wr_en => wr_en2, data_in => data_wr, data_out => reg3);
        port_map_reg4: reg16bits port map (clk=>clk, rst=>rst, wr_en => wr_en3, data_in => data_wr, data_out => reg4);
        port_map_reg5: reg16bits port map (clk=>clk, rst=>rst, wr_en => wr_en4, data_in => data_wr, data_out => reg5);
        port_map_reg6: reg16bits port map (clk=>clk, rst=>rst, wr_en => wr_en5, data_in => data_wr, data_out => reg6);
        port_map_reg7: reg16bits port map (clk=>clk, rst=>rst, wr_en => wr_en6, data_in => data_wr, data_out => reg7);
        port_map_reg8: reg16bits port map (clk=>clk, rst=>rst, wr_en => wr_en7, data_in => data_wr, data_out => reg8);
        port_map_reg9: reg16bits port map (clk=>clk, rst=>rst, wr_en => wr_en8, data_in => data_wr, data_out => reg9);

        -- Multiplexadores para leitura
        with ra1 select
            data_r1 <= reg1 when "0000",
                       reg2 when "0001",
                       reg3 when "0010",
                       reg4 when "0011",
                       reg5 when "0100",
                       reg6 when "0101",
                       reg7 when "0110",
                       reg8 when "0111",
                       reg9 when "1000",
                       (others => '0') when others; -- Saída padrão (0x00) para endereços inválidos
        with ra2 select
            data_r2 <= reg1 when "0000",
                       reg2 when "0001",
                       reg3 when "0010",
                       reg4 when "0011",
                       reg5 when "0100",
                       reg6 when "0101",
                       reg7 when "0110",
                       reg8 when "0111",
                       reg9 when "1000",
                       (others => '0') when others; -- Saída padrão (0x00) para endereços inválidos
    end architecture;
