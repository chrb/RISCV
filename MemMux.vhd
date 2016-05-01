library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity MemMux is
	Port ( 	
				-- Input
				A : in std_logic_vector(31 downto 0);
				B : in std_logic_vector(31 downto 0);
				S : in std_logic;
				FunctI : in std_logic_vector(2 downto 0);
				MemAddrLowI: in std_logic_vector(1 downto 0);
				-- Output
				O : out std_logic_vector(31 downto 0));
end MemMux;

architecture RTL of MemMux is

begin
	process (A, B, S, FunctI, MemAddrLowI)
	begin
	
		O <= std_logic_vector(to_unsigned(0,32));
		if S='0' then
			-- reg
			O <= A;
		else
			-- imm
			
			case FunctI is
				-- LB
				when funct_LB =>
					case MemAddrLowI is
						when "00" => O <= std_logic_vector(resize(signed(B(7 downto 0)),32));
						when "01" => O <= std_logic_vector(resize(signed(B(15 downto 8)),32));
						when "10" => O <= std_logic_vector(resize(signed(B(23 downto 16)),32));
						when "11" => O <= std_logic_vector(resize(signed(B(31 downto 24)),32));
						when others => O <= std_logic_vector(to_unsigned(0,32));
					end case;
					
				-- LBU
				when funct_LBU =>
					case MemAddrLowI is
						when "00" => O <= std_logic_vector(resize(unsigned(B(7 downto 0)),32));
						when "01" => O <= std_logic_vector(resize(unsigned(B(15 downto 8)),32));
						when "10" => O <= std_logic_vector(resize(unsigned(B(23 downto 16)),32));
						when "11" => O <= std_logic_vector(resize(unsigned(B(31 downto 24)),32));
						when others => O <= std_logic_vector(to_unsigned(0,32));
					end case;
				-- LH
				when funct_LH =>
					case MemAddrLowI(1) is
						when '0' => O <= std_logic_vector(resize(signed(B(15 downto 0)),32));
						when '1' => O <= std_logic_vector(resize(signed(B(31 downto 16)),32));
						when others => O <= std_logic_vector(to_unsigned(0,32));
					end case;
				-- LHU
				when funct_LHU =>
					case MemAddrLowI(1) is
						when '0' => O <= std_logic_vector(resize(unsigned(B(15 downto 0)),32));
						when '1' => O <= std_logic_vector(resize(unsigned(B(31 downto 16)),32));
						when others => O <= std_logic_vector(to_unsigned(0,32));
					end case;
				-- LW
				when others =>
					O <= B;
			end case;
		end if;
	end process;
end RTL;