-------------------------------------------------------------------------------
-- Title      : Cordig Siggen
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : cordic_siggen.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-21
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module uses the cordic algorithm to implement a sinusodial
--              signal generator.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

use ieee.math_real.all;

entity cordic_siggen is
  
  generic (
    DATA_WIDTH : positive := 8;
    ITERATIONS : positive := 10;
    ITER_WIDTH : positive := 4);

  port (
    CLK_IN    : in  std_logic;
    nRESET    : in  std_logic;
    PHASE_INC : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    DATA_OUT  : out std_logic_vector(DATA_WIDTH-1 downto 0));

end cordic_siggen;

architecture behavioral of cordic_siggen is

  constant cn_angle_scale_factor : natural := 2**(DATA_WIDTH-3);

  constant ci_pi     : natural := integer(MATH_PI*real(cn_angle_scale_factor));
  constant ci_two_pi : natural := 2*ci_pi;

  -- This lut is only used for getting the scale_factor
  component cordic_lut
    generic (
      DATA_WIDTH : positive;
      ITER_WIDTH : positive);
    port (
      STEP        : in  std_logic_vector(ITER_WIDTH-1 downto 0);
      ALPHA_I     : out std_logic_vector(DATA_WIDTH-1 downto 0);
      TAN_ALPHA_I : out std_logic_vector(DATA_WIDTH-1 downto 0);
      K_I         : out std_logic_vector(DATA_WIDTH-1 downto 0);
      K_G         : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  signal sv_vector_full_k : std_logic_vector(DATA_WIDTH-1 downto 0);
  
  component cordic_full
    generic (
      ITER_WIDTH : positive;
      ITERATIONS : positive;
      DATA_WIDTH : positive;
      SCALE_OUTPUT : boolean);
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
  end component;

  signal si_phase_inc : integer range -(2**(DATA_WIDTH-1)) to (2**(DATA_WIDTH-1))-1;
  signal sv_phase     : std_logic_vector(DATA_WIDTH-1 downto 0);
  
begin  -- behavioral

  -- This lut is only used for getting the scale_factor. It will hopefully
  -- optimized down to a simple constant value
  cordic_lut_1: cordic_lut
    generic map (
      DATA_WIDTH => DATA_WIDTH,
      ITER_WIDTH => ITER_WIDTH)
    port map (
      STEP        => ITERATIONS-1,
      ALPHA_I     => open,
      TAN_ALPHA_I => open,
      K_I         => open,
      K_G         => sv_vector_full_k);
  
  cordic_full_1 : cordic_full
    generic map (
      ITER_WIDTH => ITER_WIDTH,
      ITERATIONS => ITERATIONS,
      DATA_WIDTH => DATA_WIDTH,
      SCALE_OUTPUT => false)
    port map (
      CLK_IN   => CLK_IN,
      nRESET   => nRESET,
      DVAL_IN  => DVAL_IN,
      DVAL_OUT => DVAL_OUT,
      MODE     => '0',
      PARAM_M  => "01",
      X_IN     => sv_vector_full_k,
      Y_IN     => sv_vector_null,
      Z_IN     => sv_phase,
      X_OUT    => X_OUT,
      Y_OUT    => Y_OUT,
      Z_OUT    => Z_OUT);

  -- This process accumulates the phase increment to the full angle of the
  -- rotation
  proc_phase_inc : process (CLK_IN, nRESET)
    variable vi_phase : integer range -(2**(DATA_WIDTH-1)) to (2**(DATA_WIDTH-1))-1;
    variable vn_count : natural range 0 to ITERATIONS-1;
  begin  -- process proc_phase_inv
    if nRESET = '0' then                -- asynchronous reset (active low)
      vi_phase := 0;
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      if vn_count = 0 then
        if vi_phase + si_phase_inc > ci_pi then
          vi_phase := ci_two_pi - vi_phase;
        else
          vi_phase := vi_phase + si_phase_inc;
        end if;
        sv_phase <= conv_std_logic_vector(vi_phase);
      end if;

      if vn_count = 0 then
        vn_count := ITERATIONS-1;
        sl_cordic_dval_in <= '1';
      else
        vn_count := vn_count - 1;
        sl_cordic_dval_in <= '0'; 
      end if;

    end if;

  end process proc_phase_inc;

  sv_vector_null <= (others => '0');
  si_phase_inc <= conv_integer(PHASE_INC);

end behavioral;

