-------------------------------------------------------------------------------
-- Title      : Cordic
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : cordic.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-16
-- Last update: 2006-11-29
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
-- 2006-11-16  1.0      sidaglas        Created
-- 2006-11-24  1.0      sidaglas        Finished
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity cordic is
  
  generic (
    ITER_WIDTH : positive := 4;
    ITERATIONS : positive := 10;
    DATA_WIDTH : positive := 8;
    SCALE_OUTPUT : boolean := true);

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

end cordic;

architecture behavioral of cordic is

  constant cl_CORDIC_MODE_ROTATION  : std_logic := '0';
  constant cl_CORDIC_MODE_VECTORING : std_logic := '1';

  subtype tv_data is std_logic_vector(DATA_WIDTH-1 downto 0);
  subtype ti_data is integer range -(2**(DATA_WIDTH)) to ((2**(DATA_WIDTH))-1);
  -- ti_data must be one bit larger than input to compensate the bigger size of
  -- the uncorrected output, so 2**DATA_WIDTH is right not 2**DATA_WIDTH-1

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

  component barrel_shifter
    generic (
      USE_MULTIPLIER : boolean;
      AMOUNT_WIDTH   : positive;
      DATA_WIDTH     : positive);
    port (
      SIGNED_SHIFT : in  std_logic;
      SHIFT_AMOUNT : in  std_logic_vector(AMOUNT_WIDTH-1 downto 0);
      DATA_IN      : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT     : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  signal sv_bs_shift_amount : std_logic_vector(3 downto 0);
  signal sv_bs_data_in_x      : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_bs_data_out_x     : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_bs_data_in_y      : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_bs_data_out_y     : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_bs_data_in_z      : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_bs_data_out_z     : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sv_cordic_step : std_logic_vector(ITER_WIDTH-1 downto 0);
  signal sv_alpha_i     : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_tan_aplha_i : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_k_i         : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_k_g         : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal si_k_g       : natural range 0 to (2**DATA_WIDTH)-1;
  signal sn_iter_step : natural range 0 to ITERATIONS;

  signal si_x, si_x_temp, si_x_sig : integer range -(2**DATA_WIDTH) to (2**DATA_WIDTH)-1;
  signal si_y, si_y_temp, si_y_sig : integer range -(2**DATA_WIDTH) to (2**DATA_WIDTH)-1;
  signal si_z, si_z_temp, si_z_sig : integer range -(2**DATA_WIDTH) to (2**DATA_WIDTH)-1;

  signal si_m : integer range -1 to 1;

  signal sb_dir_positive, sb_x_add_nsub : boolean;
  signal sb_active, sb_start            : boolean;
  signal sb_rot_nvec                    : boolean;
  
begin  -- behavioral

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

  barrel_shifter_x : barrel_shifter
    generic map (
      USE_MULTIPLIER => true,
      AMOUNT_WIDTH   => 4,
      DATA_WIDTH     => DATA_WIDTH)
    port map (
      SIGNED_SHIFT => '1',
      SHIFT_AMOUNT => sv_bs_shift_amount,
      DATA_IN      => sv_bs_data_in_x,
      DATA_OUT     => sv_bs_data_out_x);

  barrel_shifter_y : barrel_shifter
    generic map (
      USE_MULTIPLIER => true,
      AMOUNT_WIDTH   => 4,
      DATA_WIDTH     => 8)
    port map (
      SIGNED_SHIFT => '1',
      SHIFT_AMOUNT => sv_bs_shift_amount,
      DATA_IN      => sv_bs_data_in_y,
      DATA_OUT     => sv_bs_data_out_y);

  barrel_shifter_z : barrel_shifter
    generic map (
      USE_MULTIPLIER => true,
      AMOUNT_WIDTH   => 4,
      DATA_WIDTH     => 8)
    port map (
      SIGNED_SHIFT => '1',
      SHIFT_AMOUNT => sv_bs_shift_amount,
      DATA_IN      => sv_bs_data_in_z,
      DATA_OUT     => sv_bs_data_out_z);

  
  cordic_control : process (CLK_IN, nRESET)
    variable vl_dval : std_logic;
  begin  -- process cordic_control
    if nRESET = '0' then                -- asynchronous reset (active low)
      sb_active       <= true;
      vl_dval         := '1';
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      
      if vl_dval = '0' and DVAL_IN = '1' and not sb_active then
        
        si_x         <= conv_integer(X_IN);
        si_y         <= conv_integer(Y_IN);
        si_z         <= conv_integer(Z_IN);
        sb_active    <= true;
        sn_iter_step <= 0;
        
      else
        
        if sb_active and sn_iter_step /= ITERATIONS then
          if si_m /= 0 then
            si_x <= si_x - si_x_sig;
          else
            si_x <= si_x;
          end if;
          si_y <= si_y + si_y_sig;
          si_z <= si_z - si_z_sig;
          if (sn_iter_step = ITERATIONS-1  and SCALE_OUTPUT)
            or (sn_iter_step = ITERATIONS and not SCALE_OUTPUT)  then
--          if si_m /= 0 then
--            X_OUT <= si_x - si_x_sig;
--          else
--            X_OUT <= si_x;
--          end if;
--          Y_OUT <= si_y + si_y_sig;
--          Z_OUT <= si_z - si_z_sig;
            sb_active <= false;
            si_k_g    <= conv_integer("0" & sv_k_g);
          end if;
        elsif sn_iter_step = ITERATIONS and SCALE_OUTPUT then
          X_OUT <= conv_std_logic_vector((si_x * si_k_g)/(2**DATA_WIDTH), DATA_WIDTH);
          Y_OUT <= conv_std_logic_vector((si_y * si_k_g)/(2**DATA_WIDTH), DATA_WIDTH);
          Z_OUT <= conv_std_logic_vector((si_z * si_k_g)/(2**DATA_WIDTH), DATA_WIDTH);
        end if;

        if sb_active then
          sn_iter_step <= sn_iter_step + 1;
        else
          sn_iter_step <= 0;
        end if;
        
      end if;
      vl_dval := DVAL_IN;
    end if;
  end process cordic_control;

  -- purpose: We register the settings to hold them constant while working.
  --          We also get timing advantages, because we will have the
  --          information stable when they are needed.
  -- type   : sequential
  reg_parameters : process (CLK_IN, nRESET)
  begin  -- process reg_parameters
    if nRESET = '0' then                -- asynchronous reset (active low)
      si_m        <= 0;
      sb_rot_nvec <= true;
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if not sb_active then
        si_m <= conv_integer(PARAM_M);
        if MODE = cl_CORDIC_MODE_ROTATION then
          -- CORDIC_MODE_ROTATION
          sb_rot_nvec <= true;
        else
          -- CORDIC_MODE_VECTORING
          sb_rot_nvec <= false;
        end if;
      end if;
    end if;
  end process reg_parameters;

  sb_dir_positive <= true when
                     ((si_z >= 0) and sb_rot_nvec) or
                     ((si_y >= 0) and not sb_rot_nvec) else false;
  
  sb_x_add_nsub <= true when
                   ((si_m = 1) and sb_dir_positive) or
                   ((si_m = -1) and not sb_dir_positive)
                   else false;

  sv_bs_shift_amount <= conv_std_logic_vector(sn_iter_step, ITER_WIDTH);

  si_x_temp <= conv_integer(sv_bs_data_out_x);
  si_y_temp <= conv_integer(sv_bs_data_out_y);
  si_z_temp <= conv_integer(sv_bs_data_out_z);

  sv_bs_data_in_x <= conv_std_logic_vector(si_x, DATA_WIDTH);
  sv_bs_data_in_y <= conv_std_logic_vector(si_y, DATA_WIDTH);
  sv_bs_data_in_z <= sv_tan_aplha_i;

--  si_z_temp <= conv_integer(sv_tan_aplha_i)/(2**sn_iter_step);

  si_x_sig <= si_x_temp when sb_x_add_nsub   else -si_x_temp;
  si_y_sig <= si_y_temp when sb_dir_positive else -si_y_temp;
  si_z_sig <= si_z_temp when sb_dir_positive else -si_z_temp;
  
end behavioral;
