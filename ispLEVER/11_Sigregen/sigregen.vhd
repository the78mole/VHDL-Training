-------------------------------------------------------------------------------
-- Title      : Signal Regeneration
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sigregen.vhd
-- Author     : 
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-22
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Ths module regenerates the serial input signal, which is FSK
--              modulated with two different sinusodial signals. Two bandpasses
--              filter out the correct frequencies, a demodulator gives a dc
--              offset and a low pass filter makes is smooth again. This two dc
--              signals are compared and the bigger one gives the valid output.
--              A hysteresis is also applied to kill some noise.
-------------------------------------------------------------------------------
-- Copyright (c) 2007 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

--NOCOPY

entity sigregen is

  generic (
    DATA_WIDTH : positive := 8;
    HYSTERESIS : natural  := 2);

  port (
    CLK_IN    : in  std_logic;
    nRESET    : in  std_logic;
    DVAL_IN   : in  std_logic;
    DVAL_OUT  : out std_logic;
    DATA_IN_A : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    DATA_IN_B : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    DATA_OUT  : out std_logic);

end sigregen;

architecture behavioral of sigregen is

  constant FILTER_ORDER : positive := 32;

  signal si_comp_out : integer range -2**(DATA_WIDTH) to 2**(DATA_WIDTH)-1;
  signal sl_add_val  : std_logic;

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

  component huellkurve
    generic (
      DATA_WIDTH : positive);
    port (
      CLK_IN     : in  std_logic;
      nRESET     : in  std_logic;
      DVAL_IN    : in  std_logic;
      DVAL_OUT   : out std_logic;
      DATA_IN_A  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_IN_B  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT_A : out std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT_B : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  signal sl_hk_dval_in, sl_hk_dval_out      : std_logic;
  signal sv_hk_data_in_a, sv_hk_data_in_b   : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_hk_data_out_a, sv_hk_data_out_b : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sl_filt_val : std_logic;
  
  signal sl_lp1_dval_in, sl_lp1_dval_out : std_logic;
  signal sv_lp1_data_in, sv_lp1_data_out : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal sl_lp2_dval_in, sl_lp2_dval_out : std_logic;
  signal sv_lp2_data_in, sv_lp2_data_out : std_logic_vector(DATA_WIDTH-1 downto 0);

begin  -- behavioral

  huellkurve_1 : huellkurve
    generic map (
      DATA_WIDTH => DATA_WIDTH)
    port map (
      CLK_IN     => CLK_IN,
      nRESET     => nRESET,
      DVAL_IN    => sl_hk_dval_in,
      DVAL_OUT   => sl_hk_dval_out,
      DATA_IN_A  => sv_hk_data_in_a,
      DATA_IN_B  => sv_hk_data_in_b,
      DATA_OUT_A => sv_hk_data_out_a,
      DATA_OUT_B => sv_hk_data_out_b);

  sv_hk_data_in_a <= DATA_IN_A;
  sv_hk_data_in_b <= DATA_IN_B;
  sl_hk_dval_in   <= DVAL_IN;

  sv_lp1_data_in <= '0' & sv_hk_data_out_a(DATA_WIDTH-1 downto 1);
  sv_lp2_data_in <= '0' & sv_hk_data_out_b(DATA_WIDTH-1 downto 1);
  sl_lp1_dval_in <= sl_hk_dval_out;
  sl_lp2_dval_in <= sl_hk_dval_out;

  filteropt_1 : filteropt
    generic map (
      FILTER_ORDER => FILTER_ORDER,
      DATA_WIDTH   => DATA_WIDTH)
    port map (
      CLK_IN   => CLK_IN,
      nRESET   => nRESET,
      DVAL_IN  => sl_lp1_dval_in,
      DVAL_OUT => sl_lp1_dval_out,
      DATA_IN  => sv_lp1_data_in,
      DATA_OUT => sv_lp1_data_out);

  filteropt_2 : filteropt
    generic map (
      FILTER_ORDER => FILTER_ORDER,
      DATA_WIDTH   => DATA_WIDTH)
    port map (
      CLK_IN   => CLK_IN,
      nRESET   => nRESET,
      DVAL_IN  => sl_lp2_dval_in,
      DVAL_OUT => sl_lp2_dval_out,
      DATA_IN  => sv_lp2_data_in,
      DATA_OUT => sv_lp2_data_out);

  sync_filters : process (CLK_IN, nRESET)
    variable vl_filter_val1, vl_filter_val2 : std_logic;
    variable vl_lp1_val, vl_lp2_val         : std_logic;
  begin  -- process sync_filters
    if nRESET = '0' then                -- asynchronous reset (active low)
      vl_filter_val1 := '0';
      vl_filter_val2 := '0';
      sl_filt_val <= '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      
      if vl_filter_val1 = '1' and vl_filter_val2 = '1' then
        sl_filt_val <= '1';
        vl_filter_val1 := '0';
        vl_filter_val2 := '0';
      else
        sl_filt_val <= '0';
        if sl_lp1_dval_out = '1' and vl_lp1_val = '0' then
          vl_filter_val1 := '1';
        end if;
        if sl_lp2_dval_out = '1' and vl_lp2_val = '0' then
          vl_filter_val2 := '1';
        end if;
      end if;
      
      vl_lp1_val := sl_lp1_dval_out;
      vl_lp2_val := sl_lp2_dval_out;
    end if;
  end process sync_filters;

  proc_comp : process (CLK_IN, nRESET)
    variable vl_dval : std_logic := '0';
  begin  -- process proc_comp
    if nRESET = '0' then                -- asynchronous reset (active low)
      si_comp_out <= 0;
      sl_add_val  <= '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if sl_filt_val = '1' and vl_dval = '0' then
        si_comp_out <= conv_integer('0' & sv_lp1_data_out) - conv_integer('0' & sv_lp2_data_out);
        sl_add_val  <= '1';
      else
        sl_add_val <= '0';
      end if;

      vl_dval := sl_filt_val;
    end if;
  end process proc_comp;

  proc_hyst : process (CLK_IN, nRESET)
    variable vl_val : std_logic := '0';
  begin  -- process proc_hyst
    if nRESET = '0' then                -- asynchronous reset (active low)
      DATA_OUT <= '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if sl_add_val = '1' and vl_val = '0' then
        if si_comp_out >= HYSTERESIS then
          DATA_OUT <= '1';
        elsif si_comp_out <= -(HYSTERESIS) then
          DATA_OUT <= '0';
        end if;
        DVAL_OUT <= '1';
      else
        DVAL_OUT <= '0';
      end if;

      vl_val := sl_add_val;
    end if;
  end process proc_hyst;
end behavioral;
