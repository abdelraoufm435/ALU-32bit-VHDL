library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or_gate is
    port (
        a : in  STD_LOGIC_VECTOR(31 downto 0):=(others=>'0') ;
        b : in  STD_LOGIC_VECTOR(31 downto 0):=(others=>'0') ;
        x : out STD_LOGIC_VECTOR(31 downto 0)
    );
end or_gate;

architecture arch of or_gate is
begin
    x <= a or b;
end arch;