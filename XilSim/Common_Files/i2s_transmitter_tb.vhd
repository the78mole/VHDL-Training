-------------------------------------------------------------------------------
-- Title      : Testbench for design "i2s_transmitter"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : i2s_transmitter_tb.vhd
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

entity i2s_transmitter_tb is

end i2s_transmitter_tb;

-------------------------------------------------------------------------------

architecture i2s_transmitter_tb_behavioral of i2s_transmitter_tb is

  component i2s_transmitter
    generic (
      DATA_WIDTH     : positive;
      CLK_IN_PER_BCK : positive;
      BCK_PER_LRCK   : positive);
    port (
      CLK_IN : in  std_logic;
      nRESET : in  std_logic;
      LRCK   : out std_logic;
      BCK    : out std_logic;
      DOUT   : out std_logic;
      DINL   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DINR   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DVAL   : in  std_logic);
  end component;

  -- component generics
  constant DATA_WIDTH     : positive := 24;
  constant CLK_IN_PER_BCK : positive := 64;
  constant BCK_PER_LRCK   : positive := 64;

  -- component ports
  signal CLK_IN : std_logic;
  signal nRESET : std_logic;
  signal LRCK   : std_logic;
  signal BCK    : std_logic;
  signal DOUT   : std_logic;
  signal DINL   : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DINR   : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DVAL   : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- i2s_transmitter_tb_behavioral

  -- component instantiation
  DUT: i2s_transmitter
    generic map (
      DATA_WIDTH     => DATA_WIDTH,
      CLK_IN_PER_BCK => CLK_IN_PER_BCK,
      BCK_PER_LRCK   => BCK_PER_LRCK)
    port map (
      CLK_IN => CLK_IN,
      nRESET => nRESET,
      LRCK   => LRCK,
      BCK    => BCK,
      DOUT   => DOUT,
      DINL   => DINL,
      DINR   => DINR,
      DVAL   => DVAL);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    
    wait until Clk = '1';
  end process WaveGen_Proc;

  

end i2s_transmitter_tb_behavioral;

-------------------------------------------------------------------------------

configuration i2s_transmitter_tb_i2s_transmitter_tb_behavioral_cfg of i2s_transmitter_tb is
  for i2s_transmitter_tb_behavioral
  end for;
end i2s_transmitter_tb_i2s_transmitter_tb_behavioral_cfg;

-------------------------------------------------------------------------------
