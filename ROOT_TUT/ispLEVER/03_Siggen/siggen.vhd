-------------------------------------------------------------------------------
-- Title      : CORDIC Signalgenerator
-- Project    : 
-------------------------------------------------------------------------------
-- File       : siggen.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-21
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This Module implements a Signalgenerator using the CORDIC
--              algorithm to achieve the rotation of a vector.
--              With standard settings, the PHASE_INCREMENT is added
--              approximately every mirosecond.
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

entity siggen is
  
  generic (
    DATA_WIDTH : positive := 16;
    ITERATIONS : positive := 10;
    ITER_WIDTH : positive := 4;
    CLK_DIV    : positive := 49);

  port (
    CLK_IN          : in  std_logic;
    nRESET          : in  std_logic;
    CE              : in  std_logic;
    PHASE_INCREMENT : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    SIGNAL_OUT      : out std_logic_vector(DATA_WIDTH-1 downto 0);
    DVAL            : out std_logic);

end siggen;

architecture behavioral of siggen is

  component cordic_full
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
      MODE     : in  std_logic;
      PARAM_M  : in  std_logic_vector(1 downto 0);
      X_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      Y_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      Z_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      X_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
      Y_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
      Z_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

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

  constant cn_quart_pi : natural := integer((MATH_PI*real(2**(DATA_WIDTH-3)))/real(4));
  constant cn_half_pi  : natural := integer((MATH_PI*real(2**(DATA_WIDTH-3)))/real(2));
  constant cn_pi       : natural := integer(MATH_PI*real(2**(DATA_WIDTH-3)));
  constant cn_two_pi   : natural := integer(MATH_PI*real(2**(DATA_WIDTH-2)));

  constant cv_scale_step : std_logic_vector(ITER_WIDTH-1 downto 0) := conv_std_logic_vector(ITERATIONS, ITER_WIDTH);

  signal sv_x, sv_y, sv_z : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_outsig        : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sl_cordic_dval_in, sl_cordic_dval_out               : std_logic;
  signal sl_debug_feed, sl_debug_corr_pos, sl_debug_corr_neg : std_logic;

  signal sv_scale_input : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- pragma synthesis_off
  signal sn_clk_count                           : natural;
  signal sl_feed                                : std_logic;
  signal sr_scale_input, sr_phase_inc, sr_phase : real;
  -- pragma synthesis_on
  
begin  -- behavioral

  assert conv_integer(PHASE_INCREMENT) >= 4 - cn_pi
    report "PHASE_INCREMENT to large. Please choose a smaller value."
    severity error;
  assert conv_integer(PHASE_INCREMENT) <= cn_pi - 4
                                          report "PHASE_INCREMENT to small. Please choose a larger value."
                                          severity error;
  assert (ITERATIONS + 2) <= CLK_DIV
                             report "CLK_DIV must be at least 2 larger than ITERATIONS, because we are not pipelined."
                             severity error;
  
  cordic_full_1 : cordic_full
    generic map (
      ITER_WIDTH   => ITER_WIDTH,
      ITERATIONS   => ITERATIONS,
      DATA_WIDTH   => DATA_WIDTH,
      SCALE_OUTPUT => false)
    port map (
      CLK_IN   => CLK_IN,
      nRESET   => nRESET,
      DVAL_IN  => sl_cordic_dval_in,
      DVAL_OUT => sl_cordic_dval_out,
      MODE     => '0',
      PARAM_M  => "00",
      X_IN     => sv_x,
      Y_IN     => sv_y,
      Z_IN     => sv_z,
      X_OUT    => sv_outsig,
      Y_OUT    => open,
      Z_OUT    => open);

  -- This is just for getting a vector that will have a length of 1 after
  -- cordic has finished without scaling. So we save one multiplier.
  cordic_lut_1 : cordic_lut
    generic map (
      DATA_WIDTH => DATA_WIDTH,
      ITER_WIDTH => ITER_WIDTH)
    port map (
      STEP        => cv_scale_step,
      ALPHA_I     => open,
      TAN_ALPHA_I => open,
      K_I         => open,
      K_G         => sv_scale_input);

  feed_cordic : process (CLK_IN, nRESET)
    variable vn_clk_count          : natural range 0 to CLK_DIV-1 := CLK_DIV-1;
    variable vl_feed, vl_feed_last : std_logic                    := '0';
    variable vi_x, vi_y, vi_z      : integer range -(2**DATA_WIDTH) to 2**DATA_WIDTH-1;
  begin  -- process feed_cordic
    if nRESET = '0' then                -- asynchronous reset (active low)
      vi_x         := conv_integer(sv_scale_input);
      vi_y         := 0;
      vi_z         := 0;
      vl_feed_last := '0';
      vl_feed      := '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      if vl_feed /= vl_feed_last then
        vi_x              := conv_integer(sv_scale_input);
        vi_y              := 0;
        vi_z              := vi_z + conv_integer(PHASE_INCREMENT);
        sl_cordic_dval_in <= '1';
        sl_debug_feed     <= '1';
      elsif vi_z >= cn_pi then
        -- We are running out of range in positive 
        vi_z              := vi_z - cn_two_pi;
        sl_debug_corr_pos <= '1';
      elsif vi_z <= -integer(cn_pi) then
        -- We are running out of range in negative
        vi_z              := vi_z + cn_two_pi;
        sl_debug_corr_neg <= '1';
      else
        sl_cordic_dval_in <= '0';
        sl_debug_feed     <= '0';
        sl_debug_corr_pos <= '0';
        sl_debug_corr_neg <= '0';
      end if;

      sv_x <= conv_std_logic_vector(vi_x, DATA_WIDTH);
      sv_y <= conv_std_logic_vector(vi_y, DATA_WIDTH);
      sv_z <= conv_std_logic_vector(vi_z, DATA_WIDTH);

      vl_feed_last := vl_feed;

      -- We make a new toogle signal
      if CE = '1' then
        
        if vn_clk_count = 0 then
          vn_clk_count := CLK_DIV-1;
          vl_feed      := not vl_feed;
          -- pragma synthesis_off
          sl_feed      <= vl_feed;
          -- pragma synthesis_on
        else
          vn_clk_count := vn_clk_count - 1;
        end if;

      end if;

      -- pragma synthesis_off
      sn_clk_count <= vn_clk_count;
      sr_phase     <= real(180)*real(vi_z)/real(cn_pi);
      -- pragma synthesis_on

      SIGNAL_OUT <= sv_outsig;
      
    end if;
  end process feed_cordic;

  DVAL <= sl_cordic_dval_out;
  
  -- pragma synthesis_off
  sr_scale_input <= real(conv_integer(sv_scale_input))/real(16384);
  sr_phase_inc   <= real(conv_integer(PHASE_INCREMENT))*real(180)/real(cn_pi);
  -- pragma synthesis_on
  
end behavioral;

