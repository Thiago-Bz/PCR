----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2019 13:26:09
-- Design Name: 
-- Module Name: OITO_PSK_RTL - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;


entity OITO_PSK_RTL is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           s_Dig : in STD_LOGIC;
           s_Modulado : out STD_LOGIC_VECTOR (16 downto 0));
end OITO_PSK_RTL;

architecture Behavioral of OITO_PSK_RTL is

signal s_reg : STD_LOGIC_VECTOR (2 downto 0) :=(others=>'0');
signal cos_psk : std_logic_vector(15 downto 0) :=(others=>'0');
signal amp_cos_psk : std_logic_vector(4 downto 0) :=(others=>'0');
signal mult_cos_psk : std_logic_vector(16 downto 0) :=(others=>'0');
signal sen_psk : std_logic_vector(15 downto 0) :=(others=>'0');
signal amp_sen_psk : std_logic_vector(4 downto 0) :=(others=>'0');
signal mult_sen_psk : std_logic_vector(16 downto 0) :=(others=>'0');
signal freq : std_logic_vector(2 downto 0) :=(others=>'0');
signal enable_gerador : std_logic :='0';

component gerador_de_onda is
    Port (clk : in std_logic;
    reset : in std_logic;
    enable_clk: in std_logic;
    freq : in std_logic_vector(2 downto 0);
    cosseno : out std_logic_vector(15  downto 0);
    seno : out std_logic_vector(15  downto 0));
end component;

component SIPO is
Port( reset: in std_logic;
    s_in : in std_logic;
    clk  : in std_logic;
    pout : out std_logic_vector(2 downto 0));
end component;

component oito_PSK is
Port( data_in : in  STD_LOGIC_VECTOR (2 downto 0);            
    amp_cos : out  STD_LOGIC_VECTOR (4 downto 0);            
    amp_sin : out  STD_LOGIC_VECTOR (4 downto 0));
end component;

component multiplicador is
Port ( onda : in STD_LOGIC_VECTOR (11 downto 0);
       amplitude : in STD_LOGIC_VECTOR (4 downto 0);
       resultado : out STD_LOGIC_VECTOR (16 downto 0));
end component;

component somador is
Port ( a : in STD_LOGIC_VECTOR (16 downto 0);
       b : in STD_LOGIC_VECTOR (16 downto 0);
       saida : out STD_LOGIC_VECTOR (16 downto 0));
end component;

begin

gerador_onda: gerador_de_onda port map(
    clk         =>clk,
    reset       =>reset,
    enable_clk  => enable_gerador,
    freq        => s_reg, --freq
    seno        => sen_psk,
    cosseno     => cos_psk);
    
SIPO_reg: SIPO port map(
    clk     =>clk,
    reset   =>reset,
    s_in    =>s_Dig,
    pout    => s_reg);
    
modulador: oito_PSK port map(
    data_in => s_reg,
    amp_cos => amp_cos_psk,
    amp_sin => amp_sen_psk);
    
mul1: multiplicador port map(
    onda        => sen_psk,
    amplitude   => amp_sen_psk,
    resultado   => mult_sen_psk);

mul2: multiplicador port map(
    onda        => cos_psk,
    amplitude   => amp_cos_psk,
    resultado   => mult_cos_psk); 
    
add1: somador port map(
    a       => mult_sen_psk,
    b       => mult_sen_psk,
    saida   => s_modulado);    
    
end Behavioral;
