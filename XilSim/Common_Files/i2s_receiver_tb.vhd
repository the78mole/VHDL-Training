-------------------------------------------------------------------------------
-- Title      : Testbench for design "i2s_receiver"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : i2s_receiver_tb.vhd
-- Author     : 
-- Company    : 
-- Created    : 2007-01-10
-- Last update: 2007-01-10
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2007-01-10  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity i2s_receiver_tb is

end i2s_receiver_tb;

-------------------------------------------------------------------------------

architecture i2s_receiver_tb_behavioral of i2s_receiver_tb is

  component i2s_receiver
    generic (
      DATA_WIDTH : positive);
    port (
      CLK_IN : in  std_logic;
      nRESET : in  std_logic;
      LRCK   : in  std_logic;
      BCK    : in  std_logic;
      DIN    : in  std_logic;
      DOUTL  : out std_logic_vector(DATA_WIDTH-1 downto 0);
      DOUTR  : out std_logic_vector(DATA_WIDTH-1 downto 0);
      DVAL   : out std_logic);
  end component;

  -- component generics
  constant DATA_WIDTH : positive := 24;

  -- component ports
  signal CLK_IN : std_logic;
  signal nRESET : std_logic;
  signal LRCK   : std_logic;
  signal BCK    : std_logic;
  signal DIN    : std_logic;
  signal DOUTL  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DOUTR  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DVAL   : std_logic;

  -- clock
  signal Clk : std_logic := '1';

  constant clk_period      : time := 10172 ps;
  constant clk_full_period : time := 2 * clk_period;

begin  -- i2s_receiver_tb_behavioral

  -- component instantiation
  DUT : i2s_receiver
    generic map (
      DATA_WIDTH => DATA_WIDTH)
    port map (
      CLK_IN => CLK_IN,
      nRESET => nRESET,
      LRCK   => LRCK,
      BCK    => BCK,
      DIN    => DIN,
      DOUTL  => DOUTL,
      DOUTR  => DOUTR,
      DVAL   => DVAL);

  -- clock generation
  Clk <= not Clk after clk_period;

  lrck_gen: process
    variable bck_count : natural := 0;
  begin  -- process lrck_gen
    wait for bck = '1';
    if bck_count = 64 then
      bck_count := 0;
    else
      bck_count := bck_count + 1;
    end if;
  end process lrck_gen;
  
  bck_gen : process
  begin  -- process bck_gen
    wait for Clk = '1';
    
  end process bck_gen;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET <= '0';
    LRCK <= '0';

  end process WaveGen_Proc;

  

end i2s_receiver_tb_behavioral;

-------------------------------------------------------------------------------

configuration i2s_receiver_tb_i2s_receiver_tb_behavioral_cfg of i2s_receiver_tb is
  for i2s_receiver_tb_behavioral
  end for;
end i2s_receiver_tb_i2s_receiver_tb_behavioral_cfg;

-------------------------------------------------------------------------------
