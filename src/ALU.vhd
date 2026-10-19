LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY ALU is 
    PORT (
            A :in STD_LOGIC_VECTOR(31 downto 0);
            B :in STD_LOGIC_VECTOR(31 downto 0);
            S: in STD_LOGIC_VECTOR(1 downto 0);
            Ainvert: in STD_LOGIC;
            Bnegate : in STD_LOGIC;
            RESULT: out STD_LOGIC_VECTOR(31 downto 0);
            C : out STD_LOGIC;
            V: out STD_LOGIC;
            Z: out STD_LOGIC; 
            N: out STD_LOGIC
         );
END Entity ALU;

ARCHITECTURE arch OF ALU IS
    SIGNAL A_INV : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL B_INV : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL OUTA : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL OUTB : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL AND_RESULT : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL OR_RESULT : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL ARITH_RESULT : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL SLT :STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL C_ACTIVE : STD_LOGIC;
    SIGNAL V_ACTIVE : STD_LOGIC;
    
    component mux
        PORT(
            I0, I1: in STD_LOGIC_VECTOR(31 downto 0);
            S: in STD_LOGIC;
            y : out STD_LOGIC_VECTOR(31 downto 0)
        );
    END component;
    component and_gate
        PORT(
            a : in STD_LOGIC_VECTOR(31 downto 0);
            b : in STD_LOGIC_VECTOR(31 downto 0);
            x : out STD_LOGIC_VECTOR(31 downto 0)
        );
    END component;
    component or_gate
        PORT(
            a : in STD_LOGIC_VECTOR(31 downto 0);
            b : in STD_LOGIC_VECTOR(31 downto 0);
            x : out STD_LOGIC_VECTOR(31 downto 0)
        );
    END component;
    component add_sub
        PORT(
            A, B : in STD_LOGIC_VECTOR(31 downto 0);
            Cin : in STD_LOGIC; 
            S : out STD_LOGIC_VECTOR(31 downto 0);
            Carry,overflow : out STD_LOGIC
        );
    END component;
    component mux4to1
        PORT(
            I0, I1, I2, I3 : in STD_LOGIC_VECTOR(31 downto 0);
            s : in STD_LOGIC_VECTOR(1 downto 0);
            y : out STD_LOGIC_VECTOR(31 downto 0)
        );
    END component;

BEGIN
    -- Operand Inversion
    A_INV <= not A;
    B_INV <= not B;

    -- Input Muxes
     mux1 : mux
     port map(
        I0 => A,
        I1 => A_INV,
        y => OUTA,
        S => Ainvert

    );

    mux2 : mux
     port map(
        I0 => B,
        I1 => B_INV,
        y => OUTB,
        S => Bnegate
    );

    --Logical Units
    and1 : and_gate
    port map(
        a =>OUTA,
        b =>OUTB,
        x => AND_RESULT
        );

    or1 : or_gate
    port map(
        a =>OUTA,
        b =>OUTB,
        x => OR_RESULT
        );
        
    adderandsubtractor : add_sub
    port map(
        A => OUTA,
        B => OUTB,
        Cin => Bnegate,
        s => ARITH_RESULT,
        Carry => C_ACTIVE, 
        overflow => V_ACTIVE
    );

    SLT <= ( 0=> (V_ACTIVE xor ARITH_RESULT(31)), others =>'0');

    -- Output Mux
    mux4_1 : mux4to1
    port map(
        I0 => AND_RESULT,
        I1 => OR_RESULT,
        I2 => ARITH_RESULT,
        I3 => SLT,
        s => S,
        y => RESULT
    );

    --Flags Operations
    C <= C_ACTIVE when S = "10" else '0';
    V <= V_ACTIVE when S = "10" else '0';
    Z <= nor RESULT ;
    N <= RESULT(31);

END arch;
