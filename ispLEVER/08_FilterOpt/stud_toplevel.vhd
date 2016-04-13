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
  component filteropt
    generic (
      FILTER_ORDER : positive;
      DATA_WIDTH   : positive);
    port (
      CLK_IN   : in  std_logic;
      nRESET   : in  std_logic;
      DVAL_IN  : in  std_logic;
      DVAL_OUT : out std_logic;
      DATA_IN  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

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

  signal sl_filter_dval_in, sl_filter_dval_out : std_logic;
  signal sv_filter_data_in, sv_filter_data_out : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sv_phase_inc : std_logic_vector(DATA_WIDTH-1 downto 0);
--STOPL

begin  -- behavioral

-- Here's the place for instantiations and code
--STARTL
  filteropt_1 : filteropt
    generic map (
      FILTER_ORDER => 37,
      DATA_WIDTH   => DATA_WIDTH)
    port map (
      CLK_IN   => CLK_FAST,
      nRESET   => nRESET,
      DVAL_IN  => sl_filter_dval_in,
      DVAL_OUT => sl_filter_dval_out,
      DATA_IN  => sv_filter_data_in,
      DATA_OUT => sv_filter_data_out);

  dds_sinus_1 : dds_sinus
    generic map (
      OUTPUT_WIDTH => 8,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => 8,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_FAST,
      nRESET    => nRESET,
      PHASE_INC => sv_phase_inc,
      OUTPUT    => sv_filter_data_in);

  -- We can use this as a 96 kHz-Source ;-)
  sl_filter_dval_in <= AD_DVAL;

  DA_PDOUT_L <= sv_filter_data_out;
  DA_DVAL    <= sl_filter_dval_out;

  proc_phase_inc : process (CLK_FAST, nRESET)
    variable vi_phase_inc : natural range 0 to 120;
    variable vl_dval : std_logic;
  begin  -- process proc_phase_inc
    if nRESET = '0' then                -- asynchronous reset (active low)
      sv_phase_inc <= (others => '0');
    elsif rising_edge(CLK_FAST) then      -- rising clock edge
      if AD_DVAL = '1' and vl_dval = '0' then
        
        if vi_phase_inc = 100 then
          vi_phase_inc := 0;
        else
          vi_phase_inc := vi_phase_inc + 1;
        end if;
        
      end if;
      
      vl_dval := AD_DVAL;

    end if;   
  end process proc_phase_inc;
--STOPL
end behavioral;
