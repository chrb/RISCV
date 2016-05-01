library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PipelineControl is
	Port ( 
			 
			 Clk : in std_logic;
			 nRst : in std_logic;
			 StallI : in std_logic;
			 
			 -- Output

			 StallO : out std_logic);
end PipelineControl;

architecture RTL of PipelineControl is

begin

process(Clk, nRst)
	variable Inkrement: integer := 0;
	begin 
		-- Reset
		if nRst='0' then
			StallO <= '0';
		elsif rising_edge(Clk) then
			StallO <= '0';
			if StallI = '1' then
				if Inkrement = 9 then
					StallO <= '0';
					Inkrement := 0;
				else
					Inkrement := Inkrement + 1;
					StallO <= '1';
				end if;
			end if;
			
		end if;
	end process;

end RTL;