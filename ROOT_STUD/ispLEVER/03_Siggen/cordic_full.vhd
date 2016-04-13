-------------------------------------------------------------------------------
-- Title      : Cordic Full
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : cordic_full.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-21
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module improves the cordic with full scale 2*PI rotation
--              capability.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

use ieee.math_real.all;

entity cordic_full is
  
  generic (
    ITER_WIDTH   : positive := 4;
    ITERATIONS   : positive := 10;
    DATA_WIDTH   : positive := 16;
    SCALE_OUTPUT : boolean  := true);

  port (
    CLK_IN   : in  std_logic;
    nRESET   : in  std_logic;
    DVAL_IN  : in  std_logic;
    DVAL_OUT : out std_logic;
    MODE     : in  std_logic;
    PARAM_M  : in  std_logic_vector(1 downto 0);
    X_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    Y_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    Z_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    X_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
    Y_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
    Z_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0));

end cordic_full;

architecture behavioral of cordic_full is


-- WRITE_HERE

  
begin  -- behavioral


-- WRITE_HERE

  
end behavioral;

