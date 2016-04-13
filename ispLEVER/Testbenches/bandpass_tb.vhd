-------------------------------------------------------------------------------
-- Title      : Testbench for design "bandpass"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : bandpass_tb.vhd
-- Author     : 
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-22
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------

entity bandpass_tb is

end bandpass_tb;

-------------------------------------------------------------------------------

architecture bandpass_tb_behavioral of bandpass_tb is

  component bandpass
    generic (
      DATA_WIDTH  : positive;
      ORDER_WIDTH : positive);
    port (
      CLK_IN   : in  std_logic;
      nRESET   : in  std_logic;
      CE       : in  std_logic;
      DATA_IN  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0));
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
  constant DATA_WIDTH  : positive := 8;
  constant ORDER_WIDTH : positive := 4;

  -- component ports
  signal CLK_IN   : std_logic;
  signal nRESET   : std_logic := '0';
  signal CE       : std_logic := '0';
  signal DATA_IN  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_OUT : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

  signal sv_sine_2_kHz                                  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_sine_200_Hz                                 : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_sine_10_kHz, sv_sine_15_kHz, sv_sine_20_kHz : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sl_mixture : std_logic;

  signal sv_rectpulse : std_logic_vector(DATA_WIDTH-1 downto 0);

begin  -- bandpass_tb_behavioral

  -- component instantiation
  DUT : bandpass
    generic map (
      DATA_WIDTH  => DATA_WIDTH,
      ORDER_WIDTH => ORDER_WIDTH)
    port map (
      CLK_IN   => CLK_IN,
      nRESET   => nRESET,
      CE       => CE,
      DATA_IN  => DATA_IN,
      DATA_OUT => DATA_OUT);

  dds_sinus_1 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
--      PHASE_INC => "000001010",          -- 10
      PHASE_INC => "00000001",          -- 10
--      OUTPUT    => sv_sine_2_kHz);
      OUTPUT    => sv_sine_200_Hz);

  dds_sinus_2 : dds_sinus
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

  dds_sinus_3 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => "01001011",
      OUTPUT    => sv_sine_15_kHz);

  dds_sinus_4 : dds_sinus
    generic map (
      OUTPUT_WIDTH => DATA_WIDTH,
      TABLE_WIDTH  => 4,
      PHASE_WIDTH  => DATA_WIDTH,
      CLK_DIV      => 250)
    port map (
      CLK_IN    => CLK_IN,
      nRESET    => nRESET,
      PHASE_INC => "01100100",
      OUTPUT    => sv_sine_20_kHz);

  -- clock generation
  Clk    <= not Clk after 10 ns;
  CLK_IN <= Clk;

  gen_ce : process (CLK_IN, nRESET)
    variable vn_clk_count : natural := 0;
  begin  -- process gen_ce
    if nRESET = '0' then                -- asynchronous reset (active low)
      CE <= '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if vn_clk_count = 0 then
        vn_clk_count := 511;
        CE           <= '1';
      else
        vn_clk_count := vn_clk_count - 1;
        CE           <= '0';
      end if;
    end if;
  end process gen_ce;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET <= '0';
    sl_mixture <= '1';
    sv_rectpulse <= (others => '0');
    wait for 1 ns;
    nRESET <= '1';
    wait for 6 ms;
    sl_mixture <= '0';
    wait for 500 us;
    sv_rectpulse <= conv_std_logic_vector(64, DATA_WIDTH);
    wait for 200 us;
    sv_rectpulse <= (others => '0');
    wait;
  end process WaveGen_Proc;

--  gen_dirac: process
--  begin  -- process gen_dirac
--    DATA_IN <= (others => '0');
--    wait for 100 us;
--    wait until CE = '0';
--    DATA_IN <= conv_std_logic_vector(127,DATA_WIDTH);
--    wait until CE = '1';
--    wait until CE = '0';
--    wait for 150 us;
--    DATA_IN <= conv_std_logic_vector(127, DATA_WIDTH);
--    wait until CE = '1';
--    wait until CE = '0';
--    wait for 5 us;
--    DATA_IN <= conv_std_logic_vector(127,DATA_WIDTH);
--    wait until CE = '1';
--    wait until CE = '0';
--    wait for 5 us;
--    DATA_IN <= (others => '0');
--    wait;
--  end process gen_dirac;
  
  DATA_IN <= conv_std_logic_vector(
--    (conv_integer(sv_sine_2_kHz) +
    (conv_integer(sv_sine_200_Hz) +
     conv_integer(sv_sine_10_kHz) +
     conv_integer(sv_sine_15_kHz) +
     conv_integer(sv_sine_20_kHz))/4, DATA_WIDTH) when sl_mixture = '1' else sv_rectpulse;

end bandpass_tb_behavioral;

-------------------------------------------------------------------------------

configuration bandpass_tb_bandpass_tb_behavioral_cfg of bandpass_tb is
  for bandpass_tb_behavioral
  end for;
end bandpass_tb_bandpass_tb_behavioral_cfg;

-------------------------------------------------------------------------------
