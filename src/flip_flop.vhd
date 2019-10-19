library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity flip_flop is
    Port ( input : in std_logic;
           output : out std_logic;
           clock : in std_logic;
		   enable : in std_logic);
end flip_flop;

architecture Behavioral of flip_flop is

begin

	process (clock)
	begin
		if clock'event and clock = '1' then  
			if enable = '1' then
				output <= input;
			end if;
		end if;
	end process;
 
end Behavioral;
