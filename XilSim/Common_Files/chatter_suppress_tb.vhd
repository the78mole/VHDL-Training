-------------------------------------------------------------------------------
-- Title      : Testbench for design "chatter_suppress"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : chatter_suppress_tb.vhd
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

entity chatter_suppress_tb is

end chatter_suppress_tb;

-------------------------------------------------------------------------------

architecture chatter_suppress_tb_behavioral of chatter_suppress_tb is

  component chatter_suppress
    generic (
      BUTTON_COUNT    : positive;
      SUPPRESS_CLOCKS : positive);
    port (
      CLK_IN : in  std_logic;
      nRESET : in  std_logic;
      INPUT  : in  std_logic_vector(BUTTON_COUNT-1 downto 0);
      OUTPUT : out std_logic_vector(BUTTON_COUNT-1 downto 0));
  end component;

  -- component generics
  constant BUTTON_COUNT    : positive := 8;
  constant SUPPRESS_CLOCKS : positive := 64;

  -- component ports
  signal CLK_IN : std_logic;
  signal nRESET : std_logic;
  signal INPUT  : std_logic_vector(BUTTON_COUNT-1 downto 0);
  signal OUTPUT : std_logic_vector(BUTTON_COUNT-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- chatter_suppress_tb_behavioral

  -- component instantiation
  DUT: chatter_suppress
    generic map (
      BUTTON_COUNT    => BUTTON_COUNT,
      SUPPRESS_CLOCKS => SUPPRESS_CLOCKS)
    port map (
      CLK_IN => CLK_IN,
      nRESET => nRESET,
      INPUT  => INPUT,
      OUTPUT => OUTPUT);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    
    wait until Clk = '1';
  end process WaveGen_Proc;

  

end chatter_suppress_tb_behavioral;

-------------------------------------------------------------------------------

configuration chatter_suppress_tb_chatter_suppress_tb_behavioral_cfg of chatter_suppress_tb is
  for chatter_suppress_tb_behavioral
  end for;
end chatter_suppress_tb_chatter_suppress_tb_behavioral_cfg;

-------------------------------------------------------------------------------
