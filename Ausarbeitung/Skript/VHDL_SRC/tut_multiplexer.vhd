

entity multiplexer is

  port (
  -- Musterloesung Anfang
    sine_5kHz : in std_logic_vector(7 downto 0);
    sine_7kHz : in std_logic_vector(7 downto 0);
    adc_data  : in std_logic_vector(7 downto 0);
    dac_data : out std_logic_vector(7 downto 0);
  -- Musterloesung Ende
    sel_s1 : in std_logic;
    sel_s2 : in std_logic);

end;


