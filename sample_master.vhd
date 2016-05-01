-- sample_master.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sample_master is
	port (
		avm_m0_address     : out std_logic_vector(9 downto 0);                     --    m0.address
		avm_m0_read        : out std_logic;                                        --      .read
		avm_m0_waitrequest : in  std_logic                     := '0';             --      .waitrequest
		avm_m0_readdata    : in  std_logic_vector(31 downto 0) := (others => '0'); --      .readdata
		avm_m0_write       : out std_logic;                                        --      .write
		avm_m0_writedata   : out std_logic_vector(31 downto 0);                    --      .writedata
		clk                : in  std_logic                     := '0';             -- clock.clk
		reset              : in  std_logic                     := '0'              -- reset.reset
	);
end entity sample_master;

architecture rtl of sample_master is
begin

	-- TODO: Auto-generated HDL template

	avm_m0_writedata <= "00000000000000000000000000000000";

	avm_m0_address <= "0000000000";

	avm_m0_write <= '0';

	avm_m0_read <= '0';

end architecture rtl; -- of sample_master
