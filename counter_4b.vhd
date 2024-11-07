library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_4b is
 Port (
    CLK: in std_logic;
    LOADC, ENC: in std_logic;
    count: out std_logic_vector(3 downto 0)
 );
end counter_4b;

architecture struct of counter_4b is
    signal Y3_i, Y2_i, Y1_i, Y0_i: std_logic; --Present state
    signal y3, y2, y1, y0: std_logic; -- Next state
    signal y3Bar, y2Bar, y1Bar, y0Bar: std_logic;
	 SIGNAL divided_clock: std_logic;
	 
	 COMPONENT clk_div
	 port(
		clock_25Mhz				: IN	STD_LOGIC;
		clock_1Hz				: OUT	STD_LOGIC
		
		);
	END COMPONENT;
begin

    clock_div_inst:clk_div
		PORT MAP(
		clock_25Mhz	=> CLK,	
		clock_1Hz => divided_clock	
	   );
		
    Y3_i <= (y3 or (y2 and y1 and y0)) and (not(LOADC) and ENC);
    Y2_i <= ((y2 and y1Bar) or (y2 and y0Bar) or (y3 and y2) or (y2Bar and y1 and y0)) and (not(LOADC) and ENC);
    Y1_i <= ((y1Bar and y0) or (y1 and y0Bar) or (y3 and y2 and y0)) and (not(LOADC) and ENC);
    Y0_i <= (y0Bar or (y3 and y2 and y1)) and (not(LOADC) and ENC);
    
    DFF3: entity work.dFF_2(rtl)
        port map(Y3_i, divided_clock, y3, y3Bar);
    DFF2: entity work.dFF_2(rtl)
        port map(Y2_i, divided_clock, y2, y2Bar);
    DFF1: entity work.dFF_2(rtl)
        port map(Y1_i, divided_clock, y1, y1Bar);
    DFF0: entity work.dFF_2(rtl)
        port map(Y0_i, divided_clock, y0, y0Bar);
		  
	 --DFF3: entity work.dFF_2(rtl)
        --port map(Y3_i, CLK, y3, y3Bar);
    --DFF2: entity work.dFF_2(rtl)
        --port map(Y2_i, CLK, y2, y2Bar);
    --DFF1: entity work.dFF_2(rtl)
        --port map(Y1_i, CLK, y1, y1Bar);
    --DFF0: entity work.dFF_2(rtl)
        --port map(Y0_i, CLK, y0, y0Bar);
    
        
    count(3) <= y3;
    count(2) <= y2;
    count(1) <= y1;
    count(0) <= y0;

end ;
