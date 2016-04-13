-------------------------------------------------------------------------------
-- Title      : Chatter suppress
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : chatter_suppress.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-04
-- Last update: 2007-01-11
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module suppresses the chatter from switches and buttons.
--              It is configurable in swing suppress time.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-09-04  1.0      sidaglas        Created
-- 2006-11-23  1.1      sidaglas        Fixed some comments
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity chatter_suppress is
  
  generic (
    BUTTON_COUNT    : positive := 8;
    SUPPRESS_CLOCKS : positive := 64);

  port (
    CLK_IN : in  std_logic;
    nRESET : in  std_logic;
    INPUT  : in  std_logic_vector(BUTTON_COUNT-1 downto 0);
    OUTPUT : out std_logic_vector(BUTTON_COUNT-1 downto 0));

end chatter_suppress;

architecture behavioral of chatter_suppress is

begin  -- behavioral

  gen_proc_button : for i in 0 to BUTTON_COUNT-1 generate

    -- purpose: This process suppresses the chatter of one button
    -- type   : sequential
    -- inputs : CLK_IN, nRESET
    -- outputs: 
    chatter_suppress : process (CLK_IN, nRESET, INPUT)
      variable vn_count : natural range 0 to SUPPRESS_CLOCKS-1 := SUPPRESS_CLOCKS-1;
      variable vl_prev  : std_logic                            := '0';
    begin  -- process chatter_suppress
      if nRESET = '0' then              -- asynchronous reset (active low)
        OUTPUT(i) <= '0';
        vl_prev   := INPUT(i);
        vn_count  := SUPPRESS_CLOCKS-1;
      elsif rising_edge(CLK_IN) then    -- rising clock edge

        if vl_prev /= INPUT(i) then
          vl_prev  := INPUT(i);
          vn_count := SUPPRESS_CLOCKS-1;
        elsif vn_count = 0 then
          OUTPUT(i) <= INPUT(i);
        else
          vn_count := vn_count - 1;
        end if;
        
      end if;
    end process chatter_suppress;

  end generate gen_proc_button;

end behavioral;
