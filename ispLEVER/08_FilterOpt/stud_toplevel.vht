
-- VHDL Test Bench Created from source file stud_toplevel.vhd -- 11/30/06  08:04:29
--
-- Notes: 
-- 1) This testbench template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the unit under test.
-- Lattice recommends that these types always be used for the top-level
-- I/O of a design in order to guarantee that the testbench will bind
-- correctly to the timing (post-route) simulation model.
-- 2) To use this template as your testbench, change the filename to any
-- name of your choice with the extension .vhd, and use the "source->import"
-- menu in the ispLEVER Project Navigator to import the testbench.
-- Then edit the user defined section below, adding code to generate the 
-- stimulus for your design.
--
LIBRARY ieee;
LIBRARY generics;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE generics.components.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

	COMPONENT stud_toplevel
	PORT(
		CLK_FAST : IN std_logic;
		CLK_SLOW : IN std_logic;
		nRESET : IN std_logic;
		SWITCH_1 : IN std_logic;
		SWITCH_2 : IN std_logic;
		SWITCH_3 : IN std_logic;
		SWITCH_4 : IN std_logic;
		SWITCH_5 : IN std_logic;
		SWITCH_6 : IN std_logic;
		SWITCH_7 : IN std_logic;
		SWITCH_8 : IN std_logic;
		BUTTON_1 : IN std_logic;
		BUTTON_2 : IN std_logic;
		BUTTON_3 : IN std_logic;
		BUTTON_4 : IN std_logic;
		BUTTON_5 : IN std_logic;
		BUTTON_6 : IN std_logic;
		BUTTON_7 : IN std_logic;
		BUTTON_8 : IN std_logic;
		PC_SDIN : IN std_logic;
		AD_PDIN_L : IN std_logic_vector(23 downto 0);
		AD_PDIN_R : IN std_logic_vector(23 downto 0);
		AD_DVAL : IN std_logic;          
		STATUS_L_RED : OUT std_logic;
		STATUS_L_YEL : OUT std_logic;
		STATUS_L_GRE : OUT std_logic;
		STATUS_M_RED : OUT std_logic;
		STATUS_M_YEL : OUT std_logic;
		STATUS_M_GRE : OUT std_logic;
		STATUS_R_RED : OUT std_logic;
		STATUS_R_YEL : OUT std_logic;
		STATUS_R_GRE : OUT std_logic;
		SEGMENT_LED1 : OUT std_logic_vector(3 downto 0);
		SEGMENT_LED2 : OUT std_logic_vector(3 downto 0);
		SEGMENT_LED3 : OUT std_logic_vector(3 downto 0);
		SEGMENT_LED4 : OUT std_logic_vector(3 downto 0);
		BARGRAPH_LEFT : OUT std_logic_vector(7 downto 0);
		BARGRAPH_RIGHT : OUT std_logic_vector(7 downto 0);
		BARGRAPH_DEC_EN : OUT std_logic;
		PC_SDOUT : OUT std_logic;
		MA_GAIN : OUT std_logic_vector(5 downto 0);
		DA_PDOUT_L : OUT std_logic_vector(23 downto 0);
		DA_PDOUT_R : OUT std_logic_vector(23 downto 0);
		DA_DVAL : OUT std_logic
		);
	END COMPONENT;

	SIGNAL CLK_FAST :  std_logic;
	SIGNAL CLK_SLOW :  std_logic;
	SIGNAL nRESET :  std_logic;
	SIGNAL SWITCH_1 :  std_logic;
	SIGNAL SWITCH_2 :  std_logic;
	SIGNAL SWITCH_3 :  std_logic;
	SIGNAL SWITCH_4 :  std_logic;
	SIGNAL SWITCH_5 :  std_logic;
	SIGNAL SWITCH_6 :  std_logic;
	SIGNAL SWITCH_7 :  std_logic;
	SIGNAL SWITCH_8 :  std_logic;
	SIGNAL BUTTON_1 :  std_logic;
	SIGNAL BUTTON_2 :  std_logic;
	SIGNAL BUTTON_3 :  std_logic;
	SIGNAL BUTTON_4 :  std_logic;
	SIGNAL BUTTON_5 :  std_logic;
	SIGNAL BUTTON_6 :  std_logic;
	SIGNAL BUTTON_7 :  std_logic;
	SIGNAL BUTTON_8 :  std_logic;
	SIGNAL STATUS_L_RED :  std_logic;
	SIGNAL STATUS_L_YEL :  std_logic;
	SIGNAL STATUS_L_GRE :  std_logic;
	SIGNAL STATUS_M_RED :  std_logic;
	SIGNAL STATUS_M_YEL :  std_logic;
	SIGNAL STATUS_M_GRE :  std_logic;
	SIGNAL STATUS_R_RED :  std_logic;
	SIGNAL STATUS_R_YEL :  std_logic;
	SIGNAL STATUS_R_GRE :  std_logic;
	SIGNAL SEGMENT_LED1 :  std_logic_vector(3 downto 0);
	SIGNAL SEGMENT_LED2 :  std_logic_vector(3 downto 0);
	SIGNAL SEGMENT_LED3 :  std_logic_vector(3 downto 0);
	SIGNAL SEGMENT_LED4 :  std_logic_vector(3 downto 0);
	SIGNAL BARGRAPH_LEFT :  std_logic_vector(7 downto 0);
	SIGNAL BARGRAPH_RIGHT :  std_logic_vector(7 downto 0);
	SIGNAL BARGRAPH_DEC_EN :  std_logic;
	SIGNAL PC_SDIN :  std_logic;
	SIGNAL PC_SDOUT :  std_logic;
	SIGNAL MA_GAIN :  std_logic_vector(5 downto 0);
	SIGNAL AD_PDIN_L :  std_logic_vector(23 downto 0);
	SIGNAL AD_PDIN_R :  std_logic_vector(23 downto 0);
	SIGNAL AD_DVAL :  std_logic;
	SIGNAL DA_PDOUT_L :  std_logic_vector(23 downto 0);
	SIGNAL DA_PDOUT_R :  std_logic_vector(23 downto 0);
	SIGNAL DA_DVAL :  std_logic;

BEGIN

	uut: stud_toplevel PORT MAP(
		CLK_FAST => CLK_FAST,
		CLK_SLOW => CLK_SLOW,
		nRESET => nRESET,
		SWITCH_1 => SWITCH_1,
		SWITCH_2 => SWITCH_2,
		SWITCH_3 => SWITCH_3,
		SWITCH_4 => SWITCH_4,
		SWITCH_5 => SWITCH_5,
		SWITCH_6 => SWITCH_6,
		SWITCH_7 => SWITCH_7,
		SWITCH_8 => SWITCH_8,
		BUTTON_1 => BUTTON_1,
		BUTTON_2 => BUTTON_2,
		BUTTON_3 => BUTTON_3,
		BUTTON_4 => BUTTON_4,
		BUTTON_5 => BUTTON_5,
		BUTTON_6 => BUTTON_6,
		BUTTON_7 => BUTTON_7,
		BUTTON_8 => BUTTON_8,
		STATUS_L_RED => STATUS_L_RED,
		STATUS_L_YEL => STATUS_L_YEL,
		STATUS_L_GRE => STATUS_L_GRE,
		STATUS_M_RED => STATUS_M_RED,
		STATUS_M_YEL => STATUS_M_YEL,
		STATUS_M_GRE => STATUS_M_GRE,
		STATUS_R_RED => STATUS_R_RED,
		STATUS_R_YEL => STATUS_R_YEL,
		STATUS_R_GRE => STATUS_R_GRE,
		SEGMENT_LED1 => SEGMENT_LED1,
		SEGMENT_LED2 => SEGMENT_LED2,
		SEGMENT_LED3 => SEGMENT_LED3,
		SEGMENT_LED4 => SEGMENT_LED4,
		BARGRAPH_LEFT => BARGRAPH_LEFT,
		BARGRAPH_RIGHT => BARGRAPH_RIGHT,
		BARGRAPH_DEC_EN => BARGRAPH_DEC_EN,
		PC_SDIN => PC_SDIN,
		PC_SDOUT => PC_SDOUT,
		MA_GAIN => MA_GAIN,
		AD_PDIN_L => AD_PDIN_L,
		AD_PDIN_R => AD_PDIN_R,
		AD_DVAL => AD_DVAL,
		DA_PDOUT_L => DA_PDOUT_L,
		DA_PDOUT_R => DA_PDOUT_R,
		DA_DVAL => DA_DVAL
	);


-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
