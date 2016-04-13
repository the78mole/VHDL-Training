-------------------------------------------------------------------------------
-- Title      : i2s-bus interface
-- Project    : 
-------------------------------------------------------------------------------
-- File       : i2s_bus_interface.vhd
-- Author     : Daniel Glaser
-- Company    : LfTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-07-03
-- Last update: 2006-07-10
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This is the master or slave i2s-bus interface that also can be
--              configured to accept left or right aligned data
-------------------------------------------------------------------------------
-- Copyright (c) 2006 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-07-03  1.0      sidaglas        Created
-- 2006-07-11                           Finished Coding
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use ieee.arith.all;


use work.my_math.all;                   -- Here are some nice helpers in
use work.PCM1803_config.all;

entity i2s_bus_interface is
  
  generic (
    CLK_FREQ          : positive := 49152000;  -- Typical for 96 kHz
    FS_CLOCK_DIVIDER  : positive := 512;
    BIT_CLOCK_DIVIDER : positive := 64;
    DATA_WIDTH        : positive := 24;
    I2S               : boolean  := false;
    ALIGN_LEFT        : boolean  := false;
    ALIGN_RIGHT       : boolean  := true;
    MASTER_nSLAVE     : boolean  := false;
    SENDER_nRECEIVER  : boolean  := false      -- From serial side of view
    ); 

  port (
    CLK    : in std_logic;
    nRESET : in std_logic;

    BCK   : inout std_logic;
    LRCK  : inout std_logic;
    SDATA : inout std_logic;

    PDATA_L : inout std_logic_vector(DATA_WIDTH-1 downto 0);
    PDATA_R : inout std_logic_vector(DATA_WIDTH-1 downto 0);
    PSTROBE : inout std_logic);

end i2s_bus_interface;

architecture i2s_bus_interface_behavioral of i2s_bus_interface is

  constant cn_clk_per_bit      : natural := FS_CLOCK_DIVIDER/BIT_CLOCK_DIVIDER;
  constant cn_bcks_per_channel : natural := BIT_CLOCK_DIVIDER/2;

  type tu_I2S_STATE is (SI2S_START, SI2S_WAIT_CHANNEL, SI2S_WAIT_SAMPLE, SI2S_ROTATE, SI2S_PSTROBE);
  
begin  -- i2s_bus_interface_behavioral

  assert I2S xor ALIGN_LEFT xor ALIGN_RIGHT
    report "You have to choose one Protocol type out of I2S, ALIGN_LEFT, ALIGN_RIGHT in generics"
    severity error;
  assert I2S or ALIGN_LEFT or ALIGN_RIGHT
    report "You must specify a protocol in generics"
    severity error;
  assert (ALIGN_RIGHT and DATA_WIDTH = 20) or DATA_WIDTH = 24
    report "Wrong data width or wrong data width for this protocol (supported ALL: 24, ALIGN_RIGHT (additional): 20). Change this in generics"
    severity error;

  p_sm_i2s : process (CLK, nRESET)
    variable vu_state_i2s   : I2S_STATE                                := SI2S_START;
    variable vn_bit_count   : natural range 0 to DATA_WIDTH-1          := 0;
    variable vn_wait_count  : natural range 0 to cn_bcks_per_channel-1 := 0;
    variable vl_cur_channel : std_logic                                := '0';  -- '0' is LEFT, '1' is RIGHT
  begin  -- process p_sm_i2s
    if nRESET = '0' then                -- asynchronous reset (active low)
      I2S_STATE := SI2S_START;
    elsif rising_edge(CLK) then         -- rising clock edge
      case I2S_STATE is
        when SI2S_START =>
          -- Initializing everything
--          vn_bit_count := DATA_WIDTH; -- Already done in SI2S_WAIT_CHANNEL
          vu_state_i2s   := SI2S_WAIT_CHANNEL;
          vl_cur_channel := '0';
          
        when SI2S_WAIT_CHANNEL =>
          -- We are waiting for the edge of LRCK
          if (I2S and sl_lrck_falling_edge = '1') or (not I2S and sl_lrck_rising_edge = '1') then
            vn_bit_count := DATA_WIDTH-1;
            if ALIGN_LEFT then
              vu_state_i2s := SI2S_SAMPLE;
            elsif I2S then
              vn_wait_count := 1;
              vu_state_i2s  := SI2S_WAIT_SAMPLE;
            elsif ALIGN_RIGHT then
              vn_wait_count := cn_bcks_per_channel-DATA_WIDTH;
              vu_state_i2s  := SI2S_WAIT_SAMPLE;
            end if;
          end if;
          
        when SI2S_WAIT_SAMPLE =>
          -- We are waiting for the sample
          if sl_bck_falling_edge = '1' then
            if vn_wait_count = 0 then
              vu_state_i2s := SI2S_SAMPLE;
            else
              vn_wait_count := vn_wait_count - 1;
            end if;
          end if;

        when SI2S_SAMPLE =>

          if SENDER_nRECEIVER then
            SDATA <= vv_reg_rot(DATA_WIDTH-1);
            if sl_bck_rising_edge = '1' then
              if vn_bit_count /= 0 then
                vu_state_i2s := SI2S_ROTATE;
                vn_bit_count := vn_bit_count - 1
              else
                vu_state_i2s := SI2S_PSTROBE;
              end if;
            end if;
          else
            if sl_bck_rising_edge = '1' then
              vv_reg_rot(0) := SDATA;
            end if;
          end if;

        when SI2S_ROTATE =>
          if sl_bck_falling_edge = '1' then
            vv_reg_rot   <= vv_reg_rot sll 1;
            vu_state_i2s := SI2S_WAIT_SAMPLE;
          end if;

        when SI2S_PSTROBE =>
          if sl_bck_falling_edge = '1' then
            if SENDER_nRECEIVER then
              if vl_cur_channel = '0' then
                vv_reg_l := PDATA_L;
              else
                vv_reg_r := PDATA_R;
              end if;
            else
              PSTROBE <= not PSTROBE;
              if vl_cur_channel = '0' then
                PDATA_L <= vv_reg_l;
              else
                PDATA_R <= vv_reg_r;
              end if;
            end if;
            SDATA          <= '0';
            vl_cur_channel := not vl_cur_channel;
            vu_state_i2s   := SI2S_WAIT_SAMPLE;
          end if;

        when others => null;
      end case;
    end if;
  end process p_sm_i2s;

  sig_sender : if SENDER_nRECEIVER generate
    PDATA_L <= (others => 'Z');
    PDATA_R <= (others => 'Z');
    PSTROBE <= 'Z';
  end generate sig_sender;

  sig_receiver : if not SENDER_nRECEIVER generate
    SDATA <= 'Z';
  end generate sig_receiver;

  gen_bck_lrck : process (CLK, nRESET)
    variable vn_bck_counter            : natural range 0 to cn_clk_per_bit-1      := cn_clk_per_bit-1;
    variable vn_lrck_counter           : natural range 0 to cn_bcks_per_channel-1 := cn_bcks_per_channel-1;
    variable vl_bck_last, vl_lrck_last : std_logic;
  begin  -- process gen_bck
    if nRESET = '0' then                -- asynchronous reset (active low)
      if MASTER_nSLAVE then
        BCK  <= '0';
        LRCK <= '0';
      else
        BCK  <= 'Z';
        LRCK <= 'Z';
      end if;
    elsif rising_edge(CLK) then         -- rising clock edge
      if (vn_lrck_counter = 0 and MASTER_nSLAVE)
        or (LRCK = '1' and vl_lrck_last = '0' and not (MASTER_nSLAVE or I2S))
        or (LRCK = '0' and vl_lrck_last = '1' and I2S and not MASTER_nSLAVE) then
        vn_lrck_counter := cn_bcks_per_channel-1;
      elsif (vn_bck_counter = 0 and MASTER_nSLAVE) or (BCK = '0' and vl_bck_last = '1' and not MASTER_nSLAVE) then
        vn_lrck_counter := vn_lrck_counter-1;
      end if;

      case vn_bck_counter is
        when 0 =>
          sl_bck_falling_edge = '1';
          BCK <= '0';
        when cn_clk_per_bit/2 =>
          sl_bck_rising_edge = '1';
          BCK <= '1';
        when others =>
          sl_bck_rising_edge  <= '0';
          sl_bck_falling_edge <= '0';
      end case;

      case vn_lrck_counter is
        when 0 =>
          sl_lrck_falling_edge = '1';
        when others => null;
      end case;

      if (vn_bck_counter = 0 and MASTER_nSLAVE) or (BCK = '0' and vl_bck_last and not MASTER_nSLAVE) then
        vn_bck_counter := cn_clk_per_bit-1;
      else
        vn_bck_counter := vn_bck_counter-1;
      end if;

      vl_bck_last  := BCK;
      vl_lrck_last := LRCK;
    end if;
  end process gen_bck_lrck;
  
end i2s_bus_interface_behavioral;

