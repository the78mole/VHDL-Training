-------------------------------------------------------------------------------
-- Title      : Testbench for design "segment_decoder"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : segment_decoder_tb.vhd
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

entity segment_decoder_tb is

end segment_decoder_tb;

-------------------------------------------------------------------------------

architecture segment_decoder_tb_behavioral of segment_decoder_tb is

  component segment_decoder
    generic (
      OUTPUT_ACTIVE_LOW : boolean;
      REGISTER_OUTPUTS  : boolean);
    port (
      CLK_IN : in  std_logic;
      nRESET : in  std_logic;
      OE     : in  std_logic;
      INPUT  : in  std_logic_vector(3 downto 0);
      OUTPUT : out std_logic_vector(7 downto 0));
  end component;

  -- component generics
  constant OUTPUT_ACTIVE_LOW : boolean := true;
  constant REGISTER_OUTPUTS  : boolean := true;

  -- component ports
  signal CLK_IN : std_logic;
  signal nRESET : std_logic;
  signal OE     : std_logic;
  signal INPUT  : std_logic_vector(3 downto 0);
  signal OUTPUT : std_logic_vector(7 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- segment_decoder_tb_behavioral

  -- component instantiation
  DUT: segment_decoder
    generic map (
      OUTPUT_ACTIVE_LOW => OUTPUT_ACTIVE_LOW,
      REGISTER_OUTPUTS  => REGISTER_OUTPUTS)
    port map (
      CLK_IN => CLK_IN,
      nRESET => nRESET,
      OE     => OE,
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

  

end segment_decoder_tb_behavioral;

-------------------------------------------------------------------------------

configuration segment_decoder_tb_segment_decoder_tb_behavioral_cfg of segment_decoder_tb is
  for segment_decoder_tb_behavioral
  end for;
end segment_decoder_tb_segment_decoder_tb_behavioral_cfg;

-------------------------------------------------------------------------------
