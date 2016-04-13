-------------------------------------------------------------------------------
-- Title      : Toplevel
-- Project    : ADS-Praktikum
-------------------------------------------------------------------------------
-- File       : toplevel.vhd
-- Author     : Daniel Glaser
-- Company    : Lehrstuhl für Technische Elektronik, Universität Erlangen
-- Created    : 2006-06-27
-- Last update: 2006-07-06
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This is the toplevel of the ADS-Practice. This will be reused
--              in every design.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-06-27  1.0      sidaglas        Created
-- XXXX-YY-ZZ                           Finished
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity toplevel is
  
  generic (
    adm_input_width   : positive := 24;         -- adc operates at
    adm_output_width  : positive := 8;  -- adc module throws out
    dam_input_width   : positive := 8;  -- dac module is fed
    dam_output_width  : positive := 24;         -- dac operates at
    adm_sampling_rate : positive := 96000;      -- adc operates at
    adm_data_rate     : positive := 48000;      -- adc module throws out
    dam_sampling_rate : positive := 192000;     -- dac operates at
    dam_data_rate     : positive := 48000;      -- dac module accepts
    clk_in_freq       : positive := 24576000;   -- Given by the Oszillator
    desired_clock     : positive := 49152000);  -- Is defined by the PLL-Settings

  port (
    CLK_IN : in std_logic;
    nRESET : in std_logic;

    -- Microphone Amplifier (Port names are as pin descriptions of MA-IC)
    MA_0dB   : out std_logic;
    MA_ZCEN  : out std_logic;
    MA_nDCEN : out std_logic;
    MA_nCS   : out std_logic;
    MA_SCLK  : out std_logic;
    MA_SDI   : out std_logic;
    MA_SDO   : in  std_logic;

    -- AD-Converter (Port names are as pin descriptions of ADC-IC)
    AD_SCKI  : out   std_logic;
    AD_LRCK  : inout std_logic;
    AD_BCK   : inout std_logic;
    AD_DOUT  : in    std_logic;
    AD_FMT   : out   std_logic_vector(1 downto 0);
    AD_MODE  : out   std_logic_vector(1 downto 0);
    AD_BYPAS : out   std_logic;
    AD_nPDWN : out   std_logic;

    -- DA-Converter (Port names are as pin descriptions of DAC-IC)
    DA_LRCK  : out std_logic;
    DA_DATA  : out std_logic;
    DA_BCK   : out std_logic;
    DA_SCKI  : out std_logic;
    DA_nRST  : out std_logic;
    DA_ZEROL : in  std_logic;
    DA_ZEROR : in  std_logic;
    DA_DEMP  : out std_logic_vector(1 downto 0);
    DA_FMT   : out std_logic_vector(2 downto 0);
    DA_MUTE  : out std_logic;

    -- Status, DIPs and Switches
    LED_S1R : out std_logic;
    LED_S1Y : out std_logic;
    LED_S1G : out std_logic;

    LED_S2R : out std_logic;
    LED_S2Y : out std_logic;
    LED_S2G : out std_logic;

    LED_S3R : out std_logic;
    LED_S3Y : out std_logic;
    LED_S3G : out std_logic;

    SDIP : in std_logic_vector(7 downto 0);

    ST : in std_logic_vector(7 downto 0);

    -- 7-Segment Displays (0,1,2,3,4,5,6,7) => (a,b,c,d,e,f,g,dp)

    LED_DISP_1 : out std_logic_vector(7 downto 0);
    LED_DISP_2 : out std_logic_vector(7 downto 0);
    LED_DISP_3 : out std_logic_vector(7 downto 0);
    LED_DISP_4 : out std_logic_vector(7 downto 0);

    -- Bargraphs (Red is 7, Green is 0)

    LED_BAR_L : out std_logic_vector(7 downto 0);
    LED_BAR_R : out std_logic_vector(7 downto 0);

    -- Faeture Extendors (Port names doesn't correspond with pin numbers)

    FEXT_B5 : inout std_logic_vector(15 downto 0);
    FEXT_B7 : inout std_logic_vector(15 downto 0);

    -- RS-232

    RS232_RxD : in  std_logic;
    RS232_TxD : out std_logic;
    RS232_DSR : in  std_logic;
    RS232_DTR : out std_logic);

end;

architecture toplevel_behavioral of toplevel is

  signal CLK : std_logic;               -- The system clock (49,152 MHz)

  signal CLK_OK   : std_logic;
  signal CLK_LOCK : std_logic;

  signal sine_5kHz : std_logic_vector(7 downto 0);
  signal sine_7kHz : std_logic_vector(7 downto 0);

  signal adc_data : std_logic_vector(7 downto 0);
  signal dac_data : std_logic_vector(7 downto 0);

  signal sel_s1 : std_logic;
  signal sel_s2 : std_logic;

  component FS_CLOCK_GEN
    port (
      CLK   : in  std_logic;
      RESET : in  std_logic;
      CLKOP : out std_logic;
      CLKOK : out std_logic;
      LOCK  : out std_logic);
  end component;

  component adc_deserialize
    generic (
      input_width         : positive;
      output_width        : positive;
      input_sampling_rate : positive;
      output_data_rate    : positive;
      clk_freq            : positive;
      fs_multi            : positive);
    port (
      CLK         : in  std_logic;
      nRESET      : in  std_logic;
      SCKI        : out std_logic;
      LRCK        : in  std_logic;
      BCK         : in  std_logic;
      DOUT        : in  std_logic;
      FMT         : out std_logic_vector(1 downto 0);
      MODE        : out std_logic_vector(1 downto 0);
      BYPAS       : out std_logic;
      nPDWN       : out std_logic;
      OSR         : out std_logic;
      DATA_STROBE : out std_logic;
      DATA_LEFT   : out std_logic_vector(adm_output_width-1 downto 0);
      DATA_RIGHT  : out std_logic_vector(adm_output_width-1 downto 0));
  end component;

  component multiplexer
    port (
      sine_5kHz : in  std_logic_vector(7 downto 0);
      sine_7kHz : in  std_logic_vector(7 downto 0);
      adc_data  : in  std_logic_vector(7 downto 0);
      dac_data  : out std_logic_vector(7 downto 0);
      sel_s1    : in  std_logic;
      sel_s2    : in  std_logic);
  end component;
  
begin
  
  FS_CLOCK_GEN : FS_CLOCK_GEN
    port map (
      CLK   => CLK_IN,                  -- 24,576 MHz
      RESET => nRESET,
      CLKOP => CLK,                     -- 49,152 MHz (for ADC and DAC)
      CLKOK => CLK_OK,                  -- 384 kHz    (helper for audio)
      LOCK  => CLK_LOCK);

  adc_deserialize_1 : adc_deserialize
    generic map (
      input_width         => adm_input_width,
      output_width        => adm_output_width,
      input_sampling_rate => adm_sampling_rate,
      output_data_rate    => adm_data_rate,
      clk_freq            => clk_in_freq,
      fs_multi            => fs_multi)
    port map (
      CLK         => CLK,
      nRESET      => nRESET,
      SCKI        => ADM_SCKI,
      LRCK        => ADM_LRCK,
      BCK         => ADM_BCK,
      DOUT        => ADM_DOUT,
      FMT         => ADM_FMT,
      MODE        => ADM_MODE,
      BYPAS       => ADM_BYPAS,
      nPDWN       => ADM_nPDWN,
      OSR         => ADM_OSR,
      DATA_STROBE => ADCM_DATA_STROBE,
      DATA_LEFT   => ADCM_DATA_LEFT,
      DATA_RIGHT  => ADCM_DATA_RIGHT);

  multiplexer : multiplexer
    port map (
      sine_5kHz => sine_5kHz,
      sine_7kHz => sine_7kHz,
      adc_data  => adc_data,
      dac_data  => dac_data,
      sel_s1    => sel_s1,
      sel_s2    => sel_s2);

  sel_s1 <= ST(0);
  sel_s2 <= ST(1);

  AD_SCKI <= ADM_SCKI;
  DA_SCKI <= DAM_SCKI;

  
  
end toplevel_behavioral;


