library ieee;
use ieee.std_logic_1164.all;

package my_funcs is

  type unsigned is array (natural range <>) of std_logic;
  type signed is array (natural range <>) of std_logic;


  function ld (NUM              : natural) return natural;
  function integer_min (WIDTH   : natural) return integer;
  function integer_max (WIDTH   : natural) return integer;
  function natural_min (WIDTH   : natural) return natural;
  function natural_max (WIDTH   : natural) return natural;
  function integer_scale (WIDTH : natural) return natural;
  function natural_scale (WIDTH : natural) return natural;
  
end my_funcs;

package body my_funcs is

  -- purpose: returns the logarithm dualis of value (same as number of bits)
  function ld (NUM : natural) return natural is
    variable tmp, number_of_bits : natural;
  begin
    tmp            := num;
    number_of_bits := 1;
    while tmp > 1 loop
      number_of_bits := number_of_bits+1;
      tmp            := tmp/2;
    end loop;
    return number_of_bits;
  end ld;

  function integer_min (WIDTH : natural) return integer is
  begin
    return -(2**(WIDTH-1));
  end integer_min;

  function integer_max (WIDTH : natural) return integer is
  begin
    return (2**(WIDTH-1))-1;
  end integer_max;

  function natural_min (WIDTH : natural) return natural is
  begin
    return 0;
  end natural_min;

  function natural_max (WIDTH : natural) return natural is
  begin
    return (2**WIDTH)-1;
  end natural_max;

  function integer_scale (WIDTH : natural) return natural is
  begin
    return 2**(WIDTH-1);
  end integer_scale;

  function natural_scale (WIDTH : natural) return natural is
  begin
    return 2**WIDTH;
  end natural_scale;
  
end my_funcs;
