library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FetchStage is
	Port (	
				-- Input
				PCI: in std_logic_vector(31 downto 0);
				StallI: in std_logic;
				Clk: in std_logic;
				nRst: in std_logic;
				
				-- Output
				PCO: out std_logic_vector(31 downto 0);
				StallO: out std_logic
				);
end FetchStage;

architecture RTL of FetchStage is

begin

process(Clk, nRst, StallI)
begin
	StallO <= StallI;
	-- Reset
	if nRst='0' then
		PCO <= std_logic_vector(to_signed(-4,32));
		StallO <= '0';
	-- Taktflanke
	elsif rising_edge(Clk) then
		
		if StallI = '1' then
		else
			PCO <= PCI;
		end if;
	end if;
end process;
	
end RTL;