library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Forward is
	Port (	
				-- Input
				
				SrcRegNo1: in std_logic_vector(4 downto 0);
				SrcRegNo2: in std_logic_vector(4 downto 0);
				SrcData1: in std_logic_vector(31 downto 0);
				SrcData2: in std_logic_vector(31 downto 0);
				-- Execute Stage
				ExDestWrEn: in std_logic;
				ExDestRegNo: in std_logic_vector(4 downto 0);
				ExDestData: in std_logic_vector(31 downto 0);
				-- MemStage
				MemDestWrEn: in std_logic;
				MemDestRegNo: in std_logic_vector(4 downto 0);
				MemDestData: in std_logic_vector(31 downto 0);
				
				-- Output
				FwdData1: out std_logic_vector(31 downto 0);
				FwdData2: out std_logic_vector(31 downto 0));
end Forward;

architecture RTL of Forward is

begin

process(SrcRegNo1, SrcRegNo2, ExDestRegNo, ExDestWrEn, ExDestData, SrcData1, SrcData2, MemDestRegNo, MemDestWrEn, MemDestData)
begin
	-- SrcRegNo1
	
	if ExDestWrEn = '1' and SrcRegNo1 = ExDestRegNo then
		FwdData1 <= ExDestData;
	elsif MemDestWrEn = '1' and SrcRegNo1 = MemDestRegNo then
		FwdData1 <= MemDestData;
	else
		FwdData1 <= SrcData1;
	end if;

	-- SrcRegNo2
	
	if ExDestWrEn = '1' and SrcRegNo2 = ExDestRegNo then
		FwdData2 <= ExDestData;
	elsif MemDestWrEn = '1' and SrcRegNo2 = MemDestRegNo then
		FwdData2 <= MemDestData;
	else
		FwdData2 <= SrcData2;
	end if;

end process;
	
end RTL;