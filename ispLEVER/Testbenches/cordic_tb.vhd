-------------------------------------------------------------------------------
-- Title      : Testbench for design "cordic"
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : cordic_tb.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-29
-- Last update: 2006-11-30
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-11-29  1.0      sidaglas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

use ieee.math_real.all;

-------------------------------------------------------------------------------

entity cordic_tb is

end cordic_tb;

-------------------------------------------------------------------------------

architecture cordic_tb_behavioral of cordic_tb is

  constant cn_quart_pi : natural := integer((MATH_PI*real(2**(DATA_WIDTH-3)))/real(4));
  constant cn_half_pi  : natural := integer((MATH_PI*real(2**(DATA_WIDTH-3)))/real(2));

  component cordic
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
  signal nRESET   : std_logic;
  signal DVAL_IN  : std_logic;
  signal DVAL_OUT : std_logic;
  signal MODE     : std_logic;
  signal PARAM_M  : std_logic_vector(1 downto 0);
  signal X_IN     : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal Y_IN     : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal Z_IN     : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal X_OUT    : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal Y_OUT    : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal Z_OUT    : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- cordic_tb_behavioral

  -- component instantiation
  DUT: cordic
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
  Clk <= not Clk after 10 ns;
  CLK_IN <= Clk;
  
  -- waveform generation
  WaveGen_Proc: process
  begin    
    -- insert signal assignments here
    nRESET <= '0';
    X_IN <= (others => '0');
    Y_IN <= (others => '0');
    Z_IN <= (others => '0');
    MODE <= '0';
    PARAM_M <= "01";
    wait for 10 ns;
    DVAL_IN <= '0';
    wait for 10 ns;
    nRESET <= '1';
    wait for 100 ns;
    X_IN <= conv_std_logic_vector(-12456, DATA_WIDTH);
    Y_IN <= conv_std_logic_vector(-1090, DATA_WIDTH);
    Z_IN <= conv_std_logic_vector(cn_half_pi, DATA_WIDTH);
    wait for 50 ns;
    DVAL_IN <= '1';
    wait for 40 ns;
    DVAL_IN <= '0';
    wait;
  end process WaveGen_Proc;

  

end cordic_tb_behavioral;

-------------------------------------------------------------------------------

configuration cordic_tb_cordic_tb_behavioral_cfg of cordic_tb is
  for cordic_tb_behavioral
  end for;
end cordic_tb_cordic_tb_behavioral_cfg;

-------------------------------------------------------------------------------
