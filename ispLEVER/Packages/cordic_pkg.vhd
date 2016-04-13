-------------------------------------------------------------------------------
-- Title      : Cordic Package
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : cordic_pkg.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-24
-- Last update: 2006-11-26
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This Packages provides the Cordic module with the appropriate
--              types and settings.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-24  1.0      sidaglas	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

package cordic_pkg is

  constant CORDIC_MODE_ROTATION : std_logic := '0';
  constant CORDIC_MODE_VECTORING : std_logic := '1';

  constant CPARM_CIRCULAR : std_logic_vector(1 downto 0) := "01";
  constant CPARM_LINEAR : std_logic_vector(1 downto 0) := "00";
  constant CPARM_HYPERBOLIC : std_logic_vector(1 downto 0) := "10";


end cordic_pkg;
