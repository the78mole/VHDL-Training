-------------------------------------------------------------------------------
-- Title      : Testbench for design "levelmeter"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : levelmeter_tb.vhd
-- Author     : 
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-01
-- Last update: 2007-01-22
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2007 LTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006-11-01  1.0      sidaglas        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity levelmeter_tb is

end levelmeter_tb;

-------------------------------------------------------------------------------

architecture levelmeter_tb_behavioral of levelmeter_tb is

  component levelmeter
    generic (
      DATA_WIDTH        : positive;
      INTEGRATION_WIDTH : positive);
    port (
      CLK_IN   : in  std_logic;
      nRESET   : in  std_logic;
      DIN_VAL  : in  std_logic;
      DOUT_VAL : out std_logic;
      DATA_IN  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DATA_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  -- component generics
  constant DATA_WIDTH        : positive := 8;
  constant INTEGRATION_WIDTH : positive := 8;

  -- component ports
  signal CLK_IN   : std_logic;
  signal nRESET   : std_logic;
  signal DIN_VAL  : std_logic;
  signal DOUT_VAL : std_logic;
  signal DATA_IN  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal DATA_OUT : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

  signal sv_random : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sv_other : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal sl_random : std_logic := '1';
  
begin  -- levelmeter_tb_behavioral

  -- component instantiation
  DUT : levelmeter
    generic map (
      DATA_WIDTH        => DATA_WIDTH,
      INTEGRATION_WIDTH => INTEGRATION_WIDTH)
    port map (
      CLK_IN   => CLK_IN,
      nRESET   => nRESET,
      DIN_VAL  => DIN_VAL,
      DOUT_VAL => DOUT_VAL,
      DATA_IN  => DATA_IN,
      DATA_OUT => DATA_OUT);

  -- clock generation
  Clk    <= not Clk after 10 ns;
  CLK_IN <= Clk;

  DATA_IN <= sv_random when sl_random = '1' else sv_other;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    nRESET <= '0';
    wait for 1 ns;
    nRESET <= '1';
    wait for 500 us;
    sl_random <= '0';
    sv_other <= conv_std_logic_vector(127, DATA_WIDTH);
    wait for 100 us;                    -- 600 us
    sv_other <= conv_std_logic_vector(63, DATA_WIDTH);
    wait for 100 us;                    -- 700 us
    sv_other <= conv_std_logic_vector(0, DATA_WIDTH);
    wait for 100 us;                    -- 800 us
    sv_other <=  conv_std_logic_vector(-127,DATA_WIDTH);
    wait for 100 us;                    -- 900 us
    sv_other <= conv_std_logic_vector(-128, DATA_WIDTH);
    wait;
  end process WaveGen_Proc;

  gen_random : process (CLK_IN, nRESET)
    variable vv_random1, vv_random2 : std_logic_vector(sv_random'range);
  begin  -- process gen_random
    if nRESET = '0' then                -- asynchronous reset (active low)
      sv_random  <= (others => '0');
      vv_random1 := (others => '1');
      vv_random2 := (others => '1');
    elsif rising_edge(CLK_IN) then      -- rising clock edge
      vv_random1 := (vv_random1(2) xor vv_random1(1) xor vv_random1(0) xor sv_random(sv_random'left)) &
                    vv_random1(vv_random1'left downto 1);
      vv_random2 := vv_random2(vv_random2'left-1 downto 0) &
                    (vv_random2(vv_random2'left) xor vv_random2(vv_random2'left-2) xor sv_random(1));
      sv_random <= vv_random1 xor not vv_random2;
    end if;
  end process gen_random;

  Gen_dvals : process
  begin  -- process Gen_dvals

    for i in 0 to 10 loop
      DIN_VAL <= '1';
      wait for 20 ns;
      DIN_VAL <= '0';
      wait for 80 ns;
    end loop;  -- i

  end process Gen_dvals;
  

end levelmeter_tb_behavioral;

-------------------------------------------------------------------------------

configuration levelmeter_tb_levelmeter_tb_behavioral_cfg of levelmeter_tb is
  for levelmeter_tb_behavioral
  end for;
end levelmeter_tb_levelmeter_tb_behavioral_cfg;

-------------------------------------------------------------------------------
