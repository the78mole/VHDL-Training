-------------------------------------------------------------------------------
-- Title      : Testbench for design "chatter_suppress"
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : chatter_suppress_tb.vhd
-- Author     : Daniel Glaser
-- Company    : LfTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-04
-- Last update: 2007-01-11
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LfTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-09-04  1.0      student36	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity chatter_suppress_tb is

end chatter_suppress_tb;

-------------------------------------------------------------------------------

architecture chatter_suppress_tb of chatter_suppress_tb is

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
  constant SUPPRESS_CLOCKS : positive := 8;

  -- component ports
  signal nRESET : std_logic;
  signal INPUT  : std_logic_vector(BUTTON_COUNT-1 downto 0);
  signal OUTPUT : std_logic_vector(BUTTON_COUNT-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

  constant chatter_timebase : time := 10 ps;

begin  -- chatter_suppress_tb

  -- component instantiation
  DUT: chatter_suppress
    generic map (
      BUTTON_COUNT    => BUTTON_COUNT,
      SUPPRESS_CLOCKS => SUPPRESS_CLOCKS)
    port map (
      CLK_IN => Clk,
      nRESET => nRESET,
      INPUT  => INPUT,
      OUTPUT => OUTPUT);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    INPUT <= (others => '0');
    nRESET <= '0';
    
    wait for 100 ns;
    nRESET <= '1';

    wait for 100 ns;

    INPUT <= "10000010";

    wait for 100 ns;

    INPUT <= "00001010";

    wait for 100 ns;

    INPUT <= "00000010";

    wait for 100 ns;

    INPUT <= "00001010";

    wait;
    
  end process WaveGen_Proc;  

end chatter_suppress_tb;

-------------------------------------------------------------------------------

configuration chatter_suppress_tb_chatter_suppress_tb_cfg of chatter_suppress_tb is
  for chatter_suppress_tb
  end for;
end chatter_suppress_tb_chatter_suppress_tb_cfg;

-------------------------------------------------------------------------------
