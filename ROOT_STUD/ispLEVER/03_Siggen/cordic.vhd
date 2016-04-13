-------------------------------------------------------------------------------
-- Title      : Cordic Base
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : cordic.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-21
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This is the beatiful cordic algorithm. It is implemented as a
--              parametrizable module. The iteration depth is variable as the
--              width of the data is.
--                It is completely written in VHDL and doesn't need any tools
--              from your fpga vendor, but it needs the math_real package at
--              synthesis time. If you can't cope with this, implement your
--              own, hand calculated lut or try to solve it in integer
--              arithmetic and you should be happy again.
--                The algorithm takes ITERATIONS+1 cycles to complete.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-01  1.0      sidaglas        Created
-- 2006-11-24  1.0      sidaglas        Finished
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
--use ieee.numeric_std.all;

entity cordic_base is
  
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
    MODE     : in  std_logic;                     -- unused
    PARAM_M  : in  std_logic_vector(1 downto 0);  -- unused
    X_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    Y_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    Z_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    X_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
    Y_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0);
    Z_OUT    : out std_logic_vector(DATA_WIDTH-1 downto 0));

end cordic_base;

architecture behavioral of cordic_base is


-- WRITE_HERE

  
begin  -- behavioral


-- WRITE_HERE

  
end behavioral;

