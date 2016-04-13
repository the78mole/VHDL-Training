-------------------------------------------------------------------------------
-- Title      : Multiplexer
-- Project    : ADS-Praktikum - 01_Multiplexer
-------------------------------------------------------------------------------
-- File       : multiplexer.vhd
-- Author     : Daniel Glaser
-- Company    : Lehrstuhl für Technische Elektronik, Universität Erlangen
-- Created    : 2006-06-27
-- Last update: 2006-07-10
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module defines an 8-bit multiplexer for digital audio data
-------------------------------------------------------------------------------
-- Copyright (c) 2006 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-06-27  1.0      sidaglas        Created
-- 2006-06-27                           Finished
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;



entity multiplexer is

  port (
  -- Musterloesung Anfang
    sine_5kHz : in std_logic_vector(7 downto 0);
    sine_7kHz : in std_logic_vector(7 downto 0);
    adc_data  : in std_logic_vector(7 downto 0);
    dac_data : out std_logic_vector(7 downto 0);
  -- Musterloesung Ende
    sel_s1 : in std_logic;
    sel_s2 : in std_logic);

end;



architecture multiplexer_behavioral of multiplexer is
begin

  -- Musterloesung Anfang

  dac_data <= sine_5kHz when sel_s1 = '0' and sel_s2 = '1' else
              sine_7kHz when sel_s1 = '0' and sel_s2 = '1' else
              adc_data  when sel_s1 = '1' and sel_s2 = '0' else (others => '0');

  -- Musterloesung Ende

end multiplexer_behavioral;


