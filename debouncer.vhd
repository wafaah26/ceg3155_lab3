
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY debouncer IS
	PORT(
		i_raw			: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_clean			: OUT	STD_LOGIC);
END debouncer;

ARCHITECTURE fsm OF debouncer IS
	SIGNAL int_currentState, int_nextState : std_logic_vector (1 downto 0);
	SIGNAL divided_clock: std_logic;
	
	COMPONENT clk_div
		port(
		clock_25Mhz				: IN	STD_LOGIC;
		clock_1Hz				: OUT	STD_LOGIC
		
		);
	END COMPONENT;

BEGIN

	clock_div_inst:clk_div
		PORT MAP(
		clock_25Mhz	=> i_clock,	
		clock_1Hz => divided_clock	
		);

	-- Combinational logic for next state
	int_nextState <= "00" when i_raw = '0' else
					 "01" when int_currentState = "00" else
					 "10";

	-- Sequential logic
	process(divided_clock) begin
		if rising_edge(divided_clock) then
			int_currentState <= int_nextState;
		end if;
	end process;

	--  Concurrent Signal Assignment
	o_clean <= '1' when int_currentState = "10" else 
			   '0';

END fsm;
