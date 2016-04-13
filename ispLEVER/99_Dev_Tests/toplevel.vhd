-------------------------------------------------------------------------------
-- Title      : Toplevel
-- Project    : ADS-Praktikum
-------------------------------------------------------------------------------
-- File       : toplevel.vhd
-- Author     : Daniel Glaser
-- Company    : Lehrstuhl für Technische Elektronik, Universität Erlangen
-- Created    : 2006-06-27
-- Last update: 2006-07-05
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
    ad_input_width       : positive := 24;
    da_output_width      : positive := 24;
    input_sampling_rate  : positive := 96000;
    output_sampling_rate : positive := 192000;
    main_clk_freq        : positive := 24576000);


  port (
    clk_in : in std_logic;
    reset  : in std_logic;

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

  -----------------------------------------------------------------------------
  -- General declarations
  -----------------------------------------------------------------------------
  
  signal CLK : std_logic;               -- The system clock (49,152 MHz)

  signal CLK_OK   : std_logic;
  signal CLK_LOCK : std_logic;

  component FS_CLOCK_GEN
    port (
      CLK   : in  std_logic;
      RESET : in  std_logic;
      CLKOP : out std_logic;
      CLKOK : out std_logic;
      LOCK  : out std_logic);
  end component;

  -----------------------------------------------------------------------------
  -- Project specific declarations
  -----------------------------------------------------------------------------
  
begin

  -----------------------------------------------------------------------------
  -- General instantiations
  -----------------------------------------------------------------------------

  -- The PLL for generating all neccessary clocks
  
  FS_CLOCK_GEN : FS_CLOCK_GEN
    port map (
      CLK   => CLK_IN,                  -- 24,576 MHz
      RESET => nRESET,
      CLKOP => CLK,                     -- 49,152 MHz (for ADC and DAC)
      CLKOK => CLK_OK,                  -- 384 kHz    (helper for audio)
      LOCK  => CLK_LOCK);

  -----------------------------------------------------------------------------
  -- Project specific instantiations and code
  -----------------------------------------------------------------------------

end toplevel_behavioral;

