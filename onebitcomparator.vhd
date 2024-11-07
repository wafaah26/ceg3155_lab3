LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY oneBitComparator IS
	PORT(
		i_GTPrevious, i_LTPrevious	: IN	STD_LOGIC;
		i_Ai, i_Bi			: IN	STD_LOGIC;
		o_GT, o_LT			: OUT	STD_LOGIC);
END oneBitComparator;

ARCHITECTURE rtl OF oneBitComparator IS
	SIGNAL int_GT1, int_GT2, int_LT1, int_LT2 : STD_LOGIC;
	SIGNAL int_GT, int_LT : STD_LOGIC;

BEGIN

	-- Concurrent Signal Assignment
	int_GT1 <= not(i_GTPrevious) and not(i_LTPrevious) and i_Ai and not(i_Bi);
	int_GT2 <= i_GTPrevious and not(i_LTPrevious);
	int_GT <= int_GT1 or int_GT2;
	int_LT1 <= not(i_GTPrevious) and not(i_LTPrevious) and not(i_Ai) and i_Bi;
	int_LT2 <= not(i_GTPrevious) and i_LTPrevious;
	int_LT <= int_LT1 or int_LT2;

	-- Output Driver
	o_GT <= int_GT;
	o_LT <= int_LT;

END rtl;
