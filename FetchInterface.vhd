library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FetchInterface is
	Port ( 	
			logic_address : in std_logic_vector(9 downto 0);
			logic_readdata: out std_logic_vector(31 downto 0);
			logic_waitrequest : out std_logic;
			
			-- master
			m_address : out std_logic_vector(9 downto 0);
			m_byteenable : out std_logic_vector(3 downto 0);
			m_read : out std_logic;
			
			m_readdata : in std_logic_vector(31 downto 0);
			m_waitrequest : in std_logic;
			
			-- Clock + Reset
			Clk : in std_logic;
			nRst : in std_logic;
			StallI : in std_logic
			
			
			);
end FetchInterface;

architecture RTL of FetchInterface is

signal logic_read : std_logic := '1';
signal logic_byteenable : std_logic_vector(3 downto 0) := "1111";

begin
	process (Clk, nRst)
	begin
		if nRst = '0' then
			m_address <= "0000000000";
			m_byteenable <= "0000";
			m_read <= '0';
		elsif rising_edge(Clk) then
			if StallI = '1' then
				-- nop
			else 
				m_address <= logic_address;
				m_byteenable <= logic_byteenable;
				m_read <= logic_read;
				-- Wait
				if m_waitrequest = '0' then
					logic_waitrequest <= '0';
				else
					logic_waitrequest <= '1';
				end if;
			end if;
		end if;
	end process;
	
	process (m_readdata)
		begin
		logic_readdata <= m_readdata;
	end process;
end RTL;