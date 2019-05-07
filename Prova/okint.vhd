

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

use work.fpupack.all;
use work.entities.all;

entity okint is
    Port ( clk : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : in STD_LOGIC;
           reset : in STD_LOGIC;
           ok : in STD_LOGIC_VECTOR (27 downto 0);
           oz : in STD_LOGIC_VECTOR (27 downto 0);
           Gk : in STD_LOGIC_VECTOR (27 downto 0);
           okout : out STD_LOGIC_VECTOR (27 downto 0));
end okint;

architecture Behavioral of okint is
signal outmul : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal rdymul : STD_LOGIC := '0';
signal rdyadd_0 : STD_LOGIC := '0';
signal outadd_0 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal Gkint : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');

begin
    mul1: multiplierfsm_v2 port map(
    reset      => reset,
    clk          => clk,   
    op_a          => Gkint,
    op_b          => ok,
    start_i     => start,
    mul_out   => outmul,
    ready_mul => rdymul);
    
    add0: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '0',   
    op_a       => outmul,
    op_b       => ok,
    start_i    => rdymul,
    addsub_out => outadd_0,
    ready_as   => rdyadd_0);
    
    okout <= outadd_0;

end Behavioral;
