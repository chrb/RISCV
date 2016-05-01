library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity ALU is
	Port ( -- Input
			 FunctI : in std_logic_vector(2 downto 0);
			 A : in std_logic_vector(31 downto 0);
			 B : in std_logic_vector(31 downto 0);
			 PCNextI: in std_logic_vector(31 downto 0);
			 Aux : in std_logic;
			 JumpI : in std_logic;
			 JumpRel : in std_logic;
			 JumpTargetI : in std_logic_vector(31 downto 0);
			 MemAccessI : in std_logic;
			 MemWrEnI : in std_logic;
			 MemRdEnI : in std_logic;
			 DestWrEnI: in std_logic;
			 ClearI : in std_logic;
			 MemWrDataI : in std_logic_vector(31 downto 0);
			 DestRegNoI : in std_logic_vector(4 downto 0);
			 
			 -- Output
			 FunctO : out std_logic_vector(2 downto 0);
			 MemAddrLow : out std_logic_vector(1 downto 0);
			 X : out std_logic_vector(31 downto 0);
			 DestWrEnO: out std_logic;
			 MemAccessO : out std_logic;
			 DestRegNoO : out std_logic_vector(4 downto 0);
			 MemWrDataO : out std_logic_vector(31 downto 0);
			 MemAddr: out std_logic_vector(9 downto 0);
			 MemByteEna : out std_logic_vector(3 downto 0);
			 MemWrEnO: out std_logic;
			 MemRdEnO: out std_logic;
			 JumpTargetO : out std_logic_vector(31 downto 0);
			 JumpO : out std_logic);
			 
end ALU;

architecture RTL of ALU is

begin

process(FunctI, A, B, Aux, JumpTargetI, JumpI, JumpRel, MemAccessI, PCNextI, ClearI, DestWrEnI, MemWrDataI, DestRegNoI, MemWrEnI, MemRdEnI)

variable Result : std_logic_vector(31 downto 0);
variable Cond : std_logic;

variable tmpMemAddr : std_logic_vector(31 downto 0);
variable tmpMemByteEna : std_logic_vector(1 downto 0);

variable saveMemWrDataO : std_logic_vector(31 downto 0);
variable saveMemByteEna : std_logic_vector(3 downto 0);
variable saveMemAddr : std_logic_vector(9 downto 0);

begin

	--X <= std_logic_vector(to_unsigned(0,32));
	FunctO <= FunctI;
	DestRegNoO <= DestRegNoI;
	JumpTargetO <= std_logic_vector(to_unsigned(0,32));
	JumpO <= JumpI;
	MemAccessO <= MemAccessI;
	MemByteEna <= std_logic_vector(to_unsigned(0,4));
	MemWrEnO <= MemWrEnI;
	MemRdEnO <= MemRdEnI;
	DestWrEnO <= DestWrEnI;
	MemByteEna <= "0000";
	MemAddr <= std_logic_vector(to_unsigned(0,10));
	MemWrDataO <= std_logic_vector(to_unsigned(0,32));
	Cond := '0';
	Result := std_logic_vector(to_unsigned(0,32));
	X <= std_logic_vector(to_unsigned(0,32));
	MemWrDataO <= std_logic_vector(to_unsigned(0,32));
	tmpMemAddr := std_logic_vector(to_unsigned(0,32));
	tmpMemByteEna := std_logic_vector(to_unsigned(0,2));
	MemAddrLow <= std_logic_vector(to_unsigned(0,2));
	
	-- Speicherzugriffe
	if MemAccessI = '1' then
		tmpMemAddr := std_logic_vector(unsigned(A) + unsigned(B));
		saveMemAddr := tmpMemAddr(11 downto 2);
		MemAddr <= saveMemAddr;
		tmpMemByteEna := tmpMemAddr(1 downto 0);
		MemAddrLow <= tmpMemByteEna;
		
		case FunctI is
			-- SB (8 Bit)
			when funct_SB =>
				saveMemWrDataO := std_logic_vector(signed(MemWrDataI(7 downto 0) & MemWrDataI(7 downto 0) & MemWrDataI(7 downto 0) & MemWrDataI(7 downto 0)));
				case tmpMemByteEna is
					when "00" => saveMemByteEna := "0001";
					when "01" => saveMemByteEna := "0010";
					when "10" => saveMemByteEna := "0100";
					when "11" => saveMemByteEna := "1000";
					when others => saveMemByteEna := "0000";
				end case;
			-- SH (16 Bit)
			when funct_SH =>
				saveMemWrDataO := std_logic_vector(signed(MemWrDataI(15 downto 0) & MemWrDataI(15 downto 0)));
				case tmpMemByteEna is
					when "00" => saveMemByteEna := "0011";
					when "01" => saveMemByteEna := "0011";
					when "10" => saveMemByteEna := "1100";
					when "11" => saveMemByteEna := "1100";
					when others => saveMemByteEna := "0000";
				end case;
			-- SW (32 Bit) normal
			when funct_SW =>
				saveMemWrDataO := MemWrDataI;
				saveMemByteEna := "1111";
			when others =>
				saveMemWrDataO := std_logic_vector(to_unsigned(0,32));
				saveMemByteEna := std_logic_vector(to_unsigned(0,4));
		end case;
		MemWrDataO <= saveMemWrDataO;
		MemByteEna <= saveMemByteEna;
	end if;
	

	
	-- Jumps
	if ClearI = '1' then
		DestWrEnO <= '0';
		JumpO <= '0';
		MemAccessO <= '0';
	else
		-- Bedingter Sprung
		if JumpI = '0' and JumpRel = '1' then
		
			case FunctI is
				-- BEQ Branch Equal (Rs == Rt)
				when funct_BEQ =>
					if A = B then
						Cond := '1';
					else
						Cond := '0';
					end if;
				-- BNE Branch Not Equal (Rs != Rt)
				when funct_BNE =>
					if A /= B then
						Cond := '1';
					else
						Cond := '0';
					end if;
				-- BLT Branch Lower Then (vorzeichenbehaftet) (Rs < Rt)
				when funct_BLT =>
					if signed(A) < signed(B) then
						Cond := '1';
					else
						Cond := '0';
					end if;
				-- BGE Branch Bigger Then (vorzeichenbehaftet) (Rs => Rt)
				when funct_BGE =>
					if signed(A) >= signed(B) then
						Cond := '1';
					else
						Cond := '0';
					end if;
				-- BLTU Branch Lower Than Unsigned (Rs < Rt)
				when funct_BLTU =>
					if unsigned(A) < unsigned(B) then
						Cond := '1';
					else
						Cond := '0';
					end if;
				-- BGEU Branch Bigger Then Unsigned (Rs => Rt)
				when funct_BGEU =>
					if unsigned(A) >= unsigned(B) then
						Cond := '1';
					else
						Cond := '0';
					end if;
				when others =>
					Cond := '0';
					X <= std_logic_vector(to_unsigned(0,32));
					JumpTargetO <= std_logic_vector(to_unsigned(0,32));
					JumpO <= '0';
					MemAccessO <= '0';
					MemWrDataO <= std_logic_vector(to_unsigned(0,32));
					MemByteEna <= std_logic_vector(to_unsigned(0,4));
			end case;
		-- Berechnung
		else
			case FunctI is
				-- Addieren
				when funct_ADD => 
					if Aux = '1' then
						Result := std_logic_vector(unsigned(A) - unsigned(B));
					else
						Result := std_logic_vector(unsigned(A) + unsigned(B));
					end if;
				-- Shift Left Logical
				when funct_SLL => 
					Result := std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
				when funct_SLT =>
					if (signed(A) < signed(B)) then
						Result := std_logic_vector(to_unsigned(1,32));
					else
						Result := std_logic_vector(to_unsigned(0,32));
					end if;
				when funct_SLTU =>
					if (unsigned(A) < unsigned(B)) then
						Result := std_logic_vector(to_unsigned(1,32));
					else
						Result := std_logic_vector(to_unsigned(0,32));
					end if;
				-- XOR
				when funct_XOR => 
					Result := A xor B;
				-- Shift Right Logical
				when funct_SRL => 
					if Aux = '1' then
						-- Arithmetischer Shift
						Result := std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
					else
						-- logischer Shift
						Result := std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
					end if;
				-- OR
				when funct_OR => 
					Result := A or B;
				-- AND
				when funct_AND => 
					Result := A and B;
				when others =>
					Result := std_logic_vector(to_unsigned(0,32));
			end case;
		end if;
		
		if JumpI = '0' then
			X <= Result;
			-- Bedingter Sprung
			if JumpRel ='1' then
				JumpO <= Cond;
				JumpTargetO <= JumpTargetI;
			end if;
		else
			X <= PCNextI;
			if JumpRel = '1' then
				-- JAL (PC-realtive Zieladresse)
				JumpTargetO <= JumpTargetI;
			else
				-- JALR
				JumpTargetO <= Result;
			end if;
		end if;
	end if;
	
end process;
end RTL;
