library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux32Bit is
	Port ( 	
				-- Input
				A : in std_logic_vector(31 downto 0);
				B : in std_logic_vector(31 downto 0);
				S : in std_logic;
				-- Output
				O : out std_logic_vector(31 downto 0));
end Mux32Bit;

architecture RTL of Mux32Bit is

begin
	process (A, B, S)
	begin
		if S='1' then
			-- reg
			O <= A;
		else
			-- imm
			O <= B;
		end if;
	end process;
end RTL;