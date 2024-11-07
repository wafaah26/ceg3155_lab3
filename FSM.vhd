library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
 Port (
    clk, reset: in std_logic;
    SSCS, CEXP: in std_logic;
    MSTL,SSTL: out std_logic_vector(2 downto 0);
    SELC: out std_logic_vector(1 downto 0);
    LOADC, ENC: out std_logic
 );
end FSM;

architecture struct of FSM is
    signal Y2_i, Y1_i, Y0_i: std_logic;
    signal y2, y1, y0: std_logic;
    signal y2Bar, y1Bar, y0Bar: std_logic;
	 signal divided_clock: std_logic;
	 
	 COMPONENT clk_div
		port(
		clock_25Mhz				: IN	STD_LOGIC;
		clock_1Hz				: OUT	STD_LOGIC
		
		);
	 END COMPONENT;
	 
begin
	 	clock_div_inst:clk_div
		PORT MAP(
		clock_25Mhz	=> clk,	
		clock_1Hz => divided_clock	
		);
		
    -- update present state
    -- Y2_i <= (y2 and not(CEXP)) or (y1 and CEXP);
    -- Y1_i <= (y1 and not(CEXP)) or (y1Bar and y0 and SSCS and CEXP) or (y2Bar and y0Bar and CEXP);
    -- Y0_i <= (y2 xnor y1);

    Y2_i <= (y1 and not y0 and cexp) or (y2 and not cexp) or (y2 and y0);
    Y1_i <= (not y2 and y0 and sscs and cexp) or (not y2 and y1) or (y1 and not y0) or (y1 and not cexp);
    Y0_i <= (not y2 and not y1 and not cexp) or (y0 and cexp) or (y2 and y1 and not cexp);

    DFF2: entity work.dFF_2(rtl)
        port map(Y2_i, divided_clock, y2, y2Bar);
    DFF1: entity work.dFF_2(rtl)
        port map(Y1_i, divided_clock, y1, y1Bar);
    DFF0: entity work.dFF_2(rtl)
        port map(Y0_i, divided_clock, y0, y0Bar);
		  
    --DFF2: entity work.dFF_2(rtl)
        --port map(Y2_i, CLK, y2, y2Bar);
    --DFF1: entity work.dFF_2(rtl)
        --port map(Y1_i, CLK, y1, y1Bar);
    --DFF0: entity work.dFF_2(rtl)
        --port map(Y0_i, CLK, y0, y0Bar);

    -- update outputs
    -- MSTL:
    MSTL(2) <= y2;
    MSTL(1) <= (y2Bar and y1);
    MSTL(0) <= (y2Bar and y1Bar);
    -- SSTL:
    SSTL(2) <= y2Bar;
    SSTL(1) <= (y2 and y1Bar);
    SSTL(0) <= (y2 and y1);
    -- SELC:
    SELC(1) <= (y2Bar and y1Bar) or (y2 and y1);
    SELC(0) <= y1Bar;

    LOADC   <= (y2Bar and (y1 xnor y0)) or (y2 and (y1 xor y0));
    ENC     <= (y2Bar and (y1 xor y0)) or (y2 and (y1 xnor y0));
    
end ;