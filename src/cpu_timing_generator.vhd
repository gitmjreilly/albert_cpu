----------------------------------------------------------------------------------
-- 
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu_timing_generator is
    Port ( 
		clk : in  STD_LOGIC;
		reset : in STD_LOGIC;
		cpu_start : out  STD_LOGIC;
		cpu_finish : out  STD_LOGIC
	);
end cpu_timing_generator;

architecture Behavioral of cpu_timing_generator is

	-- This is the count of underlying cycles
	-- for each instruction cycle
	-- At 50Mhz, we divide by 5 to get an effective 10Mhz cpu clock
	-- The way the code is written N = 5 - 1
	
	
	constant N : unsigned := "0011";
	    
	type state_type is (state_idle, state_0, state_1, state_2, state_3);
	signal state_reg, state_next : state_type;
	
	signal L : std_logic;
	signal H : std_logic;
	
	signal count_0, count_0_next : unsigned(3 downto 0);
	signal count_2, count_2_next : unsigned(3 downto 0);

begin

	-----------------------------------------------------------------
	process(clk, reset)
	begin
		if reset = '1' then
			state_reg <= state_idle;
			-- L <= '1';
			-- H <= '0';
		elsif (rising_edge(clk)) then
			state_reg <= state_next;
			count_0 <= count_0_next;
			count_2 <= count_2_next;
		end if;	
	end process;
	-----------------------------------------------------------------

	-----------------------------------------------------------------
	process (state_reg, count_0, count_0_next, count_2, count_2_next)

	-- This process statement is NG; count (nexts) have to be included
	-- process (state_reg, count_0, count_2)
	begin
		state_next <= state_reg;
		-- Initializing the signals below to avoid generating latches
		count_0_next <= count_0;
		count_2_next <= count_2;
		
		case state_reg is 
			when state_idle =>
				state_next <= state_0;
				L <= '0';
				H <= '0';
			when state_0 =>
				state_next <= state_1;
				L <= '1';
				H <= '0';
				count_0_next <= N - 1;
			when state_1 =>
				count_0_next <= count_0 - 1;
				if (count_0_next = 0) then
					state_next <= state_2;
				end if;
				L <= '0';
				H <= '0';
			when state_2 =>
				count_2_next <= N - 1;
				state_next <= state_3;
				L <= '0';
				H <= '1'; 
			when state_3 =>
				count_2_next <= count_2 - 1;
				if (count_2_next = 0) then
					state_next <= state_0;
				end if;
				L <= '0';
				H <= '0';
				
				
				
		end case;
	end process;
	-----------------------------------------------------------------



	cpu_start <= L;
	cpu_finish <= H;

end Behavioral;


