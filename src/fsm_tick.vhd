--
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- looked at implementation; it uses ieee.std_logic_1164


-- use ieee.numeric_std_unsigned.all;
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_tick is
	Port ( 
		clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
      tick : out STD_LOGIC;
      rollover_count : in unsigned(15 downto 0)
	);
end fsm_tick;

	

architecture Behavioral of fsm_tick is
	type state_type is (state_1,  state_2);

   signal tick_reg, tick_next : STD_LOGIC;
	signal state_reg, state_next : state_type;
	signal internal_counter : unsigned(15 downto 0);
	signal internal_counter_next : unsigned(15 downto 0);

	
begin
	
	tick <= tick_reg;
	
	-----------------------------------------------------------------
	process(clock, reset, state_next, internal_counter_next, tick_next)
	begin
		if (reset = '1') then
			internal_counter <= (others => '0');
			state_reg <= state_1;
			tick_reg <= '1';
		elsif (rising_edge(clock)) then
			state_reg <= state_next;
			tick_reg <= tick_next;
			internal_counter <= internal_counter_next;
		end if;
	end process;
	
	
	process (state_reg, internal_counter, rollover_count, tick_reg)
	begin

		case state_reg is
		
			when state_1 => 
            tick_next <= '0';
			   state_next <= state_2;
            internal_counter_next <= X"0001"; 


			when state_2 => 
            if (internal_counter = (rollover_count - 1)) then
               tick_next <= '1';
				   state_next <= state_1;
               internal_counter_next <= (others => '0');
            else
               tick_next <= '0';
               state_next <= state_2;
               internal_counter_next <= internal_counter + 1;
            end if;

		end case;

	end process;
	-----------------------------------------------------------------
	
	

end Behavioral;

