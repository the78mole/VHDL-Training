-------------------------------------------------------------------------------
-- Title      : Testbench for design "adc_deserialize"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : adc_deserialize_tb.vhd
-- Author     : Daniel Glaser
-- Company    : 
-- Created    : 2006-06-29
-- Last update: 2006-06-29
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2006 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-06-29  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity adc_deserialize_tb is

end adc_deserialize_tb;

-------------------------------------------------------------------------------

architecture adc_serializer_tb_behavioral of adc_deserialize_tb is

  component adc_deserialize
    generic (
      ad_input_width      : positive;
      ad_output_width     : positive;
      input_sampling_rate : positive;
      clk_freq            : positive;
      fs_multi            : positive);
    port (
      CLK             : in  std_logic;
      nRESET          : in  std_logic;
      AD_SCKI         : out std_logic;
      AD_LRCK         : in  std_logic;
      AD_BCK          : in  std_logic;
      AD_DOUT         : in  std_logic;
      AD_FMT          : out std_logic_vector(1 downto 0);
      AD_MODE         : out std_logic_vector(1 downto 0);
      AD_BYPAS        : out std_logic;
      AD_nPDWN        : out std_logic;
      AD_OSR          : out std_logic;
      ADC_DATA_STROBE : out std_logic;
      ADC_DATA_LEFT   : out std_logic_vector(ad_output_width-1 downto 0);
      ADC_DATA_RIGHT  : out std_logic_vector(ad_output_width-1 downto 0));
  end component;

  -- component generics
  constant ad_input_width      : positive := 24;
  constant ad_output_width     : positive := 24;
  constant input_sampling_rate : positive := 96000;
  constant clk_freq            : positive := 49152000;
  constant fs_multi            : positive := 512;

  -- component ports
--  signal CLK             : std_logic;
  signal nRESET          : std_logic;
  signal AD_SCKI         : std_logic;
  signal AD_LRCK         : std_logic;
  signal AD_BCK          : std_logic;
  signal AD_DOUT         : std_logic;
  signal AD_FMT          : std_logic_vector(1 downto 0);
  signal AD_MODE         : std_logic_vector(1 downto 0);
  signal AD_BYPAS        : std_logic;
  signal AD_nPDWN        : std_logic;
  signal AD_OSR          : std_logic;
  signal ADC_DATA_STROBE : std_logic;
  signal ADC_DATA_LEFT   : std_logic_vector(ad_output_width-1 downto 0);
  signal ADC_DATA_RIGHT  : std_logic_vector(ad_output_width-1 downto 0);

  -- clock
  signal CLK : std_logic := '1';

  signal audio_data_bit_count : integer := 0;
  signal audio_data_word      : std_logic_vector(23 downto 0);

begin  -- adc_serializer_tb_behavioral

  -- component instantiation
  DUT : adc_deserialize
    generic map (
      ad_input_width      => ad_input_width,
      ad_output_width     => ad_output_width,
      input_sampling_rate => input_sampling_rate,
      clk_freq            => clk_freq,
      fs_multi            => fs_multi)
    port map (
      CLK             => CLK,
      nRESET          => nRESET,
      AD_SCKI         => AD_SCKI,
      AD_LRCK         => AD_LRCK,
      AD_BCK          => AD_BCK,
      AD_DOUT         => AD_DOUT,
      AD_FMT          => AD_FMT,
      AD_MODE         => AD_MODE,
      AD_BYPAS        => AD_BYPAS,
      AD_nPDWN        => AD_nPDWN,
      AD_OSR          => AD_OSR,
      ADC_DATA_STROBE => ADC_DATA_STROBE,
      ADC_DATA_LEFT   => ADC_DATA_LEFT,
      ADC_DATA_RIGHT  => ADC_DATA_RIGHT);

  -- clock generation
  CLK    <= not CLK after 10.173 ns;

  gen_bck: process (CLK, nRESET)
    variable vi_count_clk : integer;
  begin  -- process gen_bck
    if nRESET = '0' then               -- asynchronous reset (active low)
      AD_BCK <= '0';
      vi_count_clk := 31;
    elsif rising_edge(CLK) then  -- rising clock edge
      if vi_count_clk = 0 then
        vi_count_clk := 31;
        AD_BCK <= not AD_BCK;
      else
        vi_count_clk := vi_count_clk - 1;          
      end if;
    end if;
  end process gen_bck;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET <= '0';

    wait for 100 ns;

    nRESET <= '1';
    
    wait until CLK = '1';

    AD_LRCK <= '1';

    audio_data_word <= conv_std_logic_vector(1234, 24);

    wait for 1 ps;                      -- Give the signals time to set
    
    for audio_words_counter in 0 to 10 loop
      
      AD_LRCK <= not AD_LRCK;

      wait for 100 ns;
      wait until AD_BCK = '0';

      for audio_data_bit_count in 23 downto 0 loop
        AD_DOUT <= audio_data_word(audio_data_bit_count);
        wait until AD_BCK = '1';
        wait until AD_BCK = '0';
      end loop;

      audio_data_word <= conv_std_logic_vector(conv_integer(audio_data_word) + 100, 24);

    end loop;  -- audio_words_counter

    wait;
  end process WaveGen_Proc;

  

end adc_serializer_tb_behavioral;

-------------------------------------------------------------------------------

configuration adc_deserialize_tb_adc_serializer_tb_behavioral_cfg of adc_deserialize_tb is
  for adc_serializer_tb_behavioral
  end for;
end adc_deserialize_tb_adc_serializer_tb_behavioral_cfg;

-------------------------------------------------------------------------------

