-------------------------------------------------------------------------------
-- Title      : Testbench for design "i2s_receiver"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : i2s_receiver_tb.vhd
-- Author     : 
-- Company    : 
-- Created    : 2006-11-01
-- Last update: 2007-01-22
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity i2s_receiver_tb is

end i2s_receiver_tb;

-------------------------------------------------------------------------------

architecture i2s_receiver_tb_behavioral of i2s_receiver_tb is

  component i2s_receiver
    generic (
      DATA_WIDTH : positive);
    port (
      CLK_IN : in  std_logic;
      nRESET : in  std_logic;
      LRCK   : in  std_logic;
      BCK    : in  std_logic;
      DIN    : in  std_logic;
      DOUTL  : out std_logic_vector(DATA_WIDTH-1 downto 0);
      DOUTR  : out std_logic_vector(DATA_WIDTH-1 downto 0);
      DVAL   : out std_logic);
  end component;

  -- component generics
  constant DATA_WIDTH : positive := 24;

  -- component ports
  signal CLK_IN : std_logic;
  signal nRESET : std_logic;
  signal LRCK   : std_logic;
  signal BCK    : std_logic;
  signal DIN    : std_logic;
  signal DOUTL  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DOUTR  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DVAL   : std_logic;

  -- clock
  signal Clk : std_logic := '1';

  constant clk_period      : time := 10172 ps;
  constant clk_full_period : time := 2 * clk_period;

  signal sl_bck, sl_lrck : std_logic := '0';

  constant cn_clk_per_bck  : natural := 8;
  constant cn_bck_per_lrck : natural := 64;

  signal sv_left_channel, sv_right_channel : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

  -- pragma synthesis_off
  signal sv_active : std_logic_vector(DATA_WIDTH downto 0);
  -- pragma synthesis_on
  
begin  -- i2s_receiver_tb_behavioral

  -- component instantiation
  DUT : i2s_receiver
    generic map (
      DATA_WIDTH => DATA_WIDTH)
    port map (
      CLK_IN => CLK_IN,
      nRESET => nRESET,
      LRCK   => LRCK,
      BCK    => BCK,
      DIN    => DIN,
      DOUTL  => DOUTL,
      DOUTR  => DOUTR,
      DVAL   => DVAL);

  -- clock generation
  Clk    <= not Clk after clk_period;
  CLK_IN <= Clk;

  bck_gen : process (Clk, nRESET)
    variable vn_clk_count : natural := 0;
  begin  -- process bck_gen
    if nRESET = '0' then                -- asynchronous reset (active low)
      sl_bck       <= '0';
      vn_clk_count := 0;
    elsif rising_edge(CLK) then         -- rising clock edge

      if vn_clk_count = 0 then
        sl_bck <= '1';
      elsif vn_clk_count = cn_clk_per_bck/2 then
        sl_bck <= '0';
      end if;

      if vn_clk_count = 0 then
        vn_clk_count := cn_clk_per_bck - 1;
      else
        vn_clk_count := vn_clk_count - 1;
      end if;
      
    end if;
  end process bck_gen;

  BCK <= sl_bck;

  lrck_gen : process (CLK, nRESET)
    variable vl_last_bck  : std_logic := '0';
    variable vn_bck_count : natural   := 0;
  begin  -- process lrck_gen
    if nRESET = '0' then                -- asynchronous reset (active low)
      sl_lrck <= '1';
    elsif rising_edge(CLK) then         -- rising clock edge
      
      if vl_last_bck = '1' and sl_bck = '0' then
        
        if vn_bck_count = 0 then
          sl_lrck <= '0';               -- Left Channel active
        elsif vn_bck_count = cn_bck_per_lrck/2 then
          sl_lrck <= '1';               -- Right Channel active
        end if;

        if vn_bck_count = 0 then
          vn_bck_count := cn_bck_per_lrck - 1;
        else
          vn_bck_count := vn_bck_count - 1;
        end if;
        
      end if;

      vl_last_bck := sl_bck;
    end if;
  end process lrck_gen;

  LRCK <= sl_lrck;

  gen_data : process (CLK, nRESET)
    variable vv_active_word            : std_logic_vector(DATA_WIDTH downto 0) := (others => '0');
    variable vl_last_bck, vl_last_lrck : std_logic                               := '0';
  begin  -- process gen_data
    if nRESET = '0' then                -- asynchronous reset (active low)
      DIN <= '0';
    elsif rising_edge(CLK) then         -- rising clock edge
      
      if vl_last_lrck = '0' and sl_lrck = '1' then
        vv_active_word := '0' & sv_right_channel;
      elsif vl_last_lrck = '1' and sl_lrck = '0' then
        vv_active_word := '0' & sv_left_channel;
      elsif vl_last_bck = '0' and sl_bck = '1' then
        DIN            <= vv_active_word(DATA_WIDTH);
        vv_active_word := vv_active_word(DATA_WIDTH-1 downto 0) & '0';
      end if;

      -- pragma synthesis_off
      sv_active <= vv_active_word;
      -- pragma synthesis_on

      vl_last_lrck := sl_lrck;
      vl_last_bck  := sl_bck;
      
    end if;
  end process gen_data;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET           <= '0';
    wait for 20 ns;
    nRESET           <= '1';
    -- ---------------  "012345678901234567890123"
    sv_left_channel  <= "101100111000111100001111";
    sv_right_channel <= "111010101010101010101111";
    wait for 10 us;
    sv_left_channel  <= "000000000000111111111111";
    sv_right_channel <= "111000111000111000111000";
    wait;

  end process WaveGen_Proc;

  

end i2s_receiver_tb_behavioral;

-------------------------------------------------------------------------------

configuration i2s_receiver_tb_i2s_receiver_tb_behavioral_cfg of i2s_receiver_tb is
  for i2s_receiver_tb_behavioral
  end for;
end i2s_receiver_tb_i2s_receiver_tb_behavioral_cfg;

-------------------------------------------------------------------------------
