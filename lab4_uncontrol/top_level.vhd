library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port (
        clk : in  std_logic;
        rst : in  std_logic
    );
end entity top_level;

architecture a_top_level of top_level is

    --componentes
    component pc is
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            wr_en   : in  std_logic;
            pc_in   : in  unsigned(16 downto 0);
            pc_out  : out unsigned(16 downto 0)
        );
    end component;
    
    component rom is
        port( clk      : in std_logic;
              endereco : in unsigned(6 downto 0);
              dado     : out unsigned(16 downto 0) 
        );
    end component;

    component unidade_de_controle is
        port (
            clk           : in  std_logic;
            rst           : in  std_logic;
            instrucao_in  : in  unsigned(16 downto 0);
            pc_atual_in   : in  unsigned(16 downto 0);
            pc_out        : out unsigned(16 downto 0);
            pc_wr_en_out  : out std_logic
        );
    end component;

    --sinais
    signal pc_addr_s      : unsigned(16 downto 0);
    signal instruction_s  : unsigned(16 downto 0);
    signal next_pc_s      : unsigned(16 downto 0);
    signal pc_write_en_s  : std_logic;

begin

    -- pc
    pc_instance: pc port map (
        clk     => clk,
        rst     => rst,
        wr_en   => pc_write_en_s,
        pc_in   => next_pc_s,
        pc_out  => pc_addr_s
    );

    -- ROM
    rom_instance: rom port map (
        clk      => clk,
        endereco => pc_addr_s(6 downto 0),
        dado     => instruction_s
    );

    -- uc
    uc_instance: unidade_de_controle port map (
        clk           => clk,
        rst           => rst,
        instrucao_in  => instruction_s,
        pc_atual_in   => pc_addr_s,
        pc_out        => next_pc_s,
        pc_wr_en_out  => pc_write_en_s
    );

end architecture a_top_level;
