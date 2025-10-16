library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_de_controle is
    port (
        -- entradas
        clk           : in  std_logic;
        rst           : in  std_logic;
        instrucao_in  : in  unsigned(16 downto 0); -- da ROM
        pc_atual_in   : in  unsigned(16 downto 0); -- do PC
        
        -- saídas
        pc_out        : out unsigned(16 downto 0); --  entrada do PC
        pc_wr_en_out  : out std_logic              -- wr_en do PC
    );
end entity unidade_de_controle;

architecture a_unidade_de_controle of unidade_de_controle is

    -- máquina de estados
    component maqestados is
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            data_out : out std_logic
        );
    end component;

    -- sinais
    signal estado_s      : std_logic;
    signal opcode_s      : unsigned(3 downto 0);
    signal endereco_jump_s : unsigned(16 downto 0);
    signal pc_mais_um_s  : unsigned(16 downto 0);
    signal eh_jump_s     : std_logic;

begin

    -- máquina de estados
    fsm_instance: maqestados port map (
        clk      => clk,
        rst      => rst,
        data_out => estado_s
    );

    -- decodifica a instrução
    -- opcode nos 4 bits mais significativos e endereço no restante.
    opcode_s <= instrucao_in(16 downto 13);
    endereco_jump_s(12 downto 0) <= instrucao_in(12 downto 0);
    endereco_jump_s(16 downto 13) <= (others => '0'); -- zera os bits superiores

    -- lógica pra detectar jump
    eh_jump_s <= '1' when opcode_s = "1111" else '0';

    --somador
    pc_mais_um_s <= pc_atual_in + 1;

    -- jump
    pc_out <= endereco_jump_s when eh_jump_s = '1' else
              pc_mais_um_s;

    --wr_en
    pc_wr_en_out <= '1' when estado_s = '1' else '0';

end architecture a_unidade_de_controle;
