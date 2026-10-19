library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;
entity add_sub is
    port ( 
        A, B : in STD_LOGIC_VECTOR(31 downto 0);
        Cin : in STD_LOGIC; -- 0 = add, 1 = subtract 
        S : out STD_LOGIC_VECTOR(31 downto 0);
        Carry,overflow : out STD_LOGIC );
end add_sub;
architecture arch of add_sub 
is
    signal Tmp : unsigned(32 downto 0);
    signal C : unsigned(32 downto 0); 
begin
    C <= (0 => Cin, others => '0');
    Tmp <= unsigned('0' & A) + unsigned('0' & B) + C; 
    S <= std_logic_vector(Tmp(31 downto 0));
    Carry <= Tmp(32); 
overflow <= (not (A(31) xor B(31))) and (A(31) xor Tmp(31));
        end arch;