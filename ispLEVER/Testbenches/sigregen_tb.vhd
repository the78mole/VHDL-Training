-------------------------------------------------------------------------------
-- Title      : Testbench for design "sigregen"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sigregen_tb.vhd
-- Author     : 
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-21
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity sigregen_tb is

end sigregen_tb;

-------------------------------------------------------------------------------

architecture sigregen_tb_behavioral of sigregen_tb is

  component sigregen
    generic (
      DATA_WIDTH : positive;
      HYSTERESIS : natural);
    port (
      CLK_IN    : in  std_logic;
      nRESET    : in  std_logic;
      DVAL_IN   : in  std_logic;
      DVAL_OUT  : out std_logic;
      DATA_IN_A : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_IN_B : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT  : out std_logic);
  end component;

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
  constant DATA_WIDTH : positive := 8;
  constant HYSTERESIS : natural  := 2;

  -- component ports
  signal CLK_IN    : std_logic;
  signal nRESET    : std_logic;
  signal DVAL_IN   : std_logic;
  signal DVAL_OUT  : std_logic;
  signal DATA_IN_A : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_IN_B : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_OUT  : std_logic;

  -- clock
  signal Clk : std_logic := '1';

  signal sv_sine_10_kHz : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_sine_14_kHz : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sr_scale_a, sr_scale_b : real;

  signal sl_data_in : std_logic;
  
begin  -- sigregen_tb_behavioral

  -- component instantiation
  DUT : sigregen
    generic map (
      DATA_WIDTH => DATA_WIDTH,
      HYSTERESIS => HYSTERESIS)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      DVAL_IN   => DVAL_IN,
      DVAL_OUT  => DVAL_OUT,
      DATA_IN_A => DATA_IN_A,
      DATA_IN_B => DATA_IN_B,
      DATA_OUT  => DATA_OUT);

  dds_sinus_1 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => "00110010",
      OUTPUT    => sv_sine_10_kHz);

    dds_sinus_2 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => "01000110",
      OUTPUT    => sv_sine_14_kHz);
  
  -- clock generation
  Clk    <= not Clk after 10 ns;
  CLK_IN <= Clk;

  sl_data_in <= '1' when sr_scale_a > sr_scale_b else '0';
  
  DATA_IN_A <= conv_std_logic_vector(
    integer(real(conv_integer(sv_sine_10_kHz)) * sr_scale_a), DATA_WIDTH);
  DATA_IN_B <= conv_std_logic_vector(
    integer(real(conv_integer(sv_sine_14_kHz)) * sr_scale_b), DATA_WIDTH);

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    sr_scale_a <= 0.0;
    sr_scale_b <= 0.0;
    nRESET     <= '0';
    wait for 1 ns;
    nRESET     <= '1';
    wait for 2 ms;
    sr_scale_a <= 0.05;
    sr_scale_b <= 0.0;
    wait for 1 ms;
    sr_scale_a <= 0.1;
    sr_scale_b <= 0.0;
    wait for 1 ms;
    sr_scale_a <= 0.2;
    sr_scale_b <= 0.0;
    wait for 1 ms;
    sr_scale_a <= 0.4;
    sr_scale_b <= 0.0;
    wait for 1 ms;
    sr_scale_a <= 1.0;
    sr_scale_b <= 0.0;
    wait for 2 ms;
    sr_scale_a <= 0.0;
    sr_scale_b <= 1.0;
    wait for 2 ms;
    sr_scale_a <= 1.0;
    sr_scale_b <= 0.9;
    wait for 2 ms;
    sr_scale_a <= 0.9;
    sr_scale_b <= 1.0;
    wait until Clk = '1';
  end process WaveGen_Proc;

  gen_dval : process
  begin  -- process gen_dval
    DVAL_IN <= '0';
    wait for 56 ns;
    DVAL_IN <= '1';
    wait for 20 ns;
    DVAL_IN <= '0';
    wait for 10 us;
    wait for 340 ns;
  end process gen_dval;

end sigregen_tb_behavioral;

-------------------------------------------------------------------------------

configuration sigregen_tb_sigregen_tb_behavioral_cfg of sigregen_tb is
  for sigregen_tb_behavioral
  end for;
end sigregen_tb_sigregen_tb_behavioral_cfg;

-------------------------------------------------------------------------------
