library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegSet is
	Port ( RdRegNo1 : in std_logic_vector(4 downto 0); -- Register Nr. 1 lesen
			 RdRegNo2 : in std_logic_vector(4 downto 0);	 -- Register Nr. 2 lesen
			 
			 WrEn : in std_logic;
			 WrRegNo : in std_logic_vector(4 downto 0); -- Welches Register schreiben?
			 WrData : in std_logic_vector(31 downto 0); -- Dateneingang
			 
			 Clk : in std_logic;
			 nRst : in std_logic;
			 
			 -- Output
			 RdData1 : out std_logic_vector(31 downto 0); -- Leseausgang
			 RdData2 : out std_logic_vector(31 downto 0)); -- Leseausgang)
end RegSet;

architecture RTL of RegSet is

TYPE TRegisters IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Registers: TRegisters;

begin
	
	-- Reading
	RdData1 <= Registers(to_integer(unsigned(RdRegNo1)));
	RdData2 <= Registers(to_integer(unsigned(RdRegNo2)));

	-- Writing
	writing: process(Clk, nRst)
	begin 
		-- Reset
		
		if nRst='0' then
			for Var in 0 to 31
				loop
					Registers(Var) <= std_logic_vector(to_unsigned(0,32));
				end loop;
				Registers(1) <= std_logic_vector(to_unsigned(1,32));
		-- Writing
		elsif rising_edge(Clk) then
			if WrEn='1' then
				Registers(to_integer(unsigned(WrRegNo))) <= WrData;
			end if;

		end if;
	end process;

end RTL;