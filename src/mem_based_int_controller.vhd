-- TODO Remove cpu_finish, add 2 clocks to detect AST end of uCode cycle (RE)
--
-- This is the multi input interrupt controller.
-- It is meant to be memory mapped.
-- It supports 3 registers:
--		Address 00 - INTERRUPT_STATUS - readonly
--		Address 01 - INTERRUPT_MASK - read/write
--		Address 10 - INTERRUPT_CLEAR - read/write
--		Address 11 - UNUSED
--
-- Please note the data_bus had to be specified one bit at a time.
-- For reason(s) unknown, passing in the 16 bit data bus did not work.
-- i.e. reading from regs did not work (Writing might not have worked either)
-- I am guessing it is related to the fact the port is "inout".
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mem_based_int_controller is
    Port ( 
		clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		cpu_finish : in std_logic;
		addr_bus : in  STD_LOGIC_VECTOR (3 downto 0);
		data_bus : inout std_logic_vector(15 downto 0);
		int_occurred : out  STD_LOGIC;
		n_cs : in  STD_LOGIC;
		n_wr : in  STD_LOGIC;
		n_rd : in  STD_LOGIC;
		raw_interrupt_word : in  STD_LOGIC_vector(15 downto 0))
	;
end mem_based_int_controller;



architecture Behavioral of mem_based_int_controller is

	type state_type is (state_idle, state_0, state_1);
	signal r_state_reg, r_state_next : state_type;
	signal w_state_reg, w_state_next : state_type;
	
	signal val_reg, val_next : std_logic_vector(15 downto 0);

	signal reg_0, reg_0_next : std_logic_vector(15 downto 0);
	signal reg_1, reg_3_next : std_logic_vector(15 downto 0);
	signal reg_2, reg_2_next : std_logic_vector(15 downto 0);
	signal reg_3, reg_1_next : std_logic_vector(15 downto 0);
	
	signal is_read_in_progress  : std_logic; 
	signal is_write_in_progress : std_logic;


	signal sync_interrupt_word : std_logic_vector(15 downto 0);
	signal status_reg : std_logic_vector(15 downto 0);
	signal clear_reg : std_logic_vector(15 downto 0);
	signal mask_reg : std_logic_vector(15 downto 0);
	signal clear_tick : std_logic;

	signal clear_next : std_logic_vector(15 downto 0);
	signal mask_next : std_logic_vector(15 downto 0);

	
begin
	int_occurred <= '0' when status_reg = X"0000" else '1';


	-----------------------------------------------------------------
	-- These 2 signals indicate either a read or write is in 
	-- progress by the host.
	-- They are asserted during the entire microcode cycle.
	-- They are NOT edge based.
	-- Please note all reads and writes are from the host's perspective
	is_read_in_progress  <= '1' when ((n_cs = '0') and (n_rd = '0')) else '0';
	is_write_in_progress <= '1' when ((n_cs = '0') and (n_wr = '0')) else '0';
	-----------------------------------------------------------------

 

	
	-----------------------------------------------------------------
	-- This is the thing which sync's raw interrupt inputs
	u_sync : process(clock, reset, raw_interrupt_word)
	begin
		if (reset = '1') then
			sync_interrupt_word <= (others => '0');
		elsif (rising_edge(clock)) then
			sync_interrupt_word <= raw_interrupt_word;
		end if;
	
	end process;
	-----------------------------------------------------------------

	
	-----------------------------------------------------------------	
	-- This is the Thing which either captures or clears status_reg
	u_status_reg : process (
		clock, reset, clear_tick, status_reg, clear_reg, sync_interrupt_word, mask_reg)
	begin
		if (reset = '1') then
			status_reg <= (others => '0');
		elsif (rising_edge(clock)) then
			if (clear_tick = '1') then 
				status_reg <= status_reg AND (not(clear_reg));
			else
				status_reg <= (status_reg OR sync_interrupt_word) AND mask_reg;
			end if;
		end if;

	end process;
	-----------------------------------------------------------------

	
	-----------------------------------------------------------------
	-- This is the FSM Thing which allows the host to write to 
	-- the mask or clear regs.
	-- Writing to the clear_reg address ALSO triggers clear_tick
	-- which causes the process that "owns" the status register
	-- to clear it (on a bit basis).
	process(clock, reset, w_state_next, mask_next, clear_next)
	begin
		if (reset = '1') then
			w_state_reg <= state_idle;
			mask_reg <= (others => '0');
			clear_reg <= (others => '0');
		elsif (rising_edge(clock)) then
			w_state_reg <= w_state_next;
			mask_reg <= mask_next;
			clear_reg <= clear_next;	
		end if;
	end process;
	
	
	process (
		w_state_reg, mask_reg, clear_reg, cpu_finish, is_write_in_progress, addr_bus, data_bus)
	begin
		w_state_next <= w_state_reg;
		mask_next <= mask_reg;
		clear_next <= clear_reg;
		clear_tick <= '0';

		case w_state_reg is
			when state_idle =>
				if (cpu_finish = '1') then
					w_state_next <= state_0;
				end if;
				
			when state_0 =>
				if (is_write_in_progress = '1') then
					case addr_bus is 
						when X"1" => 
							mask_next <= data_bus;
							w_state_next <= state_idle;
						when X"2" =>
							clear_next <= data_bus;
							w_state_next <= state_1;
						when others =>
							w_state_next <= state_idle;
					end case;
				end if;
		
			when state_1 => 
				clear_tick <= '1';
				w_state_next <= state_idle;

		end case;
				
	end process;
	-----------------------------------------------------------------
	
	
	-----------------------------------------------------------------
	-- This is the FSM Thing which allows the host to read  
	-- the status, mask or clear regs.
	process(clock, reset, r_state_next, val_next)
	begin
		if (reset = '1') then
			r_state_reg <= state_idle;
			val_reg <= X"6666";
		elsif (rising_edge(clock)) then
			val_reg <= val_next;
			r_state_reg <= r_state_next;
		end if;
	end process;


	
	process (
		r_state_reg, val_reg, status_reg, mask_reg, clear_reg, cpu_finish, is_read_in_progress, addr_bus)
	begin
		r_state_next <= r_state_reg;
		val_next <= val_reg;

		case r_state_reg is
			when state_idle =>
				if (cpu_finish = '1') then
					r_state_next <= state_0;
				end if;
				
			-- Necessary Pause?
			when state_0 =>
				r_state_next <= state_1;
				
			when state_1 =>
				r_state_next <= state_idle;
				if (is_read_in_progress = '1') then
					case addr_bus is 
						when X"0" =>
							val_next <= status_reg;
						when X"1" =>
							val_next <= mask_reg;
						when X"2" =>
							val_next <= clear_reg;
						when others =>
							val_next <= X"1234";
					end case;
				else
					r_state_next <= state_idle;
				end if;
	
			when others =>
				r_state_next <= state_idle;
	
	
		end case;
		
		
	end process;
	-----------------------------------------------------------------
	
	-----------------------------------------------------------------
	-- If a read is in progress (determined combinatorially),
	-- we drive the data bus with the register containing the 
	-- the requested value val_reg.  val_reg was populated
	-- by the state machine above.
	process (is_read_in_progress, val_reg)
	begin
		if (is_read_in_progress = '1') then
			data_bus <= val_reg;
		else
			data_bus <= (others => 'Z');
		end if;	
	end process;
	--------------------	
	

end Behavioral;

