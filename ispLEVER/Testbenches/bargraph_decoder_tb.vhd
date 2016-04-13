-------------------------------------------------------------------------------
-- Title      : Testbench for design "bargraph_decoder"
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : bargraph_decoder_tb.vhd
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
-- 2006-09-04  1.0      student36       Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

-------------------------------------------------------------------------------

entity bargraph_decoder_tb is

end bargraph_decoder_tb;

-------------------------------------------------------------------------------

architecture bargraph_decoder_tb of bargraph_decoder_tb is

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
  constant BAR_LIGHT_COUNT   : positive := 2;
  constant OUTPUT_ACTIVE_LOW : boolean  := false;

  -- component ports
  signal CLK_IN : std_logic;
  signal nRESET : std_logic;
  signal OE     : std_logic;
  signal DEC_EN : std_logic;
  signal INPUT  : std_logic_vector(7 downto 0);
  signal OUTPUT : std_logic_vector(7 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- bargraph_decoder_tb

  -- component instantiation
  DUT : bargraph_decoder
    generic map (
      BAR_LIGHT_COUNT   => BAR_LIGHT_COUNT,
      OUTPUT_ACTIVE_LOW => OUTPUT_ACTIVE_LOW)
    port map (
      CLK_IN => Clk,
      nRESET => nRESET,
      OE     => OE,
      DEC_EN => DEC_EN,
      INPUT  => INPUT,
      OUTPUT => OUTPUT);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET <= '0';
    OE <= '1';
    DEC_EN <= '1';
    INPUT  <= (others => '0');
    wait for 100 ns;

    nRESET <= '1';
    wait for 300 ns;

    INPUT <= "00000001";
    wait for 1 us;

    for i in 0 to 7 loop
      INPUT(7 downto 0) <= INPUT(6 downto 0) & '0';
      wait for 1 us;
    end loop;  -- i

    INPUT <= "00001111";
    wait for 1 us;

    for i in 0 to 5 loop
      INPUT(7 downto 1) <= INPUT(6 downto 0);
      wait for 1 us;
    end loop;  -- i

    wait;
  end process WaveGen_Proc;

end bargraph_decoder_tb;

-------------------------------------------------------------------------------

configuration bargraph_decoder_tb_bargraph_decoder_tb_cfg of bargraph_decoder_tb is
  for bargraph_decoder_tb
  end for;
end bargraph_decoder_tb_bargraph_decoder_tb_cfg;

-------------------------------------------------------------------------------
