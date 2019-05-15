----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2019 12:39:52
-- Design Name: 
-- Module Name: polinomio - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

use work.fpupack.all;
use work.entities.all;



entity polinomio is
    Port (x : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           start : in STD_LOGIC;
           reset : in STD_LOGIC;
           bntU : in STD_LOGIC;
           bntD : in STD_LOGIC;
           ready : out STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0));
end polinomio;

architecture Behavioral of polinomio is

signal outmul : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal outmu2 : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal outmu3 : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal rdymul : STD_LOGIC := '0';
signal rdymu2 : STD_LOGIC := '0';
signal rdymu3 : STD_LOGIC := '0';
signal rdyadd_0 : STD_LOGIC := '0';
signal rdyadd_1 : STD_LOGIC := '0';
signal outadd_0 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_1 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal fx : STD_LOGIC_VECTOR (26 downto 0):= (others=>'0');
--signal x_mul : STD_LOGIC_VECTOR (26 downto 0):= (others=>'0');
signal x1 : STD_LOGIC_VECTOR (26 downto 0):= (others=>'0');
--signal x2 : STD_LOGIC_VECTOR (10 downto 0):= (others=>'0');


begin
    
    mul1: multiplierfsm_v2 port map(
    reset      => reset,
    clk          => clk,   
    op_a          => x1,
    op_b          => x1,
    start_i     => start,
    mul_out   => outmul,
    ready_mul => rdymul);
    
    mul2: multiplierfsm_v2 port map(
    reset      => reset,
    clk          => clk,   
    op_a          => x1,
    op_b          => b,
    start_i     => start,
    mul_out   => outmu2,
    ready_mul => rdymu2);
    
    mul3: multiplierfsm_v2 port map(
    reset     => reset,
    clk       => clk,   
    op_a      => outmul,
    op_b      => a,
    start_i   => rdymul,
    mul_out   => outmu3,
    ready_mul => rdymu3);
    
    add0: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '0',   
    op_a       => outmu2,
    op_b       => c,
    start_i    => rdymul,
    addsub_out => outadd_0,
    ready_as   => rdyadd_0);

    add1: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '0',   
    op_a       => outmu3,
    op_b       => outadd_0,
    start_i    => rdymu3,
    addsub_out => outadd_1,
    ready_as   => rdyadd_1);

--processo para selecionar a entrade e saida
    process(clk, reset, bntU, bntD)
    begin
        if reset ='1' then
            led <= (others=>'0');
            ready <= '0';
        elsif rising_edge(clk) then
            case bntD is 
                when '0' => x1(15 downto 0) <= x(15 downto 0) ;
                when '1' => x1(26 downto 16) <= x(10 downto 0) ;
                when others => x1 <= (others=>'0'); 
            end case;
--        else
            case bntU is
                when '0' => led <= fx(15 downto 0);
                when '1' => led <= "00000" & fx(26 downto 16);
                when others => led <= (others=>'0'); 
            end case;
            
        end if;               
    fx <= outadd_1;
       
    end process;
end Behavioral;
