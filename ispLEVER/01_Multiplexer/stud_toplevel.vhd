-------------------------------------------------------------------------------
-- Title      : Students toplevel
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : stud_toplevel.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-04
-- Last update: 2006-11-26
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This Toplevel is for student use. They should start here, as
--              here are already usable signals like parallel data from adc. It
--              simplyfies the work to be done.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-09-04  1.0      sidaglas        Created
-- 2006-11-22  1.1      sidaglas        Modified
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity stud_toplevel is

  generic (
    DATA_WIDTH : positive := 8);

  port (
    ---------------------------------------------------------------------------
    -- Generic signals
    ---------------------------------------------------------------------------
    CLK_FAST : in std_logic;            -- 49,152 MHz
    CLK_SLOW : in std_logic;            -- 0,768 MHz = 768 kHz

    nRESET : in std_logic;

    ---------------------------------------------------------------------------
    -- Human device interface (HDI)
    ---------------------------------------------------------------------------

    -- Inputs
    SWITCH_1 : in std_logic;
    SWITCH_2 : in std_logic;
    SWITCH_3 : in std_logic;
    SWITCH_4 : in std_logic;
    SWITCH_5 : in std_logic;
    SWITCH_6 : in std_logic;
    SWITCH_7 : in std_logic;
    SWITCH_8 : in std_logic;

    BUTTON_1 : in std_logic;
    BUTTON_2 : in std_logic;
    BUTTON_3 : in std_logic;
    BUTTON_4 : in std_logic;
    BUTTON_5 : in std_logic;
    BUTTON_6 : in std_logic;
    BUTTON_7 : in std_logic;
    BUTTON_8 : in std_logic;

    -- Outputs
    STATUS_L_RED : out std_logic;
    STATUS_L_YEL : out std_logic;
    STATUS_L_GRE : out std_logic;
    STATUS_M_RED : out std_logic;
    STATUS_M_YEL : out std_logic;
    STATUS_M_GRE : out std_logic;
    STATUS_R_RED : out std_logic;
    STATUS_R_YEL : out std_logic;
    STATUS_R_GRE : out std_logic;

    -- The segment leds take hex numbers and show them
    SEGMENT_LED1 : out std_logic_vector(3 downto 0);
    SEGMENT_LED2 : out std_logic_vector(3 downto 0);
    SEGMENT_LED3 : out std_logic_vector(3 downto 0);
    SEGMENT_LED4 : out std_logic_vector(3 downto 0);

    -- The Bargraph switches on the count of lights you say
    BARGRAPH_LEFT   : out std_logic_vector(7 downto 0);
    BARGRAPH_RIGHT  : out std_logic_vector(7 downto 0);
    BARGRAPH_DEC_EN : out std_logic;

    ---------------------------------------------------------------------------
    -- PC communications
    ---------------------------------------------------------------------------
    PC_SDIN  : in  std_logic;
    PC_SDOUT : out std_logic;

    ---------------------------------------------------------------------------
    -- Peripherial connections
    ---------------------------------------------------------------------------
    -- Digitally controlled microphone preamplifier
    MA_GAIN : out std_logic_vector(5 downto 0);

    -- Analog to digital converter
    AD_PDIN_L : in std_logic_vector(23 downto 0);
    AD_PDIN_R : in std_logic_vector(23 downto 0);
    AD_DVAL   : in std_logic;

    -- Digital to analog converter
    DA_PDOUT_L : out std_logic_vector(23 downto 0);
    DA_PDOUT_R : out std_logic_vector(23 downto 0);
    DA_DVAL    : out std_logic);

end stud_toplevel;

architecture behavioral of stud_toplevel is

  component dds_sinus
    generic (
      OUTPUT_WIDTH : positive;
      TABLE_WIDTH  : positive;
      PHASE_WIDTH  : positive;
      CLK_DIV      : positive);
    port (
      CLK_IN    : in  std_logic;
      nRESET    : in  std_logic;
      PHASE_INC : in  std_logic_vector(PHASE_WIDTH-1 downto 0);
      OUTPUT    : out std_logic_vector(OUTPUT_WIDTH-1 downto 0));
  end component;

  component my_multiplexer
    port (
      sine_5kHz : in  std_logic_vector(7 downto 0);
      sine_7kHz : in  std_logic_vector(7 downto 0);
      adc_data  : in  std_logic_vector(7 downto 0);
      dac_data  : out std_logic_vector(7 downto 0);
      sel_s1    : in  std_logic;
      sel_s2    : in  std_logic);
  end component;

  signal sv_sine_5kHz : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_sine_7kHz : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_dac_data  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_adc_data  : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sl_sel_s1, sl_sel_s2 : std_logic;

begin  -- behavioral

  dds_sinus_5kHz : dds_sinus
    generic map (
      OUTPUT_WIDTH => 8,
      TABLE_WIDTH  => 3,
      PHASE_WIDTH  => 8,
      CLK_DIV      => 8)
    port map (
      CLK_IN    => CLK_SLOW,
      nRESET    => nRESET,
      PHASE_INC => "00001101",
      OUTPUT    => sv_sine_5kHz);

  dds_sinus_7kHz : dds_sinus
    generic map (
      OUTPUT_WIDTH => 8,
      TABLE_WIDTH  => 3,
      PHASE_WIDTH  => 8,
      CLK_DIV      => 8)
    port map (
      CLK_IN    => CLK_SLOW,
      nRESET    => nRESET,
      PHASE_INC => "00010010",
      OUTPUT    => sv_sine_5kHz);

  my_multiplexer_1 : my_multiplexer
    port map (
      sine_5kHz => sv_sine_5kHz,
      sine_7kHz => sv_sine_7kHz,
      adc_data  => sv_adc_data,
      dac_data  => sv_dac_data,
      sel_s1    => sl_sel_s1,
      sel_s2    => sl_sel_s2);

  DA_DVAL <= AD_DVAL;

  DA_PDOUT_L  <= sv_dac_data;
  sv_adc_data <= AD_PDIN_L;

  sl_sel_s1 <= SWITCH_1 xor BUTTON_1;
  sl_sel_s2 <= SWITCH_2 xor BUTTON_2;
  
end behavioral;
