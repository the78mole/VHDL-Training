-------------------------------------------------------------------------------
-- Title      : Testbench for design "huellkurve"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : huellkurve_tb.vhd<2>
-- Author     : 
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-21
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-11-01  1.0      sidaglas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity huellkurve_tb is

end huellkurve_tb;

-------------------------------------------------------------------------------

architecture huellkurve_tb_behavioral of huellkurve_tb is

  component huellkurve
    generic (
      DATA_WIDTH : positive);
    port (
      CLK_IN     : in  std_logic;
      nRESET     : in  std_logic;
      DVAL_IN    : in  std_logic;
      DVAL_OUT   : out std_logic;
      DATA_IN_A  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_IN_B  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT_A : out std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT_B : out std_logic_vector(DATA_WIDTH-1 downto 0));
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
  constant DATA_WIDTH : positive := 8;

  -- component ports
  signal CLK_IN     : std_logic;
  signal nRESET     : std_logic;
  signal DVAL_IN    : std_logic;
  signal DVAL_OUT   : std_logic;
  signal DATA_IN_A  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_IN_B  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_OUT_A : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_OUT_B : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sv_sine_10_kHz : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_sine_14_kHz : std_logic_vector(DATA_WIDTH-1 downto 0);
  
  -- clock
  signal Clk : std_logic := '1';

begin  -- huellkurve_tb_behavioral

  -- component instantiation
  DUT: huellkurve
    generic map (
      DATA_WIDTH => DATA_WIDTH)
    port map (
      CLK_IN     => CLK_IN,
      nRESET     => nRESET,
      DVAL_IN    => DVAL_IN,
      DVAL_OUT   => DVAL_OUT,
      DATA_IN_A  => DATA_IN_A,
      DATA_IN_B  => DATA_IN_B,
      DATA_OUT_A => DATA_OUT_A,
      DATA_OUT_B => DATA_OUT_B);

  dds_sinus_1 : dds_sinus
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

    dds_sinus_2 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => "01000110",
      OUTPUT    => sv_sine_14_kHz);

  -- clock generation
  Clk <= not Clk after 10 ns;
  CLK_IN <= Clk;

  DATA_IN_A <= sv_sine_10_kHz;
  DATA_IN_B <= sv_sine_14_kHz;
  
  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    nRESET <= '0';
    wait for 1 ns;
    nRESET <= '1';
    wait;
  end process WaveGen_Proc;

  gen_dval: process
  begin  -- process gen_dval
    DVAL_IN <= '0';
    wait for 56 ns;
    DVAL_IN <= '1';
    wait for 20 ns;
    DVAL_IN <= '0';
    wait for 10 us;
    wait for 340 ns;
  end process gen_dval;
  
end huellkurve_tb_behavioral;

-------------------------------------------------------------------------------

configuration huellkurve_tb_huellkurve_tb_behavioral_cfg of huellkurve_tb is
  for huellkurve_tb_behavioral
  end for;
end huellkurve_tb_huellkurve_tb_behavioral_cfg;

-------------------------------------------------------------------------------
