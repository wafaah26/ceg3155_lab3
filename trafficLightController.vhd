library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity trafficLightController is
 Port (
    MSC, SSC: in std_logic_vector(3 downto 0);
    SSCS: in std_logic;
    GClock: in std_logic;
    GReset: in std_logic;
    MSTL, SSTL: out std_logic_vector(2 downto 0)
	 --BCD0, BCD1: out std_logic_vector(3 downto 0) 
 );
end trafficLightController;

architecture struct of trafficLightController is
    signal CEXP, LOADC, ENC: std_logic;
    signal SELC: std_logic_vector(1 downto 0);
    signal cntMUXout, maxMUXout: std_logic_vector(3 downto 0);
    signal MSTout, SSTout, SSCout, MSCout: std_logic_vector(3 downto 0);
    signal MSTmax, SSTmax, SSCmax, MSCmax: std_logic_vector(3 downto 0);
	 --signal BCD1_int, BCD2_int: std_logic_vector(3 downto 0);
begin

    --MAX COUNTER VALUES
    MSTmax <= "0100";
    SSTmax <= "0011";
    SSCmax <= SSC;
    MSCmax <= MSC;
		  
    FSMControl: entity work.FSM(struct)
        port map(GClock, GReset, SSCS, CEXP, MSTL, SSTL, SELC, LOADC, ENC);
    
    Comparator: entity work.comparator_4b(struct)
        port map(cntMUXout, maxMUXout, CEXP);

    cntMUX: entity work.mux4to1_4b(struct)
        port map(MSTout, SSCout, SSTout, MSCout, SELC(1), SELC(0), cntMUXout);
    
    maxMUX: entity work.mux4to1_4b(struct)
        port map(MSTmax, SSCmax, SSTmax, MSCmax, SELC(1), SELC(0), maxMUXout);

    MSTcounter: entity work.counter_4b(struct)
        port map(GClock, LOADC, ENC, MSTout);

    SSTcounter: entity work.counter_4b(struct)
        port map(GClock, LOADC, ENC, SSTout);

    SSCcounter: entity work.counter_4b(struct)
        port map(GClock, LOADC, ENC, SSCout);

    MSCcounter: entity work.counter_4b(struct)
        port map(GClock, LOADC, ENC, MSCout);
		  
	
end ;