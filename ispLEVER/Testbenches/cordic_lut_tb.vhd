-------------------------------------------------------------------------------
-- Title      : Testbench for design "cordic_lut"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : cordic_lut_tb.vhd
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
-- 2006-11-01  1.0      sidaglas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity cordic_lut_tb is

end cordic_lut_tb;

-------------------------------------------------------------------------------

architecture cordic_lut_tb_behavioral of cordic_lut_tb is

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

  -- component generics
  constant DATA_WIDTH : positive := 16;
  constant ITER_WIDTH : positive := 4;

  -- component ports
  signal STEP        : std_logic_vector(ITER_WIDTH-1 downto 0) := (others => '0');
  signal ALPHA_I     : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal TAN_ALPHA_I : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal K_I         : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal K_G         : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- cordic_lut_tb_behavioral

  -- component instantiation
  DUT: cordic_lut
    generic map (
      DATA_WIDTH => DATA_WIDTH,
      ITER_WIDTH => ITER_WIDTH)
    port map (
      STEP        => STEP,
      ALPHA_I     => ALPHA_I,
      TAN_ALPHA_I => TAN_ALPHA_I,
      K_I         => K_I,
      K_G         => K_G);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    wait for 60 ns;
    STEP <= STEP + "0001";
  end process WaveGen_Proc;

  

end cordic_lut_tb_behavioral;

-------------------------------------------------------------------------------

configuration cordic_lut_tb_cordic_lut_tb_behavioral_cfg of cordic_lut_tb is
  for cordic_lut_tb_behavioral
  end for;
end cordic_lut_tb_cordic_lut_tb_behavioral_cfg;

-------------------------------------------------------------------------------
