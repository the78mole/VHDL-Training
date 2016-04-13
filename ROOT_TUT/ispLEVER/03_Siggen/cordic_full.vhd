-------------------------------------------------------------------------------
-- Title      : Cordic Full
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : cordic_full.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-21
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module improves the cordic with full scale 2*PI rotation
--              capability.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

use ieee.math_real.all;

entity cordic_full is
  
  generic (
    ITER_WIDTH   : positive := 4;
    ITERATIONS   : positive := 10;
    DATA_WIDTH   : positive := 16;
    SCALE_OUTPUT : boolean  := true);

  port (
    CLK_IN   : in  std_logic;
    nRESET   : in  std_logic;
    DVAL_IN  : in  std_logic;
    DVAL_OUT : out std_logic;
    MODE     : in  std_logic;
    PARAM_M  : in  std_logic_vector(1 downto 0);
    X_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    Y_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    Z_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    X_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
    Y_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
    Z_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0));

end cordic_full;

architecture behavioral of cordic_full is

  -- Musterloesung Anfang
  component cordic_base
    generic (
      ITER_WIDTH   : positive;
      ITERATIONS   : positive;
      DATA_WIDTH   : positive;
      SCALE_OUTPUT : boolean);
    port (
      CLK_IN   : in  std_logic;
      nRESET   : in  std_logic;
      DVAL_IN  : in  std_logic;
      DVAL_OUT : out std_logic;
      MODE     : in  std_logic;                     -- unused
      PARAM_M  : in  std_logic_vector(1 downto 0);  -- unused
      X_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      Y_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      Z_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      X_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
      Y_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
      Z_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  constant cn_quart_pi : natural := integer((MATH_PI*real(2**(DATA_WIDTH-3)))/real(4));
  constant cn_half_pi  : natural := integer((MATH_PI*real(2**(DATA_WIDTH-3)))/real(2));
  constant cn_pi       : natural := integer(MATH_PI*real(2**(DATA_WIDTH-3)));

  type tab_saver is array (1 to 4) of boolean;

  signal sb_rot_sec_1, sb_rot_sec_2, sb_rot_sec_3, sb_rot_sec_4 : boolean;
  signal sb_active                                              : boolean;

  signal sv_in_x, sv_in_y, sv_in_z    : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_out_x, sv_out_y, sv_out_z : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sl_dval_in, sl_dval_out : std_logic;

  signal si_x, si_y, si_z : integer range -(2**DATA_WIDTH) to 2**DATA_WIDTH-1;
  signal si_z_rot         : integer range -(2**DATA_WIDTH) to 2**DATA_WIDTH-1;

  -- Musterloesung Ende
  
begin  -- behavioral

  -- Musterloesung Anfang
  cordic_1 : cordic_base
    generic map (
      ITER_WIDTH   => ITER_WIDTH,
      ITERATIONS   => ITERATIONS-2,
      DATA_WIDTH   => DATA_WIDTH,
      SCALE_OUTPUT => SCALE_OUTPUT)
    port map (
      CLK_IN   => CLK_IN,
      nRESET   => nRESET,
      DVAL_IN  => sl_dval_in,
      DVAL_OUT => sl_dval_out,
      MODE     => MODE,
      PARAM_M  => PARAM_M,
      X_IN     => sv_in_x,
      Y_IN     => sv_in_y,
      Z_IN     => sv_in_z,
      X_OUT    => sv_out_x,
      Y_OUT    => sv_out_y,
      Z_OUT    => sv_out_z);

  --      +-----+-----+
  --      |  2  |  1  |
  --      +-----0-----+
  --      |  3  |  4  |
  --      +-----+-----+

  si_x <= conv_integer(X_IN);
  si_y <= conv_integer(Y_IN);
  si_z <= conv_integer(Z_IN);

  -- Make the angle between -90 and 0 degree, the vector will be in
  -- the first Quadrant. This ensures, that the cordic will converge
--  si_z_rot <= si_z - integer(2*cn_half_pi) when sb_rot_sec_2 else
--              si_z + integer(cn_half_pi) when sb_rot_sec_3 else
--              si_z - integer(cn_half_pi) when sb_rot_sec_1 else
--              si_z;

  proc_rot : process (CLK_IN, nRESET)
    variable vl_dval_in, vl_dval_out      : std_logic;
    variable vab_rot_saver, vab_vec_saver : tab_saver;
    variable vb_correct_angle             : boolean;
    variable vv_half_pi_rots              : std_logic_vector(1 downto 0);
    variable vi_x, vi_y, vi_z             : integer
      range -(2**DATA_WIDTH) to 2**DATA_WIDTH-1;
  begin  -- process proc_rot_before
    if nRESET = '0' then                -- asynchronous reset (active low)
      vl_dval_out      := '0';
      vl_dval_in       := '0';
      vb_correct_angle := false;
      vv_half_pi_rots  := (others => '0');
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      if DVAL_IN = '1' and vl_dval_in = '0' and not sb_active then
        
        vi_x := si_x;
        vi_y := si_y;
        vi_z := si_z;

        if vi_z >= -integer(cn_half_pi) and vi_z <= integer(cn_half_pi) then
          sl_dval_in <= '1';
        else
          vb_correct_angle := true;
        end if;
        
      elsif vb_correct_angle then
        
        if vi_z < -integer(cn_half_pi) then
          vi_x := -vi_x;
          vi_y := -vi_y;
          vi_z := vi_z + integer(cn_pi);
          
        elsif vi_z > integer(cn_half_pi) then
          vi_x := -vi_x;
          vi_y := -vi_y;
          vi_z := vi_z - integer(cn_pi);

        else
          sl_dval_in       <= '1';
          vb_correct_angle := false;
        end if;
        
      else
        sl_dval_in <= '0';
      end if;

      sv_in_x <= conv_std_logic_vector(vi_x, DATA_WIDTH);
      sv_in_y <= conv_std_logic_vector(vi_y, DATA_WIDTH);
      sv_in_z <= conv_std_logic_vector(vi_z, DATA_WIDTH);

      vl_dval_out := sl_dval_out;
      vl_dval_in  := DVAL_IN;
    end if;
  end process proc_rot;

  DVAL_OUT <= sl_dval_out;
  X_OUT    <= sv_out_x;
  Y_OUT    <= sv_out_y;
  Z_OUT    <= sv_out_z;

  -- Musterloesung Ende
  
end behavioral;

