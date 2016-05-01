library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SDRAMInterface is
	Port ( 	

			-- connect with user logic
			logic_writedata : in std_logic_vector(31 downto 0);
			logic_address : in std_logic_vector(9 downto 0);
			logic_byteenable : in std_logic_vector(3 downto 0);
			logic_write : in std_logic;
			logic_read : in std_logic;
			logic_StallI: in std_logic;
			
			logic_readdata : out std_logic_vector(31 downto 0);
			logic_StallO : out std_logic;
			
			-- master slot - connect with system Interconnect Fabric (Avalon Bus)
			m_writedata: out std_logic_vector(31 downto 0);
			m_address : out std_logic_vector(20 downto 0);
			m_byteenable : out std_logic_vector(3 downto 0);
			m_write : out std_logic;
			m_read : out std_logic;
		
			m_readdata: in std_logic_vector(31 downto 0);
			m_readdatavalid : in std_logic;
			m_waitrequest : in std_logic;
			
			-- Clock + Reset
			Clk : in std_logic;
			nRst : in std_logic
			
			
			);
end SDRAMInterface;

architecture RTL of SDRAMInterface is

begin
	process (Clk, nRst)
	begin
		if nRst = '0' then
			m_writedata <= "00000000000000000000000000000000";
			m_address <= "000000000000000000000";
			m_byteenable <= "0000";
			m_write <= '0';
			m_read <= '0';
		elsif rising_edge(Clk) then
			if m_readdatavalid = '1' then
				logic_readdata <= m_readdata;
			end if;
			
			if logic_write = '1' then
				m_writedata <= logic_writedata;
				--m_address <= logic_address;
				m_address <= std_logic_vector(resize(unsigned(logic_address),21));
				m_byteenable <= logic_byteenable;
				m_write <= '1';
				m_read <= '0';
			elsif logic_read = '1' then
				--m_address <= logic_address;
				m_address <= std_logic_vector(resize(unsigned(logic_address),21));
				m_byteenable <= logic_byteenable;
				m_write <= '0';
				m_read <= '1';
			end if;
			
			if m_waitrequest = '0' then
				logic_StallO <= '0';
			else
				logic_StallO <= logic_StallI;
			end if;
		end if;
	end process;
end RTL;