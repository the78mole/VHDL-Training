-------------------------------------------------------------------------------
-- Title      : Testbench for design "prn_shiftreg"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : prn_shiftreg_tb.vhd
-- Author     : 
-- Company    : 
-- Created    : 2006-11-01
-- Last update: 2007-01-22
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-11-01  1.0      sidaglas	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity prn_shiftreg_tb is

end prn_shiftreg_tb;

-------------------------------------------------------------------------------

architecture prn_shiftreg_tb_behavioral of prn_shiftreg_tb is

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

  -- component generics
  constant REG_LENGTH : positive := 16;

  -- component ports
  signal CLK_IN           : std_logic;
  signal nRESET           : std_logic;
  signal CE               : std_logic;
  signal SHIFTREG_CONTENT : std_logic_vector(REG_LENGTH-1 downto 0);
  signal PRN_OUT          : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- prn_shiftreg_tb_behavioral

  -- component instantiation
  DUT: prn_shiftreg
    generic map (
      REG_LENGTH => REG_LENGTH)
    port map (
      CLK_IN           => CLK_IN,
      nRESET           => nRESET,
      CE               => CE,
      SHIFTREG_CONTENT => SHIFTREG_CONTENT,
      PRN_OUT          => PRN_OUT);

  -- clock generation
  Clk <= not Clk after 10 ns;
  CLK_IN <= Clk;
  
  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    nRESET <= '0';
    wait for 1 ns;
    nRESET <= '1';
    CE <= '1';
    wait for 9300 ns;
    CE <= '0';
    wait;
  end process WaveGen_Proc;

end prn_shiftreg_tb_behavioral;

-------------------------------------------------------------------------------

configuration prn_shiftreg_tb_prn_shiftreg_tb_behavioral_cfg of prn_shiftreg_tb is
  for prn_shiftreg_tb_behavioral
  end for;
end prn_shiftreg_tb_prn_shiftreg_tb_behavioral_cfg;

-------------------------------------------------------------------------------
