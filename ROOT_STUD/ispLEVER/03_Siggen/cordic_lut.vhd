-------------------------------------------------------------------------------
-- Title      : Cordic look-up table
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : cordic_lut.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-16
-- Last update: 2006-11-29
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This modlue implements the look-up table needed for cordic
--              algorithm. It uses math_real to claculate the values needed.
--              Math_real is not needed after synthesis time, because the
--              values are converted to std_logic_vector representing a scaled
--              integer value. The values are stored within distributed RAM
--              (ROM-mode).
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-16  1.0      sidaglas        Created
-- 2006-11-24  1.1      sidaglas        Improved
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- NOCOPY -- Don't copy this script to students work folder

entity cordic_lut is
  
  generic (
    DATA_WIDTH : positive := 16;
    ITER_WIDTH : positive := 4);

  port (
    STEP        : in  std_logic_vector(ITER_WIDTH-1 downto 0);
    ALPHA_I     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    TAN_ALPHA_I : out std_logic_vector(DATA_WIDTH-1 downto 0);
    K_I         : out std_logic_vector(DATA_WIDTH-1 downto 0);
    K_G         : out std_logic_vector(DATA_WIDTH-1 downto 0));

end cordic_lut;

architecture behavioral of cordic_lut is

  constant cn_iterations         : positive := 2**ITER_WIDTH;
  constant cn_max_value          : positive := (2**DATA_WIDTH)-1;
  constant cn_scale_factor       : natural  := 2**(DATA_WIDTH-2);
  constant cn_angle_scale_factor : natural  := 2**(DATA_WIDTH-3);

  type tur_lut is record
    ALPHA_I     : natural range 0 to cn_max_value;
    TAN_ALPHA_I : natural range 0 to cn_max_value;
    K_I         : natural range 0 to cn_max_value;
    K_G         : natural range 0 to cn_max_value;
  end record tur_lut;

  type   tuar_lut is array (0 to cn_iterations-1) of tur_lut;
  signal suar_cordic_lut : tuar_lut;

--  signal sr_tan_alpha_i : real := real(0);
--  signal sr_alphi_i     : real := real(0);
  signal si_k_i_helper : integer := 0;
  signal si_k_helper   : integer := 0;
  signal sn_step       : natural range 0 to (2**ITER_WIDTH)-1;
  
begin  -- behavioral

  gen_lut : for i in 0 to cn_iterations-1 generate
    suar_cordic_lut(i).TAN_ALPHA_I <=
      integer(ROUND(real(cn_scale_factor)/(real(2**i))));

    suar_cordic_lut(i).ALPHA_I <=
      integer(ROUND(arctan(real(1)/(real(2**i)))*real(cn_angle_scale_factor)));

    suar_cordic_lut(i).K_I <=
      integer(real(cn_scale_factor)/sqrt(real(1)+(real(2)**(-2*i))));

    gen_zeroi : if i = 0 generate
      suar_cordic_lut(i).K_G <=
        integer(real(cn_scale_factor)/
                sqrt(real(1)+(real(2)**(-2*i))));
    end generate gen_zeroi;
    gen_nonzeroi : if i /= 0 generate
      suar_cordic_lut(i).K_G <=
        integer(real(suar_cordic_lut(i-1).K_G)/
                sqrt(real(1)+(real(2)**(-2*i))));
    end generate gen_nonzeroi;
    
  end generate gen_lut;

  sn_step <= conv_integer("0" & STEP);

  ALPHA_I     <= conv_std_logic_vector(conv_signed(suar_cordic_lut(sn_step).ALPHA_I, DATA_WIDTH), DATA_WIDTH);
  TAN_ALPHA_I <= conv_std_logic_vector(conv_signed(suar_cordic_lut(sn_step).TAN_ALPHA_I, DATA_WIDTH), DATA_WIDTH);
  K_I         <= conv_std_logic_vector(conv_signed(suar_cordic_lut(sn_step).K_I, DATA_WIDTH), DATA_WIDTH);
  K_G         <= conv_std_logic_vector(conv_signed(suar_cordic_lut(sn_step).K_G, DATA_WIDTH), DATA_WIDTH);

--  ALPHA_I     <= suar_cordic_lut(1).ALPHA_I;
--  TAN_ALPHA_I <= suar_cordic_lut(1).TAN_ALPHA_I;
--  K_I         <= suar_cordic_lut(1).K_I;
--  K_G         <= suar_cordic_lut(1).K_G;

end behavioral;

