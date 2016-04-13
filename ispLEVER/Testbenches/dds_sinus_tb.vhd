-------------------------------------------------------------------------------
-- Title      : Testbench for design "dss_sinus"
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : dss_sinus_tb.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-05
-- Last update: 2007-01-12
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-09-05  1.0      student36       Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity dds_sinus_tb is

end dds_sinus_tb;

-------------------------------------------------------------------------------

architecture dds_sinus_tb of dds_sinus_tb is

  component dds_sinus
    generic (
      OUTPUT_WIDTH : positive;
      TABLE_WIDTH  : positive;
      PHASE_WIDTH  : positive;
      CLK_DIV     : positive);
    port (
      CLK_IN    : in  std_logic;
      nRESET    : in  std_logic;
      PHASE_INC : in  std_logic_vector(PHASE_WIDTH-1 downto 0);
      OUTPUT    : out std_logic_vector(OUTPUT_WIDTH-1 downto 0));
  end component;

  -- component generics
  constant OUTPUT_WIDTH : positive := 8;
  constant TABLE_WIDTH  : positive := 4;
  constant PHASE_WIDTH  : positive := 8;
  constant CLK_DIV     : positive := 250;

  -- component ports
  signal CLK_IN    : std_logic;
  signal nRESET    : std_logic;
  signal PHASE_INC : std_logic_vector(PHASE_WIDTH-1 downto 0) := (others => '0');
  signal OUTPUT    : std_logic_vector(OUTPUT_WIDTH-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- dss_sinus_tb

  assert PHASE_INC > (2**PHASE_WIDTH)-1 report "PHASE_INC to large, must be smaller than half of 2**PHASE_WIDTH" severity error;
  
  -- component instantiation
  DUT : dds_sinus
    generic map (
      OUTPUT_WIDTH => OUTPUT_WIDTH,
      TABLE_WIDTH  => TABLE_WIDTH,
      PHASE_WIDTH  => PHASE_WIDTH,
      CLK_DIV     => CLK_DIV)
    port map (
      CLK_IN    => CLK,
      nRESET    => nRESET,
      PHASE_INC => PHASE_INC,
      OUTPUT    => OUTPUT);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET    <= '0';
    wait for 20 ns;
    nRESET <= '1';
    wait for 20 ns;
    PHASE_INC <= conv_std_logic_vector(100, PHASE_WIDTH);
    wait for 1 ms;
    PHASE_INC <= conv_std_logic_vector(50, PHASE_WIDTH);
    wait;
  end process WaveGen_Proc;

  

end dds_sinus_tb;

-------------------------------------------------------------------------------

configuration dds_sinus_tb_dds_sinus_tb_cfg of dds_sinus_tb is
  for dds_sinus_tb
  end for;
end dds_sinus_tb_dds_sinus_tb_cfg;

-------------------------------------------------------------------------------
