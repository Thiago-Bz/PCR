library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity somador is
    Port ( a : in STD_LOGIC_VECTOR (16 downto 0);
           b : in STD_LOGIC_VECTOR (16 downto 0);
           saida : out STD_LOGIC_VECTOR (16 downto 0));
end somador;

architecture Behavioral of somador is

begin

saida <= a + b;

end Behavioral;
