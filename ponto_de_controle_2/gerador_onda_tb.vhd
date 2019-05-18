
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gerador_onda_tb is
--  Port ( );
end gerador_onda_tb;

architecture Behavioral of gerador_onda_tb is

component gerador_de_onda
    Port (clk : in std_logic;
    reset : in std_logic;
    enable_clk: in std_logic;
    freq : in std_logic_vector(2 downto 0);
    cosseno : out std_logic_vector(15  downto 0);
    seno : out std_logic_vector(15  downto 0));
end component;

signal clk : std_logic :='0';
signal reset : std_logic :='0';
signal enable : std_logic :='0';
signal freq : std_logic_vector(2 downto 0) := "000";
signal cos : std_logic_vector(15  downto 0) := (others=>'0');
signal sen : std_logic_vector(15  downto 0) := (others=>'0');
begin

 u1: gerador_de_onda port map(
    clk=>clk,
    reset=>reset,
    enable_clk=> enable,
    freq=> freq,
    cosseno=> cos,
    seno=> sen);
clk<= not clk after 5 ns; --n
enable <= '0', '1' after 10 ns;
reset<= '0','1' after 15 ns, '0' after 25 ns;
freq <="000", "001" after 20 ns, "010" after 30 ns, "011" after 40 ns, "100" after 50 ns,"101" after 60 ns,"110" after 70 ns;

end Behavioral;
