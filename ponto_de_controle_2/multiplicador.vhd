----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2019 22:58:59
-- Design Name: 
-- Module Name: multiplicador - Behavioral
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

entity multiplicador is
    Port ( onda : in STD_LOGIC_VECTOR (15 downto 0);
           amplitude : in STD_LOGIC_VECTOR (4 downto 0);
           resultado : out STD_LOGIC_VECTOR (20 downto 0));
end multiplicador;

architecture Behavioral of multiplicador is

begin

resultado <= onda*amplitude; 

end Behavioral;
