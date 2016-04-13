-- VHDL netlist generated by SCUBA ispLever_v60_PROD_Build (36)
-- Module  Version: 2.1
--C:\ispTOOLS6_0_STRT\ispfpga\bin\nt\scuba.exe -w -n FilterCell -lang vhdl -synth synplify -bus_exp 7 -bb -arch ep5g00p -type dspmaddsum -widtha 9 -widthb 9 -widthsum 20 -gsr ENABLED -area -madd0 -madd1 -signed -rega0 -rega0clk CLK0 -rega0rst RST0 -rega1 -rega1clk CLK0 -rega1rst RST0 -rega2 -rega2clk CLK0 -rega2rst RST0 -rega3 -rega3clk CLK0 -rega3rst RST0 -regb0 -regb0clk CLK0 -regb0rst RST0 -regb1 -regb1clk CLK0 -regb1rst RST0 -regb2 -regb2clk CLK0 -regb2rst RST0 -regb3 -regb3clk CLK0 -regb3rst RST0 -regp0 -regp0clk CLK0 -regp0rst RST0 -regp1 -regp1clk CLK0 -regp1rst RST0 -regp2 -regp2clk CLK0 -regp2rst RST0 -regp3 -regp3clk CLK0 -regp3rst RST0 -rego -regoclk CLK0 -regorst RST0 -load -clk0 -rst0 -e 

-- Thu Nov 30 04:15:48 2006

library IEEE;
use IEEE.std_logic_1164.all;
-- synopsys translate_off
library ecp;
use ecp.components.all;
-- synopsys translate_on

entity FilterCell is
    port (
        CLK0: in  std_logic; 
        RST0: in  std_logic; 
        A0: in  std_logic_vector(8 downto 0); 
        A1: in  std_logic_vector(8 downto 0); 
        A2: in  std_logic_vector(8 downto 0); 
        A3: in  std_logic_vector(8 downto 0); 
        B0: in  std_logic_vector(8 downto 0); 
        B1: in  std_logic_vector(8 downto 0); 
        B2: in  std_logic_vector(8 downto 0); 
        B3: in  std_logic_vector(8 downto 0); 
        SUM: out  std_logic_vector(19 downto 0));
end FilterCell;

architecture Structure of FilterCell is

    -- internal signal declarations
    signal scuba_vhi: std_logic;
    signal scuba_vlo: std_logic;

    -- local component declarations
    component VHI
        port (Z: out  std_logic);
    end component;
    component VLO
        port (Z: out  std_logic);
    end component;
    component MULT9X9ADDSUBSUM
    -- synopsys translate_off
        generic (GSR : in String; SHIFT_IN_B3 : in String; 
                SHIFT_IN_A3 : in String; SHIFT_IN_B2 : in String; 
                SHIFT_IN_A2 : in String; SHIFT_IN_B1 : in String; 
                SHIFT_IN_A1 : in String; SHIFT_IN_B0 : in String; 
                SHIFT_IN_A0 : in String; REG_ADDNSUB3_1_RST : in String; 
                REG_ADDNSUB3_1_CE : in String; 
                REG_ADDNSUB3_1_CLK : in String; 
                REG_ADDNSUB3_0_RST : in String; 
                REG_ADDNSUB3_0_CE : in String; 
                REG_ADDNSUB3_0_CLK : in String; 
                REG_ADDNSUB1_1_RST : in String; 
                REG_ADDNSUB1_1_CE : in String; 
                REG_ADDNSUB1_1_CLK : in String; 
                REG_ADDNSUB1_0_RST : in String; 
                REG_ADDNSUB1_0_CE : in String; 
                REG_ADDNSUB1_0_CLK : in String; 
                REG_SIGNEDAB_1_RST : in String; 
                REG_SIGNEDAB_1_CE : in String; 
                REG_SIGNEDAB_1_CLK : in String; 
                REG_SIGNEDAB_0_RST : in String; 
                REG_SIGNEDAB_0_CE : in String; 
                REG_SIGNEDAB_0_CLK : in String; 
                REG_OUTPUT_RST : in String; REG_OUTPUT_CE : in String; 
                REG_OUTPUT_CLK : in String; 
                REG_PIPELINE3_RST : in String; 
                REG_PIPELINE3_CE : in String; 
                REG_PIPELINE3_CLK : in String; 
                REG_PIPELINE2_RST : in String; 
                REG_PIPELINE2_CE : in String; 
                REG_PIPELINE2_CLK : in String; 
                REG_PIPELINE1_RST : in String; 
                REG_PIPELINE1_CE : in String; 
                REG_PIPELINE1_CLK : in String; 
                REG_PIPELINE0_RST : in String; 
                REG_PIPELINE0_CE : in String; 
                REG_PIPELINE0_CLK : in String; 
                REG_INPUTB3_RST : in String; REG_INPUTB3_CE : in String; 
                REG_INPUTB3_CLK : in String; REG_INPUTB2_RST : in String; 
                REG_INPUTB2_CE : in String; REG_INPUTB2_CLK : in String; 
                REG_INPUTB1_RST : in String; REG_INPUTB1_CE : in String; 
                REG_INPUTB1_CLK : in String; REG_INPUTB0_RST : in String; 
                REG_INPUTB0_CE : in String; REG_INPUTB0_CLK : in String; 
                REG_INPUTA3_RST : in String; REG_INPUTA3_CE : in String; 
                REG_INPUTA3_CLK : in String; REG_INPUTA2_RST : in String; 
                REG_INPUTA2_CE : in String; REG_INPUTA2_CLK : in String; 
                REG_INPUTA1_RST : in String; REG_INPUTA1_CE : in String; 
                REG_INPUTA1_CLK : in String; REG_INPUTA0_RST : in String; 
                REG_INPUTA0_CE : in String; REG_INPUTA0_CLK : in String);
    -- synopsys translate_on
        port (A00: in  std_logic; A01: in  std_logic; A02: in  std_logic; 
            A03: in  std_logic; A04: in  std_logic; A05: in  std_logic; 
            A06: in  std_logic; A07: in  std_logic; A08: in  std_logic; 
            A10: in  std_logic; A11: in  std_logic; A12: in  std_logic; 
            A13: in  std_logic; A14: in  std_logic; A15: in  std_logic; 
            A16: in  std_logic; A17: in  std_logic; A18: in  std_logic; 
            A20: in  std_logic; A21: in  std_logic; A22: in  std_logic; 
            A23: in  std_logic; A24: in  std_logic; A25: in  std_logic; 
            A26: in  std_logic; A27: in  std_logic; A28: in  std_logic; 
            A30: in  std_logic; A31: in  std_logic; A32: in  std_logic; 
            A33: in  std_logic; A34: in  std_logic; A35: in  std_logic; 
            A36: in  std_logic; A37: in  std_logic; A38: in  std_logic; 
            SRIA0: in  std_logic; SRIA1: in  std_logic; 
            SRIA2: in  std_logic; SRIA3: in  std_logic; 
            SRIA4: in  std_logic; SRIA5: in  std_logic; 
            SRIA6: in  std_logic; SRIA7: in  std_logic; 
            SRIA8: in  std_logic; B00: in  std_logic; B01: in  std_logic; 
            B02: in  std_logic; B03: in  std_logic; B04: in  std_logic; 
            B05: in  std_logic; B06: in  std_logic; B07: in  std_logic; 
            B08: in  std_logic; B10: in  std_logic; B11: in  std_logic; 
            B12: in  std_logic; B13: in  std_logic; B14: in  std_logic; 
            B15: in  std_logic; B16: in  std_logic; B17: in  std_logic; 
            B18: in  std_logic; B20: in  std_logic; B21: in  std_logic; 
            B22: in  std_logic; B23: in  std_logic; B24: in  std_logic; 
            B25: in  std_logic; B26: in  std_logic; B27: in  std_logic; 
            B28: in  std_logic; B30: in  std_logic; B31: in  std_logic; 
            B32: in  std_logic; B33: in  std_logic; B34: in  std_logic; 
            B35: in  std_logic; B36: in  std_logic; B37: in  std_logic; 
            B38: in  std_logic; SRIB0: in  std_logic; 
            SRIB1: in  std_logic; SRIB2: in  std_logic; 
            SRIB3: in  std_logic; SRIB4: in  std_logic; 
            SRIB5: in  std_logic; SRIB6: in  std_logic; 
            SRIB7: in  std_logic; SRIB8: in  std_logic; 
            SIGNEDAB: in  std_logic; ADDNSUB1: in  std_logic; 
            ADDNSUB3: in  std_logic; CE0: in  std_logic; 
            CE1: in  std_logic; CE2: in  std_logic; CE3: in  std_logic; 
            CLK0: in  std_logic; CLK1: in  std_logic; 
            CLK2: in  std_logic; CLK3: in  std_logic; 
            RST0: in  std_logic; RST1: in  std_logic; 
            RST2: in  std_logic; RST3: in  std_logic; 
            SROA0: out  std_logic; SROA1: out  std_logic; 
            SROA2: out  std_logic; SROA3: out  std_logic; 
            SROA4: out  std_logic; SROA5: out  std_logic; 
            SROA6: out  std_logic; SROA7: out  std_logic; 
            SROA8: out  std_logic; SROB0: out  std_logic; 
            SROB1: out  std_logic; SROB2: out  std_logic; 
            SROB3: out  std_logic; SROB4: out  std_logic; 
            SROB5: out  std_logic; SROB6: out  std_logic; 
            SROB7: out  std_logic; SROB8: out  std_logic; 
            SUM0: out  std_logic; SUM1: out  std_logic; 
            SUM2: out  std_logic; SUM3: out  std_logic; 
            SUM4: out  std_logic; SUM5: out  std_logic; 
            SUM6: out  std_logic; SUM7: out  std_logic; 
            SUM8: out  std_logic; SUM9: out  std_logic; 
            SUM10: out  std_logic; SUM11: out  std_logic; 
            SUM12: out  std_logic; SUM13: out  std_logic; 
            SUM14: out  std_logic; SUM15: out  std_logic; 
            SUM16: out  std_logic; SUM17: out  std_logic; 
            SUM18: out  std_logic; SUM19: out  std_logic);
    end component;
    attribute GSR : string; 
    attribute SHIFT_IN_B3 : string; 
    attribute SHIFT_IN_A3 : string; 
    attribute SHIFT_IN_B2 : string; 
    attribute SHIFT_IN_A2 : string; 
    attribute SHIFT_IN_B1 : string; 
    attribute SHIFT_IN_A1 : string; 
    attribute SHIFT_IN_B0 : string; 
    attribute SHIFT_IN_A0 : string; 
    attribute REG_ADDNSUB3_1_RST : string; 
    attribute REG_ADDNSUB3_1_CE : string; 
    attribute REG_ADDNSUB3_1_CLK : string; 
    attribute REG_ADDNSUB3_0_RST : string; 
    attribute REG_ADDNSUB3_0_CE : string; 
    attribute REG_ADDNSUB3_0_CLK : string; 
    attribute REG_ADDNSUB1_1_RST : string; 
    attribute REG_ADDNSUB1_1_CE : string; 
    attribute REG_ADDNSUB1_1_CLK : string; 
    attribute REG_ADDNSUB1_0_RST : string; 
    attribute REG_ADDNSUB1_0_CE : string; 
    attribute REG_ADDNSUB1_0_CLK : string; 
    attribute REG_SIGNEDAB_1_RST : string; 
    attribute REG_SIGNEDAB_1_CE : string; 
    attribute REG_SIGNEDAB_1_CLK : string; 
    attribute REG_SIGNEDAB_0_RST : string; 
    attribute REG_SIGNEDAB_0_CE : string; 
    attribute REG_SIGNEDAB_0_CLK : string; 
    attribute REG_OUTPUT_RST : string; 
    attribute REG_OUTPUT_CE : string; 
    attribute REG_OUTPUT_CLK : string; 
    attribute REG_PIPELINE3_RST : string; 
    attribute REG_PIPELINE3_CE : string; 
    attribute REG_PIPELINE3_CLK : string; 
    attribute REG_PIPELINE2_RST : string; 
    attribute REG_PIPELINE2_CE : string; 
    attribute REG_PIPELINE2_CLK : string; 
    attribute REG_PIPELINE1_RST : string; 
    attribute REG_PIPELINE1_CE : string; 
    attribute REG_PIPELINE1_CLK : string; 
    attribute REG_PIPELINE0_RST : string; 
    attribute REG_PIPELINE0_CE : string; 
    attribute REG_PIPELINE0_CLK : string; 
    attribute REG_INPUTB3_RST : string; 
    attribute REG_INPUTB3_CE : string; 
    attribute REG_INPUTB3_CLK : string; 
    attribute REG_INPUTA3_RST : string; 
    attribute REG_INPUTA3_CE : string; 
    attribute REG_INPUTA3_CLK : string; 
    attribute REG_INPUTB2_RST : string; 
    attribute REG_INPUTB2_CE : string; 
    attribute REG_INPUTB2_CLK : string; 
    attribute REG_INPUTA2_RST : string; 
    attribute REG_INPUTA2_CE : string; 
    attribute REG_INPUTA2_CLK : string; 
    attribute REG_INPUTB1_RST : string; 
    attribute REG_INPUTB1_CE : string; 
    attribute REG_INPUTB1_CLK : string; 
    attribute REG_INPUTA1_RST : string; 
    attribute REG_INPUTA1_CE : string; 
    attribute REG_INPUTA1_CLK : string; 
    attribute REG_INPUTB0_RST : string; 
    attribute REG_INPUTB0_CE : string; 
    attribute REG_INPUTB0_CLK : string; 
    attribute REG_INPUTA0_RST : string; 
    attribute REG_INPUTA0_CE : string; 
    attribute REG_INPUTA0_CLK : string; 
    attribute GSR of dsp_0 : label is "ENABLED";
    attribute SHIFT_IN_B3 of dsp_0 : label is "FALSE";
    attribute SHIFT_IN_A3 of dsp_0 : label is "FALSE";
    attribute SHIFT_IN_B2 of dsp_0 : label is "FALSE";
    attribute SHIFT_IN_A2 of dsp_0 : label is "FALSE";
    attribute SHIFT_IN_B1 of dsp_0 : label is "FALSE";
    attribute SHIFT_IN_A1 of dsp_0 : label is "FALSE";
    attribute SHIFT_IN_B0 of dsp_0 : label is "FALSE";
    attribute SHIFT_IN_A0 of dsp_0 : label is "FALSE";
    attribute REG_ADDNSUB3_1_RST of dsp_0 : label is "RST0";
    attribute REG_ADDNSUB3_1_CE of dsp_0 : label is "CE0";
    attribute REG_ADDNSUB3_1_CLK of dsp_0 : label is "NONE";
    attribute REG_ADDNSUB3_0_RST of dsp_0 : label is "RST0";
    attribute REG_ADDNSUB3_0_CE of dsp_0 : label is "CE0";
    attribute REG_ADDNSUB3_0_CLK of dsp_0 : label is "NONE";
    attribute REG_ADDNSUB1_1_RST of dsp_0 : label is "RST0";
    attribute REG_ADDNSUB1_1_CE of dsp_0 : label is "CE0";
    attribute REG_ADDNSUB1_1_CLK of dsp_0 : label is "NONE";
    attribute REG_ADDNSUB1_0_RST of dsp_0 : label is "RST0";
    attribute REG_ADDNSUB1_0_CE of dsp_0 : label is "CE0";
    attribute REG_ADDNSUB1_0_CLK of dsp_0 : label is "NONE";
    attribute REG_SIGNEDAB_1_RST of dsp_0 : label is "RST0";
    attribute REG_SIGNEDAB_1_CE of dsp_0 : label is "CE0";
    attribute REG_SIGNEDAB_1_CLK of dsp_0 : label is "NONE";
    attribute REG_SIGNEDAB_0_RST of dsp_0 : label is "RST0";
    attribute REG_SIGNEDAB_0_CE of dsp_0 : label is "CE0";
    attribute REG_SIGNEDAB_0_CLK of dsp_0 : label is "NONE";
    attribute REG_OUTPUT_RST of dsp_0 : label is "RST0";
    attribute REG_OUTPUT_CE of dsp_0 : label is "CE0";
    attribute REG_OUTPUT_CLK of dsp_0 : label is "CLK0";
    attribute REG_PIPELINE3_RST of dsp_0 : label is "RST0";
    attribute REG_PIPELINE3_CE of dsp_0 : label is "CE0";
    attribute REG_PIPELINE3_CLK of dsp_0 : label is "CLK0";
    attribute REG_PIPELINE2_RST of dsp_0 : label is "RST0";
    attribute REG_PIPELINE2_CE of dsp_0 : label is "CE0";
    attribute REG_PIPELINE2_CLK of dsp_0 : label is "CLK0";
    attribute REG_PIPELINE1_RST of dsp_0 : label is "RST0";
    attribute REG_PIPELINE1_CE of dsp_0 : label is "CE0";
    attribute REG_PIPELINE1_CLK of dsp_0 : label is "CLK0";
    attribute REG_PIPELINE0_RST of dsp_0 : label is "RST0";
    attribute REG_PIPELINE0_CE of dsp_0 : label is "CE0";
    attribute REG_PIPELINE0_CLK of dsp_0 : label is "CLK0";
    attribute REG_INPUTB3_RST of dsp_0 : label is "RST0";
    attribute REG_INPUTB3_CE of dsp_0 : label is "CE0";
    attribute REG_INPUTB3_CLK of dsp_0 : label is "CLK0";
    attribute REG_INPUTA3_RST of dsp_0 : label is "RST0";
    attribute REG_INPUTA3_CE of dsp_0 : label is "CE0";
    attribute REG_INPUTA3_CLK of dsp_0 : label is "CLK0";
    attribute REG_INPUTB2_RST of dsp_0 : label is "RST0";
    attribute REG_INPUTB2_CE of dsp_0 : label is "CE0";
    attribute REG_INPUTB2_CLK of dsp_0 : label is "CLK0";
    attribute REG_INPUTA2_RST of dsp_0 : label is "RST0";
    attribute REG_INPUTA2_CE of dsp_0 : label is "CE0";
    attribute REG_INPUTA2_CLK of dsp_0 : label is "CLK0";
    attribute REG_INPUTB1_RST of dsp_0 : label is "RST0";
    attribute REG_INPUTB1_CE of dsp_0 : label is "CE0";
    attribute REG_INPUTB1_CLK of dsp_0 : label is "CLK0";
    attribute REG_INPUTA1_RST of dsp_0 : label is "RST0";
    attribute REG_INPUTA1_CE of dsp_0 : label is "CE0";
    attribute REG_INPUTA1_CLK of dsp_0 : label is "CLK0";
    attribute REG_INPUTB0_RST of dsp_0 : label is "RST0";
    attribute REG_INPUTB0_CE of dsp_0 : label is "CE0";
    attribute REG_INPUTB0_CLK of dsp_0 : label is "CLK0";
    attribute REG_INPUTA0_RST of dsp_0 : label is "RST0";
    attribute REG_INPUTA0_CE of dsp_0 : label is "CE0";
    attribute REG_INPUTA0_CLK of dsp_0 : label is "CLK0";

begin
    -- component instantiation statements
    scuba_vhi_inst: VHI
        port map (Z=>scuba_vhi);

    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    dsp_0: MULT9X9ADDSUBSUM
        -- synopsys translate_off
        generic map (GSR=> "ENABLED", SHIFT_IN_B3=> "FALSE", SHIFT_IN_A3=> "FALSE", 
        SHIFT_IN_B2=> "FALSE", SHIFT_IN_A2=> "FALSE", SHIFT_IN_B1=> "FALSE", 
        SHIFT_IN_A1=> "FALSE", SHIFT_IN_B0=> "FALSE", SHIFT_IN_A0=> "FALSE", 
        REG_ADDNSUB3_1_RST=> "RST0", REG_ADDNSUB3_1_CE=> "CE0", 
        REG_ADDNSUB3_1_CLK=> "NONE", REG_ADDNSUB3_0_RST=> "RST0", 
        REG_ADDNSUB3_0_CE=> "CE0", REG_ADDNSUB3_0_CLK=> "NONE", 
        REG_ADDNSUB1_1_RST=> "RST0", REG_ADDNSUB1_1_CE=> "CE0", 
        REG_ADDNSUB1_1_CLK=> "NONE", REG_ADDNSUB1_0_RST=> "RST0", 
        REG_ADDNSUB1_0_CE=> "CE0", REG_ADDNSUB1_0_CLK=> "NONE", 
        REG_SIGNEDAB_1_RST=> "RST0", REG_SIGNEDAB_1_CE=> "CE0", 
        REG_SIGNEDAB_1_CLK=> "NONE", REG_SIGNEDAB_0_RST=> "RST0", 
        REG_SIGNEDAB_0_CE=> "CE0", REG_SIGNEDAB_0_CLK=> "NONE", 
        REG_OUTPUT_RST=> "RST0", REG_OUTPUT_CE=> "CE0", REG_OUTPUT_CLK=> "CLK0", 
        REG_PIPELINE3_RST=> "RST0", REG_PIPELINE3_CE=> "CE0", 
        REG_PIPELINE3_CLK=> "CLK0", REG_PIPELINE2_RST=> "RST0", 
        REG_PIPELINE2_CE=> "CE0", REG_PIPELINE2_CLK=> "CLK0", 
        REG_PIPELINE1_RST=> "RST0", REG_PIPELINE1_CE=> "CE0", 
        REG_PIPELINE1_CLK=> "CLK0", REG_PIPELINE0_RST=> "RST0", 
        REG_PIPELINE0_CE=> "CE0", REG_PIPELINE0_CLK=> "CLK0", 
        REG_INPUTB3_RST=> "RST0", REG_INPUTB3_CE=> "CE0", 
        REG_INPUTB3_CLK=> "CLK0", REG_INPUTA3_RST=> "RST0", 
        REG_INPUTA3_CE=> "CE0", REG_INPUTA3_CLK=> "CLK0", 
        REG_INPUTB2_RST=> "RST0", REG_INPUTB2_CE=> "CE0", 
        REG_INPUTB2_CLK=> "CLK0", REG_INPUTA2_RST=> "RST0", 
        REG_INPUTA2_CE=> "CE0", REG_INPUTA2_CLK=> "CLK0", 
        REG_INPUTB1_RST=> "RST0", REG_INPUTB1_CE=> "CE0", 
        REG_INPUTB1_CLK=> "CLK0", REG_INPUTA1_RST=> "RST0", 
        REG_INPUTA1_CE=> "CE0", REG_INPUTA1_CLK=> "CLK0", 
        REG_INPUTB0_RST=> "RST0", REG_INPUTB0_CE=> "CE0", 
        REG_INPUTB0_CLK=> "CLK0", REG_INPUTA0_RST=> "RST0", 
        REG_INPUTA0_CE=> "CE0", REG_INPUTA0_CLK=> "CLK0")
        -- synopsys translate_on
        port map (A00=>A0(0), A01=>A0(1), A02=>A0(2), A03=>A0(3), 
            A04=>A0(4), A05=>A0(5), A06=>A0(6), A07=>A0(7), A08=>A0(8), 
            A10=>A1(0), A11=>A1(1), A12=>A1(2), A13=>A1(3), A14=>A1(4), 
            A15=>A1(5), A16=>A1(6), A17=>A1(7), A18=>A1(8), A20=>A2(0), 
            A21=>A2(1), A22=>A2(2), A23=>A2(3), A24=>A2(4), A25=>A2(5), 
            A26=>A2(6), A27=>A2(7), A28=>A2(8), A30=>A3(0), A31=>A3(1), 
            A32=>A3(2), A33=>A3(3), A34=>A3(4), A35=>A3(5), A36=>A3(6), 
            A37=>A3(7), A38=>A3(8), SRIA0=>scuba_vlo, SRIA1=>scuba_vlo, 
            SRIA2=>scuba_vlo, SRIA3=>scuba_vlo, SRIA4=>scuba_vlo, 
            SRIA5=>scuba_vlo, SRIA6=>scuba_vlo, SRIA7=>scuba_vlo, 
            SRIA8=>scuba_vlo, B00=>B0(0), B01=>B0(1), B02=>B0(2), 
            B03=>B0(3), B04=>B0(4), B05=>B0(5), B06=>B0(6), B07=>B0(7), 
            B08=>B0(8), B10=>B1(0), B11=>B1(1), B12=>B1(2), B13=>B1(3), 
            B14=>B1(4), B15=>B1(5), B16=>B1(6), B17=>B1(7), B18=>B1(8), 
            B20=>B2(0), B21=>B2(1), B22=>B2(2), B23=>B2(3), B24=>B2(4), 
            B25=>B2(5), B26=>B2(6), B27=>B2(7), B28=>B2(8), B30=>B3(0), 
            B31=>B3(1), B32=>B3(2), B33=>B3(3), B34=>B3(4), B35=>B3(5), 
            B36=>B3(6), B37=>B3(7), B38=>B3(8), SRIB0=>scuba_vlo, 
            SRIB1=>scuba_vlo, SRIB2=>scuba_vlo, SRIB3=>scuba_vlo, 
            SRIB4=>scuba_vlo, SRIB5=>scuba_vlo, SRIB6=>scuba_vlo, 
            SRIB7=>scuba_vlo, SRIB8=>scuba_vlo, SIGNEDAB=>scuba_vhi, 
            ADDNSUB1=>scuba_vhi, ADDNSUB3=>scuba_vhi, CE0=>scuba_vhi, 
            CE1=>scuba_vhi, CE2=>scuba_vhi, CE3=>scuba_vhi, CLK0=>CLK0, 
            CLK1=>scuba_vlo, CLK2=>scuba_vlo, CLK3=>scuba_vlo, 
            RST0=>RST0, RST1=>scuba_vlo, RST2=>scuba_vlo, 
            RST3=>scuba_vlo, SROA0=>open, SROA1=>open, SROA2=>open, 
            SROA3=>open, SROA4=>open, SROA5=>open, SROA6=>open, 
            SROA7=>open, SROA8=>open, SROB0=>open, SROB1=>open, 
            SROB2=>open, SROB3=>open, SROB4=>open, SROB5=>open, 
            SROB6=>open, SROB7=>open, SROB8=>open, SUM0=>SUM(0), 
            SUM1=>SUM(1), SUM2=>SUM(2), SUM3=>SUM(3), SUM4=>SUM(4), 
            SUM5=>SUM(5), SUM6=>SUM(6), SUM7=>SUM(7), SUM8=>SUM(8), 
            SUM9=>SUM(9), SUM10=>SUM(10), SUM11=>SUM(11), SUM12=>SUM(12), 
            SUM13=>SUM(13), SUM14=>SUM(14), SUM15=>SUM(15), 
            SUM16=>SUM(16), SUM17=>SUM(17), SUM18=>SUM(18), 
            SUM19=>SUM(19));

end Structure;

-- synopsys translate_off
library ecp;
configuration Structure_CON of FilterCell is
    for Structure
        for all:VHI use entity ecp.VHI(V); end for;
        for all:VLO use entity ecp.VLO(V); end for;
        for all:MULT9X9ADDSUBSUM use entity ecp.MULT9X9ADDSUBSUM(V); end for;
    end for;
end Structure_CON;

-- synopsys translate_on
