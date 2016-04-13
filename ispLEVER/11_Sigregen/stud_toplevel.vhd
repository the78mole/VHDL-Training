-------------------------------------------------------------------------------
-- Title      : Students toplevel
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : stud_toplevel.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-04
-- Last update: 2007-01-22
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

-- Here's the place for declarations
  
--STARTL
  component sigregen
    generic (
      DATA_WIDTH : positive;
      HYSTERESIS : natural);
    port (
      CLK_IN    : in  std_logic;
      nRESET    : in  std_logic;
      DVAL_IN   : in  std_logic;
      DVAL_OUT  : out std_logic;
      DATA_IN_A : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_IN_B : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT  : out std_logic);
  end component;

  signal sv_data_in_a, sv_data_in_b : std_logic_vector(DATA_WIDTH-1 downto 0);

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

  signal sv_sinus_5kHz, sv_sinus_10kHz : std_logic_vector(DATA_WIDTH-1 downto 0);
  
--STOPL
begin  -- behavioral

-- Here's the place for instantiations and code

--STARTL
  sigregen_1: sigregen
    generic map (
      DATA_WIDTH => DATA_WIDTH,
      HYSTERESIS => 2)
    port map (
      CLK_IN    => CLK_FAST,
      nRESET    => nRESET,
      DVAL_IN   => AD_DVAL,
      DVAL_OUT  => open,
      DATA_IN_A => sv_data_in_a,
      DATA_IN_B => sv_data_in_b,
      DATA_OUT  => STATUS_R_GRE);

  dds_sinus_1: dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_FAST,
      nRESET    => nRESET,
      PHASE_INC => "00011001",
      OUTPUT    => sv_sinus_5kHz);

  sv_data_in_a <= sv_sinus_5kHz when BUTTON_1 = '1' else (others => '0');
  
  dds_sinus_2: dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_FAST,
      nRESET    => nRESET,
      PHASE_INC => "00110010",
      OUTPUT    => sv_sinus_10kHz);

  sv_data_in_b <= sv_sinus_10kHz when BUTTON_2 = '1' else (others => '0');
  
--STOPL
end behavioral;
