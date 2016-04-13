-------------------------------------------------------------------------------
-- Title      : Testbench for design "dds_sinus"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dds_sinus_tb.vhd
-- Author     : 
-- Company    : 
-- Created    : 2007-01-11
-- Last update: 2007-01-11
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2007-01-11  1.0      sidaglas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity dds_sinus_tb is

end dds_sinus_tb;

-------------------------------------------------------------------------------

architecture dds_sinus_tb_behavioral of dds_sinus_tb is

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
  constant OUTPUT_WIDTH : positive := 8;
  constant TABLE_WIDTH  : positive := 3;
  constant PHASE_WIDTH  : positive := 8;
  constant CLK_DIV      : positive := 10;

  -- component ports
  signal CLK_IN    : std_logic;
  signal nRESET    : std_logic;
  signal PHASE_INC : std_logic_vector(PHASE_WIDTH-1 downto 0);
  signal OUTPUT    : std_logic_vector(OUTPUT_WIDTH-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- dds_sinus_tb_behavioral

  -- component instantiation
  DUT: dds_sinus
    generic map (
      OUTPUT_WIDTH => OUTPUT_WIDTH,
      TABLE_WIDTH  => TABLE_WIDTH,
      PHASE_WIDTH  => PHASE_WIDTH,
      CLK_DIV      => CLK_DIV)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => PHASE_INC,
      OUTPUT    => OUTPUT);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    
    wait until Clk = '1';
  end process WaveGen_Proc;

  

end dds_sinus_tb_behavioral;

-------------------------------------------------------------------------------

configuration dds_sinus_tb_dds_sinus_tb_behavioral_cfg of dds_sinus_tb is
  for dds_sinus_tb_behavioral
  end for;
end dds_sinus_tb_dds_sinus_tb_behavioral_cfg;

-------------------------------------------------------------------------------
