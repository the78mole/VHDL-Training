-------------------------------------------------------------------------------
-- Title      : Students toplevel
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : stud_toplevel.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-04
-- Last update: 2006-12-02
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

  constant cp_clk_divider : positive := 10000;
  constant cp_reg_length : positive := 16;
  
  component prn_shiftreg
    generic (
      REG_LENGTH : positive);
    port (
      CLK_IN           : in  std_logic;
      nRESET           : in  std_logic;
      CE               : in  std_logic;
      SHIFTREG_CONTENT : out std_logic_vector(REG_LENGTH-1 downto 0);
      PRN_OUT          : out std_logic);
  end component;

  signal sv_prnreg : std_logic_vector(REG_LENGTH-1 downto 0);
  signal sl_prn_ce : std_logic;
  
begin  -- behavioral

  prn_shiftreg_1 : prn_shiftreg
    generic map (
      REG_LENGTH => cp_reg_length)
    port map (
      CLK_IN           => CLK_SLOW,
      nRESET           => nRESET,
      CE               => sl_prn_ce,
      SHIFTREG_CONTENT => sv_prnreg,
      PRN_OUT          => STATUS_R_GRE);

  BARGRAPH_LEFT  <= sv_prnreg(cp_reg_length-1 downto cp_reg_length-8);
  BARGRAPH_RIGHT <= sv_prnreg(7 downto 0);

  BARGRAPH_DEC_EN <= '0';

  -- This process is for debugging the prn 
  gen_ce : process (CLK_SLOW, nRESET)
    variable vl_last_button_state : std_logic;
    variable vn_count : natural range 0 to cp_clk_divider-1;
  begin  -- process gen_ce
    if nRESET = '0' then                -- asynchronous reset (active low)
      sl_prn_ce <= '0';
      vn_count := cp_clk_divider-1;
    elsif rising_edge(CLK_SLOW) then    -- rising clock edge
      if SWITCH_1 = '0' then
        -- SWITCH active = '0'
        if vn_count = 0 then          
          sl_prn_ce <= '1';
          vn_count := cp_clk_divider-1;
        else
          sl_prn_ce <= '1';
          vn_count := vn_count + 1;
        end if;
      elsif vl_last_button_state = '1' and BUTTON_1 = '0' then
        -- Button signal edge detect (BUTTON active = '0')
        sl_prn_ce <= '1';
      else
        sl_prn_ce <= '0';
      end if;
    end if;
  end process gen_ce;
  
end behavioral;
