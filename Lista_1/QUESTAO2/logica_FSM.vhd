

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity logica_FSM is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sw0 : in STD_LOGIC;
           sw15 : in STD_LOGIC;
           lr : out STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0);
           seg : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end logica_FSM;

architecture Behavioral of logica_FSM is

type state is (inicio,joga_p1, joga_p2, des_esq, des_dir);
signal current_state, next_state : state := inicio;
--signal cnt0, cnt1 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal reg : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal sled : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal menable : STD_LOGIC := '0';
signal mlr : STD_LOGIC := '1';
signal cnt_10Hz 	: integer range 0 to 5000000 := 0;
signal clk_10Hz 	: std_logic := '0';
signal cnt_40Hz 	: integer range 0 to 1250000 := 0;
signal clk_40Hz 	: std_logic := '0';
signal cnt0 		: std_logic_vector(3 downto 0) := "0000";
signal cnt1 		: std_logic_vector(3 downto 0) := "0000";

component registrador is
    Port ( clk_10Hz : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component display is
    Port ( reset : in STD_LOGIC;
           clk_40hz : in STD_LOGIC; 
           seg : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;
begin

--processo para armazenar o estado atual
process(clk, reset)
begin
    if reset='1' then
        current_state <= inicio;
    elsif rising_edge (clk) then
        current_state <= next_state;
    end if;
end process;

--processo para atualizar o estado 
process(current_state,sw0,sw15)

begin
    case current_state is
        when inicio =>
            menable <= '0';
--        cnt0<="0000";
--        cnt1<="0000";
            if sw0='1' then
                next_state <= des_esq;                
            else 
                next_state <= inicio;
            end if;
        when joga_p1 =>
            if cnt0="1001" then
                next_state <= inicio;
                cnt0<="0000";
                cnt1<="0000";
            elsif sw0='1' then
                next_state <= des_esq;
                cnt0 <= cnt0 + 1;
            else
                next_state <= joga_p1;
            end if;            
        when joga_p2 =>
            if cnt1="1001" then
                next_state <= inicio;
                cnt0<="0000";
                cnt1<="0000";
            elsif sw15='1' then
                next_state <= des_dir;
                cnt1 <= cnt1 + 1;
            else
                next_state <= joga_p2;
            end if;
        when des_esq =>
            menable <= '1';
            mlr <= '1'; --desloca a esquerda  lr = 1 no regisrador de delsocamento
            if  sw15='1' and reg="1000000000000000" then
                next_state <= des_dir;
            else
                next_state <= joga_p1;
            end if;            
        when des_dir =>
            menable <= '1';
            mlr <= '0'; --desloca a direita  lr = 0 no regisrador de delsocamento
            if  sw0='1' and reg="0000000000000001" then
                next_state <= des_esq;
            else
                next_state <= joga_p2;
            end if;
    end case;   
    
end process;
led <= reg;
lr <= mlr;

-- process para dividir o clock 10Hz
	process(clk,reset)
	begin
		if reset='1' then
			cnt_10Hz <= 0;
			clk_10Hz <= '0';
		elsif rising_edge(clk) then
			if cnt_10Hz = 5000000 then
				cnt_10Hz <= 0;
				clk_10Hz <= not clk_10Hz;
			else
				cnt_10Hz <= cnt_10Hz + 1;
			end if;
		end if;
	end process;

	-- process para divisor de clock do multiplexador de anodos a 40Hz
	process(clk,reset)
	begin
		if reset='1' then
			cnt_40Hz <= 0;
			clk_40Hz <= '0';
		elsif rising_edge(clk) then
			if cnt_40Hz = 1250000 then
				cnt_40Hz <= 0;
				clk_40Hz <= not clk_40Hz;
			else
				cnt_40Hz <= cnt_40Hz + 1;
			end if;
		end if;	
	end process;
	
    u1 : registrador port map(
        clk_10Hz    => clk_10Hz,
        reset       => reset,
        enable       => menable,
        led         => sled);
	   
    u2 : display port map(
        reset       => reset,
        clk_40hz    => clk_40hz,
        seg         => seg,
        an          => an);

end Behavioral;
