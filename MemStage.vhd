library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemStage is
	Port ( 	
				-- Input
				FunctI: in std_logic_vector(2 downto 0);
				MemAddrLowI: in std_logic_vector(1 downto 0);
				DestWrDataI: in std_logic_vector(31 downto 0);
				DestWrEnI: in std_logic;
				MemAccessI: in std_logic;
				DestRegNoI: in std_logic_vector(4 downto 0);
				
				Clk: in std_logic;
				nRst: in std_logic;
				
				-- Output
				DestWrEnO: out std_logic;
				DestRegNoO: out std_logic_vector(4 downto 0);
				DestWrDataO: out std_logic_vector(31 downto 0);
				MemAccessO: out std_logic;
				FunctO: out std_logic_vector(2 downto 0);
				MemAddrLowO: out std_logic_vector(1 downto 0));
end MemStage;

architecture RTL of MemStage is

begin
	process (Clk, nRst)
	begin
		-- Reset
		if nRst='0' then
			DestWrEnO <= '0';
			DestRegNoO <= std_logic_vector(to_unsigned(0,5));
			DestWrDataO <= std_logic_vector(to_unsigned(0,32));
			MemAccessO <= '0';
			FunctO <= std_logic_vector(to_unsigned(0,3));
			MemAddrLowO <= std_logic_vector(to_unsigned(0,2));
		-- Taktflanke
		elsif rising_edge(Clk) then
			DestWrEnO <= DestWrEnI;
			DestRegNoO <= DestRegNoI;
			DestWrDataO <= DestWrDataI;
			MemAccessO <= MemAccessI;
			FunctO <= FunctI;
			MemAddrLowO <= MemAddrLowI;
		end if;
	end process;
end RTL;