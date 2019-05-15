library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ping_pong_rtl is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sw0 : in STD_LOGIC;
           sw15 : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0));
end ping_pong_rtl;

architecture Behavioral of ping_pong_rtl is

signal cnt_10Hz 	: integer range 0 to 5000000 := 0;
signal clk_10Hz 	: std_logic := '0';
signal cnt_40Hz 	: integer range 0 to 1250000 := 0;
signal clk_40Hz 	: std_logic := '0';
signal senable 		: std_logic := '0';
signal lr 			: std_logic := '1';
signal player 		: std_logic := '0';
signal reg 			: std_logic_vector(15 downto 0) := (others=>'0');
signal cnt0 		: std_logic_vector(3 downto 0) := "0000";
signal cnt1 		: std_logic_vector(3 downto 0) := "0000";

component registrador is
    Port ( clk_10Hz : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component logica is
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
end component;

component display is
    Port ( reset : in STD_LOGIC;
           clk_40hz : in STD_LOGIC; 
           seg : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

begin

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

    u1 : display port map(
        reset       => reset,
        clk_40hz    => clk_40hz,
        seg         => seg,
        an          => an);
            
    u2 : logica port map(
        clk => clk,
        reset => reset,
        creg => reg,
        sw0 => sw0,
        sw15 =>sw15,
        ccnt0 => cnt0,
        ccnt1 => cnt1,
        cenable =>senable,
        clr =>lr,
        cplayer  => player);

    u3 : registrador port map(
        clk_10Hz    => clk_10Hz,
        reset       => reset,
        enable      => senable,
        led         => led);
    
    

end Behavioral;
