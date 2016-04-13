-------------------------------------------------------------------------------
-- Title      : reset generator
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
--              This Project aims at applicating the knowledge, collected in
--              the lecture ADS. Students should learn, how to use MATLAB for
--              dimensioning digital signal processing architectures and how
--              to implement this algorithms and architectures into hardware,
--              in this case some Lattice ECP20-FPGA.
-------------------------------------------------------------------------------
-- File       : reset_gen.vhd
-- Author     : Daniel Glaser
-- Company    : LTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-09-01
-- Last update: 2007-01-14
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Generates a reset pulse at the beginning right after power is
--              applied and configuration is done. It's implemented as a
--              simple counter that counts up some time and then simply stops
--              counting while taking back reset. This module expects an
--              initial value of the reset counter beeing (others => '0'). This
--              is given e.g. for Xilinx Virtex-Family.
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
use ieee.std_logic_unsigned.all;

entity reset_gen is
  
  generic (
    CLK_FREQ        : integer := 49152000;  -- The clock frequency in Hz
    RESET_HOLD_TIME : integer := 50);       -- Time in milliseconds

  port (
    CLK    : in  std_logic;
    nRESET : out std_logic;
    RESET  : out std_logic);

end reset_gen;

architecture behavioral of reset_gen is

begin  -- behavioral

  -- purpose: This process is intended to count the clocks right after
  --          configuration and then releases the reset signal to inactive state
  -- type   : sequential
  -- inputs : CLK
  -- outputs: 
  reset_count : process (CLK)
    variable vn_count : natural range 0 to (RESET_HOLD_TIME*(CLK_FREQ/1000) - 1):= 0;
  begin  -- process reset_count
    if rising_edge(CLK) then            -- rising clock edge
      if vn_count = (RESET_HOLD_TIME*(CLK_FREQ/1000)-1) then
        RESET <= '0';
        nRESET <= '1';
      else
        RESET <= '1';
        nRESET  <= '0';
        vn_count := vn_count + 1;
      end if;
    end if;
  end process reset_count;

end behavioral;
