-------------------------------------------------------------------------------
-- Title      : Levelmeter
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : levelmeter.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-21
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module calculates the mean square of an audio signal. Be
--              careful with the output signal. It is an unsigned vector.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity levelmeter is
  
  generic (
    DATA_WIDTH        : positive := 8;
    INTEGRATION_WIDTH : positive := 10);

  port (
    CLK_IN   : in  std_logic;
    nRESET   : in  std_logic;
    DIN_VAL  : in  std_logic;
    DOUT_VAL : out std_logic;
    DATA_IN  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    DATA_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0));

end levelmeter;

architecture behavioral of levelmeter is


-- WRITE_HERE

  
begin  -- behavioral

  assert DATA_WIDTH < 17
    report "DATA_WIDTH must be equal or less than 16"
    severity error;
  assert INTEGRATION_WIDTH + DATA_WIDTH < 33
    report "DATA_WIDTH or INTEGRATION_WIDTH to large. DATA_WIDTH + INTEGRATION_WIDTH must be equal or less 32"
    severity error;

-- WRITE_HERE

  
end behavioral;

