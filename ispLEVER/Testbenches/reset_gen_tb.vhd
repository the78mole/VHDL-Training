-------------------------------------------------------------------------------
-- Title      : Testbench for design "reset_gen"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : reset_gen_tb.vhd
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
-- Date        Version  Author          Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity reset_gen_tb is

end reset_gen_tb;

-------------------------------------------------------------------------------

architecture reset_gen_tb_behavioral of reset_gen_tb is

  component reset_gen
    generic (
      CLK_FREQ        : integer;
      RESET_HOLD_TIME : integer);
    port (
      CLK    : in  std_logic;
      nRESET : out std_logic;
      RESET  : out std_logic);
  end component;

  -- component generics
  constant CLK_FREQ        : integer := 49152000;
  constant RESET_HOLD_TIME : integer := 50;

  -- component ports
  signal nRESET : std_logic;
  signal RESET  : std_logic;

  -- clock
  signal Clk : std_logic := '1';

  constant clk_period      : time := 10172 ps;
  constant clk_full_period : time := 2 * clk_period;

begin  -- reset_gen_tb_behavioral

  -- component instantiation
  DUT : reset_gen
    generic map (
      CLK_FREQ        => CLK_FREQ,
      RESET_HOLD_TIME => RESET_HOLD_TIME)
    port map (
      CLK    => CLK,
      nRESET => nRESET,
      RESET  => RESET);

  -- clock generation
  Clk <= not Clk after clk_period;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    
    wait;
  end process WaveGen_Proc;

  

end reset_gen_tb_behavioral;

-------------------------------------------------------------------------------

configuration reset_gen_tb_reset_gen_tb_behavioral_cfg of reset_gen_tb is
  for reset_gen_tb_behavioral
  end for;
end reset_gen_tb_reset_gen_tb_behavioral_cfg;

-------------------------------------------------------------------------------
