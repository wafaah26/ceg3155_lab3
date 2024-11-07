library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_4b is
 Port (
    counter, max: in std_logic_vector(3 downto 0);
    GTE : out std_logic
 );
end comparator_4b;

architecture struct of comparator_4b is
signal compare0: std_logic_vector(1 downto 0);
signal compare1: std_logic_vector(1 downto 0);
signal compare2: std_logic_vector(1 downto 0);
signal compare3: std_logic_vector(1 downto 0);
signal GT: std_logic;
signal LT: std_logic;
signal EQ: std_logic;
begin
compare3 <= "00";

CP3: entity work.oneBitComparator(rtl)
    port map(compare3(0),compare3(1),counter(3),max(3),compare2(0),compare2(1));
CP2: entity work.oneBitComparator(rtl)
    port map(compare2(0),compare2(1),counter(2),max(2),compare1(0),compare1(1));
CP1: entity work.oneBitComparator(rtl)
    port map(compare1(0),compare1(1),counter(1),max(1),compare0(0),compare0(1));
CP0: entity work.oneBitComparator(rtl)
    port map(compare0(0),compare0(1),counter(0),max(0),GT,LT);

EQ <= GT nor LT;   
 
GTE <= GT or EQ;

end ;