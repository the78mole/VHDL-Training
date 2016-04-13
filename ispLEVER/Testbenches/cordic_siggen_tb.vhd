-------------------------------------------------------------------------------
-- Title      : Testbench for design "cordic_siggen"
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : cordic_siggen_tb.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-30
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
-- 2006-11-30  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

use ieee.math_real.all;

-------------------------------------------------------------------------------

entity cordic_siggen_tb is

end cordic_siggen_tb;

-------------------------------------------------------------------------------

architecture cordig_siggen_tb_behavioral of cordic_siggen_tb is

  component cordic_siggen
    generic (
      DATA_WIDTH : positive;
      ITERATIONS : positive;
      ITER_WIDTH : positive);
    port (
      CLK_IN    : in  std_logic;
      nRESET    : in  std_logic;
      PHASE_INC : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  -- component generics
  constant DATA_WIDTH : positive := 16;
  constant ITERATIONS : positive := 12;
  constant ITER_WIDTH : positive := 4;

  constant cn_angle_scale_factor : natural := 2**(DATA_WIDTH-3);

  constant cn_pi       : natural := integer(MATH_PI*real(cn_angle_scale_factor));
  constant cn_two_pi   : natural := integer(2*MATH_PI*real(cn_angle_scale_factor));
  constant cn_quart_pi : natural := integer(MATH_PI*real(cn_angle_scale_factor)/real(4));

  -- component ports
  signal CLK_IN    : std_logic;
  signal nRESET    : std_logic;
  signal PHASE_INC : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_OUT  : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- cordig_siggen_tb_behavioral

  -- component instantiation
  DUT : cordic_siggen
    generic map (
      DATA_WIDTH => DATA_WIDTH,
      ITERATIONS => ITERATIONS,
      ITER_WIDTH => ITER_WIDTH)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => PHASE_INC,
      DATA_OUT  => DATA_OUT);

  -- clock generation
  Clk    <= not Clk after 10 ns;
  CLK_IN <= Clk;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET    <= '0';
    wait for 100 ns;
    nRESET    <= '1';
    wait for 1 us;
    PHASE_INC <=
      wait until Clk = '1';
  end process WaveGen_Proc;

  

end cordig_siggen_tb_behavioral;

-------------------------------------------------------------------------------

configuration cordic_siggen_tb_cordig_siggen_tb_behavioral_cfg of cordic_siggen_tb is
  for cordig_siggen_tb_behavioral
  end for;
end cordic_siggen_tb_cordig_siggen_tb_behavioral_cfg;

-------------------------------------------------------------------------------
