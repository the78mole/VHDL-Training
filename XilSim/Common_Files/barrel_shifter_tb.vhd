-------------------------------------------------------------------------------
-- Title      : Testbench for design "barrel_shifter"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : barrel_shifter_tb.vhd
-- Author     : 
-- Company    : 
-- Created    : 2007-01-11
-- Last update: 2007-01-11
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2007-01-11  1.0      sidaglas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity barrel_shifter_tb is

end barrel_shifter_tb;

-------------------------------------------------------------------------------

architecture barrel_shifter_tb_behavioral of barrel_shifter_tb is

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

  -- component generics
  constant USE_MULTIPLIER : boolean  := true;
  constant AMOUNT_WIDTH   : positive := 4;
  constant DATA_WIDTH     : positive := 8;

  -- component ports
  signal SIGNED_SHIFT : std_logic;
  signal SHIFT_AMOUNT : std_logic_vector(AMOUNT_WIDTH-1 downto 0);
  signal DATA_IN      : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_OUT     : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- barrel_shifter_tb_behavioral

  -- component instantiation
  DUT: barrel_shifter
    generic map (
      USE_MULTIPLIER => USE_MULTIPLIER,
      AMOUNT_WIDTH   => AMOUNT_WIDTH,
      DATA_WIDTH     => DATA_WIDTH)
    port map (
      SIGNED_SHIFT => SIGNED_SHIFT,
      SHIFT_AMOUNT => SHIFT_AMOUNT,
      DATA_IN      => DATA_IN,
      DATA_OUT     => DATA_OUT);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    
    wait until Clk = '1';
  end process WaveGen_Proc;

  

end barrel_shifter_tb_behavioral;

-------------------------------------------------------------------------------

configuration barrel_shifter_tb_barrel_shifter_tb_behavioral_cfg of barrel_shifter_tb is
  for barrel_shifter_tb_behavioral
  end for;
end barrel_shifter_tb_barrel_shifter_tb_behavioral_cfg;

-------------------------------------------------------------------------------
