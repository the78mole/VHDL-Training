-------------------------------------------------------------------------------
-- Title      : Testbench for design "filteropt"
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : filteropt_tb.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-30
-- Last update: 2006-11-30
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-30  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

-------------------------------------------------------------------------------

entity filteropt_tb is

end filteropt_tb;

-------------------------------------------------------------------------------

architecture filteropt_tb_behavioral of filteropt_tb is

  component filteropt
    generic (
      FILTER_ORDER : positive;
      DATA_WIDTH   : positive);
    port (
      CLK_IN   : in  std_logic;
      nRESET   : in  std_logic;
      DVAL_IN  : in  std_logic;
      DVAL_OUT : out std_logic;
      DATA_IN  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  -- component generics
  constant FILTER_ORDER : positive := 24;
  constant DATA_WIDTH   : positive := 8;

  -- component ports
  signal CLK_IN   : std_logic;
  signal nRESET   : std_logic;
  signal DVAL_IN  : std_logic;
  signal DVAL_OUT : std_logic;
  signal DATA_IN  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_OUT : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- filteropt_tb_behavioral

  -- component instantiation
  DUT : filteropt
    generic map (
      FILTER_ORDER => FILTER_ORDER,
      DATA_WIDTH   => DATA_WIDTH)
    port map (
      CLK_IN   => CLK_IN,
      nRESET   => nRESET,
      DVAL_IN  => DVAL_IN,
      DVAL_OUT => DVAL_OUT,
      DATA_IN  => DATA_IN,
      DATA_OUT => DATA_OUT);

  -- clock generation
  Clk    <= not Clk after 10 ns;
  CLK_IN <= Clk;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET  <= '0';
    DATA_IN <= (others => '0');
    wait for 50 ns;
    nRESET  <= '1';
    wait for 20 ns;
    for i in 0 to 100 loop
      
      DVAL_IN <= '1';
      wait for 20 ns;
      DVAL_IN <= '0';
      wait for 200 ns;
      DATA_IN <= conv_std_logic_vector(100, DATA_WIDTH);
      DVAL_IN <= '1';
      wait for 20 ns;
      DVAL_IN <= '0';
      wait for 200 ns;
      DATA_IN <= conv_std_logic_vector(120, DATA_WIDTH);
      DVAL_IN <= '1';
      wait for 20 ns;
      DVAL_IN <= '0';
      wait for 200 ns;
      DATA_IN <= conv_std_logic_vector(10, DATA_WIDTH);
      DVAL_IN <= '1';
      wait for 20 ns;
      DVAL_IN <= '0';
      wait for 200 ns;
    end loop;  -- i
    wait;
  end process WaveGen_Proc;



end filteropt_tb_behavioral;

-------------------------------------------------------------------------------

configuration filteropt_tb_filteropt_tb_behavioral_cfg of filteropt_tb is
  for filteropt_tb_behavioral
  end for;
end filteropt_tb_filteropt_tb_behavioral_cfg;

-------------------------------------------------------------------------------
