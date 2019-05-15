library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registrador is
    Port ( clk_10Hz : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable: in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0));
end registrador;

architecture Behavioral of registrador is

--signal clk_10Hz 	: std_logic := '0';
--signal enable 		: std_logic := '0';
signal lr 			: std_logic := '1';
signal player 		: std_logic := '0';
signal reg 			: std_logic_vector(15 downto 0) := (others=>'0');

begin

process(clk_10Hz,reset)
	begin
		if reset='1' then
			reg <= "0000000000000001";
		elsif rising_edge(clk_10Hz) then
            if enable = '1' then
                if lr = '0' then
                    reg <= '0' & reg(15 downto 1); 
                else
                    reg <= reg(14 downto 0) & '0';
                end if;
            elsif player = '0' then
                reg <= "0000000000000001";
            elsif player = '1' then
                reg <= "1000000000000000";
            else
                null;
			end if;
		end if;
	end process;
	led <= reg;

end Behavioral;
