--------------------------------------------------------------------------------
-- ctl values
--		00 Pass
--		01 SLL8
--		10 SRA1
--		11 Undefined
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity shifter is
    Port ( input : in std_logic_vector(15 downto 0);
           ctl : in std_logic_vector(1 downto 0);
           output : out std_logic_vector(15 downto 0));
end shifter;

architecture Behavioral of shifter is

begin
	process (ctl, input)
	begin
		-- 00 Pass
		if (ctl = "00") then
			output <= input;

		-- 01 SLL8
		elsif (ctl = "01") then
			output(15 downto 8) <= input(7 downto 0);
			output(7 downto 0) <= (others => '0');
		-- 10 SRA1
		elsif (ctl = "10") then
			output(14 downto 0) <= input(15 downto 1);
			if (input(15) = '1') then
				output(15) <= '1';
			else
				output(15) <= '0';
			end if;
		-- 11 SLL(1)
		elsif (ctl = "11") then
			output(15 downto 0) <= input(14 downto 0) & '0';
		else
			output <= (others => '0');
		end if;
 	end process;

--    elsif <clock>'event and <clock>='1' then  
--      <reg_name> <= reg_name((<width>-2) downto 0) & '0';
--   end if;
--   <output> <= <reg_name>;
--end process;

end Behavioral;
