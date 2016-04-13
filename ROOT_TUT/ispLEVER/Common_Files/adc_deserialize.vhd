-------------------------------------------------------------------------------
-- Title      : ADC-Deserialize
-- Project    : 
-------------------------------------------------------------------------------
-- File       : adc_deserialize.vhd
-- Author     : Daniel Glaser
-- Company    : 
-- Created    : 2006-06-27
-- Last update: 2006-07-03
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module converts the serial stream from ADC to parallel
--              buses with with data valid clock
-------------------------------------------------------------------------------
-- Copyright (c) 2006 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-06-27  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

use work.my_math.all;                   -- Here are some nice helpers in

entity adc_deserialize is
  
  generic (
    input_width         : positive := 24;
    output_width        : positive := 24;
    input_sampling_rate : positive := 96000;
    output_data_rate    : positive := 48000;
    clk_freq            : positive := 49152000;
    fs_multi            : positive := 512);

  port (
    CLK    : in std_logic;
    nRESET : in std_logic;

    -- To ADC
    SCKI  : out std_logic;
    LRCK  : in  std_logic;
    BCK   : in  std_logic;
    DOUT  : in  std_logic;
    FMT   : out std_logic_vector(1 downto 0);
    MODE  : out std_logic_vector(1 downto 0);
    BYPAS : out std_logic;
    nPDWN : out std_logic;
    OSR   : out std_logic;

    -- Parallel out
    ADC_DATA_STROBE : out std_logic;
    ADC_DATA_LEFT   : out std_logic_vector(output_width-1 downto 0);
    ADC_DATA_RIGHT  : out std_logic_vector(output_width-1 downto 0));

end adc_deserialize;

architecture adc_serialize_behavioral of adc_deserialize is

  constant clks_per_input_sample    : integer := clk_freq/input_sampling_rate;
  constant clks_per_output_sample   : integer := clk_freq/output_data_rate;
  constant input_per_output_samples : integer := input_sampling_rate/output_data_rate;
  constant decimator_acc_width      : integer := output_width + ld(input_sampling_rate/output_data_rate);

  subtype DATA_REG is std_logic_vector(input_width-1 downto 0);
  subtype DATA_ACC_REG is std_logic_vector(decimator_acc_width-1 downto 0);

  signal sv_reg_right : DATA_REG;
  signal sv_reg_left  : DATA_REG;

  -- pragma translate_off
  -- only for simulation
  signal dbg_sl_last_bck_state  : std_logic;
  signal dbg_sl_last_lrck_state : std_logic;
  signal dbg_sv_right_reg       : std_logic_vector(input_width downto 0);
  signal dbg_sv_left_reg        : std_logic_vector(input_width downto 0);

  signal dbg_si_count_in  : integer;
  signal dbg_si_count_out : integer;
  -- pragma translate_on

begin  -- adc_serialize_behavioral

  assert ((fs_multi = 512) or (fs_multi = 384) or (fs_multi = 256))
    report "This fs-multiplier is not permitted"
    severity error;
  assert ((input_width = 24) or (input_width = 20) or (input_width = 0))
    report "This width is not supported"
    severity error;
  assert input_width /= 0
    report "Input width is selected autmatically by output width."
    severity note;
  assert (output_width <= input_width or input_width = 0)
    report "Output width cannot be greater than input width. You have to do your own interpolation/decimation"
    severity error;
  assert ((clk_freq / input_sampling_rate) = fs_multi)
    report "fs_multi, clk and sampling rate doesn't match well!"
    severity warning;
  assert (output_data_rate <= input_sampling_rate)
    report "Output data rate must not be higher than input data rate"
    severity error;

  -- purpose: This process initialises the ADC
  -- type   : sequential
  -- inputs : CLK, nRESET
  -- outputs: nPDWN, FMT, MODE, BYPAS, OSR
  init : process (CLK, nRESET)
  begin  -- process
    
    if nRESET = '0' then                -- asynchronous reset (active low)

      nPDWN <= '1';                  -- Powering down while reset
      BYPAS <= '0';                  -- We won't bypass the internal filter
      OSR   <= '0';                  -- This means x64 oversampling...
      -- (no choice for 96 kHz)

      if input_width = 20 then
        FMT <= "11";                 -- This means right-justified, 20-bit
      else
        FMT <= "10";  -- This means right-justified, 24-bit        
      end if;

      if fs_multi = 512 then
        MODE <= "01";                -- This defines the master mode 512 fs
      elsif fs_multi = 384 then
        MODE <= "10";                -- This defines the master mode 384 fs
      elsif fs_multi = 256 then
        MODE <= "11";                -- This defines the master mode 256 fs
      end if;
      
    elsif rising_edge(CLK) then         -- rising clock edge

      nPDWN <= '0';                  -- Powering the ADC up
      
    end if;

  end process init;


  -- purpose: This process deserializes the ADC-Data, should come out at the
  --          appropriate ports
  -- type   : sequential
  -- inputs : CLK, nRESET, and some others
  -- outputs: DATA_STROBE, DATA_LEFT, DATA_RIGHT
  deserialization : process (CLK, nRESET)
    variable vv_reg_right, vv_reg_left             : std_logic_vector(input_width downto 0);
    variable vl_last_lrck_state, vl_last_bck_state : std_logic;
  begin  -- process deserialization
    if nRESET = '0' then                -- asynchronous reset (active low)

      vv_reg_right := (others => '0');
      vv_reg_left  := (others => '0');

      vl_last_bck_state  := '0';
      vl_last_lrck_state := '0';


      DATA_STROBE <= '0';
      DATA_LEFT   <= (others => '0');
      DATA_RIGHT  <= (others => '0');

      
    elsif rising_edge(CLK) then         -- rising clock edge

      if vl_last_lrck_state = '1' and LRCK = '0' then
        -- We will throw out the data
        sv_reg_right <= vv_reg_right(sv_reg_right'high downto sv_reg_right'high-input_width);
        sv_reg_left  <= vv_reg_left(sv_reg_left'high downto sv_reg_left'high-input_width);
      end if;

--      ADC_DATA_STROBE <= vl_last_lrck_state;  -- Edge means valid

      -------------------------------------------------------------------------
      -- Some variables get their values here, don't use them later, unless you
      -- know what you do
      -------------------------------------------------------------------------
      if vl_last_bck_state = '0' and BCK = '1' then
        -- Here we look for BCK LOW->HIGH transitions
        if LRCK = '0' then
          -- We are on right channel
          vv_reg_right(vv_reg_right'high downto 1) := vv_reg_right(vv_reg_right'high-1 downto 0);
        else
          -- We are on left channel
          vv_reg_left(vv_reg_left'high downto 1) := vv_reg_left(vv_reg_left'high-1 downto 0);
        end if;
      elsif vl_last_bck_state = '1' and BCK = '0' then
        -- Must be a HIGH->LOW transition of BCK
        if LRCK = '0' then
          vv_reg_right(0) := DOUT;
        else
          vv_reg_left(0) := AD_DOUT;
        end if;
      end if;

      -- pragma translate_off
      dbg_sv_left_reg        <= vv_reg_left;
      dbg_sv_right_reg       <= vv_reg_right;
      dbg_sl_last_lrck_state <= vl_last_lrck_state;
      dbg_sl_last_bck_state  <= vl_last_bck_state;
      -- pragma translate_on

      -------------------------------------------------------------------------
      -- Some variables get their values here, don't use them later, unless you
      -- know what you do
      -------------------------------------------------------------------------
      vl_last_bck_state  := BCK;
      vl_last_lrck_state := LRCK;
      
    end if;
  end process deserialization;

  sampling_counter : process (CLK, nRESET)
    variable vn_count_in        : natural range 0 to clks_per_input_sample    := clks_per_input_sample-1;
    variable vn_count_out       : natural range 0 to clks_per_output_sample   := clks_per_output_sample-1;
    variable vn_input_array_pos : natural range 0 to input_per_output_samples := input_per_output_samples-1;

    variable vv_decimator_acc_reg_right, vv_decimator_acc_reg_left : DATA_ACC_REG;
    variable vv_decimator_out_reg_right, vv_decimator_out_reg_left : DATA_REG;

  begin  -- process input_sampling_counter
    if nRESET = '0' then                -- asynchronous reset (active low)
      
      vn_count_in  := clks_per_input_sample-1;
      vn_count_out := clks_per_output_sample-1;

      vn_input_array_pos := input_per_output_samples-1;
      
    elsif rising_edge(CLK) then         -- rising clock edge

      -- pragma translate_off
      dbg_si_count_in  <= vi_count_in;
      dbg_si_count_out <= vi_count_out;
      -- pragma translate_off

      -- Output samples counter
      if vn_count_out = 0 then
        vn_count_out    := clks_per_output_sample-1;
        DATA_STROBE := '1';
      else
        DATA_STROBE := '0';
        vn_count_out    := vn_count_out - 1;
      end if;

      -- Input samples counter
      if vn_count_in = 0 then
        vn_count_in := clks_per_input_sample-1;

        if vn_input_array_pos = 0 then
          vi_input_array_pos := input_per_output_samples-1;

          DATA_RIGHT <= vv_decimator_out_reg_right(vv_decimator_out_reg_right'high downto vv_decimator_out_reg_right'high-ADC_DATA_RIGHT'length+1);
          DATA_LEFT  <= vv_decimator_out_reg_left(vv_decimator_out_reg_left'high downto vv_decimator_out_reg_left'high-ADC_DATA_LEFT'length+1);

          vv_decimator_acc_reg_right := conv_std_logic_vector(0, decimator_acc_width);
          vv_decimator_acc_reg_left  := conv_std_logic_vector(0, decimator_acc_width);
        else
          vn_input_array_pos := vn_input_array_pos - 1;
          accumulate(vv_decimator_acc_reg_right, sv_reg_right);
          accumulate(vv_decimator_acc_reg_left, sv_reg_left);
        end if;
      else
        vn_count_in := vn_count_in - 1;
      end if;

    end if;
  end process input_sampling_counter;

-- The concurrent statements and direct wires

  SCKI <= CLK;

--  sampling_is_data : if input_sampling_rate = output_data_rate generate
--    ADC_DATA_RIGHT <= vv_reg_right(ADC_DATA_RIGHT'high+1 downto ADC_DATA_RIGHT'high-ad_output_width+2);
--    ADC_DATA_LEFT  <= vv_reg_left(ADC_DATA_LEFT'high+1 downto ADC_DATA_LEFT'high-ad_output_width+2);
--  end generate;
--  sampling_not_data : if input_sampling_rate /= output_data_rate generate
--    sva_right_decimator_reg(si_input_array_pos) <= vv_reg_right(vv_reg_right'high downto vv_reg_right'low+1);
--    sva_left_decimator_reg(si_input_array_pos)  <= vv_reg_left(vv_reg_left'high downto vv_reg_left'low+1);
--  end generate;

end adc_serialize_behavioral;

