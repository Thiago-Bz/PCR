
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity gerador_de_onda is
    Port (clk : in std_logic;
        reset : in std_logic;
        enable_clk: in std_logic;
        freq : in std_logic_vector(2 downto 0);
        cosseno : out std_logic_vector(15 downto 0);
        seno : out std_logic_vector(15 downto 0));
end gerador_de_onda;

architecture Behavioral of gerador_de_onda is

signal enb : std_logic :='0';
signal seno_real : signed(15 downto 0); -- signed vçores vão de -7 a 7
signal seno_im : signed(15 downto 0); -- signed vçores vão de -7 a 7
signal addres_cont : unsigned(3 downto 0);
signal sum_freq : integer; -- := 0;

begin
 enb <= enable_clk;
 
 -- processo para definição de frequencia
 process(freq)
 begin
    case freq is
        when "000" => sum_freq <= 1;
        when "001" => sum_freq <= 2;
        when "010" => sum_freq <= 3;
        when "011" => sum_freq <= 4;
        when "100" => sum_freq <= 5;
        when "101" => sum_freq <= 6;
        when "110" => sum_freq <= 7;
        when others => sum_freq <= 8;
    end case;
 end process;
 
 -- contador
 process(clk,reset)
 begin
    if reset='1' then
        addres_cont<= to_unsigned(0,4);
    elsif rising_edge(clk) then
        if enb='1' then
            if addres_cont= to_unsigned(9,4) then
                addres_cont <= to_unsigned(0,4);
            else
                addres_cont <= addres_cont + sum_freq;
            end if;
        end if;
    end if;
 end process;

--- processo para a saida do gerador de onda, real e im
process(addres_cont)
begin
    case addres_cont is
        when "0000"=> seno_real  <= "0100000000000000";
        when "0001"=> seno_real  <= "0011001111000111";
        when "0010"=> seno_real  <= "0001001111000111";
        when "0011"=> seno_real  <= "1110110000111001";
        when "0100"=> seno_real  <= "1100110000111001";
        when "0101"=> seno_real  <= "1100000000000000";
        when "0110"=> seno_real  <= "1100110000111001";
        when "0111"=> seno_real  <= "1110110000111001";
        when "1000"=> seno_real  <= "0001001111000111";
        when "1001"=> seno_real  <= "0011001111000111";
        when others => seno_real <= "0011001111000111";
    end case;

cosseno <= std_logic_vector(seno_real);
end process;

process(addres_cont)
begin
    case addres_cont is
        when "0000" =>   seno_im    <= "0000000000000000";
        when "0001" =>   seno_im    <= "0010010110011110";
        when "0010" =>   seno_im    <= "0011110011011110";
        when "0011" =>   seno_im    <= "0011110011011110";
        when "0100" =>   seno_im    <= "0010010110011110";
        when "0101" =>   seno_im    <= "0000000000000000";
        when "0110" =>   seno_im    <= "1101101001100010";
        when "0111" =>   seno_im    <= "1100001100100010";
        when "1000" =>   seno_im    <= "1100001100100010";
        when "1001" =>   seno_im    <= "1101101001100010";
        when others =>   seno_im    <= "1101101001100010";
    end case;

seno <= std_logic_vector(seno_im);
end process;

end Behavioral;
