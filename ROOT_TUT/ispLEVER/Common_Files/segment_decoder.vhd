-------------------------------------------------------------------------------
-- Title      : segment decoder
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : segment_decoder.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-04
-- Last update: 2006-11-23
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module decodes a std_logic_vector 4-bit coded hex number
--              to a 7-segment display, showing hexadecimal numbers
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-09-04  1.0      sidaglas        Created
-- 2006-11-23  1.1      sidaglas        OE added
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity segment_decoder is

  generic (
    OUTPUT_ACTIVE_LOW : boolean := true;
    REGISTER_OUTPUTS  : boolean := true);
  port (
    CLK_IN : in  std_logic;
    nRESET : in  std_logic;
    OE     : in  std_logic;
    INPUT  : in  std_logic_vector(3 downto 0);
    OUTPUT : out std_logic_vector(7 downto 0));

end segment_decoder;

architecture behavioral of segment_decoder is

  signal sv_output : std_logic_vector(OUTPUT'range);
  
begin  -- behavioral


  gen_reg_out : if REGISTER_OUTPUTS generate

    -- purpose: This process registers the outputs
    -- type   : sequential
    -- inputs : CLK_IN, nRESET
    -- outputs: 
    reg_outputs : process (CLK_IN, nRESET)
    begin  -- process reg_outputs
      if nRESET = '0' then              -- asynchronous reset (active low)
        OUTPUT <= (others => 'Z');
      elsif rising_edge(CLK_IN) then    -- rising clock edge
        if OE = '0' then
          OUTPUT <= (others => 'Z');
        elsif OUTPUT_ACTIVE_LOW then
          OUTPUT <= not sv_output;
        else
          OUTPUT <= sv_output;
        end if;
      end if;
    end process reg_outputs;
  end generate gen_reg_out;

  nogen_reg_out : if not REGISTER_OUTPUTS generate
    OUTPUT <= (others => 'Z') when OE = '0'
              else not sv_output when OUTPUT_ACTIVE_LOW
              else sv_output;
  end generate nogen_reg_out;

  sv_output <= "00111111" when INPUT = "0000" else  -- 0
               "00000110" when INPUT = "0001" else  -- 1
               "01011011" when INPUT = "0010" else  -- 2
               "01001111" when INPUT = "0011" else  -- 3
               "01100110" when INPUT = "0100" else  -- 4
               "01101101" when INPUT = "0101" else  -- 5
               "01111101" when INPUT = "0110" else  -- 6
               "00000111" when INPUT = "0111" else  -- 7
               "01111111" when INPUT = "1000" else  -- 8
               "01101111" when INPUT = "1001" else  -- 9
               "11110111" when INPUT = "1010" else  -- A (10)
               "11111100" when INPUT = "1011" else  -- B (11)
               "10111001" when INPUT = "1100" else  -- C (12)
               "11011110" when INPUT = "1101" else  -- D (13)
               "11111001" when INPUT = "1110" else  -- E (14)
               "11110001" when INPUT = "1111" else  -- F (15)
               (others => '0');
  
end behavioral;

