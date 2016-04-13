-------------------------------------------------------------------------------
-- Title      : Testbench for design "gain_control"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : gain_control_tb.vhd
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

entity gain_control_tb is

end gain_control_tb;

-------------------------------------------------------------------------------

architecture gain_control_tb_behavioral of gain_control_tb is

  component gain_control
    generic (
      CLK_FREQ : positive;
      CLK_MAX  : positive);
    port (
      CLK_IN      : in  std_logic;
      nRESET      : in  std_logic;
      GAIN        : in  std_logic_vector(5 downto 0);
      GPO         : in  std_logic_vector(3 downto 0);
      DC_SERVO_EN : in  std_logic;
      CM_SERVO_EN : in  std_logic;
      OVERLOAD    : in  std_logic;
      SCKL        : out std_logic;
      nCS         : out std_logic;
      DOUT        : out std_logic;
      DIN         : in  std_logic);
  end component;

  -- component generics
  constant CLK_FREQ : positive := 49152000;
  constant CLK_MAX  : positive := 6250000;

  -- component ports
  signal CLK_IN      : std_logic;
  signal nRESET      : std_logic;
  signal GAIN        : std_logic_vector(5 downto 0);
  signal GPO         : std_logic_vector(3 downto 0);
  signal DC_SERVO_EN : std_logic;
  signal CM_SERVO_EN : std_logic;
  signal OVERLOAD    : std_logic;
  signal SCKL        : std_logic;
  signal nCS         : std_logic;
  signal DOUT        : std_logic;
  signal DIN         : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- gain_control_tb_behavioral

  -- component instantiation
  DUT: gain_control
    generic map (
      CLK_FREQ => CLK_FREQ,
      CLK_MAX  => CLK_MAX)
    port map (
      CLK_IN      => CLK_IN,
      nRESET      => nRESET,
      GAIN        => GAIN,
      GPO         => GPO,
      DC_SERVO_EN => DC_SERVO_EN,
      CM_SERVO_EN => CM_SERVO_EN,
      OVERLOAD    => OVERLOAD,
      SCKL        => SCKL,
      nCS         => nCS,
      DOUT        => DOUT,
      DIN         => DIN);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    
    wait until Clk = '1';
  end process WaveGen_Proc;

  

end gain_control_tb_behavioral;

-------------------------------------------------------------------------------

configuration gain_control_tb_gain_control_tb_behavioral_cfg of gain_control_tb is
  for gain_control_tb_behavioral
  end for;
end gain_control_tb_gain_control_tb_behavioral_cfg;

-------------------------------------------------------------------------------
