
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

use work.fpupack.all;
use work.entities.all;


entity Gk is
    Port ( ok : in STD_LOGIC_VECTOR (27 downto 0);
           oz : in STD_LOGIC_VECTOR (27 downto 0);
           start : in STD_LOGIC;
           clk : in STD_LOGIC;
           ready : in STD_LOGIC;
           Gkint : out STD_LOGIC_VECTOR (27 downto 0));
end Gk;

architecture Behavioral of Gk is

signal outdiv : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal rdydiv : STD_LOGIC := '0';
signal rdyadd_0 : STD_LOGIC := '0';
signal outadd_0 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');

begin

    add0: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '1',  -- subtração 
    op_a       => ok,
    op_b       => oz,
    start_i    => start,
    addsub_out => outadd_0,
    ready_as   => rdyadd_0);
    
    mul1: multiplierfsm_v2 port map(
    reset      => reset,
    clk          => clk,   
    op_a          => ok,
    op_b          => outadd_0,
    start_i     => rdyadd_0,
    div_out   => outdiv,
    ready_div => rdydiv);

    Gkin <= outdiv;


end Behavioral;
