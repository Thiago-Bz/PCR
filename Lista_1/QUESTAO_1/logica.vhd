library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity logica is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           creg : in std_logic_vector(15 downto 0) := (others=>'0');
           sw0 : in STD_LOGIC;
           sw15 : in STD_LOGIC;
           ccnt0 : out STD_LOGIC_VECTOR (3 downto 0);
           ccnt1 : out STD_LOGIC_VECTOR (3 downto 0);
           cenable : out STD_LOGIC := '0';
           clr : out STD_LOGIC := '1';
           cplayer : out STD_LOGIC := '0');
           
end logica;

architecture Behavioral of logica is

signal enable 		: std_logic := '0';
signal lr 			: std_logic := '1';
signal player 		: std_logic := '0';
signal reg 			: std_logic_vector(15 downto 0) := (others=>'0');
signal cnt0 		: std_logic_vector(3 downto 0) := "0000";
signal cnt1 		: std_logic_vector(3 downto 0) := "0000";

begin

process(clk,reset)
	begin
		if reset = '1' then
			cnt0 <= "0000";
			cnt1 <= "0000";
			lr <= '1';
			enable <= '0'; -- deshabilita o deslocamento
			player <= '0';
		elsif rising_edge(clk) then
			if cnt0 = "1001" or cnt1 = "1001" then
				lr <= '1'; -- desloca à esquerda
				enable <= '1'; -- habilita o deslocamento
				player <= '0'; -- player 0 começa
				cnt0 <= "0000";
				cnt1 <= "0000";
			elsif reg="0000000000000001" and sw0 = '1' then
				lr <= '1'; -- desloca à esquerda
				enable <= '1'; -- habilita o deslocamento
			elsif reg="0000000000000001" and sw0 = '0' then
				lr <= '0'; -- desloca à direita
				enable <= '0'; -- deshabilita o deslocamento
				player <= '1'; -- player 1 joga
				cnt1 <= cnt1 + 1; -- incrementa placar player 1
			elsif reg="1000000000000000" and sw15 = '1' then
				lr <= '0'; -- desloca à direita
				enable <= '1'; -- habilita o deslocamento
			elsif reg="1000000000000000" and sw15 = '0' then
				lr <= '1'; -- desloca à esquerda
				enable <= '0'; -- deshabilita o deslocamento	
				player <= '0'; -- player 0 joga
				cnt0 <= cnt0 + 1;	-- incrementa placar player 0	
			end if;		
		end if;
	end process;

end Behavioral;
