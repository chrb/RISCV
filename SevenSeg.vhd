library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SevenSeg is
	Port (	
				Set: in std_logic;
				V : in std_logic_vector(31 downto 0);
				
				Clk : in std_logic;
				nRst: in std_logic;
				
				
				Hex0 : out std_logic_vector(6 downto 0);   
				Hex1 : out std_logic_vector(6 downto 0);
				Hex2 : out std_logic_vector(6 downto 0);
				Hex3 : out std_logic_vector(6 downto 0));
				
end SevenSeg;

architecture RTL of SevenSeg is

signal State : std_logic_vector(31 downto 0);
begin

process(Clk, nRst)
begin
	-- Reset
	if nRst='0' then
		-- 64_dec = 0_segment
		Hex0 <= std_logic_vector(to_unsigned(64,7));
		Hex1 <= std_logic_vector(to_unsigned(64,7));
		Hex2 <= std_logic_vector(to_unsigned(64,7));
		Hex3 <= std_logic_vector(to_unsigned(64,7));
		State <= std_logic_vector(to_unsigned(0,32));
	-- Taktflanke
	elsif rising_edge(Clk) then

		
		if Set = '1' then
			State <= V;
		end if;
		
		Hex0 <= State(6 downto 0);
		Hex1 <= State(14 downto 8);
		Hex2 <= State(22 downto 16);
		Hex3 <= State(30 downto 24);
		
	end if;
end process;
	
end RTL;