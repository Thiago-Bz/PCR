library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display is
    Port ( reset : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           clk_40hz : in STD_LOGIC);
end display;

architecture Behavioral of display is

signal cnt_40Hz 	: integer range 0 to 1250000 := 0;
--signal clk_40Hz 	: std_logic := '0';
signal cnt0 		: std_logic_vector(3 downto 0) := "0000";
signal cnt1 		: std_logic_vector(3 downto 0) := "0000";
signal s_an 		: unsigned(3 downto 0) := "0000";
signal sel_mux  	: std_logic_vector(1 downto 0):="00";
signal s_bin 		: std_logic_vector(3 downto 0) := "0000";

begin

-- process para multiplexar anodos
	process(clk_40Hz,reset)
	begin
		if reset='1' then
			s_an <= "1110";
			sel_mux <= "00";
		elsif rising_edge(clk_40Hz) then
			s_an <= s_an srl 1;
			sel_mux <= sel_mux + 1;
		end if;
	end process;
	an <= std_logic_vector(s_an);
	
	-- mux para decodificador
	with sel_mux select
		s_bin <= cnt0 when "00",
					"1111" when "01", 
					"1111" when "10", 
					cnt1 when "11"; 
	
	-- process combinacional para decodificar segmentos
	process(s_bin)
	begin
		case s_bin is
			when "0000" => seg <= "11000000";
			when "0001" => seg <= "11111001";
			when "0010" => seg <= "10100100";
			when "0011" => seg <= "10110000";
			when "0100" => seg <= "10011001";
			when "0101" => seg <= "10010010";
			when "0110" => seg <= "10000010";
			when "0111" => seg <= "11111000";
			when "1000" => seg <= "10000000";
			when "1001" => seg <= "10010000";
			when "1111" => seg <= "11111111";
			when others => seg <= "11111111";
		end case;
	end process;

end Behavioral;
