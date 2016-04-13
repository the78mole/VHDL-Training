library ieee;
use ieee.std_logic_1164.all;

package my_math is

  type UNSIGNED is array (NATURAL range <> ) of STD_LOGIC;
  type SIGNED is array (NATURAL range <> ) of STD_LOGIC;


  function ld (NUM : NATURAL) return natural;

  function accumulate(ACC, ADD : NATURAL) return NATURAL;
  function accumulate(ACC, ADD : INTEGER) return INTEGER;
  function accumulate(ACC, ADD : UNSIGNED) return UNSIGNED;
  function accumulate(ACC, ADD : SIGNED) return SIGNED;
  function accumulate(ACC, ADD : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
    
--  --============================================================================
--  -- Conversion Functions
--  --============================================================================
--  -- We put this in, because for Xilinx they are a de facto standard an they
--  -- ease the programming a lot, so why not using it...
  
--  -- Id: D.1
--  function CONV_INTEGER (ARG: UNSIGNED) return NATURAL is
--  begin
--    TO_INTEGER(ARG);
--  end CONV_INTEGER;
--  -- Result subtype: NATURAL. Value cannot be negative since parameter is an
--  --                 UNSIGNED vector.
--  -- Result: Converts the UNSIGNED vector to an INTEGER.

--  -- Id: D.2
--  function CONV_INTEGER (ARG: SIGNED) return INTEGER is
--  begin
--    TO_INTEGER(ARG);
--  end CONV_INTEGER;
--  -- Result subtype: INTEGER
--  -- Result: Converts a SIGNED vector to an INTEGER.

--  -- Id: D.3
--  function CONV_UNSIGNED (ARG, SIZE: NATURAL) return UNSIGNED is
--  begin
--    TO_UNSIGNED(ARG);
--  end TO_UNSIGNED;
--  -- Result subtype: UNSIGNED(SIZE-1 downto 0)
--  -- Result: Converts a non-negative INTEGER to an UNSIGNED vector with
--  --         the specified SIZE.

--  -- Id: D.4
--  function CONV_SIGNED (ARG: INTEGER; SIZE: NATURAL) return SIGNED is
--  begin
--    TO_SIGNED(ARG);
--  end TO_SIGNED;
--  -- Result subtype: SIGNED(SIZE-1 downto 0)
--  -- Result: Converts an INTEGER to a SIGNED vector of the specified SIZE.

--  -- D.5, D.6, D.7 and D.8 are commented out, since these functions
--  -- are not in IEEE NUMERIC_STD package, Rev 2.4, April 12, 1995
--  -- Id: D.5
--  function CONV_UNSIGNED (ARG: STD_LOGIC_VECTOR) return UNSIGNED is
--  begin
--    TO_UNSIGNED(ARG);
--  end TO_UNSIGNED;
--  -- Result subtype: UNSIGNED(ARG'RANGE)
--  -- Result: Converts STD_LOGIC_VECTOR to UNSIGNED.

--  -- Id: D.6
--  function CONV_SIGNED (ARG: STD_LOGIC_VECTOR) return SIGNED => is
--  begin
--    TO_SIGNED(ARG);
--  end TO_SIGNED;
--  -- Result subtype: SIGNED(ARG'RANGE)
--  -- Result: Converts STD_LOGIC_VECTOR to SIGNED.

--  -- Id: D.7
--  function CONV_STD_LOGIC_VECTOR (ARG: UNSIGNED) return STD_LOGIC_VECTOR is
--  begin
--    TO_STDLOGICVECTOR(ARG);
--  end TO_STDLOGICVECTOR;
--  -- Result subtype: STD_LOGIC_VECTOR(ARG'RANGE)
--  -- Result: Converts UNSIGNED to STD_LOGIC_VECTOR.

--  -- Id: D.8
--  function CONV_STD_LOGIC_VECTOR (ARG: SIGNED) return STD_LOGIC_VECTOR is
--  begin
--    TO_STDLOGICVECTOR(ARG);
--  end TO_STDLOGICVECTOR;
--  -- Result subtype: STD_LOGIC_VECTOR(ARG'RANGE)
--  -- Result: Converts SIGNED to STD_LOGIC_VECTOR.
  
end my_math;

package body my_math is

  -- purpose: returns the logarithm dualis of value (same as number of bits)
  function ld (NUM : NATURAL) return NATURAL is
    variable tmp, number_of_bits : NATURAL;
  begin
    tmp            := num;
    number_of_bits := 1;
    while tmp > 1 loop
      number_of_bits := number_of_bits+1;
      tmp            := tmp/2;
    end loop;
    return number_of_bits;
  end ld;

  -- purpose: This is a simple accumulator
  function accumulate (ACC, ADD : NATURAL) return NATURAL is
  begin  -- accumulate
    return ACC + ADD;
  end accumulate;

  function accumulate (ACC, ADD : INTEGER) return INTEGER is
  begin  -- accumulate
    return ACC + ADD;
  end accumulate;

  function accumulate (ACC, ADD : UNSIGNED) return UNSIGNED is
  begin  -- accumulate
    return ACC + ADD;
  end accumulate;

  function accumulate (ACC, ADD : SIGNED) return SIGNED is
  begin  -- accumulate
    return ACC + ADD;
  end accumulate;

  function accumulate (ACC, ADD : STD_LOGIC_VECTOR; SIZE: NATURAL) return STD_LOGIC_VECTOR is
  begin  -- accumulate
    return conv_std_logic_vector(conv_integer(ACC) + conv_integer(ADD), SIZE);
  end accumulate;

end my_math;

