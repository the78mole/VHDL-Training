-------------------------------------------------------------------------------
-- Title      : i2c receiver 
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : i2s_receiver.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-01
-- Last update: 2007-01-13
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: The task of this module is to receive serial adc data and
--              present it in parallel to the toplevel
--
-- Information: Give this module some I2S circuit in master mode and it will
--              receive the stereo audio information from it. CLK_IN must be at
--              least twice BCK frequency for proper function. The DVAL output
--              toogles each time, new data is incoming. It has the same
--              meaning as LRCK. If low LRCK means left channel data from audio
--              circuit, left parallel data is just valid, when dval goes down.
--              Left channel parallel data is valid as long as DVAL stays low.
--              It is valid until short before (3 BCK cycles) next high
--              to low edge. This allows to sample left and right data as well
--              at high to low edge of DVAL and vice versa.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-09-01  1.0      sidaglas        Created
-- 2006-11-23  1.1      sidaglas        Fixed some comments
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity i2s_receiver is
  
  generic (
    DATA_WIDTH : positive := 24);

  port (
    CLK_IN : in  std_logic;
    nRESET : in  std_logic;
    LRCK   : in  std_logic;
    BCK    : in  std_logic;
    DIN    : in  std_logic;
    DOUTL  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    DOUTR  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    DVAL   : out std_logic);

end i2s_receiver;

architecture behavioral of i2s_receiver is

  signal sl_val_l, sl_val_r : std_logic;

  -- pragma translate_off
  signal sn_count_l, sn_count_r       : natural;
  signal sv_shiftreg_l, sv_shiftreg_r : std_logic_vector(DATA_WIDTH-1 downto 0);
  -- pragma translate_on
  
begin  -- behavioral

  -- purpose: This process handles the receiption of the left channel data
  -- type   : sequential
  -- inputs : CLK_IN, nRESET
  -- outputs: 
  rec_left : process (CLK_IN, nRESET)
    variable vv_shiftreg             : std_logic_vector(DATA_WIDTH-1 downto 0);
    variable vn_count                : natural range 0 to DATA_WIDTH;
    variable vl_bck, vl_lrck, vl_val : std_logic;
    
  begin  -- process rec_left
    if nRESET = '0' then                -- asynchronous reset (active low)
      
      vv_shiftreg := (others => '0');
      sl_val_l    <= '0';
      vl_val      := '0';
      vl_bck      := '0';
      vl_lrck     := '0';
      DOUTL       <= (others => '0');
      vn_count    := 0;
      
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      -- This defines the rising clock edge of BCK
      if vl_bck = '0' and BCK = '1' then
        
        if vn_count /= 0 then
          vv_shiftreg(DATA_WIDTH-1 downto 1) := vv_shiftreg(DATA_WIDTH-2 downto 0);
          vv_shiftreg(0)                     := DIN;
        end if;

        -- The sequence LRCK '1' => '0' defines the left channel
        if vn_count = 0 and LRCK = '0' and vl_lrck = '1' then
          vn_count := vn_count + 1;
        elsif vn_count = DATA_WIDTH then
          vn_count := 0;
        elsif vn_count /= 0 then
          vn_count := vn_count + 1;
        end if;

        if LRCK = '1' and vl_lrck = '0' then
          sl_val_l <= '0';
        elsif sl_val_l = '0' and vl_val = '1' then
          DOUTL <= vv_shiftreg;
        elsif vl_val = '0' then
          sl_val_l <= '1';
        end if;

        vl_val := sl_val_l;

        -- pragma translate_off
        sn_count_l    <= vn_count;
        sv_shiftreg_l <= vv_shiftreg;
        -- pragma translate_on

        vl_lrck := LRCK;
        
      end if;

      vl_bck := BCK;

    end if;

  end process rec_left;

  -- purpose: This process handles the receiption of the right channel data
  -- type   : sequential
  -- inputs : CLK_IN, nRESET
  -- outputs: 
  rec_right : process (CLK_IN, nRESET)
    variable vv_shiftreg             : std_logic_vector(DATA_WIDTH-1 downto 0);
    variable vn_count                : natural range 0 to DATA_WIDTH;
    variable vl_bck, vl_lrck, vl_val : std_logic;
    
  begin  -- process rec_left
    if nRESET = '0' then                -- asynchronous reset (active low)
      
      vv_shiftreg := (others => '0');
      sl_val_r    <= '0';
      vl_bck      := '0';
      vl_val      := '0';
      vl_lrck     := '0';
      DOUTR       <= (others => '0');
      vn_count    := 0;
      
    elsif rising_edge(CLK_IN) then      -- rising clock edge

      -- This defines the rising clock edge of BCK
      if vl_bck = '0' and BCK = '1' then
        
        if vn_count /= 0 then
          vv_shiftreg(DATA_WIDTH-1 downto 1) := vv_shiftreg(DATA_WIDTH-2 downto 0);
          vv_shiftreg(0)                     := DIN;
        end if;

        -- The sequence LRCK '0' => '1' defines the right channel
        if vn_count = 0 and LRCK = '1' and vl_lrck = '0' then
          vn_count := vn_count + 1;
        elsif vn_count = DATA_WIDTH then
          vn_count := 0;
        elsif vn_count /= 0 then
          vn_count := vn_count + 1;
        end if;

        if LRCK = '0' and vl_lrck = '1' then
          sl_val_r <= '0';
        elsif sl_val_r = '0' and vl_val = '1' then
          DOUTR <= vv_shiftreg;
        elsif vl_val = '0' then
          sl_val_r <= '1';
        end if;

        vl_val := sl_val_r;

        -- pragma translate_off
        sn_count_r    <= vn_count;
        sv_shiftreg_r <= vv_shiftreg;
        -- pragma translate_on

        vl_lrck := LRCK;
        
      end if;

      vl_bck := BCK;

    end if;

  end process rec_right;

  -- purpose: Makes the valid signal DVAL changing level each time a channel
  --          has new data according to the finished data (e.g. left means low)          
  -- type   : sequential
  -- inputs : CLK, nRESET
  -- outputs: 
  valid_toggle : process (CLK_IN, nRESET)
    variable vl_dval : std_logic;
  begin  -- process valid_toggle
    if nRESET = '0' then                -- asynchronous reset (active low)
      DVAL    <= '0';
      vl_dval := '0';
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      if (sl_val_l and sl_val_r) = '1' and vl_dval = '0' then
        DVAL <= not LRCK;
      end if;
      vl_dval := sl_val_l and sl_val_r;
    end if;
  end process valid_toggle;

end behavioral;

