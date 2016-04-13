-------------------------------------------------------------------------------
-- Title      : Testbench for design "siggen"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : siggen_tb.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-22
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 LTE, FAU Erlangen-Nuremberg, Germany
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

-------------------------------------------------------------------------------

entity siggen_tb is

end siggen_tb;

-------------------------------------------------------------------------------

architecture siggen_tb_behavioral of siggen_tb is

  component siggen
    generic (
      DATA_WIDTH : positive;
      ITERATIONS : positive;
      ITER_WIDTH : positive;
      CLK_DIV    : positive);
    port (
      CLK_IN          : in  std_logic;
      nRESET          : in  std_logic;
      CE              : in  std_logic;
      PHASE_INCREMENT : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      SIGNAL_OUT      : out std_logic_vector(DATA_WIDTH-1 downto 0);
      DVAL            : out std_logic);
  end component;

  -- component generics
  constant DATA_WIDTH : positive := 16;
  constant ITERATIONS : positive := 10;
  constant ITER_WIDTH : positive := 4;
  constant CLK_DIV    : positive := 49;

  -- component ports
  signal CLK_IN          : std_logic;
  signal nRESET          : std_logic                               := '0';
  signal CE              : std_logic                               := '0';
  signal PHASE_INCREMENT : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal SIGNAL_OUT      : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DVAL            : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- siggen_tb_behavioral

  -- component instantiation
  DUT : siggen
    generic map (
      DATA_WIDTH => DATA_WIDTH,
      ITERATIONS => ITERATIONS,
      ITER_WIDTH => ITER_WIDTH,
      CLK_DIV    => CLK_DIV)
    port map (
      CLK_IN          => CLK_IN,
      nRESET          => nRESET,
      CE              => CE,
      PHASE_INCREMENT => PHASE_INCREMENT,
      SIGNAL_OUT      => SIGNAL_OUT,
      DVAL            => DVAL);

  -- clock generation
  Clk    <= not Clk after 10 ns;
  CLK_IN <= Clk;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    wait for 1 ns;
    nRESET          <= '1';
    wait for 20 ns;
    CE              <= '1';
    wait for 200 ns;
    PHASE_INCREMENT <= conv_std_logic_vector(515, DATA_WIDTH);  -- ~3.6° = ~10kHz
    wait;

    wait until Clk = '1';
  end process WaveGen_Proc;

  

end siggen_tb_behavioral;

-------------------------------------------------------------------------------

configuration siggen_tb_siggen_tb_behavioral_cfg of siggen_tb is
  for siggen_tb_behavioral
  end for;
end siggen_tb_siggen_tb_behavioral_cfg;

-------------------------------------------------------------------------------
