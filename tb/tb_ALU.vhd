LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_ALU IS
END ENTITY tb_ALU;

ARCHITECTURE behavior OF tb_ALU IS

    SIGNAL A : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    SIGNAL B : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    SIGNAL S : STD_LOGIC_VECTOR(1 downto 0) := "00";
    SIGNAL Ainvert : STD_LOGIC := '0';
    SIGNAL Bnegate : STD_LOGIC := '0';

    SIGNAL RESULT : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL C, V, Z, N : STD_LOGIC;

BEGIN

    uut : ENTITY work.ALU
        PORT MAP (
            A => A,
            B => B,
            S => S,
            Ainvert => Ainvert,
            Bnegate => Bnegate,
            RESULT => RESULT,
            C => C,
            V => V,
            Z => Z,
            N => N
        );

    stimulus : PROCESS
    BEGIN

        -- TEST 1: AND (5 AND 3 = 1)
        A <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32));
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(3, 32));
        S <= "00";
        Ainvert <= '0';
        Bnegate <= '0';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(1, 32))
            REPORT "TEST 1 FAILED: AND"
            SEVERITY ERROR;

        -- TEST 2: OR (5 OR 2 = 7)
        A <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32));
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, 32));
        S <= "01";
        Ainvert <= '0';
        Bnegate <= '0';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(7, 32))
            REPORT "TEST 2 FAILED: OR"
            SEVERITY ERROR;

        -- TEST 3: AND WITH A INVERTED
        -- NOT 5 AND 3 = 2
        A <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32));
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(3, 32));
        S <= "00";
        Ainvert <= '1';
        Bnegate <= '0';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(2, 32))
            REPORT "TEST 3 FAILED: INVERTED AND"
            SEVERITY ERROR;

        -- TEST 4: OR WITH B INVERTED
        -- 5 OR NOT 3 = -3 (32-bit two's complement)
        A <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32));
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(3, 32));
        S <= "01";
        Ainvert <= '0';
        Bnegate <= '1';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_SIGNED(-3, 32))
            REPORT "TEST 4 FAILED: INVERTED OR"
            SEVERITY ERROR;

        -- TEST 5: ADD (5 + 8 = 13)
        A <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32));
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(8, 32));
        S <= "10";
        Ainvert <= '0';
        Bnegate <= '0';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(13, 32))
            REPORT "TEST 5 FAILED: ADD"
            SEVERITY ERROR;

        ASSERT C = '0' AND V = '0' AND Z = '0' AND N = '0'
            REPORT "TEST 5 FAILED: ADD FLAGS"
            SEVERITY ERROR;

        -- TEST 6: ADD OVERFLOW OF UNSIGNED RANGE
        -- 4294967295 + 1 = 0, with carry out
        A <= (others => '1');
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, 32));
        S <= "10";
        Ainvert <= '0';
        Bnegate <= '0';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32))
            REPORT "TEST 6 FAILED: ADD RESULT"
            SEVERITY ERROR;

        ASSERT C = '1' AND V = '0' AND Z = '1' AND N = '0'
            REPORT "TEST 6 FAILED: ADD FLAGS"
            SEVERITY ERROR;

        -- TEST 7: SUBTRACTION (5 - 8 = -3)
        A <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32));
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(8, 32));
        S <= "10";
        Ainvert <= '0';
        Bnegate <= '1';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_SIGNED(-3, 32))
            REPORT "TEST 7 FAILED: SUBTRACTION"
            SEVERITY ERROR;

        ASSERT C = '0' AND V = '0' AND Z = '0' AND N = '1'
            REPORT "TEST 7 FAILED: SUBTRACTION FLAGS"
            SEVERITY ERROR;

        -- TEST 8: SIGNED ADDITION OVERFLOW
        -- 2147483647 + 1 = -2147483648 (32-bit result)
        A <= STD_LOGIC_VECTOR(TO_SIGNED(2147483647, 32));
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, 32));
        S <= "10";
        Ainvert <= '0';
        Bnegate <= '0';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_SIGNED(-2147483648, 32))
            REPORT "TEST 8 FAILED: SIGNED ADD OVERFLOW RESULT"
            SEVERITY ERROR;

        ASSERT V = '1' AND N = '1' AND Z = '0'
            REPORT "TEST 8 FAILED: SIGNED ADD OVERFLOW FLAGS"
            SEVERITY ERROR;

        -- TEST 9: SLT (5 < 8 = 1)
        A <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32));
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(8, 32));
        S <= "11";
        Ainvert <= '0';
        Bnegate <= '1';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(1, 32))
            REPORT "TEST 9 FAILED: SLT TRUE"
            SEVERITY ERROR;

        -- TEST 10: SLT (8 < 5 = 0)
        A <= STD_LOGIC_VECTOR(TO_UNSIGNED(8, 32));
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32));
        S <= "11";
        Ainvert <= '0';
        Bnegate <= '1';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32))
            REPORT "TEST 10 FAILED: SLT FALSE"
            SEVERITY ERROR;

        -- TEST 11: SLT WITH NEGATIVE A (-5 < 3 = 1)
        A <= STD_LOGIC_VECTOR(TO_SIGNED(-5, 32));
        B <= STD_LOGIC_VECTOR(TO_SIGNED(3, 32));
        S <= "11";
        Ainvert <= '0';
        Bnegate <= '1';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(1, 32))
            REPORT "TEST 11 FAILED: SLT NEGATIVE A"
            SEVERITY ERROR;

        -- TEST 12: SLT WITH NEGATIVE B (3 < -5 = 0)
        A <= STD_LOGIC_VECTOR(TO_SIGNED(3, 32));
        B <= STD_LOGIC_VECTOR(TO_SIGNED(-5, 32));
        S <= "11";
        Ainvert <= '0';
        Bnegate <= '1';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32))
            REPORT "TEST 12 FAILED: SLT NEGATIVE B"
            SEVERITY ERROR;

        -- TEST 13: SLT EDGE CASE WITH SIGNED OVERFLOW
        -- 2147483647 < -1 is FALSE
        A <= STD_LOGIC_VECTOR(TO_SIGNED(2147483647, 32));
        B <= STD_LOGIC_VECTOR(TO_SIGNED(-1, 32));
        S <= "11";
        Ainvert <= '0';
        Bnegate <= '1';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32))
            REPORT "TEST 13 FAILED: SLT OVERFLOW CASE"
            SEVERITY ERROR;

        -- TEST 14: ZERO RESULT AND FLAGS (5 - 5 = 0)
        A <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32));
        B <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 32));
        S <= "10";
        Ainvert <= '0';
        Bnegate <= '1';
        WAIT FOR 10 ns;

        ASSERT RESULT = STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32))
            REPORT "TEST 14 FAILED: ZERO RESULT"
            SEVERITY ERROR;

        ASSERT C = '1' AND V = '0' AND Z = '1' AND N = '0'
            REPORT "TEST 14 FAILED: ZERO FLAGS"
            SEVERITY ERROR;

        REPORT "ALL ALU TESTS COMPLETED"
            SEVERITY NOTE;

        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;
