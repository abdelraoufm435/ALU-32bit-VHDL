library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity mux is
    port (
    I0, I1: in STD_LOGIC_VECTOR(31 downto 0);
    S: in STD_LOGIC;
    y : out STD_LOGIC_VECTOR(31 downto 0) );
end mux;

architecture arch of mux is
begin
    y <= I0 when S = '0' else
         I1;    
    end arch;