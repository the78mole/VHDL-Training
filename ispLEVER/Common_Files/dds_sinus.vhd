-------------------------------------------------------------------------------
-- Title      : dds sinus generator
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : dds_sinus.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-05
-- Last update: 2007-01-15
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module generates some sinusodial signal with dds algorithm
--              for use in our first exercises.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LfTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-09-05  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity dds_sinus is

  generic (
    OUTPUT_WIDTH : positive := 8;
    TABLE_WIDTH  : positive := 3;
    PHASE_WIDTH  : positive := 8;
    CLK_DIV      : positive := 250);

  port (
    CLK_IN    : in  std_logic;
    nRESET    : in  std_logic;
    PHASE_INC : in  std_logic_vector(PHASE_WIDTH-1 downto 0);
    OUTPUT    : out std_logic_vector(OUTPUT_WIDTH-1 downto 0));

end dds_sinus;

architecture behavioral of dds_sinus is

  constant ci_phase_min     : integer := -(2**PHASE_WIDTH);
  constant ci_phase_max     : integer := (2**PHASE_WIDTH)-1;
  constant ci_table_min     : integer := 0;
  constant ci_table_max     : integer := (2**TABLE_WIDTH)-1;
  constant ci_output_min    : integer := 0;
  constant ci_output_max    : integer := (2**OUTPUT_WIDTH)-1;
--  constant ci_output_offset : integer := (2**(OUTPUT_WIDTH-1))-1;
  constant ci_output_offset : integer := 0;
  
  signal sl_div_tog : std_logic;

  type   tu_lut is array (0 to ci_table_max) of std_logic_vector(OUTPUT_WIDTH-1 downto 0);
  type   tu_fsm_phase is (PHASE_RISING, PHASE_FALLING);
  signal sav_sin_lut : tu_lut;

  signal si_phase_reg : integer range ci_phase_min to ci_phase_max;


  -- pragma translate_off
  signal sn_phase1          : natural range 0 to ci_phase_max;
  signal sn_table_row       : integer;
  signal su_fsm_phase_state : tu_fsm_phase;
  signal si_test1, si_test2 : integer;
  signal sv_test            : std_logic_vector(31 downto 0);
  signal sn_count           : natural;
  -- pragma translate_on
  
begin  -- behavioral

  gen_sin_lut : for i in 0 to ci_table_max generate
    -- This throws an error in ispLEVER, but Synplify and Modelsim seem to
    -- deal great with this ieee.math_real_package
    sav_sin_lut(i) <= conv_std_logic_vector(
      integer(ROUND(sin((real(0.5)*MATH_PI*(real(i)+0.5))/real(ci_table_max + 1)) * real(ci_output_max))),
      OUTPUT_WIDTH);
  end generate gen_sin_lut;

  -- pragma translate_off
  -- This is for debugging purposes
  proc_rows : process
  begin  -- process proc_rows
    for k in 0 to 3 loop
      for j in 0 to ci_table_max loop
        if k = 0 then
          sn_table_row <= conv_integer('0' & sav_sin_lut(j));
        elsif k = 1 then
          sn_table_row <= conv_integer('0' & sav_sin_lut(ci_table_max-j));
        elsif k = 2 then
          sn_table_row <= -conv_integer('0' & sav_sin_lut(j));
        elsif k = 3 then
          sn_table_row <= -conv_integer('0' & sav_sin_lut(ci_table_max-j));
        end if;
        wait for 200 ns;
      end loop;  -- j      
    end loop;  -- k
  end process proc_rows;
  -- pragma translate_on

  -- purpose: This process divides the clock input
  -- type   : sequential
  -- inputs : CLK_IN, nRESET
  -- outputs: 
  div_clk : process (CLK_IN, nRESET)
    variable vn_count : natural range 0 to CLK_DIV-1;
  begin  -- process div_clk
    if nRESET = '0' then                -- asynchronous reset (active low)
      vn_count := CLK_DIV-1;
      sl_div_tog <= '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if vn_count = 0 then
        vn_count   := CLK_DIV-1;
        sl_div_tog <= not sl_div_tog;
      else
        vn_count := vn_count - 1;
      end if;
      -- pragma translate_off
      sn_count <= vn_count;
      -- pragma translate_on
    end if;
  end process div_clk;

  -- purpose: This increments the phase of the wave, that is stored in the table
  -- type   : sequential
  -- inputs : CLK_IN, nRESET
  -- outputs: 
  increment_phase : process (CLK_IN, nRESET)
    variable vu_fsm_phase_state : tu_fsm_phase;
    variable vb_second_half     : boolean := false;
    variable vl_div_tog         : std_logic;
  begin  -- process increment_phase
    if nRESET = '0' then                -- asynchronous reset (active low)
      
      vu_fsm_phase_state := PHASE_RISING;
      si_phase_reg       <= 0;
      vb_second_half     := false;
      
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      if (sl_div_tog xor vl_div_tog) = '1' then
        
        case vu_fsm_phase_state is
          
          when PHASE_RISING =>
            if conv_integer(PHASE_INC) - ci_phase_max + si_phase_reg <= 0 then
              si_phase_reg <= si_phase_reg + conv_integer(PHASE_INC);
            else
              si_phase_reg       <= (2*ci_phase_max) + 1 - si_phase_reg - conv_integer(PHASE_INC);
              vu_fsm_phase_state := PHASE_FALLING;
            end if;
            
          when PHASE_FALLING =>
            if conv_integer(PHASE_INC) - si_phase_reg - ci_phase_max <= 0 then
              si_phase_reg <= si_phase_reg - conv_integer(PHASE_INC);
            else
              si_phase_reg       <= conv_integer(PHASE_INC) + (2*ci_phase_min) + 1 - si_phase_reg;
              vu_fsm_phase_state := PHASE_RISING;
            end if;
            
          when others => vu_fsm_phase_state := PHASE_FALLING;
                         
        end case;

        -- pragma translate_off
        su_fsm_phase_state <= vu_fsm_phase_state;
        -- pragma translate_on
      end if;

      vl_div_tog := sl_div_tog;
      
    end if;
  end process increment_phase;

  -- purpose: This process get's the data from the table
  -- type   : sequential
  -- inputs : CLK_IN, nRESET
  -- outputs: 
  get_wave_data : process (CLK_IN, nRESET)
    variable vv_phase         : std_logic_vector(PHASE_WIDTH-1 downto 0);
    variable vv_phase_reduced : std_logic_vector(TABLE_WIDTH-1 downto 0);
    variable vn_phase         : natural range 0 to (2**PHASE_WIDTH)-1;
    variable vb_positive1     : boolean := false;
    variable vb_positive2     : boolean := false;
    variable vv_pre_output    : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
  begin  -- process get_wave_data
    if nRESET = '0' then                -- asynchronous reset (active low)
      OUTPUT   <= (others => '0');
      vv_phase := (others => '0');
      vn_phase := 2**(PHASE_WIDTH-1);
      vb_positive1 := false;
      vb_positive2 := false;
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      if vb_positive2 then
        OUTPUT <= conv_std_logic_vector(ci_output_offset, OUTPUT_WIDTH) + ('0' & vv_pre_output(OUTPUT_WIDTH-1 downto 1));
      else
        OUTPUT <= conv_std_logic_vector(ci_output_offset, OUTPUT_WIDTH) - ('0' & vv_pre_output(OUTPUT_WIDTH-1 downto 1));
      end if;

      vv_pre_output := sav_sin_lut(conv_integer('0' & vv_phase(PHASE_WIDTH-1 downto PHASE_WIDTH-TABLE_WIDTH)));

      vv_phase := conv_std_logic_vector(abs(si_phase_reg), PHASE_WIDTH);

      -- pragma translate_off
      si_test1 <= conv_integer('0' & vv_phase(PHASE_WIDTH-1 downto PHASE_WIDTH-TABLE_WIDTH));
      si_test2 <= PHASE_WIDTH-TABLE_WIDTH-1;
      sv_test  <= EXT(vv_phase, sv_test'length);

      sn_phase1 <= abs(si_phase_reg);
      -- pragma translate_on

      vb_positive2 := vb_positive1;     -- delay one more cycle

      if si_phase_reg < 0 then
        vb_positive1 := false;
      else
        vb_positive1 := true;
      end if;
      
    end if;
  end process get_wave_data;
  
end behavioral;
