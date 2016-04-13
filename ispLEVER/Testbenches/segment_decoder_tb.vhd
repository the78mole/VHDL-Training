-------------------------------------------------------------------------------
-- Title      : Testbench for design "segment_decoder"
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : segment_decoder_tb.vhd
-- Author     : Daniel Glaser
-- Company    : LfTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-04
-- Last update: 2007-01-14
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LfTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-09-04  1.0      student36       Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity segment_decoder_tb is

end segment_decoder_tb;

-------------------------------------------------------------------------------

architecture segment_decoder_tb of segment_decoder_tb is

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
  signal OE     : std_logic := '0';
  signal INPUT  : std_logic_vector(3 downto 0);
  signal OUTPUT : std_logic_vector(7 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- segment_decoder_tb

  -- component instantiation
  DUT : segment_decoder
    generic map (
      OUTPUT_ACTIVE_LOW => OUTPUT_ACTIVE_LOW,
      REGISTER_OUTPUTS  => REGISTER_OUTPUTS)
    port map (
      CLK_IN => Clk,
      nRESET => nRESET,
      OE     => OE,
      INPUT  => INPUT,
      OUTPUT => OUTPUT);

  -- clock generation
  Clk    <= not Clk after 10 ns;
  CLK_IN <= Clk;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET <= '0';

    wait for 1 ns;
    nRESET <= '1';
    OE     <= '1';
    INPUT  <= "0000";

    wait for 20 ns;

    for i in 0 to 15 loop
      INPUT <= INPUT + 1;
      wait for 20 ns;
    end loop;  -- i

    wait for 20 ns;
    OE <= '0';

    wait;
  end process WaveGen_Proc;

end segment_decoder_tb;

-------------------------------------------------------------------------------

configuration segment_decoder_tb_segment_decoder_tb_cfg of segment_decoder_tb is
  for segment_decoder_tb
  end for;
end segment_decoder_tb_segment_decoder_tb_cfg;

-------------------------------------------------------------------------------
