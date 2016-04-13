-------------------------------------------------------------------------------
-- Title      : PRN-Schieberegister
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : prn_shiftreg.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-23
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module implements a PRN shift register. 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity prn_shiftreg is
  
  generic (
    REG_LENGTH : positive := 16);

  port (
    CLK_IN           : in  std_logic;
    nRESET           : in  std_logic;
    CE               : in  std_logic;
    SHIFTREG_CONTENT : out std_logic_vector(REG_LENGTH-1 downto 0);
    PRN_OUT          : out std_logic);

end prn_shiftreg;

architecture behavioral of prn_shiftreg is

--STARTL
  constant cv_init : std_logic_vector(REG_LENGTH-1 downto 0) := "1010101010101010";
  
--STOPL
begin  -- behavioral

--STARTL
  proc_shiftreg : process (CLK_IN, nRESET)
    variable vv_shiftreg : std_logic_vector(REG_LENGTH-1 downto 0);
  begin  -- process proc_shiftreg
    if nRESET = '0' then                -- asynchronous reset (active low)
      vv_shiftreg := cv_init;
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if CE = '1' then
        PRN_OUT          <= vv_shiftreg(0);
        SHIFTREG_CONTENT <= vv_shiftreg;

        vv_shiftreg(REG_LENGTH-1 downto 0) :=
          (vv_shiftreg(5) xor vv_shiftreg(1)) &
          vv_shiftreg(REG_LENGTH-1 downto 1);
      end if;
    end if;
  end process proc_shiftreg;
  
--STOPL
end behavioral;
