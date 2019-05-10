-- Thiago Gomes de Sousa Bezerra  - 150022638
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

use work.fpupack.all;
use work.entities.all;

entity prova_pcr is
    Port (xir : in STD_LOGIC_VECTOR (26 downto 0);
           xul : in STD_LOGIC_VECTOR (26 downto 0);
           clk : in STD_LOGIC;
           bntD : in STD_LOGIC;
           bntU : in STD_LOGIC;
           start : in STD_LOGIC;
           reset : in STD_LOGIC;
           ready : out STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0));
end prova_pcr;

architecture Behavioral of prova_pcr is

signal outmul3 : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal outmul4 : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal rdymul3 : STD_LOGIC := '0';
signal rdymul4 : STD_LOGIC := '0';
signal rdyadd_3 : STD_LOGIC := '0';
signal rdyadd_4 : STD_LOGIC := '0';
signal rdyadd_5 : STD_LOGIC := '0';
signal rdyG : STD_LOGIC := '0';
signal rdyGo : STD_LOGIC := '0';
signal rdyok : STD_LOGIC := '0';
signal rdyoko : STD_LOGIC := '0';
signal outadd_3 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_4 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_5 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal Gkint : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal Gkprox : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal Gkout : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal okout : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal sokint : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal okfim : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal xfusao : STD_LOGIC_VECTOR (26 downto 0):= (others=>'0');



begin


    u1: Gk port map(
    ok => ok,
    oz => oz,
    start => start,
    reset => reset,
    clk => clk ,
    ready => rdyG,
    Gkint => Gkint);
    
    u2: okint port map(
    ok => ok,
    oz => oz,
    Gk => Gkint,
    start => rdyG,
    reset => reset,
    clk => clk ,
    ready => rdyok,
    okout => sokint);
    
    u3: Gk port map(
    ok => sokint,--okout --okfim por ultimo
    oz => oz,
    start => rdyok, --oko
    reset => reset,
    clk => clk ,
    ready => rdyGo,
    Gkint => Gkout); --gkprox
    
    u4: okint port map(
    ok => sokint,-- okout --por ultimo okfim
    oz => oz,
    Gk => Gkout,--gkprox
    start => rdyGo,
    reset => reset,
    clk => clk ,
    ready => rdyoko,---rdyok
    okout => okout);
    
    add0: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '1',  -- subtração 
    op_a       => xir,
    op_b       => xul,
    start_i    => start,
    addsub_out => outadd_3,
    ready_as   => rdyadd_3);
    
    mul1: multiplierfsm_v2 port map(
    reset      => reset,
    clk          => clk,   
    op_a          => outadd_3,
    op_b          => Gkint, --gkout
    start_i     => rdyG,
    mul_out   => outmul3,
    ready_mul => rdymul3);
    
    mul2: multiplierfsm_v2 port map(
    reset      => reset,
    clk          => clk,   
    op_a          => outadd_3,
    op_b          => Gkout,
    start_i     => rdyGo, --rdygo
    mul_out   => outmul4,
    ready_mul => rdymul4);

    add1: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '0',   
    op_a       => outmul3,
    op_b       => xul,
    start_i    => rdymul3,
    addsub_out => outadd_4,--outadd_4
    ready_as   => rdyadd_4);
    
    add2: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '0',   
    op_a       => outmul4,
    op_b       => xul,
    start_i    => rdymul4,
    addsub_out => outadd_5,--outadd_5
    ready_as   => rdyadd_5);
    
process(clk)
begin
--    if reset='1' then
--       xfusao <= (others=>'0');
--       ready<='0'; 
    if rising_edge(clk) then
        if rdyadd_4='1' then
            ready<='1';
        elsif rdyadd_5='1' then
            ready<='1';
        else 
            ready<='0';
        end if;
    end if;
end process;
 
process(rdyadd_4,rdyadd_5)
begin
    case rdyadd_4 is
        when '0'=> xfusao <= (others=>'0');        
        when '1'=> xfusao <= outadd_4;        
        when others => xfusao <= (others=>'0');        
    end case;
    
    case rdyadd_5 is
        when '0'=> xfusao <= outadd_4;        
        when '1'=> xfusao <= outadd_5;        
        when others => xfusao <= (others=>'0');        
    end case;
end process;        

end Behavioral;
