-- VHDL netlist generated by SCUBA ispLever_v61_PROD_Build (37)
-- Module  Version: 3.2
--C:\ispTOOLS6_1_STRT\ispfpga\bin\nt\scuba.exe -w -n clockgen_main -lang vhdl -synth synplify -arch ep5g00p -type pll -fin 32.768 -fclkop 98 -fclkop_tol 0.5 -delay_cntl STATIC -fdel 0 -fb_mode CLOCKTREE -noclkos -fclkok 49.152 -fclkok_tol 0.0 -e 

-- Wed Nov 15 23:58:42 2006

library IEEE;
use IEEE.std_logic_1164.all;
-- synopsys translate_off
library ecp;
use ecp.components.all;
-- synopsys translate_on

entity clockgen_main is
    port (
        CLK: in std_logic; 
        RESET: in std_logic; 
        CLKOP: out std_logic; 
        CLKOK: out std_logic; 
        LOCK: out std_logic);
end clockgen_main;

architecture Structure of clockgen_main is

    -- internal signal declarations
    signal scuba_vlo: std_logic;
    signal CLKOP_t: std_logic;
    signal CLK_t: std_logic;

    -- local component declarations
    component EHXPLLB
    -- synopsys translate_off
        generic (DUTY : in String; PHASEADJ : in String; 
                DELAY_CNTL : in String; CLKOK_DIV : in String; 
                FDEL : in String; CLKFB_DIV : in String; 
                CLKOP_DIV : in String; CLKI_DIV : in String);
    -- synopsys translate_on
        port (CLKI: in std_logic; CLKFB: in std_logic; RST: in std_logic; 
            DDAMODE: in std_logic; DDAIZR: in std_logic; DDAILAG: in std_logic; 
            DDAIDEL0: in std_logic; DDAIDEL1: in std_logic; DDAIDEL2: in std_logic; 
            CLKOP: out std_logic; CLKOS: out std_logic; CLKOK: out std_logic; 
            LOCK: out std_logic; DDAOZR: out std_logic; DDAOLAG: out std_logic; 
            DDAODEL0: out std_logic; DDAODEL1: out std_logic; DDAODEL2: out std_logic);
    end component;
    component VLO
        port (Z: out std_logic);
    end component;
    attribute DELAY_CNTL : string; 
    attribute FDEL : string; 
    attribute DUTY : string; 
    attribute PHASEADJ : string; 
    attribute FB_MODE : string; 
    attribute FREQUENCY_PIN_CLKOS : string; 
    attribute FREQUENCY_PIN_CLKOP : string; 
    attribute FREQUENCY_PIN_CLKI : string; 
    attribute FREQUENCY_PIN_CLKOK : string; 
    attribute CLKOK_DIV : string; 
    attribute CLKOP_DIV : string; 
    attribute CLKFB_DIV : string; 
    attribute CLKI_DIV : string; 
    attribute FIN : string; 
    attribute DELAY_CNTL of PLLBInst_0 : label is "STATIC";
    attribute FDEL of PLLBInst_0 : label is "0";
    attribute DUTY of PLLBInst_0 : label is "4";
    attribute PHASEADJ of PLLBInst_0 : label is "0";
    attribute FB_MODE of PLLBInst_0 : label is "CLOCKTREE";
    attribute FREQUENCY_PIN_CLKOS of PLLBInst_0 : label is "98.304000";
    attribute FREQUENCY_PIN_CLKOP of PLLBInst_0 : label is "98.304000";
    attribute FREQUENCY_PIN_CLKI of PLLBInst_0 : label is "32.768000";
    attribute FREQUENCY_PIN_CLKOK of PLLBInst_0 : label is "49.152000";
    attribute CLKOK_DIV of PLLBInst_0 : label is "2";
    attribute CLKOP_DIV of PLLBInst_0 : label is "8";
    attribute CLKFB_DIV of PLLBInst_0 : label is "3";
    attribute CLKI_DIV of PLLBInst_0 : label is "1";
    attribute FIN of PLLBInst_0 : label is "32.768000";
    attribute syn_keep : boolean;

begin
    -- component instantiation statements
    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    PLLBInst_0: EHXPLLB
        -- synopsys translate_off
        generic map (DELAY_CNTL=> "STATIC", FDEL=> "0", DUTY=> "4", 
        PHASEADJ=> "0", CLKOK_DIV=> "2", CLKOP_DIV=> "8", CLKFB_DIV=> "3", 
        CLKI_DIV=> "1")
        -- synopsys translate_on
        port map (CLKI=>CLK_t, CLKFB=>CLKOP_t, RST=>RESET, 
            DDAMODE=>scuba_vlo, DDAIZR=>scuba_vlo, DDAILAG=>scuba_vlo, 
            DDAIDEL0=>scuba_vlo, DDAIDEL1=>scuba_vlo, 
            DDAIDEL2=>scuba_vlo, CLKOP=>CLKOP_t, CLKOS=>open, 
            CLKOK=>CLKOK, LOCK=>LOCK, DDAOZR=>open, DDAOLAG=>open, 
            DDAODEL0=>open, DDAODEL1=>open, DDAODEL2=>open);

    CLKOP <= CLKOP_t;
    CLK_t <= CLK;
end Structure;

-- synopsys translate_off
library ecp;
configuration Structure_CON of clockgen_main is
    for Structure
        for all:EHXPLLB use entity ecp.EHXPLLB(V); end for;
        for all:VLO use entity ecp.VLO(V); end for;
    end for;
end Structure_CON;

-- synopsys translate_on
