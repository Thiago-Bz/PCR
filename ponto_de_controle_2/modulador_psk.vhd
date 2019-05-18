library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

entity oito_PSK is
Port( data_in : in  STD_LOGIC_VECTOR (2 downto 0);            
    amp_cos : out  STD_LOGIC_VECTOR (4 downto 0);            
    amp_sin : out  STD_LOGIC_VECTOR (4 downto 0));
end oito_PSK;

architecture Behavioral of oito_PSK is 
begin
process (data_in)
begin
    case data_in is
        when "000"  => amp_cos  <= "00000"; amp_sin <= "01010"; -- 0, 10 
        when "001"  => amp_cos  <= "00111"; amp_sin <= "00111"; -- 7, 7 
        when "010"  => amp_cos  <= "01010"; amp_sin <= "00000"; -- 10, 0 
        when "011"  => amp_cos  <= "00111"; amp_sin <= "11001"; -- 7, -7 
        when "100"  => amp_cos  <= "00000"; amp_sin <= "10110"; -- 0, -10 
        when "101"  => amp_cos  <= "11001"; amp_sin <= "11001"; -- -7, -7 
        when "110"  => amp_cos  <= "10110"; amp_sin <= "00000"; -- -10, 0 
        when "111"  => amp_cos  <= "11001"; amp_sin <= "00111"; -- -7, 7
        when others => amp_cos  <= "00000"; amp_sin <= "00000";
    end case;
end process;
end Behavioral;      