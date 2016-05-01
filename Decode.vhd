library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Konstanten
use work.constants.all;


--|31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|09|08|07|06|05|04|03|02|01|00|
--|        funct7      |      rs2     |      rs1     | funct3 |      rd      |       opcode       |	R-Type
--|             imm[11:0]             |      rs1     | funct3 |      rd      |       opcode       |	I-Type
--|    imm[11:5]       |      rs2     |      rs1     | funct3 |   imm[4:0]   |       opcode       |   S-Type
--|             imm[31:12]                                    |      rd      |       opcode       |   U-Type (LUI, AUIPC)
--|     imm[12|10:5]   |      rs2     |      rs1     | funct3 |  imm[4:1|11] |       opcode       |   SB-Type
--|        H"788"                     |      rs      | 0  0  1| 0  0  0  0  0|       opcode       |   SevenSeg (Opcode=1110011 [opcode_SYSTEM])

entity Decode is
	Port ( 	Insn : in std_logic_vector(31 downto 0); -- 32-Bit Befehlswort
				PCNextI: in std_logic_vector(31 downto 0);
				ClearI: in std_logic;
				InterlockI: in std_logic;
				StallI: in std_logic;
				
				Funct : out std_logic_vector(2 downto 0); --funct3
				SrcRegNo1 : out std_logic_vector(4 downto 0); -- rs1
				SrcRegNo2 : out std_logic_vector(4 downto 0); -- rs2
				PCNextO: out std_logic_vector(31 downto 0);
				
				Imm : out std_logic_vector(31 downto 0); -- imm[11:0] (I-Type)
				SelSrc2 : out std_logic; -- Bit 5 des Befehlswortes
				Aux : out std_logic; -- Bit 30 des Befehlswortes
				
				Jump : out std_logic;
				JumpRel : out std_logic;
				JumpTarget : out std_logic_vector(31 downto 0);
				MemAccess : out std_logic;
				MemWrEn : out std_logic;
				MemRdEn : out std_logic;
				DestWrEn: out std_logic; -- 1 wenn Opcode = "opcode_regreg" oder "opcode_regimm"
				DestRegNo : out std_logic_vector(4 downto 0); -- rd
				SetSevenSegO: out std_logic;
				InterlockO: out std_logic;
				StallO: out std_logic
				);
end Decode;

architecture RTL of Decode is

  constant const_SevenSegValue : unsigned(11 downto 0) := x"788";

begin

process (Insn, PCNextI, ClearI, InterlockI, StallI)
variable Opcode : std_logic_vector(6 downto 0);
begin
	-- initial
	PcNextO <= PCNextI;
	Imm <= std_logic_vector(to_unsigned(0,32));
	Aux <= '0';
	Jump <= '0';
	JumpRel <= '0';
	JumpTarget <= std_logic_vector(to_unsigned(0,32));
	MemAccess <= '0';
	MemWrEn <= '0';
	MemRdEn <= '0';
	DestWrEn <= '0';
	SetSevenSegO <= '0';
	InterlockO <= '0';
	StallO <= StallI;
	

	-- set
	Opcode := Insn(6 downto 0);
	Funct <= Insn(14 downto 12);
	SrcRegNo1 <= Insn(19 downto 15);
	SrcRegNo2 <= Insn(24 downto 20);
	DestRegNo <= Insn(11 downto 7);
	SelSrc2 <= Insn(5);
	
	if StallI = '1' then
		Jump <= '0';
		JumpRel <= '0';
		StallO <= StallI;
	elsif (ClearI = '1' or InterlockI = '1') then
		MemAccess <= '0';
		DestWrEn <= '0';
		Jump <= '0';
		JumpRel <= '0';
		InterlockO <= '0';
	else
		case Opcode is
			-- Register-Register
			when opcode_regreg => 
				DestWrEn <= '1';
				Aux <= Insn(30);
			-- Immmediate
			when opcode_regimm =>
				if Insn(14 downto 12) = funct_SRL and Insn(30) = '1' then
					Aux <= '1';
				else
					Aux <= '0';
				end if;
				DestWrEn <= '1';
				Imm <= std_logic_vector(resize(signed(Insn(31 downto 20)), 32));
			-- LUI load upper immmediate
			when opcode_LUI =>
				Imm <= Insn(31 downto 12) & "000000000000";
				DestRegNo <= insn(11 downto 7);
				Funct <= funct_OR;
				SrcRegNo1 <= std_logic_vector(to_unsigned(0,5));
				SelSrc2 <= '0';
				DestWrEn <= '1';
				
			-- AUIPC add upper immmediate to pc
			when opcode_AUIPC =>
				DestWrEn <= '1';
				Imm <= std_logic_vector(signed(PCNextI) + signed(Insn(31 downto 12) & "000000000000") + to_signed(-4,32));
				SelSrc2 <= '0';
				Funct <= funct_OR;
			-- JAL (Relativer Sprung)
			when opcode_JAL =>
				DestWrEn <= '1';
				Jump <= '1';
				JumpRel <= '1';
				JumpTarget <= std_logic_vector(signed(PCNextI) + to_signed(-4,32) + 
				signed(Insn(31) & Insn(19 downto 12) & Insn(20) & Insn(30 downto 21) & "0"));
				--PCNextO <= PCNextI;
				
			-- JALR (Indirekter Sprung)
			when opcode_JALR =>
				DestWrEn <= '1';
				Jump <= '1';
				JumpRel <= '0';
				SelSrc2 <= '0';
				Imm <= std_logic_vector(resize(signed(Insn(31 downto 20)), 32));
				
			-- BRANCH (Bedingte Spruenge)
			when opcode_BRANCH =>
				Jump <= '0'; -- 0
				JumpRel <= '1'; -- 1
				JumpTarget <= std_logic_vector(signed(PCNextI) + to_signed(-4,32) +
				signed(Insn(31) & Insn(7) & Insn(30 downto 25) & Insn(11 downto 8) &"0"));
				DestWrEn <= '0';
				
			-- load (Lesezugriff)
			when opcode_load =>
				MemAccess <= '1';
				DestWrEn <= '1';
				Imm <= std_logic_vector(resize(signed(Insn(31 downto 20)), 32));
				InterlockO <= '1';
				StallO <= '1';
				MemRdEn <= '1';
				
			-- store (Schreibzugriff)
			when opcode_store =>
				MemAccess <= '1';
				MemWrEn <= '1';
				DestWrEn <= '0';
				SelSrc2 <= '0';
				Imm <= std_logic_vector(resize(signed(Insn(31 downto 25) & Insn(11 downto 7)),32));
				StallO <= '1';
			
			-- Siebensegmentanzeige
			when opcode_SYSTEM =>
				Funct <= "001";
				DestWrEn <= '0';
				SetSevenSegO <= '1';
				DestRegNo <= std_logic_vector(to_unsigned(0,5));
				SrcRegNo2 <= std_logic_vector(to_unsigned(0,5));
				Imm <= std_logic_vector(resize(signed(const_SevenSegValue),32));
			
			-- Others
			when others =>
				Funct <= std_logic_vector(to_unsigned(0,3));
				SrcRegNo1 <= std_logic_vector(to_unsigned(0,5));
				SrcRegNo2 <= std_logic_vector(to_unsigned(0,5));
				DestRegNo <= std_logic_vector(to_unsigned(0,5));
				SelSrc2 <= '0';
				Imm <= std_logic_vector(to_unsigned(0,32));
				Aux <= '0';
				Jump <= '0';
				JumpRel <= '0';
				JumpTarget <= std_logic_vector(to_unsigned(0,32));
				MemAccess <= '0';
				MemWrEn <= '0';
				MemRdEn <= '0';
				DestWrEn <= '0';
				SetSevenSegO <= '0';
				InterlockO <= '0';
				StallO <= '0';
		end case;
	end if;
	
	
	-- Register x0 == 0
	if Insn(11 downto 7) = std_logic_vector(to_unsigned(0,5)) then
		DestWrEn <= '0';
	end if;
end process;

end RTL;