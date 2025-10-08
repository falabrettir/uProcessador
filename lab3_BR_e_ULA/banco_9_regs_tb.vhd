library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_9_regs_tb is
end entity banco_9_regs_tb;

architecture a_banco_9_regs_tb of banco_9_regs_tb is

    component banco_9_regs
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            wr_en        : in  std_logic;
            addr_wr       : in  std_logic_vector(3 downto 0);
            ra1          : in  std_logic_vector(3 downto 0);
            ra2          : in  std_logic_vector(3 downto 0);
            data_wr      : in  unsigned(15 downto 0);
            data_r1      : out unsigned(15 downto 0);
            data_r2      : out unsigned(15 downto 0)
        );
    end component;

   -- Inputs de teste
   signal clk          : std_logic;
   signal reset          : std_logic;
   signal wr_en        : std_logic;
   signal addr_wr       : std_logic_vector(3 downto 0);
   signal ra1          : std_logic_vector(3 downto 0);
   signal ra2          : std_logic_vector(3 downto 0);
   signal data_wr      : unsigned(15 downto 0);

    -- Outputs
   signal data_r1      : unsigned(15 downto 0);
   signal data_r2      : unsigned(15 downto 0);

   -- Periodo do clock
   constant clk_period : time := 100 ns;
   signal   finished    : std_logic := '0';
   
begin 

    uut: banco_9_regs
        port map (
            clk => clk,
            rst => reset,
            wr_en => wr_en,
            addr_wr => addr_wr,
            ra1 => ra1,
            ra2 => ra2,
            data_wr => data_wr,
            data_r1 => data_r1,
            data_r2 => data_r2
        );

    -- Tempo definido para simulação após reset
    sim_time_process: process
    begin
        wait for 1.5 us; -- Tempo total de simulação
        finished <= '1';
        wait;
    end process;

    -- Gerador de clock
    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process clk_proc;

    -- Casos de teste
    process
    begin        
        -- Inicialização
        wr_en <= '0';
        addr_wr <= (others => '0');
        ra1 <= (others => '0'); -- Inicializa os endereços de leitura (vai gerar lixo na 1 escrita com os valores em reg0)
        ra2 <= (others => '0');
        data_wr <= (others => '0');
        
        -- Ativa o reset
        reset <= '1';
        wait for clk_period*2; -- Espera o reset ser ativado
        reset <= '0';

        wait for clk_period*3; -- Espera o reset ser desativado

        -- Escreve no registrador 0
        wr_en <= '1';
        addr_wr <= "0000"; -- Endereço 0
        data_wr <= "0000000000001010"; -- 10, 0x000A
        wait for clk_period;

        -- Escreve no registrador 1
        addr_wr <= "0001"; -- Endereço 1
        data_wr <= "0000000000010100"; -- 20, 0x0014
        wait for clk_period;

        -- Escreve no registrador 2
        addr_wr <= "0010"; -- Endereço 2
        data_wr <= "0000000000011110"; -- 30, 0x001E
        wait for clk_period;

        -- Escreve no registrador 6
        addr_wr <= "0110"; -- Endereço 6
        data_wr <= "0000000000111111"; -- 63, 0x003F
        wait for clk_period;

        wr_en <= '0'; -- Desabilita escrita

        -- Lê do registrador 0 e 1
        ra1 <= "0000"; -- Lê do registrador 0
        ra2 <= "0001"; -- Lê do registrador 1
        wait for clk_period;

        -- Lê do registrador 1 e 2
        ra1 <= "0001"; -- Lê do registrador 1
        ra2 <= "0010"; -- Lê do registrador 2
        wait for clk_period;

        -- Lê do registrador 1 e 6
        ra1 <= "0000"; -- Lê do registrador 0
        ra2 <= "0110"; -- Lê do registrador 6
        wait for clk_period;

        reset <= '1'; -- Reseta todos os registradores
        wait for clk_period*2;
        reset <= '0'; 
        wait for clk_period;

        ra1 <= "0000"; -- Lê do registrador 0 (deve ser 0 após reset)
        ra2 <= "0110"; -- Lê do registrador 6 (deve ser 0 após reset)
        wait for clk_period;

        -- Acabou a simulação :)
        wait;
    end process;
end architecture;
