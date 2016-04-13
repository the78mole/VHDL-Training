-------------------------------------------------------------------------------
-- Title      : Barrel Shifter
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : barrel_shifter.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-25
-- Last update: 2007-01-13
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module is for multiplications and divisions by powers of
--              two. Left side shifting is done by positive, right side by
--              negative values of SHIFT_AMOUNT.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-25  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity barrel_shifter is
  
  generic (
    USE_MULTIPLIER : boolean  := true;
    AMOUNT_WIDTH   : positive := 4;
    DATA_WIDTH     : positive := 8);

  port (
    SIGNED_SHIFT : in  std_logic;
    SHIFT_AMOUNT : in  std_logic_vector(AMOUNT_WIDTH-1 downto 0);
    DATA_IN      : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    DATA_OUT     : out std_logic_vector(DATA_WIDTH-1 downto 0));

end barrel_shifter;

architecture behavioral of barrel_shifter is

  signal si_amount : integer range -DATA_WIDTH to DATA_WIDTH-1;
--  signal sv_amount_pow : std_logic_vector((2*DATA_WIDTH)-1 downto 0);
  type   tva_pow is array (0 to (2*DATA_WIDTH)-1)
    of std_logic_vector((2*DATA_WIDTH)-1 downto 0);
  signal sva_amount_pows : tva_pow;
  signal sv_multi        : std_logic_vector((3*DATA_WIDTH)-2 downto 0);
  signal sv_multi_datab  : std_logic_vector((2*DATA_WIDTH)-1 downto 0);
  signal si_mult1, si_mult2 : integer;
  
begin  -- behavioral
  si_amount <= conv_integer(SHIFT_AMOUNT);

  gen_no_multiplier : if not USE_MULTIPLIER generate
    gen_bits : for i in DATA_WIDTH downto 0 generate
      DATA_OUT(i) <=
        DATA_IN(i - si_amount)     when ((i-si_amount >= 0) and (i-si_amount <= DATA_WIDTH-1))
        else DATA_IN(DATA_IN'left) when SIGNED_SHIFT = '1'
        else '0';
    end generate gen_bits;
  end generate gen_no_multiplier;

  gen_with_multiplier : if USE_MULTIPLIER generate

    gen_pows : for i in 0 to (2*DATA_WIDTH)-1 generate
      sva_amount_pows(i) <= conv_std_logic_vector(2**i, 2*DATA_WIDTH);
    end generate gen_pows;

    si_mult1 <= conv_integer((SIGNED_SHIFT and DATA_IN(DATA_WIDTH-1)) & DATA_IN);
    si_mult2 <= conv_integer(sva_amount_pows(si_amount + DATA_WIDTH));
    
    sv_multi <= conv_std_logic_vector(si_mult1 * si_mult2,(3*DATA_WIDTH)-1);

    DATA_OUT <= sv_multi((2*DATA_WIDTH)-1 downto DATA_WIDTH);
  end generate gen_with_multiplier;
  
end behavioral;

