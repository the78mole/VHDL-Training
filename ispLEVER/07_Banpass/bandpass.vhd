-------------------------------------------------------------------------------
-- Title      : Bandpass
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : bandpass.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-21
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This is the Bandpass in linear phase structure.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
--use ieee.numeric_std.all;

use work.my_funcs.all;

use ieee.math_real.all;

--NOCOPY

entity bandpass is
  
  generic (
    DATA_WIDTH  : positive := 8;
    ORDER_WIDTH : positive := 4);
--    ORDER      : positive := 16);

  port (
    CLK_IN   : in  std_logic;
    nRESET   : in  std_logic;
    CE       : in  std_logic;
    DATA_IN  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    DATA_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0));

end bandpass;

architecture behavioral of bandpass is

  constant cn_order : natural := 2**ORDER_WIDTH;

  constant ci_pipe_min : integer := integer_min(DATA_WIDTH);  -- 8 Bit
  constant ci_pipe_max : integer := integer_max(DATA_WIDTH);

  constant ci_pipe_sum_min : integer := integer_min(DATA_WIDTH+1);  -- 9 Bit
  constant ci_pipe_sum_max : integer := integer_max(DATA_WIDTH+1);

  constant ci_pipe_sum_scale : integer := 2**DATA_WIDTH;

  constant ci_prod_min : integer := integer_min((2*(DATA_WIDTH+1))-1);  -- 17 Bit
  constant ci_prod_max : integer := integer_max((2*(DATA_WIDTH+1))-1);

  constant ci_prod_sum_min : integer := integer_min((2*(DATA_WIDTH+1)));  -- 18 Bit
  constant ci_prod_sum_max : integer := integer_max((2*(DATA_WIDTH+1)));

  constant ci_prod_sum_sum_min : integer := integer_min((2*(DATA_WIDTH+1))+1);  -- 19 Bit
  constant ci_prod_sum_sum_max : integer := integer_max((2*(DATA_WIDTH+1))+1);

  -- (DATA_WIDTH+1)             for the adder before the multiplier
  -- 2*(DATA_WIDTH+1)-1         for the multiplier itself
  -- ORDER_WIDTH                for the sum of adders
  -- ORDER_WIDTH-1              adder before the multiplier subtracted
  -- ==================================================================
  -- Gives: 2*(DATA_WIDTH+1) - 1 + ORDER_WIDTH - 1
  constant ci_data_out_min : integer := integer_min((2*(DATA_WIDTH+1))+ORDER_WIDTH-2);  -- 20 Bit
  constant ci_data_out_max : integer := integer_max((2*(DATA_WIDTH+1))+ORDER_WIDTH-2);

  -- This should be fixed for orders not powers of two
--  constant cn_data_out_scale : natural := 2**(DATA_WIDTH+1);
  constant cn_data_out_scale : natural := 2**DATA_WIDTH;

  subtype tui_pipe is integer range ci_pipe_min to ci_pipe_max;
  subtype tui_pipe_sum is integer range ci_pipe_sum_min to ci_pipe_sum_max;
  subtype tui_prod is integer range ci_prod_min to ci_prod_max;
  subtype tui_prod_sum is integer range ci_prod_sum_min to ci_prod_sum_max;
  subtype tui_prod_sum_sum is integer range ci_prod_sum_sum_min to ci_prod_sum_sum_max;

  subtype tui_whole_sum is integer range ci_data_out_min to ci_data_out_max;
  subtype tui_whole_scaled is integer range ci_pipe_min to ci_pipe_max;

  type tuai_pipe is array (0 to cn_order-1) of tui_pipe;
  type tuai_pipe_sum is array (0 to (cn_order/2)-1) of tui_pipe_sum;
  type tuai_prod is array (0 to (cn_order/2)-1) of tui_prod;
  type tuai_prod_sum is array (0 to (cn_order/4)-1) of tui_prod_sum;
  type tuai_prod_sum_sum is array (0 to (cn_order/4)-1) of tui_prod_sum_sum;

  --Synopsys translate_off
  signal sai_pipe         : tuai_pipe;
  --Synopsys translate_on
  signal sai_pipe_sum     : tuai_pipe_sum;
  signal sai_prod         : tuai_prod;
  signal sai_prod_sum     : tuai_prod_sum;
  signal sai_prod_sum_sum : tuai_prod_sum_sum;

  signal si_whole_sum    : tui_whole_sum;
  signal si_whole_scaled : tui_whole_scaled;

  constant cai_coefficients : tuai_pipe_sum :=
    (integer(real(-0.00101)*real(ci_pipe_sum_max)),     -- c0 = c15
     (integer(real(-0.00521)*real(ci_pipe_sum_max))),   -- c1 = c14
     (integer(real(-0.01269)*real(ci_pipe_sum_max))),   -- c2 = c13
     (integer(real(-0.01214)*real(ci_pipe_sum_max))),   -- c3 = c12
     (integer(real(+0.01830)*real(ci_pipe_sum_max))),   -- c4 = c11
     (integer(real(+0.08914)*real(ci_pipe_sum_max))),   -- c5 = c10
     (integer(real(+0.17962)*real(ci_pipe_sum_max))),   -- c6 = c9
     (integer(real(+0.24399)*real(ci_pipe_sum_max))));  -- c7 = c8

begin  -- behavioral

  proc_filter : process (CLK_IN, nRESET)
    variable vi_whole_sum : tui_whole_sum;
    variable vai_pipe     : tuai_pipe;
  begin  -- process proc_filter
    if nRESET = '0' then                -- asynchronous reset (active low)
      vai_pipe         := (others => 0);
      sai_pipe         <= (others => 0);
      sai_pipe_sum     <= (others => 0);
      sai_prod         <= (others => 0);
      sai_prod_sum     <= (others => 0);
      sai_prod_sum_sum <= (others => 0);
      si_whole_sum     <= 0;
      si_whole_scaled  <= 0;
      DATA_OUT         <= (others => '0');
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      if CE = '1' then

        vai_pipe(1 to cn_order-1) := vai_pipe(0 to cn_order-2);

        --Synopsys translate_off
        sai_pipe <= vai_pipe;
        --Synopsys translate_on

        -- We put new data into the pipeline at position 0
        vai_pipe(0) := conv_integer(DATA_IN);
        
      end if;

      for j in 0 to (cn_order/2)-1 loop
        sai_prod(j)     <= sai_pipe_sum(j) * cai_coefficients(j);
        sai_pipe_sum(j) <= vai_pipe(j) + vai_pipe(cn_order-j-1);
      end loop;  -- j

      for k in 0 to (cn_order/4)-1 loop
        sai_prod_sum(k) <= sai_prod(2*k) + sai_prod((2*k)+1);
      end loop;  -- k

      vi_whole_sum := 0;
      for l in 0 to (cn_order/8)-1 loop
        vi_whole_sum        := vi_whole_sum + sai_prod_sum_sum(l);
        sai_prod_sum_sum(l) <= sai_prod_sum(2*l) + sai_prod_sum((2*l)+1);
      end loop;  -- l

      si_whole_sum    <= vi_whole_sum;
      si_whole_scaled <= si_whole_sum/cn_data_out_scale;
      DATA_OUT        <= conv_std_logic_vector(si_whole_scaled, DATA_WIDTH);

      
    end if;
  end process proc_filter;

end behavioral;
