-------------------------------------------------------------------------------
-- Title      : Bargraph decoder
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : bargraph_decoder.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-04
-- Last update: 2006-11-23
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This decoder accepts a 8-bit-word and keeps only the upper
--              bits, where the generic BAR_LIGHT_COUNT decides how many will
--              stay. A value of 8 or more will result in a full bar from
--              ground to topmost bit. But a bar with 2 lights running up and
--              down looks much cooler and also saves power ;-)
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-09-04  1.0      sidaglas        Created
-- 2006-09-05  1.1      sidaglas        Improved
-- 2006-11-23  1.2      sidaglas        OE added
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity bargraph_decoder is
  
  generic (
    BAR_LIGHT_COUNT   : positive := 1;  -- Width of the bar (1 to 8)
    OUTPUT_ACTIVE_LOW : boolean  := true);  

  port (
    CLK_IN : in  std_logic;
    nRESET : in  std_logic;
    OE     : in  std_logic;
    DEC_EN : in  std_logic;
    INPUT  : in  std_logic_vector(7 downto 0);
    OUTPUT : out std_logic_vector(7 downto 0));

end bargraph_decoder;

architecture behavioral of bargraph_decoder is

  type   tu_fsm_states is (START, FIND_FIRST, SET_BITS, ZERO_OTHERS, RESULT_OUT);
  signal sv_output : std_logic_vector(7 downto 0);

  -- pragma translate_off
  signal su_fsm_next_state, su_fsm_active_state : tu_fsm_states;
  signal sn_bitcount, sn_barcount               : natural;
  signal sv_vv_output                           : std_logic_vector(7 downto 0);
  -- pragma translate_on
  
begin  -- behavioral

  -- purpose: This process calculates the leds to light
  -- type   : sequential
  -- inputs : CLK_IN, nRESET
  -- outputs: 
  calc_output : process (CLK_IN, nRESET)
    variable vu_fsm_state : tu_fsm_states;
    variable vn_bitcount  : natural range 0 to 7;
    variable vn_barcount  : natural range 0 to 7;
    variable vv_output    : std_logic_vector(7 downto 0);
  begin  -- process calc_output
    if nRESET = '0' then                -- asynchronous reset (active low)
      OUTPUT      <= (others => 'Z');
      sv_output   <= (others => '0');
      vv_output   := (others => '0');
      vn_bitcount := 0;
      vn_barcount := 0;
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      if DEC_EN = '1' then

        -- pragma translate_off
        su_fsm_active_state <= vu_fsm_state;
        -- pragma translate_on

        case vu_fsm_state is
          when START =>
            vv_output    := INPUT;
            vu_fsm_state := FIND_FIRST;
            vn_barcount  := BAR_LIGHT_COUNT-1;
            vn_bitcount  := 7;
            
          when FIND_FIRST =>
            if vv_output(vn_bitcount) = '1' then
              vu_fsm_state := SET_BITS;
            elsif vn_bitcount = 0 then
              vu_fsm_state := RESULT_OUT;
            elsif vn_bitcount /= 0 then
              vn_bitcount := vn_bitcount - 1;
            end if;
            
          when SET_BITS =>
            vv_output(vn_bitcount) := '1';
            if vn_bitcount /= 0 and vn_barcount /= 0 then
              vn_bitcount := vn_bitcount - 1;
              vn_barcount := vn_barcount - 1;
            elsif vn_bitcount = 0 then
              vu_fsm_state := RESULT_OUT;
            elsif vn_barcount = 0 then
              vu_fsm_state := ZERO_OTHERS;
              vn_bitcount  := vn_bitcount - 1;
            end if;
            
          when ZERO_OTHERS =>
            vv_output(vn_bitcount) := '0';
            if vn_bitcount /= 0 then
              vn_bitcount := vn_bitcount - 1;
            else
              vu_fsm_state := RESULT_OUT;
            end if;
            
          when RESULT_OUT =>
            sv_output    <= vv_output;
            vu_fsm_state := START;
            
          when others =>
            vu_fsm_state := START;
            
        end case;

        -- pragma translate_off
        su_fsm_next_state <= vu_fsm_state;
        sv_vv_output      <= vv_output;
        sn_bitcount       <= vn_bitcount;
        sn_barcount       <= vn_barcount;
        -- pragma translate_on

        if OE = '0' then
          OUTPUT <= (others => 'Z');
        else
          if OUTPUT_ACTIVE_LOW then
            OUTPUT <= not sv_output;
          else
            OUTPUT <= sv_output;
          end if;
        end if;
        
      else
        -- Encoder off 
        
        if OE = '0' then
          OUTPUT <= (others => 'Z');
        else
          if OUTPUT_ACTIVE_LOW then
            OUTPUT <= not INPUT;
          else
            OUTPUT <= INPUT;
          end if;
        end if;
      end if;
      
    end if;
  end process calc_output;
  
end behavioral;

