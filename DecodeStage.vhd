library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DecodeStage is
	Port (	
				
				PCNextI: in std_logic_vector(31 downto 0);
				InsnI: in std_logic_vector(31 downto 0);
				ClearI: in std_logic;
				InterlockI: in std_logic;
				StallI: in std_logic;
				Clk: in std_logic;
				nRst: in std_logic;
	
				InsnO: out std_logic_vector(31 downto 0);
				PCNextO: out std_logic_vector(31 downto 0);
				ClearO: out std_logic;
				InterlockO: out std_logic;
				StallO: out std_logic);
end DecodeStage;

architecture RTL of DecodeStage is

begin

process(Clk, nRst, StallI)
begin
	StallO <= StallI;
	-- Reset
	if nRst='0' then
		InsnO <= std_logic_vector(to_unsigned(0,32));
		PCNextO <= std_logic_vector(to_unsigned(0,32));
		ClearO <= '0';
		InterlockO <= '0';
		StallO <= '0';
	-- Taktflanke
	elsif rising_edge(Clk) then
		if StallI = '1' then
		else
			InsnO <= InsnI;
			PCNextO <= PCNextI;
			ClearO <= ClearI;
			InterlockO <= InterlockI;
		end if;
	end if;
end process;
	
end RTL;