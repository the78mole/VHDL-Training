-------------------------------------------------------------------------------
-- Title      : Testbench for design "filteropt"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : filteropt_tb.vhd
-- Author     : 
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2007-01-15
-- Last update: 2007-01-17
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2007-01-15  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

use ieee.math_real.all;

-------------------------------------------------------------------------------

entity filteropt_tb is

end filteropt_tb;

-------------------------------------------------------------------------------

architecture filteropt_tb_behavioral of filteropt_tb is

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

  -- component generics
  constant FILTER_ORDER : positive := 37;
  constant DATA_WIDTH   : positive := 8;

  -- component ports
  signal CLK_IN   : std_logic;
  signal nRESET   : std_logic;
  signal DVAL_IN  : std_logic;
  signal DVAL_OUT : std_logic;
  signal DATA_IN  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_OUT : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

  signal sv_sine_200_Hz, sv_sine_10_kHz, sv_sine_15_kHz, sv_sine_20_kHz : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_sine_var                                                    : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_testsig                                                     : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_dirac                                                       : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sv_phase_var : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal sn_sine_var  : natural;
  signal sr_sine_var  : real;

  signal sl_dirac : std_logic := '0';
  
begin  -- filteropt_tb_behavioral

  -- component instantiation
  DUT : filteropt
    generic map (
      FILTER_ORDER => FILTER_ORDER,
      DATA_WIDTH   => DATA_WIDTH)
    port map (
      CLK_IN   => CLK_IN,
      nRESET   => nRESET,
      DVAL_IN  => DVAL_IN,
      DVAL_OUT => DVAL_OUT,
      DATA_IN  => DATA_IN,
      DATA_OUT => DATA_OUT);

  dds_sinus_1 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
--      PHASE_INC => "000001010",          -- 10
      PHASE_INC => "00000001",          -- 10
--      OUTPUT    => sv_sine_2_kHz);
      OUTPUT    => sv_sine_200_Hz);

  dds_sinus_2 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => "00110010",
      OUTPUT    => sv_sine_10_kHz);

  dds_sinus_3 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => "01001011",
      OUTPUT    => sv_sine_15_kHz);

  dds_sinus_4 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => "01100100",
      OUTPUT    => sv_sine_20_kHz);

  dds_sinus_5 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => sv_phase_var,
      OUTPUT    => sv_sine_var);

  -- clock generation
  Clk    <= not Clk after 10 ns;
  CLK_IN <= Clk;

  sv_testsig <= conv_std_logic_vector(
    (conv_integer(sv_sine_200_Hz) +
     conv_integer(sv_sine_10_kHz) +
     conv_integer(sv_sine_15_kHz) +
     conv_integer(sv_sine_20_kHz))/4, DATA_WIDTH) when false
                else sv_sine_var when sl_dirac = '0'
                else sv_dirac;

  DATA_IN <= sv_testsig;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET   <= '0';
    sv_dirac <= (others => '0');
    sl_dirac <= '1';
    wait for 1 ns;
    nRESET   <= '1';
    wait for 120 us;
    sv_dirac <= conv_std_logic_vector(127, DATA_WIDTH);
    wait for 100 us;
    sv_dirac <= (others => '0');
    wait for 100 us;
    sl_dirac <= '0';
    wait;
    wait until Clk = '1';
  end process WaveGen_Proc;

  gen_dvals : process (CLK_IN, nRESET)
    variable vi_dval_count : integer := 1;
  begin  -- process gen_dvals
    if nRESET = '0' then                -- asynchronous reset (active low)
      vi_dval_count := 1;
      DVAL_IN       <= '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if vi_dval_count = 0 then
--        vi_dval_count := 511;
        vi_dval_count := 1023;
        DVAL_IN       <= '1';
      else
        DVAL_IN       <= '0';
        vi_dval_count := vi_dval_count - 1;
      end if;
    end if;
  end process gen_dvals;

  proc_phase_inc : process
  begin  -- process proc_phase_inc
    wait for 2 ms;
    if conv_integer(sv_phase_var) < 100 then
      sv_phase_var <= sv_phase_var + "00000001";
    end if;
  end process proc_phase_inc;

  sn_sine_var <= conv_integer('0'&sv_phase_var);
  sr_sine_var <= real(sn_sine_var)/real(5);

end filteropt_tb_behavioral;

-------------------------------------------------------------------------------

configuration filteropt_tb_filteropt_tb_behavioral_cfg of filteropt_tb is
  for filteropt_tb_behavioral
  end for;
end filteropt_tb_filteropt_tb_behavioral_cfg;

-------------------------------------------------------------------------------

