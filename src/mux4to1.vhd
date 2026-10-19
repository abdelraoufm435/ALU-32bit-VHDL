
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4to1 is
    port (
        I0, I1, I2, I3 : in STD_LOGIC_VECTOR(31 downto 0);
        s : in STD_LOGIC_VECTOR(1 downto 0);
        y : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mux4to1;

architecture arch of mux4to1 is
    component mux is
        port (
            I0, I1 : in STD_LOGIC_VECTOR(31 downto 0);
            s : in STD_LOGIC;
            y : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    Signal y0, y1 : STD_LOGIC_VECTOR(31 downto 0);

begin
    mux0 : mux
        port map(
            I0 => I0,
            I1 => I1,
            s => s(0),
            y => y0
        );

    mux1 : mux
        port map(
            I0 => I2,
            I1 => I3,
            s => s(0),
            y => y1
        );

    mux2 : mux
        port map(
            I0 => y0,
            I1 => y1,
            s => s(1),
            y => y
        );



end arch;
