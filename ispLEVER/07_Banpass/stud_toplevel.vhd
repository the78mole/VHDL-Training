-------------------------------------------------------------------------------
-- Title      : Students toplevel
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : stud_toplevel.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-04
-- Last update: 2006-11-27
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

  --STARTL
  component bandpass
    generic (
      DATA_WIDTH  : positive;
      ORDER_WIDTH : positive);
    port (
      CLK_IN   : in  std_logic;
      nRESET   : in  std_logic;
      CE       : in  std_logic;
      DATA_IN  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  signal sl_bp_ce                      : std_logic;
  signal sv_bp_data_in, sv_bp_data_out : std_logic_vector(DATA_WIDTH-1 downto 0);
  --STOPL

begin  -- behavioral

  -- Hint: Order should be multiples of 8 for easier scaling with DSP-Blocks
  --STARTL
  bandpass_1 : bandpass
    generic map (
      DATA_WIDTH  => DATA_WIDTH,
      ORDER_WIDTH => 4)
    port map (
      CLK_IN   => CLK_SLOW,
      nRESET   => nRESET,
      CE       => sl_bp_ce,
      DATA_IN  => sv_bp_data_in,
      DATA_OUT => sv_bp_data_out);

  proc_bp_test : process (CLK_SLOW, nRESET)
    variable vl_edge_detect : std_logic;
  begin  -- process proc_bp_test
    if nRESET = '0' then                -- asynchronous reset (active low)
      sl_bp_ce       <= '0';
      vl_edge_detect := '0';
      sv_bp_data_out <= (others => '0');
      DA_PDOUT_L     <= (others => '0');
    elsif rising_edge(CLK_SLOW) then    -- rising clock edge
      if vl_edge_detect = '0' and AD_DVAL = '1' then
        sl_bp_ce <= '1';
      else
        sl_bp_ce <= '0';
      end if;
      vl_edge_detect := AD_DVAL;

      sv_bp_data_in <= AD_PDIN_L(AD_PDIN_L'left downto AD_PDIN_L'left-DATA_WIDTH+1);

      DA_PDOUT_L(DA_PDOUT_L'left downto DA_PDOUT_L'left-DATA_WIDTH+1) <= sv_bp_data_in;
    end if;
  end process proc_bp_test;

  --STOPL
  
end behavioral;
