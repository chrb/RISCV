library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fetch is
	Port (	
				--Input
				PCOld: in std_logic_vector(31 downto 0);
				StallI: in std_logic;
				JumpTarget: in std_logic_vector(31 downto 0);
				Jump: in std_logic;
				InterlockI: in std_logic;
				
				--Output
				PCNext: out std_logic_vector(31 downto 0);
				ImemAddr: out std_logic_vector(9 downto 0));
				
end Fetch;

architecture RTL of Fetch is

begin

process(PCOld, Jump, JumpTarget, InterlockI, StallI)
variable Inkrement: unsigned(31 downto 0);
begin
	
	if Jump = '1' then
		PCNext <= JumpTarget;
		ImemAddr <= JumpTarget(11 downto 2);
	else
		if StallI = '1' then
			PCNext <= PCOld;
			ImemAddr <= PCOld(11 downto 2);
		elsif InterlockI = '1' then
			PCNext <= PCOld;
			ImemAddr <= PCOld(11 downto 2);
		
		else 
			inkrement := unsigned(PCOld) + 4;
			PCNext <= std_logic_vector(inkrement);
			ImemAddr <= std_logic_vector(inkrement(11 downto 2));
		end if;
	end if;
end process;
	
end RTL;