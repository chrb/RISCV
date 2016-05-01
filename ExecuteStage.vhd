library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ExecuteStage is
	Port (	
				FunctI: in std_logic_vector(2 downto 0);
				SrcData1I: in std_logic_vector(31 downto 0);
				SrcData2I: in std_logic_vector(31 downto 0);
				PCNextI: in std_logic_vector(31 downto 0);
				ImmI: in std_logic_vector(31 downto 0);
				SelSrc2I: in std_logic;
				AuxI: in std_logic;
				JumpI: in std_logic;
				JumpRelI: in std_logic;
				JumpTargetI: in std_logic_vector(31 downto 0);
				MemAccessI: in std_logic;
				MemWrEnI: in std_logic;
				MemRdEnI: in std_logic;
				DestWrEnI: in std_logic;
				DestRegNoI: in std_logic_vector(4 downto 0);
				SetSevenSegI: in std_logic;
				
				ClearI: in std_logic;
				Clk: in std_logic;
				nRst: in std_logic;
				
				FunctO: out std_logic_vector(2 downto 0);
				SrcData1O: out std_logic_vector(31 downto 0);
				SrcData2O: out std_logic_vector(31 downto 0);
				PCNextO: out std_logic_vector(31 downto 0);
				ImmO: out std_logic_vector(31 downto 0);
				SelSrc2O: out std_logic;
				AuxO: out std_logic;
				JumpO: out std_logic;
				JumpRelO: out std_logic;
				JumpTargetO: out std_logic_vector(31 downto 0);
				MemAccessO: out std_logic;
				MemWrEnO: out std_logic;
				MemRdEnO: out std_logic;
				DestWrEnO: out std_logic;
				ClearO: out std_logic;
				DestRegNoO: out std_logic_vector(4 downto 0);
				SetSevenSegO: out std_logic);
end ExecuteStage;

architecture RTL of ExecuteStage is

begin

process(Clk, nRst)
begin
	-- Reset
	if nRst='0' then
		FunctO <= std_logic_vector(to_unsigned(0,3));
		SrcData1O <= std_logic_vector(to_unsigned(0,32));
		SrcData2O <= std_logic_vector(to_unsigned(0,32));
		PCNextO <= std_logic_vector(to_unsigned(0,32));
		ImmO <= std_logic_vector(to_unsigned(0,32));
		SelSrc2O <= '0';
		AuxO <= '0';
		JumpO <= '0';
		JumpRelO <= '0';
		JumpTargetO <= std_logic_vector(to_unsigned(0,32));
		MemAccessO <= '0';
		MemWrEnO <= '0';
		MemRdEnO <= '0';
		DestWrEnO <= '0';
		DestRegNoO <= std_logic_vector(to_unsigned(0,5));
		ClearO <= '0';
		SetSevenSegO <= '0';
	-- Taktflanke
	elsif rising_edge(Clk) then
			FunctO <= FunctI;
			SrcData1O <= srcData1I;
			srcData2O <= srcData2I;
			PCNextO <= PCNextI;
			ImmO <= ImmI;
			SelSrc2O <= SelSrc2I;
			AuxO <= AuxI;
			JumpO <= JumpI;
			JumpRelO <= JumpRelI;
			JumpTargetO <= JumpTargetI;
			MemAccessO <= MemAccessI;
			MemWrEnO <= MemWrEnI;
			MemRdEnO <= MemRdEnI;
			DestWrEnO <= DestWrEnI;
			DestRegNoO <= DestRegNoI;
			ClearO <= ClearI;
			SetSevenSegO <= SetSevenSegI;
	end if;
end process;
	
end RTL;