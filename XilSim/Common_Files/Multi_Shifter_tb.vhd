-------------------------------------------------------------------------------
-- Title      : Testbench for design "Multi_Shifter"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Multi_Shifter_tb.vhd
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

entity Multi_Shifter_tb is

end Multi_Shifter_tb;

-------------------------------------------------------------------------------

architecture Multi_Shifter_tb_behavioral of Multi_Shifter_tb is

  component Multi_Shifter
    port (
      Clock  : in  std_logic;
      ClkEn  : in  std_logic;
      Aclr   : in  std_logic;
      DataA  : in  std_logic_vector(7 downto 0);
      DataB  : in  std_logic_vector(15 downto 0);
      Result : out std_logic_vector(23 downto 0));
  end component;

  -- component ports
  signal Clock  : std_logic;
  signal ClkEn  : std_logic;
  signal Aclr   : std_logic;
  signal DataA  : std_logic_vector(7 downto 0);
  signal DataB  : std_logic_vector(15 downto 0);
  signal Result : std_logic_vector(23 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- Multi_Shifter_tb_behavioral

  -- component instantiation
  DUT: Multi_Shifter
    port map (
      Clock  => Clock,
      ClkEn  => ClkEn,
      Aclr   => Aclr,
      DataA  => DataA,
      DataB  => DataB,
      Result => Result);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    
    wait until Clk = '1';
  end process WaveGen_Proc;

  

end Multi_Shifter_tb_behavioral;

-------------------------------------------------------------------------------

configuration Multi_Shifter_tb_Multi_Shifter_tb_behavioral_cfg of Multi_Shifter_tb is
  for Multi_Shifter_tb_behavioral
  end for;
end Multi_Shifter_tb_Multi_Shifter_tb_behavioral_cfg;

-------------------------------------------------------------------------------
