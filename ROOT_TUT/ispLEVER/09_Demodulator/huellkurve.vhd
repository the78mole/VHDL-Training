-------------------------------------------------------------------------------
-- Title      : Hüllkurvendemodulator
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : huellkurve.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-22
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Einfache Quadrierung des Signals
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


--NOCOPY

entity huellkurve is
  
  generic (
    DATA_WIDTH : positive := 8);

  port (
    CLK_IN     : in  std_logic;
    nRESET     : in  std_logic;
    DVAL_IN    : in  std_logic;
    DVAL_OUT   : out std_logic;
    DATA_IN_A  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    DATA_IN_B  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    DATA_OUT_A : out std_logic_vector(DATA_WIDTH-1 downto 0);
    DATA_OUT_B : out std_logic_vector(DATA_WIDTH-1 downto 0));

end huellkurve;

architecture behavioral of huellkurve is

begin  -- behavioral

  process (CLK_IN, nRESET)
    variable vl_dval : std_logic := '0';
    variable vn_count : natural range 0 to 2 := 0;
  begin  -- process
    if nRESET = '0' then                -- asynchronous reset (active low)
      DATA_OUT_A <= (others => '0');
      DATA_OUT_B <= (others => '0');
      DVAL_OUT <= '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if DVAL_IN = '1' and vl_dval = '0' then
        vn_count := 2;
      elsif vn_count /= 0 then
        vn_count := vn_count - 1;
      end if;

      if vn_count = 2 then
        DATA_OUT_B <= conv_std_logic_vector(
          (conv_integer(DATA_IN_B) * conv_integer(DATA_IN_B))/
          2**(DATA_WIDTH-2), DATA_WIDTH);
      elsif vn_count = 1 then
        DATA_OUT_A <= conv_std_logic_vector(
          (conv_integer(DATA_IN_A) * conv_integer(DATA_IN_A))/
          2**(DATA_WIDTH-2), DATA_WIDTH);
        DVAL_OUT <= '1';
      else
        DVAL_OUT <= '0';
      end if;
    end if;
  end process;

end behavioral;

