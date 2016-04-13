-------------------------------------------------------------------------------
-- Title      : Gain Control
-- Project    :  Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : gain_control.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-22
-- Last update: 2007-01-13
-- Platform   : LFECP30E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module compares the inputs to it's previous values and if
--              they change, it configures the Mic PreAmp with the new values.
--              It also generates the apropriate clock and nCS-signal.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-23  1.0      sidaglas        Created
--                                        SCLK=CLK_IN not fully implemented yet
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity gain_control is

  generic (
    CLK_FREQ : positive := 49152000;
    CLK_MAX  : positive := 6250000);
  port (
    -- System Inputs
    CLK_IN      : in  std_logic;
    nRESET      : in  std_logic;
    -- Preferences Input
    GAIN        : in  std_logic_vector(5 downto 0);
    GPO         : in  std_logic_vector(3 downto 0);
    DC_SERVO_EN : in  std_logic;
    CM_SERVO_EN : in  std_logic;
    OVERLOAD    : in  std_logic;
    -- IC-Connections
    SCKL        : out std_logic;
    nCS         : out std_logic;
    DOUT        : out std_logic;
    DIN         : in  std_logic);

end gain_control;

architecture behavioral of gain_control is

  constant cn_clock_divider   : natural := (CLK_FREQ/(CLK_MAX+1))+1;
  constant cn_clock_count_max : natural := (cn_clock_divider/2)+1;

  signal sl_toggle_sig              : std_logic := '0';
  signal sl_changed, sl_changed_ack : std_logic := '0';

begin  -- behavioral

  proc_toggle_sig : process (CLK_IN, nRESET)
    variable cn_toggle_count : natural range 0 to cn_clock_count_max := cn_clock_count_max;
  begin  -- process proc_toggle_sig
    if nRESET = '0' then                -- asynchronous reset (active low)
      sl_toggle_sig   <= '0';
      cn_toggle_count := cn_clock_count_max;
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if cn_clock_divider = 2 then
        sl_toggle_sig <= not sl_toggle_sig;
      elsif cn_clock_divider > 2 then
        if cn_toggle_count = 0 then
          cn_toggle_count := cn_clock_count_max;
          sl_toggle_sig   <= not sl_toggle_sig;
        else
          cn_toggle_count := cn_toggle_count - 1;
        end if;
      end if;
    end if;
  end process proc_toggle_sig;

  -- Output the clock for the Mic PreAmp
  SCKL <= sl_toggle_sig when cn_clock_divider > 2 else CLK_IN;

  proc_change_detect : process (CLK_IN, nRESET)
    variable vv_last_gain                       : std_logic_vector(GAIN'range);
    variable vv_last_gpo                        : std_logic_vector(GPO'range);
    variable vl_last_dc_servo, vl_last_cm_servo : std_logic;
    variable vl_last_overload                   : std_logic;

    variable vb_gain_changed     : boolean;
    variable vb_gpo_changed      : boolean;
    variable vb_servo_changed    : boolean;
    variable vb_overload_changed : boolean;
  begin  -- process proc_change_detect
    if nRESET = '0' then                -- asynchronous reset (active low)
      vv_last_gain     := (others => '0');
      vv_last_gpo      := (others => '0');
      vl_last_dc_servo := '0';
      vl_last_cm_servo := '0';
      vl_last_overload := '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      if vb_gain_changed or vb_gpo_changed or vb_servo_changed or vb_overload_changed then
        sl_changed <= '1';
      elsif sl_changed_ack = '1' then
        sl_changed <= '0';
      end if;

      -- Compare actual with past values
      if vv_last_gain /= GAIN then
        vb_gain_changed := true;
      else
        vb_gain_changed := false;
      end if;

      if vv_last_gpo /= GPO then
        vb_gpo_changed := true;
      else
        vb_gpo_changed := false;
      end if;

      if vl_last_dc_servo /= DC_SERVO_EN
        or vl_last_cm_servo /= CM_SERVO_EN then
        vb_servo_changed := true;
      else
        vb_servo_changed := false;
      end if;

      if vl_last_overload /= OVERLOAD then
        vb_overload_changed := true;
      else
        vb_overload_changed := false;
      end if;

      -- Assign last values to compare with next cycle     
      vv_last_gain     := GAIN;
      vv_last_gpo      := GPO;
      vl_last_dc_servo := DC_SERVO_EN;
      vl_last_cm_servo := CM_SERVO_EN;
      vl_last_overload := OVERLOAD;
    end if;
  end process proc_change_detect;

  proc_transmit : process (CLK_IN, nRESET)
    variable vn_counter     : natural range 0 to 20;
    variable vv_snapshot    : std_logic_vector(15 downto 0);
    variable vl_last_toggle : std_logic;
    variable vl_shift_en    : std_logic;
  begin  -- process transmit
    if nRESET = '0' then                -- asynchronous reset (active low)
      DOUT        <= '0';
      nCS         <= '1';
      vv_snapshot := (others => '0');
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if vl_last_toggle = '1' and sl_toggle_sig = '0' then
        if sl_changed = '1' then

          if vl_shift_en = '1' then
            vv_snapshot(15 downto 0) := vv_snapshot(14 downto 0) & '0';
          else
            vv_snapshot :=
              (not DC_SERVO_EN) & CM_SERVO_EN & '0' & OVERLOAD &
              GPO & "00" & GAIN;
          end if;

          DOUT <= vv_snapshot(15);
          
          if vn_counter = 0 then
            -- Set data enable and put first data
            nCS         <= '0';
            vl_shift_en := '1';
          elsif vn_counter = 16 then
            nCS            <= '1';
            vl_shift_en    := '0';
            sl_changed_ack <= '1';
          end if;

          if vn_counter = 20 then
            sl_changed_ack <= '1';
          else
            vn_counter := vn_counter + 1;
          end if;

        else
          
          vn_counter     := 0;
          sl_changed_ack <= '0';
          
        end if;
      end if;

      vl_last_toggle := sl_toggle_sig;
      
    end if;
  end process proc_transmit;
  
end behavioral;

