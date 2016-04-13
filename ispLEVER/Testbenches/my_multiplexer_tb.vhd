-------------------------------------------------------------------------------
-- Title      : Testbench for design "my_multiplexer"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : my_multiplexer_tb.vhd
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
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity my_multiplexer_tb is

end my_multiplexer_tb;

-------------------------------------------------------------------------------

architecture my_multiplexer_tb_behavioral of my_multiplexer_tb is

  component my_multiplexer
    port (
      sine_5kHz : in  std_logic_vector(7 downto 0);
      sine_7kHz : in  std_logic_vector(7 downto 0);
      adc_data  : in  std_logic_vector(7 downto 0);
      dac_data  : out std_logic_vector(7 downto 0);
      sel_s1    : in  std_logic;
      sel_s2    : in  std_logic);
  end component;

  -- component ports
  signal sine_5kHz : std_logic_vector(7 downto 0) := (others => '0');
  signal sine_7kHz : std_logic_vector(7 downto 0) := (others => '0');
  signal adc_data  : std_logic_vector(7 downto 0) := (others => '0');
  signal dac_data  : std_logic_vector(7 downto 0) := (others => '0');
  signal sel_s1    : std_logic;
  signal sel_s2    : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- my_multiplexer_tb_behavioral

  -- component instantiation
  DUT: my_multiplexer
    port map (
      sine_5kHz => sine_5kHz,
      sine_7kHz => sine_7kHz,
      adc_data  => adc_data,
      dac_data  => dac_data,
      sel_s1    => sel_s1,
      sel_s2    => sel_s2);

  -- clock generation
  Clk <= not Clk after 10 ns;

  Signal_gen: process
  begin  -- process Signal_gen
    sine_7kHz <= sine_7kHz + "00000110";
    sine_5kHz <= sine_5kHz + "00000100";
    adc_data <= adc_data + "11011011";
    wait for 1 ns;
  end process Signal_gen;
  
  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    sel_s1 <= '0';
    sel_s2 <= '0';
    wait for 100 ns;
    sel_s1 <= '1';
    wait for 100 ns;
    sel_s1 <= '0';
    sel_s2 <= '1';
    wait for 100 ns;
    sel_s1 <= '1';
    wait for 100 ns;
  end process WaveGen_Proc;
  
end my_multiplexer_tb_behavioral;

-------------------------------------------------------------------------------

configuration my_multiplexer_tb_my_multiplexer_tb_behavioral_cfg of my_multiplexer_tb is
  for my_multiplexer_tb_behavioral
  end for;
end my_multiplexer_tb_my_multiplexer_tb_behavioral_cfg;

-------------------------------------------------------------------------------
