-------------------------------------------------------------------------------
-- Title      : Testbench for design "bargraph_decoder"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : bargraph_decoder_tb.vhd
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

entity bargraph_decoder_tb is

end bargraph_decoder_tb;

-------------------------------------------------------------------------------

architecture bargraph_decoder_tb_behavioral of bargraph_decoder_tb is

  component bargraph_decoder
    generic (
      BAR_LIGHT_COUNT   : positive;
      OUTPUT_ACTIVE_LOW : boolean);
    port (
      CLK_IN : in  std_logic;
      nRESET : in  std_logic;
      OE     : in  std_logic;
      DEC_EN : in  std_logic;
      INPUT  : in  std_logic_vector(7 downto 0);
      OUTPUT : out std_logic_vector(7 downto 0));
  end component;

  -- component generics
  constant BAR_LIGHT_COUNT   : positive := 1;
  constant OUTPUT_ACTIVE_LOW : boolean  := true;

  -- component ports
  signal CLK_IN : std_logic;
  signal nRESET : std_logic;
  signal OE     : std_logic;
  signal DEC_EN : std_logic;
  signal INPUT  : std_logic_vector(7 downto 0);
  signal OUTPUT : std_logic_vector(7 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- bargraph_decoder_tb_behavioral

  -- component instantiation
  DUT: bargraph_decoder
    generic map (
      BAR_LIGHT_COUNT   => BAR_LIGHT_COUNT,
      OUTPUT_ACTIVE_LOW => OUTPUT_ACTIVE_LOW)
    port map (
      CLK_IN => CLK_IN,
      nRESET => nRESET,
      OE     => OE,
      DEC_EN => DEC_EN,
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

  

end bargraph_decoder_tb_behavioral;

-------------------------------------------------------------------------------

configuration bargraph_decoder_tb_bargraph_decoder_tb_behavioral_cfg of bargraph_decoder_tb is
  for bargraph_decoder_tb_behavioral
  end for;
end bargraph_decoder_tb_bargraph_decoder_tb_behavioral_cfg;

-------------------------------------------------------------------------------
