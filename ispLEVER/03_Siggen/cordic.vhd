-------------------------------------------------------------------------------
-- Title      : Cordic Base
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : cordic.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-23
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This is the beatiful cordic algorithm. It is implemented as a
--              parametrizable module. The iteration depth is variable as the
--              width of the data is.
--                It is completely written in VHDL and doesn't need any tools
--              from your fpga vendor, but it needs the math_real package at
--              synthesis time. If you can't cope with this, implement your
--              own, hand calculated lut or try to solve it in integer
--              arithmetic and you should be happy again.
--                The algorithm takes ITERATIONS+1 cycles to complete.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-01  1.0      sidaglas        Created
-- 2006-11-24  1.0      sidaglas        Finished
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
--use ieee.numeric_std.all;

entity cordic_base is
  
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
    MODE     : in  std_logic;                     -- unused
    PARAM_M  : in  std_logic_vector(1 downto 0);  -- unused
    X_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    Y_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    Z_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    X_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
    Y_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
    Z_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0));

end cordic_base;

architecture behavioral of cordic_base is

  --STARTL
  constant cn_scale_factor : natural := 2**(DATA_WIDTH-2);

  -----------------------------------------------------------------------------
  -- functions
  -----------------------------------------------------------------------------

  function rshift(ARG : signed; COUNT : natural) return signed is
    variable vs_tmp : signed(ARG'range);
    constant ci_lo  : integer := ARG'high - COUNT + 1;
  begin
    for n in ARG'high downto ci_lo loop
      vs_tmp(n) := ARG(ARG'high);
    end loop;
    for n in ARG'high - COUNT downto 0 loop
      vs_tmp(n) := ARG(n + COUNT);
    end loop;
    return vs_tmp;
  end function rshift;

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

  signal sv_cordic_step : std_logic_vector(ITER_WIDTH-1 downto 0);
  signal sv_alpha_i     : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_tan_aplha_i : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_k_i         : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_k_g         : std_logic_vector(DATA_WIDTH-1 downto 0);
--  signal sv_pings       : std_logic_vector(8 downto 0);

  signal si_x, si_y, si_z : integer
    range -(2**DATA_WIDTH) to 2**DATA_WIDTH-1 := 0;
  signal si_x_s, si_y_s, si_z_s : integer
    range -(2**DATA_WIDTH) to 2**DATA_WIDTH-1 := 0;
  signal si_alpha_i : integer
    range -(2**DATA_WIDTH) to 2**DATA_WIDTH-1 := 0;

  signal si_scale : integer range -(2**DATA_WIDTH) to 2**DATA_WIDTH-1;

  signal sn_iter_count : natural range 0 to ITERATIONS;
  signal sn_debug      : integer;

  signal sl_active : std_logic;

  signal sb_sigma_pos : boolean;
  --STOPL
  
begin  -- behavioral

  --STARTL
  cordic_lut_1 : cordic_lut
    generic map (
      DATA_WIDTH => DATA_WIDTH,
      ITER_WIDTH => ITER_WIDTH)
    port map (
      STEP        => sv_cordic_step,
      ALPHA_I     => sv_alpha_i,
      TAN_ALPHA_I => sv_tan_aplha_i,
      K_I         => sv_k_i,
      K_G         => sv_k_g);

  cordic_control : process (CLK_IN, nRESET)
    variable vl_dval : std_logic;
  begin  -- process cordic_control
    if nRESET = '0' then                -- asynchronous reset (active low)
      vl_dval   := '0';
      sl_active <= '0';
      DVAL_OUT  <= '0';
      X_OUT     <= (others => '0');
      Y_OUT     <= (others => '0');
      Z_OUT     <= (others => '0');
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      if DVAL_IN = '1' and vl_dval = '0' and sl_active = '0' then
        sl_active     <= '1';
        si_x          <= conv_integer(X_IN);
        si_y          <= conv_integer(Y_IN);
        si_z          <= conv_integer(Z_IN);
        sn_iter_count <= 0;
        DVAL_OUT      <= '0';
      elsif (sn_iter_count = ITERATIONS and SCALE_OUTPUT)
        or (sn_iter_count = ITERATIONS-1 and not SCALE_OUTPUT) then
        sl_active     <= '0';
        sn_iter_count <= 0;
      elsif sl_active = '1' then
        sn_iter_count <= sn_iter_count + 1;
      elsif sl_active = '0' then
        DVAL_OUT <= '1';
        X_OUT    <= conv_std_logic_vector(si_x, DATA_WIDTH);
        Y_OUT    <= conv_std_logic_vector(si_y, DATA_WIDTH);
        Z_OUT    <= conv_std_logic_vector(si_z, DATA_WIDTH);
      end if;

      if sl_active = '1' then
        if sn_iter_count = ITERATIONS then
          -- If no SCALING, we never get to sn_iter_count = ITERATIONS
          si_x <= si_x * si_scale / cn_scale_factor;
          si_y <= si_y * si_scale / cn_scale_factor;
          si_z <= si_z;
        else
          si_x <= si_x - conv_integer(rshift(signed(
            conv_std_logic_vector(si_y_s, DATA_WIDTH)), sn_iter_count));
          si_y <= si_y + conv_integer(rshift(signed(
            conv_std_logic_vector(si_x_s, DATA_WIDTH)), sn_iter_count));
          si_z <= si_z - si_z_s;
        end if;
      end if;

      vl_dval := DVAL_IN;
    end if;
  end process cordic_control;

  sn_debug <= cn_scale_factor;

  si_alpha_i <= conv_integer(sv_alpha_i);
  si_scale   <= conv_integer(sv_k_g);

  sb_sigma_pos <= true when si_z >= 0 else false;

  si_x_s <= si_x       when sb_sigma_pos else -si_x;
  si_y_s <= si_y       when sb_sigma_pos else -si_y;
  si_z_s <= si_alpha_i when sb_sigma_pos else -si_alpha_i;

  sv_cordic_step <= conv_std_logic_vector(sn_iter_count, ITER_WIDTH);
  --STOPL
  
end behavioral;
