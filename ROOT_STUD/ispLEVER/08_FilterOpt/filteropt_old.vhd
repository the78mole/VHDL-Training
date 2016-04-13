-------------------------------------------------------------------------------
-- Title      : Filter Optimization
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : filteropt.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-30
-- Last update: 2007-01-15
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module implements a DSP-Block-Optimized version of the
--              previosly discussed filter.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-11-30  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

use ieee.math_real.all;

entity filteropt is
  
  generic (
    FILTER_ORDER : positive := 24;
    DATA_WIDTH   : positive := 8);

  port (
    CLK_IN   : in  std_logic;
    nRESET   : in  std_logic;
    DVAL_IN  : in  std_logic;
    DVAL_OUT : out std_logic;
    DATA_IN  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    DATA_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0));

end filteropt;

architecture behavioral of filteropt is

--  component FilterCell
--    port (
--      CLK0 : in  std_logic;
--      RST0 : in  std_logic;
--      A0   : in  std_logic_vector(8 downto 0);
--      A1   : in  std_logic_vector(8 downto 0);
--      A2   : in  std_logic_vector(8 downto 0);
--      A3   : in  std_logic_vector(8 downto 0);
--      B0   : in  std_logic_vector(8 downto 0);
--      B1   : in  std_logic_vector(8 downto 0);
--      B2   : in  std_logic_vector(8 downto 0);
--      B3   : in  std_logic_vector(8 downto 0);
--      SUM  : out std_logic_vector(19 downto 0));
--  end component;

  type tav_multconn is array (0 to 3) of std_logic_vector(DATA_WIDTH downto 0);
  type tav_pipe is array (0 to FILTER_ORDER-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
  type tav_sumpipe is array (0 to FILTER_ORDER/2-1) of std_logic_vector(DATA_WIDTH downto 0);

  signal sav_pipe                       : tav_pipe;
  signal sav_sumpipe                    : tav_sumpipe;
  signal sav_multconn_a, sav_multconn_b : tav_multconn;

  signal sv_multout : std_logic_vector(19 downto 0);

  signal sl_mult_rst, sl_start : std_logic;
  
  constant cn_count_max : natural := (FILTER_ORDER/8)+5;

  constant ci_pipe_sum_max : integer := integer_max(DATA_WIDTH+1);  -- 9 Bit

  constant cav_coefficients : tav_sumpipe :=
    (integer(real(-0.00101)*real(ci_pipe_sum_max)),     -- c0 = c15
     (integer(real(-0.00521)*real(ci_pipe_sum_max))),   -- c1 = c14
     (integer(real(-0.01269)*real(ci_pipe_sum_max))),   -- c2 = c13
     (integer(real(-0.01214)*real(ci_pipe_sum_max))),   -- c3 = c12
     (integer(real(+0.01830)*real(ci_pipe_sum_max))),   -- c4 = c11
     (integer(real(+0.08914)*real(ci_pipe_sum_max))),   -- c5 = c10
     (integer(real(+0.17962)*real(ci_pipe_sum_max))),   -- c6 = c9
     (integer(real(+0.24399)*real(ci_pipe_sum_max))));  -- c7 = c8

begin  -- behavioral

--  FilterCell_1 : FilterCell
--    port map (
--      CLK0 => CLK_IN,
--      RST0 => sl_mult_rst,
--      A0   => sav_multconn_a(0),
--      A1   => sav_multconn_a(1),
--      A2   => sav_multconn_a(2),
--      A3   => sav_multconn_a(3),
--      B0   => sav_multconn_b(0),
--      B1   => sav_multconn_b(1),
--      B2   => sav_multconn_b(2),
--      B3   => sav_multconn_b(3),
--      SUM  => sv_multout);

  sim_multi: process (CLK_IN, sl_mult_rst)
    variable vv_imed1, vv_imed2 : std_logic_vector(17 downto 0);
    variable vv_imed3, vv_imed4 : std_logic_vector(17 downto 0);
    variable vv_2med1, vv_2med2 : std_logic_vector(18 downto 0);
    variable vv_out : std_logic_vector(19 downto 0);
  begin  -- process sim_multi
    if sl_mult_rst = '1' then                -- asynchronous reset (active low)
--      sav_multconn_a <= (others => (others => '0'));
--      sav_multconn_b <= (others => (others => '0'));
      vv_out := (others => '0');
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      vv_imed1 := signed(sav_multconn_a(0)) * signed(sav_multconn_b(0));
      vv_imed2 := signed(sav_multconn_a(1)) * signed(sav_multconn_b(1));
      vv_imed3 := signed(sav_multconn_a(2)) * signed(sav_multconn_a(2));
      vv_imed4 := signed(sav_multconn_a(3)) * signed(sav_multconn_a(3));
      vv_2med1 := conv_std_logic_vector(signed(vv_imed1) + signed(vv_imed2), 19);
      vv_2med2 := conv_std_logic_vector(signed(vv_imed3) + signed(vv_imed4), 19);
      vv_out := vv_out + vv_2med1 + vv_2med2;
      sv_multout <= vv_out;
    end if;
  end process sim_multi;



  
  proc_filter_control : process (CLK_IN, nRESET)
    variable vn_counter : natural range 0 to cn_count_max;
    variable vl_dval : std_logic;
  begin  -- process proc_filter_control
    if nRESET = '0' then                -- asynchronous reset (active low)
      vn_counter     := 0;
      sav_pipe <= (others => (others => '0'));
      sl_mult_rst    <= '1';
      sav_multconn_a <= (others => (others => '0'));
      sav_multconn_b <= (others => (others => '0'));
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if DVAL_IN = '1' and vl_dval = '0' and vn_counter = cn_count_max then
        sl_start   <= '1';
        vn_counter := 0;
        sl_mult_rst <= '0';
      elsif vn_counter /= cn_count_max then
        vn_counter := vn_counter + 1;
      end if;

      if vn_counter = 0 then
        sav_pipe(0 to sav_pipe'right) <= DATA_IN & sav_pipe(0 to sav_pipe'right-1);
        DVAL_OUT                      <= '0';
        sl_mult_rst                   <= '0';
        
      elsif vn_counter = 1 then
        DVAL_OUT <= '1';
        for i in 0 to (FILTER_ORDER/2)-1 loop
          sav_sumpipe(i) <= conv_std_logic_vector(
            signed(sav_pipe(i)) + signed(sav_pipe(FILTER_ORDER-i-1)),DATA_WIDTH+1);
        end loop;  -- i
        
      elsif vn_counter >= 2 and vn_counter < 2+(FILTER_ORDER/8) then  -- >= 2, <=4
        for j in 0 to 3 loop
          sav_multconn_a(j) <= sav_sumpipe((vn_counter - 2) + 3*j);
          sav_multconn_b(j) <= cav_coefficients((vn_counter - 2) + 3*j);
        end loop;  -- j
        
      elsif vn_counter = 4+(FILTER_ORDER/8) then
        DATA_OUT    <= conv_std_logic_vector(conv_integer(sv_multout)/2**12, DATA_WIDTH);
        DVAL_OUT    <= '1';
        sl_mult_rst <= '1';
      end if;

      vl_dval := DVAL_IN;
    end if;
  end process proc_filter_control;
end behavioral;

