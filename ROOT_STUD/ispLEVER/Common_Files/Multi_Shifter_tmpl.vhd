-- VHDL module instantiation generated by SCUBA ispLever_v60_PROD_Build (36)
-- Module  Version: 3.0
-- Sun Nov 26 00:53:39 2006

-- parameterized module component declaration
component Multi_Shifter
    port (Clock: in  std_logic; ClkEn: in  std_logic; 
        Aclr: in  std_logic; DataA: in  std_logic_vector(7 downto 0); 
        DataB: in  std_logic_vector(15 downto 0); 
        Result: out  std_logic_vector(23 downto 0));
end component;

-- parameterized module component instance
__ : Multi_Shifter
    port map (Clock=>__, ClkEn=>__, Aclr=>__, DataA(7 downto 0)=>__, 
        DataB(15 downto 0)=>__, Result(23 downto 0)=>__);

