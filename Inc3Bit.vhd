library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Inc3Bit is
	Port ( Clk: in std_logic;
			 nRst: in std_logic;
			A : out std_logic_vector(9 downto 0));
end Inc3Bit;

architecture RTL of Inc3Bit is

begin

sum: process(Clk, nRst)
variable Summe: unsigned(9 downto 0);
begin
	if nRst='0' then
		A <= "0000000000"; 
		Summe := "0000000000";
	elsif rising_edge(Clk) then
		Summe := Summe + "1";
		A <= std_logic_vector(Summe);
	end if;
end process;
	
	
	
end RTL;