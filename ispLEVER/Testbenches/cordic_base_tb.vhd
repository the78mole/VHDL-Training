-------------------------------------------------------------------------------
-- Title      : Testbench for design "cordic_base"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : cordic_base_tb.vhd
-- Author     : 
-- Company    : 
-- Created    : 2006-11-01
-- Last update: 2007-01-22
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

-- pragma synthesis_off
use ieee.math_real.all;
-- pragma synthesis_on

-------------------------------------------------------------------------------

entity cordic_base_tb is

end cordic_base_tb;

-------------------------------------------------------------------------------

architecture cordic_base_tb_behavioral of cordic_base_tb is

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
      MODE     : in  std_logic;
      PARAM_M  : in  std_logic_vector(1 downto 0);
      X_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      Y_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      Z_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      X_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
      Y_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
      Z_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  -- component generics
  constant ITER_WIDTH   : positive := 4;
  constant ITERATIONS   : positive := 10;
  constant DATA_WIDTH   : positive := 16;
  constant SCALE_OUTPUT : boolean  := true;

  -- component ports
  signal CLK_IN   : std_logic;
  signal nRESET   : std_logic                               := '0';
  signal DVAL_IN  : std_logic                               := '0';
  signal DVAL_OUT : std_logic;
  signal MODE     : std_logic                               := '0';
  signal PARAM_M  : std_logic_vector(1 downto 0)            := (others => '0');
  signal X_IN     : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal Y_IN     : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal Z_IN     : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal X_OUT    : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal Y_OUT    : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal Z_OUT    : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

  -- clock
  signal Clk                     : std_logic := '1';
  constant cn_scale_factor       : natural   := 2**(DATA_WIDTH-2);
  constant cn_angle_scale_factor : natural   := 2**(DATA_WIDTH-3);

  -- pragma synthesis_off
  signal X_IN_REAL : real := 0.0;
  signal Y_IN_REAL : real := 0.0;
  signal Z_IN_REAL : real := 0.0;
  signal Z_IN_DEGREE : real := 0.0;
  signal X_OUT_REAL : real := 0.0;
  signal Y_OUT_REAL : real := 0.0;
  signal Z_OUT_REAL : real := 0.0;
  signal Z_OUT_DEGREE : real := 0.0;
  -- pragma synthesis_on

begin  -- cordic_base_tb_behavioral

  -- component instantiation
  DUT : cordic_base
    generic map (
      ITER_WIDTH   => ITER_WIDTH,
      ITERATIONS   => ITERATIONS,
      DATA_WIDTH   => DATA_WIDTH,
      SCALE_OUTPUT => SCALE_OUTPUT)
    port map (
      CLK_IN   => CLK_IN,
      nRESET   => nRESET,
      DVAL_IN  => DVAL_IN,
      DVAL_OUT => DVAL_OUT,
      MODE     => MODE,
      PARAM_M  => PARAM_M,
      X_IN     => X_IN,
      Y_IN     => Y_IN,
      Z_IN     => Z_IN,
      X_OUT    => X_OUT,
      Y_OUT    => Y_OUT,
      Z_OUT    => Z_OUT);

  -- clock generation
  Clk    <= not Clk after 10 ns;
  CLK_IN <= Clk;

  -- pragma synthesis_off
  X_IN_REAL <= real(conv_integer(X_IN)) / real(cn_scale_factor);
  Y_IN_REAL <= real(conv_integer(Y_IN)) / real(cn_scale_factor);
  Z_IN_REAL <= real(conv_integer(Z_IN)) / real(cn_angle_scale_factor);
  Z_IN_DEGREE <= (real(180) * Z_IN_REAL) / MATH_PI;
  X_OUT_REAL <= real(conv_integer(X_OUT)) / real(cn_scale_factor);
  Y_OUT_REAL <= real(conv_integer(Y_OUT)) / real(cn_scale_factor);
  Z_OUT_REAL <= real(conv_integer(Z_OUT)) / real(cn_angle_scale_factor);
  Z_OUT_DEGREE <= (real(180) * Z_OUT_REAL) / MATH_PI;
  -- pragma synthesis_on
  
  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET <= '0';
    wait for 1 ns;
    nRESET <= '1';

    X_IN <= conv_std_logic_vector(8192, DATA_WIDTH);  -- 0.5
    Y_IN <= conv_std_logic_vector(1024, DATA_WIDTH);  -- 0.0625
    Z_IN <= conv_std_logic_vector(512, DATA_WIDTH);   -- 0.0625 ~ 3.58°

    wait for 20 ns;

    DVAL_IN <= '1';

    wait for 20 ns;

    DVAL_IN <= '0';

    wait for 439 ns;

    X_IN <= conv_std_logic_vector(8192,DATA_WIDTH);  -- 0.5
    Y_IN <= conv_std_logic_vector(8192,DATA_WIDTH);  -- 0.5
    Z_IN <= conv_std_logic_vector(12867,DATA_WIDTH);  -- 1.5707 ~ 90°

    wait for 20 ns;                    -- We are at 500 ns

    DVAL_IN <= '1';

    wait for 20 ns;

    DVAL_IN <= '0';
    
    wait for 440 ns;

    X_IN <= conv_std_logic_vector(-8192,DATA_WIDTH);  -- 0.5
    Y_IN <= conv_std_logic_vector(-8192,DATA_WIDTH);  -- 0.5
    Z_IN <= conv_std_logic_vector(4289,DATA_WIDTH);  -- 1.5707 ~ 90°

    wait for 20 ns;                    -- We are at 500 ns

    DVAL_IN <= '1';

    wait for 20 ns;

    DVAL_IN <= '0';

    wait for 440 ns;

    X_IN <= conv_std_logic_vector(-8192,DATA_WIDTH);  -- 0.5
    Y_IN <= conv_std_logic_vector(8192,DATA_WIDTH);  -- 0.5
    Z_IN <= conv_std_logic_vector(-8289,DATA_WIDTH);  -- 1.5707 ~ 90°

    wait for 20 ns;                    -- We are at 500 ns

    DVAL_IN <= '1';

    wait for 20 ns;

    DVAL_IN <= '0';

    wait;
  end process WaveGen_Proc;

  

end cordic_base_tb_behavioral;

-------------------------------------------------------------------------------

configuration cordic_base_tb_cordic_base_tb_behavioral_cfg of cordic_base_tb is
  for cordic_base_tb_behavioral
  end for;
end cordic_base_tb_cordic_base_tb_behavioral_cfg;

-------------------------------------------------------------------------------
