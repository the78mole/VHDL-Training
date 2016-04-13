-------------------------------------------------------------------------------
-- Title      : Multiplexer
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : multiplexer.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-06-27
-- Last update: 2006-11-23
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module defines an 8-bit multiplexer for digital audio data
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-06-27  1.0      sidaglas        Created
-- 2006-11-10  1.1      sidaglas        Fixed entity name to something not
--                                      conflicting with Project name. This
--                                      seemed to raise some error
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity my_multiplexer is

  port (
    sine_5kHz : in std_logic_vector(7 downto 0);
    sine_7kHz : in std_logic_vector(7 downto 0);
    adc_data  : in std_logic_vector(7 downto 0);
    dac_data : out std_logic_vector(7 downto 0);

    sel_s1 : in std_logic;
    sel_s2 : in std_logic);

end my_multiplexer;

architecture multiplexer_behavioral of my_multiplexer is
begin

-- STARTL

  dac_data <= sine_5kHz when sel_s1 = '1' and sel_s2 = '0' else
              sine_7kHz when sel_s1 = '1' and sel_s2 = '1' else
              adc_data  when sel_s1 = '0' and sel_s2 = '1' else (others => '0');

-- STOPL

end multiplexer_behavioral;

