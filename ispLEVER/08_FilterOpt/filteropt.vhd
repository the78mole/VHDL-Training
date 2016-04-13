-------------------------------------------------------------------------------
-- Title      : Filter Optimization
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : filteropt.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-23
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
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

use ieee.math_real.all;

--NOCOPY

entity filteropt is
  
  generic (
    FILTER_ORDER : positive := 37;
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

  constant cn_mult_per_block : natural := 8;
  constant cn_pipe_sum_count : natural := (FILTER_ORDER+1)/2;
  constant cn_block_count    : natural := (FILTER_ORDER-1)/(2*cn_mult_per_block)+1;
  constant cn_scale_width    : natural := DATA_WIDTH+1;  -- Empirisch emitteln!

  subtype ti_pipe is integer range -2**(DATA_WIDTH-1) to 2**(DATA_WIDTH-1)-1;  -- 8 Bit
  subtype ti_pipe_sum is integer range -2**(DATA_WIDTH) to 2**(DATA_WIDTH)-1;  -- 9 Bit
  subtype ti_multed is integer range -2**(2*(DATA_WIDTH+1)-1) to 2**(2*(DATA_WIDTH+1)-1)-1;  -- 18 Bit
  subtype ti_mult_sumed is integer range -2**(2*(DATA_WIDTH+1)) to 2**(2*(DATA_WIDTH+1))-1;  -- 19 Bit
  subtype ti_maced is integer range -2**(2*(DATA_WIDTH+2)-1) to 2**(2*(DATA_WIDTH+2)-1)-1;  -- 20 Bit
  subtype ti_endsum is integer range -2**(2*(DATA_WIDTH+2)) to 2**(2*(DATA_WIDTH+2))-1;  -- 21 Bit

  type tai_pipe is array (0 to FILTER_ORDER-1) of ti_pipe;
  type tai_pipe_sum is array (0 to cn_mult_per_block*cn_block_count-1) of ti_pipe_sum;
  type tai_mult_in is array (0 to cn_mult_per_block-1) of ti_pipe_sum;
  type tai_mult_out is array (0 to cn_mult_per_block-1) of ti_multed;
  type tai_mult_sumed is array (0 to cn_mult_per_block/2-1) of ti_mult_sumed;
  type tai_maced is array (0 to 1) of ti_maced;

  constant ci_pipe_sum_max : integer := ti_pipe_sum'high;

  constant cai_coefficients : tai_pipe_sum :=
    (integer(real(-0.00128)*real(ci_pipe_sum_max)),     -- c0, c36
     (integer(real(-0.04028)*real(ci_pipe_sum_max))),   -- c1, c35
     (integer(real(-0.02579)*real(ci_pipe_sum_max))),   -- c2, c34
     (integer(real(-0.02100)*real(ci_pipe_sum_max))),   -- c3, c33
     (integer(real(-0.00510)*real(ci_pipe_sum_max))),   -- c4, c32
     (integer(real(+0.01782)*real(ci_pipe_sum_max))),   -- c5, c31
     (integer(real(+0.04010)*real(ci_pipe_sum_max))),   -- c6, c30
     (integer(real(+0.05267)*real(ci_pipe_sum_max))),   -- c7, c29
     (integer(real(+0.04843)*real(ci_pipe_sum_max))),   -- c8, c28
     (integer(real(+0.02582)*real(ci_pipe_sum_max))),   -- c9, c27
     (integer(real(-0.00974)*real(ci_pipe_sum_max))),   -- c10, c26
     (integer(real(-0.04694)*real(ci_pipe_sum_max))),   -- c11, c25
     (integer(real(-0.07233)*real(ci_pipe_sum_max))),   -- c12, c24
     (integer(real(-0.07553)*real(ci_pipe_sum_max))),   -- c13, c23
     (integer(real(-0.05338)*real(ci_pipe_sum_max))),   -- c14, c22
     (integer(real(-0.01187)*real(ci_pipe_sum_max))),   -- c15, c21
     (integer(real(+0.03558)*real(ci_pipe_sum_max))),   -- c16, c20
     (integer(real(+0.07288)*real(ci_pipe_sum_max))),   -- c17, c19
     (integer(real(+0.08694)*real(ci_pipe_sum_max))),   -- c18
     
     (integer(real(+0.00000)*real(ci_pipe_sum_max))),
     (integer(real(+0.00000)*real(ci_pipe_sum_max))),
     (integer(real(+0.00000)*real(ci_pipe_sum_max))),
     (integer(real(+0.00000)*real(ci_pipe_sum_max))),
     (integer(real(+0.00000)*real(ci_pipe_sum_max))));

  signal sai_pipe     : tai_pipe;
  signal sai_pipe_sum : tai_pipe_sum := (others => 0);

  signal sai_multiplier_in_a, sai_multiplier_in_b : tai_mult_in;
  signal sai_multiplier_out                       : tai_mult_out;
  signal sai_mult_sum                             : tai_mult_sumed;

  signal sai_mac   : tai_maced;
  signal si_endsum : ti_endsum;

  signal si_filter_outreg, si_filter_savereg : integer range -2**(2*DATA_WIDTH-1) to 2**(DATA_WIDTH-1)-1;

  signal sl_mult_active : std_logic;

  signal sn_current_block : natural range 0 to cn_block_count-1;
  
begin  -- behavioral


  -----------------------------------------------------------------------------
  -- Let the pipe flow/smoke
  -----------------------------------------------------------------------------
  shift_pipe_regs : process (CLK_IN, nRESET)
    variable vl_dval_in : std_logic := '0';
  begin  -- process shift_pipe_regs
    if nRESET = '0' then                -- asynchronous reset (active low)
      sai_pipe <= (others => 0);
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if DVAL_IN = '1' and vl_dval_in = '0' then
        -- Shift the values in the pipeline by one
        sai_pipe <= conv_integer(DATA_IN) & sai_pipe(0 to FILTER_ORDER-2);
      end if;
      vl_dval_in := DVAL_IN;
    end if;
  end process shift_pipe_regs;
  -----------------------------------------------------------------------------
  -- Let the pipe flow/smoke
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Odd or even symmetry ??? Here we handle both ;-)
  -----------------------------------------------------------------------------
  gen_pipe_sums : for li_pipe_sum in 0 to cn_pipe_sum_count-1 generate
    process (CLK_IN, nRESET)
      variable vi_sum_helper : ti_pipe_sum;
    begin  -- process
      if nRESET = '0' then              -- asynchronous reset (active low)
        sai_pipe_sum(li_pipe_sum) <= 0;
      elsif rising_edge(CLK_IN) then    -- rising clock edge

        vi_sum_helper := sai_pipe(li_pipe_sum);
        if li_pipe_sum /= (FILTER_ORDER - li_pipe_sum - 1) then
          vi_sum_helper := vi_sum_helper + sai_pipe(FILTER_ORDER - li_pipe_sum - 1);
        end if;
        sai_pipe_sum(li_pipe_sum) <= vi_sum_helper;
        
      end if;
    end process;
  end generate gen_pipe_sums;
  -----------------------------------------------------------------------------
  -- Odd or even symmetry ??? Here we handle both ;-)
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Walk through the pipes
  -----------------------------------------------------------------------------
  proc_pipe_walk : process (CLK_IN, nRESET)
    variable vl_dval_in : std_logic := '0';
  begin  -- process proc_pipe_walk
    if nRESET = '0' then                -- asynchronous reset (active low)
      sn_current_block <= 0;
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if DVAL_IN = '1' and vl_dval_in = '0' then
        sl_mult_active   <= '1';
        sn_current_block <= cn_block_count - 1;
      elsif sn_current_block = 0 then
        sl_mult_active <= '0';
      else
        sn_current_block <= sn_current_block - 1;
      end if;

      vl_dval_in := DVAL_IN;
    end if;
  end process proc_pipe_walk;
  -----------------------------------------------------------------------------
  -- Walk through the pipes
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Multiplexer before Multiplier and Multiplier itself
  -----------------------------------------------------------------------------
  gen_mult_mux : for li_mult_in_block in 0 to cn_mult_per_block-1 generate

    sai_multiplier_in_a(li_mult_in_block) <=
      sai_pipe_sum(8*sn_current_block+li_mult_in_block)
      when sl_mult_active = '1' else 0;
    sai_multiplier_in_b(li_mult_in_block) <=
      cai_coefficients(8*sn_current_block+li_mult_in_block)
      when sl_mult_active = '1' else 0;

    -- If the synthesis is smart enough, it will see the pipeline register,
    -- available in the sysDSP blocks, otherwise, coment out the process
    proc_pipeline_reg : process (CLK_IN)
    begin  -- process gen_pipeline_reg
      if rising_edge(CLK_IN) then       -- rising clock edge
        sai_multiplier_out(li_mult_in_block) <=
          sai_multiplier_in_a(li_mult_in_block) *
          sai_multiplier_in_b(li_mult_in_block);
      end if;
    end process proc_pipeline_reg;

  end generate gen_mult_mux;
  -----------------------------------------------------------------------------
  -- Multiplexer before Multiplier and Multiplier itself
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Adder after Multiplier
  -----------------------------------------------------------------------------
  gen_mult_sum : for li_sum_after_mult in 0 to cn_mult_per_block/2-1 generate
    sai_mult_sum(li_sum_after_mult) <=
      sai_multiplier_out(2*li_sum_after_mult) +
      sai_multiplier_out(2*li_sum_after_mult + 1);
  end generate gen_mult_sum;
  -----------------------------------------------------------------------------
  -- Adder after Multiplier
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- MAC Unit with adder in front
  -----------------------------------------------------------------------------
  gen_macs : for li_macs in 0 to 1 generate
    gen_accumulate : process (CLK_IN, nRESET)
      variable vl_dval_in : std_logic := '0';
    begin  -- process gen_accumulate
      if nRESET = '0' then              -- asynchronous reset (active low)
        sai_mac(li_macs) <= 0;
      elsif rising_edge(CLK_IN) then    -- rising clock edge
        if DVAL_IN = '1' and vl_dval_in = '0' then
          -- First we save the accumulated values
          -- Then we do some other things
          sai_mac(li_macs) <= 0;
        else
          sai_mac(li_macs) <=
            sai_mac(li_macs) +
            sai_mult_sum(2*li_macs) + sai_mult_sum(2*li_macs+1);
        end if;
      end if;
    end process gen_accumulate;
  end generate gen_macs;
  -----------------------------------------------------------------------------
  -- MAC Unit with adder in front
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Do the output
  -----------------------------------------------------------------------------
  proc_out : process (CLK_IN, nRESET)
    variable vl_dval_in : std_logic := '0';
    variable vi_endsum  : ti_endsum;
  begin  -- process proc_out
    if nRESET = '0' then                -- asynchronous reset (active low)
      DATA_OUT <= (others => '0');
      DVAL_OUT <= '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      
      if DVAL_IN = '1' and vl_dval_in = '0' then
        vi_endsum := sai_mac(0) + sai_mac(1);
        si_endsum <= vi_endsum;
        DATA_OUT  <= conv_std_logic_vector(vi_endsum/2**cn_scale_width, DATA_WIDTH);
        DVAL_OUT  <= '1';
      else
        DVAL_OUT <= '0';
      end if;
      
    end if;
  end process proc_out;
  -----------------------------------------------------------------------------
  -- Do the output
  -----------------------------------------------------------------------------

end behavioral;
