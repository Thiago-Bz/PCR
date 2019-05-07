
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

use work.fpupack.all;
use work.entities.all;

entity prova_pcr is
    Port (xir : in STD_LOGIC_VECTOR (27 downto 0);
           xul : in STD_LOGIC_VECTOR (27 downto 0);
           clk : in STD_LOGIC;
           start : in STD_LOGIC;
           reset : in STD_LOGIC;
           ready : out STD_LOGIC;
           xfusao : out STD_LOGIC_VECTOR (27 downto 0));
end prova_pcr;

architecture Behavioral of prova_pcr is

signal outmul : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal rdymul : STD_LOGIC := '0';
signal rdyadd_0 : STD_LOGIC := '0';
signal rdyadd_1 : STD_LOGIC := '0';
signal rdyG : STD_LOGIC := '0';
signal rdyok : STD_LOGIC := '0';
signal outadd_0 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_1 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal Gkint : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');

component Gk is
    Port ( ok : in STD_LOGIC_VECTOR (27 downto 0);
       oz : in STD_LOGIC_VECTOR (27 downto 0);
       start : in STD_LOGIC;
       clk : in STD_LOGIC;
       ready : in STD_LOGIC;
       Gkint : out STD_LOGIC_VECTOR (27 downto 0));
end component;

component okint is
    Port ( clk : in STD_LOGIC;
       start : in STD_LOGIC;
       ready : in STD_LOGIC;
       ok : in STD_LOGIC_VECTOR (27 downto 0);
       oz : in STD_LOGIC_VECTOR (27 downto 0);
       Gk : in STD_LOGIC_VECTOR (27 downto 0));
       okint : out STD_LOGIC_VECTOR (27 downto 0));
end component;


begin

    u1: Gk port map(
    ok => ok,
    oz => oz,
    start => start,
    clk => clk ,
    ready => rdyG,
    Gkint => Gkint);
    
    u1: okint port map(
    ok => ok,
    oz => oz,
    Gk => Gkint,
    start => start,
    clk => clk ,
    ready => rdyok,
    okint => okint);
    
    add0: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '1',  -- subtração 
    op_a       => xir,
    op_b       => xul,
    start_i    => start,
    addsub_out => outadd_0,
    ready_as   => rdyadd_0);
    
    mul1: multiplierfsm_v2 port map(
    reset      => reset,
    clk          => clk,   
    op_a          => outadd_0,
    op_b          => Gkint,
    start_i     => rdyadd_0,
    mul_out   => outmul,
    ready_mul => rdymul);

    add1: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '0',   
    op_a       => outmul,
    op_b       => xul,
    start_i    => rdymul,
    addsub_out => outadd_1,
    ready_as   => rdyadd_1);
             
    xfusao <= outadd_1;

end Behavioral;
