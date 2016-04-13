-------------------------------------------------------------------------------
-- Title      : Students toplevel
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : stud_toplevel.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-04
-- Last update: 2007-01-21
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This Toplevel is for student use. They should start here, as
--              here are already usable signals like parallel data from adc. It
--              simplyfies the work to be done.
  -- Musterloesung Anfang
--              Tutors should know, that BUTTON1 is the test source for this
--              solution.
  -- Musterloesung Ende
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

  --STARL
  component cordic_siggen
    generic (
      DATA_WIDTH : positive;
      ITERATIONS : positive;
      ITER_WIDTH : positive);
    port (
      CLK_IN    : in  std_logic;
      nRESET    : in  std_logic;
      PHASE_INC : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT  : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;
  
  signal sl_cordic_dval_in  : std_logic;
  signal sl_cordic_dval_out : std_logic;

  signal sv_siggen_dout : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_phase_inc : std_logic_vector(DATA_WIDTH-1 downto 0);
  -- Musterloesung Ende
  
begin  -- behavioral

  --STARL
  cordic_siggen_1: cordic_siggen
    generic map (
      DATA_WIDTH => DATA_WIDTH,
      ITERATIONS => 10,
      ITER_WIDTH => 4)
    port map (
      CLK_IN    => CLK_SLOW,
      nRESET    => nRESET,
      PHASE_INC => sv_phase_inc,
      DATA_OUT  => sv_siggen_dout);

  process (CLK_SLOW, nRESET)
    variable vl_edge_detect : std_logic;
  begin  -- process
    if nRESET = '0' then                -- asynchronous reset (active low)
      sv_phase_inc <= (others => '0');
    elsif rising_edge(CLK_SLOW) then    -- rising clock edge
      if vl_edge_detect = '0' and BUTTON_1 = '1' then
        sv_phase_inc <= conv_std_logic_vector(cn_angle_scale_factor/20, DATA_WIDTH);
      else
        sv_phase_inc <= conv_std_logic_vector(cn_angle_scale_factor/10, DATA_WIDTH);
      end if;
      vl_edge_detect := BUTTON_1
    end if;
  end process;
  
  DA_PDOUT_L   <= sv_siggen_dout;
  -- Musterloesung Ende

end behavioral;

