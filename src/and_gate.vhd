library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_gate is
    port (
        a : in  STD_LOGIC_VECTOR(31 downto 0):=(others=>'0') ;
        b : in  STD_LOGIC_VECTOR(31 downto 0):=(others=>'0') ;
        x : out STD_LOGIC_VECTOR(31 downto 0)
    );
end and_gate;

architecture arch of and_gate is
begin
    x <= a and b;
end arch;