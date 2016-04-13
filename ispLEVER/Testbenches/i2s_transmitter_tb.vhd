-------------------------------------------------------------------------------
-- Title      : Testbench for design "i2s_transmitter"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : i2s_transmitter_tb.vhd
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
-- 2006-11-01  1.0      sidaglas	Created
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
  constant CLK_IN_PER_BCK : positive := 8;
  constant BCK_PER_LRCK   : positive := 64;

  -- component ports
  signal CLK_IN : std_logic := '0';
  signal nRESET : std_logic := '0';
  signal LRCK   : std_logic;
  signal BCK    : std_logic;
  signal DOUT   : std_logic;
  signal DINL   : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal DINR   : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal DVAL   : std_logic := '0';

  -- clock
  signal Clk : std_logic := '1';

  constant clk_period      : time := 10172 ps;
  constant clk_full_period : time := 2 * clk_period;

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
  Clk <= not Clk after clk_period;
  CLK_IN <= Clk;
  
  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    nRESET <= '0';
    wait for 20 ns;
    nRESET <= '1';
    -- ---- "012345678901234567890123"
    wait for 100 ns;
    DVAL <= '1';
    wait for 5 us;
    DINL <= "101010101010101010101010";
    DINR <= "001111000011110000111100";
    DVAL <= '0';
    
    wait;
  end process WaveGen_Proc;

  

end i2s_transmitter_tb_behavioral;

-------------------------------------------------------------------------------

configuration i2s_transmitter_tb_i2s_transmitter_tb_behavioral_cfg of i2s_transmitter_tb is
  for i2s_transmitter_tb_behavioral
  end for;
end i2s_transmitter_tb_i2s_transmitter_tb_behavioral_cfg;

-------------------------------------------------------------------------------
