-------------------------------------------------------------------------------
-- Title      : Toplevel
-- Project    : Praktikum zu Architekturen der Digitalen Signalverarbeitung
-------------------------------------------------------------------------------
-- File       : toplevel.vhd
-- Author     : Daniel Glaser
-- Company    : LfTE, FAU Erlangen-Nuremberg, Germany
-- Created    : 2006-11-14
-- Last update: 2007-01-09
-- Platform   : LFECP20E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This module is the toplevel of every exercise in this
--              laboratory.
-------------------------------------------------------------------------------
-- Copyright (c) 2006 LfTE, FAU Erlangen-Nuremberg, Germany
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2006-11-14  1.0      sidaglas        Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity toplevel is

  generic (
    DATA_WIDTH : positive := 8);

  port (
    ---------------------------------------------------------------------------
    -- Generic signals
    ---------------------------------------------------------------------------
    CLK : in std_logic;

    ---------------------------------------------------------------------------
    -- Human device interface (HDI)
    ---------------------------------------------------------------------------

    -- Inputs
    SWITCHES : in std_logic_vector(7 downto 0);
    BUTTONS  : in std_logic_vector(7 downto 0);

    -- Outputs
    STATUS_RED     : out std_logic_vector(2 downto 0);
    STATUS_YELLOW  : out std_logic_vector(2 downto 0);
    STATUS_GREEN   : out std_logic_vector(2 downto 0);
    SEGMENT_LED1   : out std_logic_vector(7 downto 0);
    SEGMENT_LED2   : out std_logic_vector(7 downto 0);
    SEGMENT_LED3   : out std_logic_vector(7 downto 0);
    SEGMENT_LED4   : out std_logic_vector(7 downto 0);
    BARGRAPH_LEFT  : out std_logic_vector(7 downto 0);
    BARGRAPH_RIGHT : out std_logic_vector(7 downto 0);

    ---------------------------------------------------------------------------
    -- PC communications
    ---------------------------------------------------------------------------
    RS232_TX  : out std_logic;
    RS232_RX  : in  std_logic;
    RS232_DTR : out std_logic;
    RS232_DSR : in  std_logic;

    ---------------------------------------------------------------------------
    -- Board Extensions
    ---------------------------------------------------------------------------
    EXTENDER_B7 : inout std_logic_vector(15 downto 0);
    EXTENDER_B5 : inout std_logic_vector(15 downto 0);

    ---------------------------------------------------------------------------
    -- Peripherial connections
    ---------------------------------------------------------------------------

    -- Digitally controlled microphone preamplifier
    MA_ZCEN  : out std_logic;
    MA_nDCEN : out std_logic;
    MA_nCS   : out std_logic;
    MA_SCLK  : out std_logic;
    MA_SDI   : out std_logic;
    MA_SDO   : in  std_logic;

    -- Analog to digital converter
    AD_SCKI  : out   std_logic;
    AD_LRCK  : inout std_logic;
    AD_BCK   : inout std_logic;
    AD_DOUT  : in    std_logic;
    AD_FMT   : out   std_logic_vector(1 downto 0);
    AD_MODE  : out   std_logic_vector(1 downto 0);
    AD_BYPAS : out   std_logic;
    AD_OSR   : out   std_logic;
    AD_nPDWN : out   std_logic;

    -- Digital to analog converter
    DA_SCKI  : out   std_logic;
    DA_LRCK  : inout std_logic;
    DA_BCK   : inout std_logic;
    DA_DIN   : out   std_logic;
    DA_nRST  : out   std_logic;
    DA_ZEROL : in    std_logic;
    DA_ZEROR : in    std_logic;
    DA_DEMP  : out   std_logic_vector(1 downto 0);
    DA_FMT   : out   std_logic_vector(2 downto 0);
    DA_MUTE  : out   std_logic;

    -- Speaker power amplifier
    PA_nEN : out std_logic);

  attribute LOC      : string;
  attribute IO_TYPES : string;
  attribute SLEW     : string;

  -- LOC attributes
  attribute LOC of CLK            : signal is "J1";
  attribute LOC of SWITCHES       : signal is "A9,B9,C9,D9,B10,A10,A11,D10";
  attribute LOC of BUTTONS        : signal is "C21,D22,E22,F22,D21,E21,F21,G22";
  attribute LOC of STATUS_RED     : signal is "E19,F20,G21";
  attribute LOC of STATUS_YELLOW  : signal is "S20,E20,G20";
  attribute LOC of STATUS_GREEN   : signal is "C22,F19,G19";
  attribute LOC of SEGMENT_LED1   : signal is "B12,C12,A13,C14,D14,D13,D12,B13";
  attribute LOC of SEGMENT_LED2   : signal is "C13,A14,B14,C15,C16,D15,B15,A15";
  attribute LOC of SEGMENT_LED3   : signal is "D16,A16,B16,B17,A18,D17,C17,A17";
  attribute LOC of SEGMENT_LED4   : signal is "C18,D18,B18,B19,A20,B20,C19,A19";
  attribute LOC of BARGRAPH_LEFT  : signal is "B5,A4,A6,D5,C6,A7,C8,B8";
  attribute LOC of BARGRAPH_RIGHT : signal is "A5,B6,B4,D6,B7,C7,D7,A8";
  attribute LOC of RS232_TX       : signal is "L2";
  attribute LOC of RS232_RX       : signal is "L1";
  attribute LOC of RS232_DTR      : signal is "L4";
  attribute LOC of RS232_DSR      : signal is "M1";
  attribute LOC of EXTENDER_B5    : signal is "Y5,AB5,W6,AB6,Y7,AB7,Y8,AB8,AA8,W8,AA7,W7,AA6,Y6,AA5,W5";
  attribute LOC of EXTENDER_B7    : signal is "F1,E1,F3,F4,D1,E3,C1,B1,C2,D3,D2,E4,G4,E2,F2,G2";
  attribute LOC of MA_ZCEN        : signal is "AA17";
  attribute LOC of MA_nDCEN       : signal is "AB18";
  attribute LOC of MA_nCS         : signal is "W15";
  attribute LOC of MA_SCLK        : signal is "AB17";
  attribute LOC of MA_SDI         : signal is "Y16";
  attribute LOC of MA_SDO         : signal is "AB16";
  attribute LOC of AD_SCKI        : signal is "W16";
  attribute LOC of AD_LRCK        : signal is "AA20";
  attribute LOC of AD_BCK         : signal is "V17";
  attribute LOC of AD_DOUT        : signal is "AA19";
  attribute LOC of AD_FMT         : signal is "W17,W18";
  attribute LOC of AD_MODE        : signal is "AA18,Y18";
  attribute LOC of AD_BYPAS       : signal is "AB20";
  attribute LOC of AD_OSR         : signal is "AB19";
  attribute LOC of AD_nPDWN       : signal is "Y19";
  attribute LOC of DA_SCKI        : signal is "P19";
  attribute LOC of DA_LRCK        : signal is "N21";
  attribute LOC of DA_BCK         : signal is "P20";
  attribute LOC of DA_DIN         : signal is "N22";
  attribute LOC of DA_nRST        : signal is "M22";
  attribute LOC of DA_ZEROL       : signal is "N19";
  attribute LOC of DA_ZEROR       : signal is "N20";
  attribute LOC of DA_DEMP        : signal is "R19,R18";
  attribute LOC of DA_FMT         : signal is "R21,P22,P21";
  attribute LOC of DA_MUTE        : signal is "R22";
  attribute LOC of PA_nEN         : signal is "K22";

  -- IO-Type attributes
  attribute IO_TYPES of CLK            : signal is "LVCMOS33, -";   -- NO OUT
  attribute IO_TYPES of SWITCHES       : signal is "LVCMOS33, -";   -- NO OUT
  attribute IO_TYPES of BUTTONS        : signal is "LVCMOS33, -";   -- NO OUT
  attribute IO_TYPES of STATUS_RED     : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of STATUS_YELLOW  : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of STATUS_GREEN   : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of SEGMENT_LED1   : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of SEGMENT_LED2   : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of SEGMENT_LED3   : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of SEGMENT_LED4   : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of BARGRAPH_LEFT  : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of BARGRAPH_RIGHT : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of RS232_TX       : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of RS232_RX       : signal is "LVCMOS33, -";   -- NO OUT
  attribute IO_TYPES of RS232_DTR      : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of RS232_DSR      : signal is "LVCMOS33, -";   -- NO OUT
  attribute IO_TYPES of EXTENDER_B5    : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of EXTENDER_B7    : signal is "LVCMOS33, 20";  -- 20mA
  attribute IO_TYPES of MA_ZCEN        : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of MA_nDCEN       : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of MA_nCS         : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of MA_SCLK        : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of MA_SDI         : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of MA_SDO         : signal is "LVCMOS33, -";   -- NO OUT
  attribute IO_TYPES of AD_SCKI        : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of AD_LRCK        : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of AD_BCK         : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of AD_DOUT        : signal is "LVCMOS33, -";   -- NO OUT
  attribute IO_TYPES of AD_FMT         : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of AD_MODE        : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of AD_BYPAS       : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of AD_OSR         : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of AD_nPDWN       : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of DA_SCKI        : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of DA_LRCK        : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of DA_BCK         : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of DA_DIN         : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of DA_nRST        : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of DA_ZEROL       : signal is "LVCMOS33, -";   -- 8mA
  attribute IO_TYPES of DA_ZEROR       : signal is "LVCMOS33, -";   -- 8mA
  attribute IO_TYPES of DA_DEMP        : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of DA_FMT         : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of DA_MUTE        : signal is "LVCMOS33, 8";   -- 8mA
  attribute IO_TYPES of PA_nEN         : signal is "LVCMOS33, 8";   -- 8mA

  -- Slew rate attributes
  attribute SLEW of STATUS_RED     : signal is "SLOW";
  attribute SLEW of STATUS_YELLOW  : signal is "SLOW";
  attribute SLEW of STATUS_GREEN   : signal is "SLOW";
  attribute SLEW of SEGMENT_LED1   : signal is "SLOW";
  attribute SLEW of SEGMENT_LED2   : signal is "SLOW";
  attribute SLEW of SEGMENT_LED3   : signal is "SLOW";
  attribute SLEW of SEGMENT_LED4   : signal is "SLOW";
  attribute SLEW of BARGRAPH_LEFT  : signal is "SLOW";
  attribute SLEW of BARGRAPH_RIGHT : signal is "SLOW";
  attribute SLEW of RS232_TX       : signal is "FAST";
  attribute SLEW of RS232_DTR      : signal is "FAST";
  attribute SLEW of EXTENDER_B5    : signal is "FAST";
  attribute SLEW of EXTENDER_B7    : signal is "FAST";
  attribute SLEW of MA_ZCEN        : signal is "FAST";
  attribute SLEW of MA_nDCEN       : signal is "FAST";
  attribute SLEW of MA_nCS         : signal is "FAST";
  attribute SLEW of MA_SCLK        : signal is "FAST";
  attribute SLEW of MA_SDI         : signal is "FAST";
  attribute SLEW of AD_SCKI        : signal is "FAST";
  attribute SLEW of AD_LRCK        : signal is "FAST";
  attribute SLEW of AD_BCK         : signal is "FAST";
  attribute SLEW of AD_FMT         : signal is "SLOW";
  attribute SLEW of AD_MODE        : signal is "SLOW";
  attribute SLEW of AD_BYPAS       : signal is "SLOW";
  attribute SLEW of AD_OSR         : signal is "SLOW";
  attribute SLEW of AD_nPDWN       : signal is "SLOW";
  attribute SLEW of DA_SCKI        : signal is "FAST";
  attribute SLEW of DA_LRCK        : signal is "FAST";
  attribute SLEW of DA_BCK         : signal is "FAST";
  attribute SLEW of DA_DIN         : signal is "FAST";
  attribute SLEW of DA_nRST        : signal is "FAST";
  attribute SLEW of DA_DEMP        : signal is "SLOW";
  attribute SLEW of DA_FMT         : signal is "SLOW";
  attribute SLEW of DA_MUTE        : signal is "SLOW";
  attribute SLEW of PA_nEN         : signal is "SLOW";

end toplevel;

architecture behavioral of toplevel is

  constant cn_data_width : natural := 8;

  component clockgen
    port (
      CLK   : in  std_logic;
      RESET : in  std_logic;
      CLKOP : out std_logic;
      CLKOK : out std_logic;
      LOCK  : out std_logic);
  end component;

  component clockgen_main
    port (
      CLK   : in  std_logic;
      RESET : in  std_logic;
      CLKOP : out std_logic;
      CLKOK : out std_logic;
      LOCK  : out std_logic);
  end component;

  signal sl_clk_98m304, sl_clk_49m152, sl_clk_768k : std_logic;
  signal sl_clk_lock                               : std_logic;

  component reset_gen
    generic (
      CLK_FREQ        : integer;
      RESET_HOLD_TIME : integer);
    port (
      CLK    : in  std_logic;
      nRESET : out std_logic;
      RESET  : out std_logic);
  end component;

  signal sl_reset, sl_nreset : std_logic;

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

  signal sv_ad_doutl, sv_ad_doutr : std_logic_vector(23 downto 0);
  signal sl_ad_dval               : std_logic;

  component i2s_transmitter
    generic (
      DATA_WIDTH     : positive;
      CLK_IN_PER_BCK : positive;
      BCK_PER_LRCK   : positive);
    port (
      CLK_IN : in  std_logic;
      nRESET : in  std_logic;
      LRCK   : out std_logic;
      BCK    : out std_logic;
      DOUT   : out std_logic;
      DINL   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DINR   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      DVAL   : in  std_logic);
  end component;

  signal sv_da_doutl, sv_da_doutr : std_logic_vector(23 downto 0);
  signal sl_da_dval               : std_logic;

  component gain_control
    generic (
      CLK_FREQ : positive;
      CLK_MAX  : positive);
    port (
      CLK_IN      : in  std_logic;
      nRESET      : in  std_logic;
      GAIN        : in  std_logic_vector(5 downto 0);
      GPO         : in  std_logic_vector(3 downto 0);
      DC_SERVO_EN : in  std_logic;
      CM_SERVO_EN : in  std_logic;
      OVERLOAD    : in  std_logic;
      SCKL        : out std_logic;
      nCS         : out std_logic;
      DOUT        : out std_logic;
      DIN         : in  std_logic);
  end component;

  signal sv_ma_gain : std_logic_vector(5 downto 0);

  component chatter_suppress
    generic (
      BUTTON_COUNT    : positive;
      SUPPRESS_CLOCKS : positive);
    port (
      CLK_IN : in  std_logic;
      nRESET : in  std_logic;
      INPUT  : in  std_logic_vector(BUTTON_COUNT-1 downto 0);
      OUTPUT : out std_logic_vector(BUTTON_COUNT-1 downto 0));
  end component;

  signal sv_buttons, sv_switches : std_logic_vector(7 downto 0);

  component bargraph_decoder
    generic (
      BAR_LIGHT_COUNT   : positive;
      OUTPUT_ACTIVE_LOW : boolean);
    port (
      CLK_IN : in  std_logic;
      nRESET : in  std_logic;
      OE     : in  std_logic;
      DEC_EN : in  std_logic;
      INPUT  : in  std_logic_vector(7 downto 0);
      OUTPUT : out std_logic_vector(7 downto 0));
  end component;

  signal sv_bargraph_left, sv_bargraph_right : std_logic_vector(BARGRAPH_LEFT'range);
  signal sl_bargraph_dec_en                  : std_logic;

  component segment_decoder
    generic (
      OUTPUT_ACTIVE_LOW : boolean;
      REGISTER_OUTPUTS  : boolean);
    port (
      CLK_IN : in  std_logic;
      nRESET : in  std_logic;
      OE     : in  std_logic;
      INPUT  : in  std_logic_vector(3 downto 0);
      OUTPUT : out std_logic_vector(7 downto 0));
  end component;

  signal sv_segment_led1, sv_segment_led2, sv_segment_led3, sv_segment_led4 :
    std_logic_vector(3 downto 0);
  
  component stud_toplevel
    generic (
      DATA_WIDTH : positive);
    port (
      CLK_FAST        : in  std_logic;
      CLK_SLOW        : in  std_logic;
      nRESET          : in  std_logic;
      SWITCH_1        : in  std_logic;
      SWITCH_2        : in  std_logic;
      SWITCH_3        : in  std_logic;
      SWITCH_4        : in  std_logic;
      SWITCH_5        : in  std_logic;
      SWITCH_6        : in  std_logic;
      SWITCH_7        : in  std_logic;
      SWITCH_8        : in  std_logic;
      BUTTON_1        : in  std_logic;
      BUTTON_2        : in  std_logic;
      BUTTON_3        : in  std_logic;
      BUTTON_4        : in  std_logic;
      BUTTON_5        : in  std_logic;
      BUTTON_6        : in  std_logic;
      BUTTON_7        : in  std_logic;
      BUTTON_8        : in  std_logic;
      STATUS_L_RED    : out std_logic;
      STATUS_L_YEL    : out std_logic;
      STATUS_L_GRE    : out std_logic;
      STATUS_M_RED    : out std_logic;
      STATUS_M_YEL    : out std_logic;
      STATUS_M_GRE    : out std_logic;
      STATUS_R_RED    : out std_logic;
      STATUS_R_YEL    : out std_logic;
      STATUS_R_GRE    : out std_logic;
      SEGMENT_LED1    : out std_logic_vector(3 downto 0);
      SEGMENT_LED2    : out std_logic_vector(3 downto 0);
      SEGMENT_LED3    : out std_logic_vector(3 downto 0);
      SEGMENT_LED4    : out std_logic_vector(3 downto 0);
      BARGRAPH_LEFT   : out std_logic_vector(7 downto 0);
      BARGRAPH_RIGHT  : out std_logic_vector(7 downto 0);
      BARGRAPH_DEC_EN : out std_logic;
      PC_SDIN         : in  std_logic;
      PC_SDOUT        : out std_logic;
      MA_GAIN         : out std_logic_vector(5 downto 0);
      AD_PDIN_L       : in  std_logic_vector(23 downto 0);
      AD_PDIN_R       : in  std_logic_vector(23 downto 0);
      AD_DVAL         : in  std_logic;
      DA_PDOUT_L      : out std_logic_vector(23 downto 0);
      DA_PDOUT_R      : out std_logic_vector(23 downto 0);
      DA_DVAL         : out std_logic);
  end component;
  
begin  -- behavioral

  clockgen_1 : clockgen
    port map (
      CLK   => CLK,
      RESET => '0',
      CLKOP => open,
      CLKOK => sl_clk_768k,
      LOCK  => open);

  clockgen_main_1 : clockgen_main
    port map (
      CLK   => CLK,
      RESET => '0',
      CLKOP => sl_clk_98m304,
      CLKOK => sl_clk_49m152,
      LOCK  => sl_clk_lock);

  reset_gen_1 : reset_gen
    generic map (
      CLK_FREQ        => 32768000,
      RESET_HOLD_TIME => 50)
    port map (
      CLK    => CLK,
      nRESET => sl_nreset,
      RESET  => sl_reset);

  DA_SCKI <= sl_clk_49m152;
  AD_SCKI <= sl_clk_49m152;

  i2s_receiver_1 : i2s_receiver
    generic map (
      DATA_WIDTH => 24)
    port map (
      CLK_IN => sl_clk_49m152,
      nRESET => sl_nreset,
      LRCK   => AD_LRCK,
      BCK    => AD_BCK,
      DIN    => AD_DOUT,
      DOUTL  => sv_ad_doutl,
      DOUTR  => sv_ad_doutr,
      DVAL   => sl_ad_dval);

  i2s_transmitter_1 : i2s_transmitter
    generic map (
      DATA_WIDTH     => 24,
      CLK_IN_PER_BCK => 32,
      BCK_PER_LRCK   => 8)
    port map (
      CLK_IN => sl_clk_49m152,
      nRESET => sl_nreset,
      LRCK   => DA_LRCK,
      BCK    => DA_BCK,
      DOUT   => DA_DIN,
      DINL   => sv_da_doutl,
      DINR   => sv_da_doutr,
      DVAL   => sl_da_dval);

  gain_control_1 : gain_control
    generic map (
      CLK_FREQ => 49152000,
      CLK_MAX  => 6250000)
    port map (
      CLK_IN      => sl_clk_49m152,
      nRESET      => sl_nreset,
      GAIN        => sv_ma_gain,
      GPO         => "0000",
      DC_SERVO_EN => '1',
      CM_SERVO_EN => '1',
      OVERLOAD    => '1',
      SCKL        => MA_SCLK,
      nCS         => MA_nCS,
      DOUT        => MA_SDI,
      DIN         => MA_SDO);

  MA_ZCEN  <= '1';
  MA_nDCEN <= '0';

  chatter_suppress_1 : chatter_suppress
    generic map (
      BUTTON_COUNT    => 8,
      SUPPRESS_CLOCKS => 64)
    port map (
      CLK_IN => sl_clk_49m152,
      nRESET => sl_nreset,
      INPUT  => BUTTONS,
      OUTPUT => sv_buttons);

  chatter_suppress_2 : chatter_suppress
    generic map (
      BUTTON_COUNT    => 8,
      SUPPRESS_CLOCKS => 64)
    port map (
      CLK_IN => sl_clk_49m152,
      nRESET => sl_nreset,
      INPUT  => SWITCHES,
      OUTPUT => sv_switches);

  bargraph_decoder_1 : bargraph_decoder
    generic map (
      BAR_LIGHT_COUNT   => 1,
      OUTPUT_ACTIVE_LOW => true)
    port map (
      CLK_IN => sl_clk_49m152,
      nRESET => sl_nreset,
      OE     => '1',
      DEC_EN => sl_bargraph_dec_en,
      INPUT  => sv_bargraph_left,
      OUTPUT => BARGRAPH_LEFT);

  bargraph_decoder_2 : bargraph_decoder
    generic map (
      BAR_LIGHT_COUNT   => 1,
      OUTPUT_ACTIVE_LOW => true)
    port map (
      CLK_IN => sl_clk_49m152,
      nRESET => sl_nreset,
      OE     => '1',
      DEC_EN => sl_bargraph_dec_en,
      INPUT  => sv_bargraph_right,
      OUTPUT => BARGRAPH_RIGHT);

  segment_decoder_1 : segment_decoder
    generic map (
      OUTPUT_ACTIVE_LOW => true,
      REGISTER_OUTPUTS  => true)
    port map (
      CLK_IN => sl_clk_49m152,
      nRESET => sl_nreset,
      OE     => '1',
      INPUT  => sv_segment_led1,
      OUTPUT => SEGMENT_LED1);

  segment_decoder_2 : segment_decoder
    generic map (
      OUTPUT_ACTIVE_LOW => true,
      REGISTER_OUTPUTS  => true)
    port map (
      CLK_IN => sl_clk_49m152,
      nRESET => sl_nreset,
      OE     => '1',
      INPUT  => sv_segment_led2,
      OUTPUT => SEGMENT_LED2);

  segment_decoder_3 : segment_decoder
    generic map (
      OUTPUT_ACTIVE_LOW => true,
      REGISTER_OUTPUTS  => true)
    port map (
      CLK_IN => sl_clk_49m152,
      nRESET => sl_nreset,
      OE     => '1',
      INPUT  => sv_segment_led3,
      OUTPUT => SEGMENT_LED3);

  segment_decoder_4 : segment_decoder
    generic map (
      OUTPUT_ACTIVE_LOW => true,
      REGISTER_OUTPUTS  => true)
    port map (
      CLK_IN => sl_clk_49m152,
      nRESET => sl_nreset,
      OE     => '1',
      INPUT  => sv_segment_led4,
      OUTPUT => SEGMENT_LED4);

  stud_toplevel_1 : stud_toplevel
    generic map (
      DATA_WIDTH => cn_data_width)
    port map (
      CLK_FAST        => sl_clk_49m152,
      CLK_SLOW        => sl_clk_768k,
      nRESET          => sl_nreset,
      SWITCH_1        => sv_switches(0),
      SWITCH_2        => sv_switches(1),
      SWITCH_3        => sv_switches(2),
      SWITCH_4        => sv_switches(3),
      SWITCH_5        => sv_switches(4),
      SWITCH_6        => sv_switches(5),
      SWITCH_7        => sv_switches(6),
      SWITCH_8        => sv_switches(7),
      BUTTON_1        => sv_buttons(0),
      BUTTON_2        => sv_buttons(1),
      BUTTON_3        => sv_buttons(2),
      BUTTON_4        => sv_buttons(3),
      BUTTON_5        => sv_buttons(4),
      BUTTON_6        => sv_buttons(5),
      BUTTON_7        => sv_buttons(6),
      BUTTON_8        => sv_buttons(7),
      STATUS_L_RED    => STATUS_RED(0),
      STATUS_L_YEL    => STATUS_YELLOW(0),
      STATUS_L_GRE    => STATUS_GREEN(0),
      STATUS_M_RED    => STATUS_RED(1),
      STATUS_M_YEL    => STATUS_YELLOW(1),
      STATUS_M_GRE    => STATUS_GREEN(1),
      STATUS_R_RED    => STATUS_RED(2),
      STATUS_R_YEL    => STATUS_YELLOW(2),
      STATUS_R_GRE    => STATUS_GREEN(2),
      SEGMENT_LED1    => sv_segment_led1,
      SEGMENT_LED2    => sv_segment_led2,
      SEGMENT_LED3    => sv_segment_led3,
      SEGMENT_LED4    => sv_segment_led4,
      BARGRAPH_LEFT   => sv_bargraph_left,
      BARGRAPH_RIGHT  => sv_bargraph_right,
      BARGRAPH_DEC_EN => sl_bargraph_dec_en,
      PC_SDIN         => RS232_RX,
      PC_SDOUT        => RS232_TX,
      MA_GAIN         => sv_ma_gain,
      AD_PDIN_L       => sv_ad_doutl,
      AD_PDIN_R       => sv_ad_doutr,
      AD_DVAL         => sl_ad_dval,
      DA_PDOUT_L      => sv_da_doutl,
      DA_PDOUT_R      => sv_da_doutr,
      DA_DVAL         => sl_da_dval);

end behavioral;
