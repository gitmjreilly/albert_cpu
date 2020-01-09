library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity block_ram_64kb is
	Port ( 
		cpu_clock : in  STD_LOGIC;
		system_clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		addr_bus : in  STD_LOGIC_VECTOR (15 downto 0);
		data_bus : inout std_logic_vector(15 downto 0);
		n_cs : in  STD_LOGIC;
		n_wr : in  STD_LOGIC;
		n_rd : in  STD_LOGIC)
	;
end block_ram_64kb;

	

architecture Behavioral of block_ram_64kb is

	type state_type is (state_idle, state_a, state_b, state_c, state_d);

	signal state_reg, state_next : state_type;
	signal r_state_reg, r_state_next : state_type;

    signal previous_cpu_clock : std_logic;
	
	
	signal is_read_in_progress  : std_logic; 
	signal is_write_in_progress : std_logic;
	signal is_busy, is_busy_next : std_logic;


	signal reg_0, reg_0_next : std_logic_vector(15 downto 0);
	signal reg_1, reg_1_next : std_logic_vector(15 downto 0);

	signal wea_next, wea_reg : std_logic_vector(0 downto 0);
	

	signal douta : std_logic_vector(15 downto 0);
	signal output_enable : std_logic;

	signal val_reg, val_next : std_logic_vector(15 downto 0);
	
begin
	u_blk_64KW : entity work.block_ram_64_KW
	  PORT MAP (
		clka => system_clock,
		wea => wea_reg,
		addra => addr_bus,
		dina => data_bus,
		douta => douta
	  );
		

	
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
	-- This process captures the previous_cpu_clock
	-- so the FSM's below can detect cpu_clock_edges
	-- and triggers and triggers a write to this thing
    --
	process(system_clock, reset, cpu_clock)
	begin
		if (reset = '1') then
			previous_cpu_clock <= '1';
		elsif (rising_edge(system_clock)) then
			previous_cpu_clock <= cpu_clock;
		end if;
	end process;
	-----------------------------------------------------------------
	
	
	
	-----------------------------------------------------------------
	-- This is the FSM Thing which responds to host writes  
	-- and triggers a write to the block ram
    --
	process(system_clock, reset, state_next, is_busy, is_busy_next, reg_0_next, reg_1_next)
	begin
		if (reset = '1') then
			state_reg <= state_a;
         is_busy <= '0';
			reg_0 <= X"0071";
			reg_1 <= X"0999";
			wea_reg <= "0";
		elsif (rising_edge(system_clock)) then
			state_reg <= state_next;
			is_busy <= is_busy_next;
			reg_0 <= reg_0_next;
			reg_1 <= reg_1_next;
			wea_reg <= wea_next;
		end if;
	end process;
	
	
	process (
		state_reg, state_next, cpu_clock, previous_cpu_clock, is_write_in_progress, is_busy, is_busy_next, addr_bus, data_bus,
		reg_0, reg_0_next, reg_1, reg_1_next)
	begin
		state_next <= state_reg;
		is_busy_next <= is_busy;
		reg_0_next <= reg_0;
		reg_1_next <= reg_1;
		wea_next <= "0";


		case state_reg is
			when state_a =>
				if previous_cpu_clock = '1' AND cpu_clock = '0' then
					state_next <= state_b;
				end if;


			when state_b =>
				if previous_cpu_clock = '0' AND cpu_clock = '1' AND is_write_in_progress = '1'  then
					state_next <= state_c;
					is_busy_next <= '1';
					wea_next <= "1";
				end if;



			when state_c =>
				if cpu_clock = '0' then
					state_next <= state_b;
					is_busy_next <= '0';
				end if;



			when others =>
				state_next <= state_reg;



		end case;

	end process;
	-----------------------------------------------------------------


	-----------------------------------------------------------------
	-- This is the FSM Thing which allows the host to read  
	-- from this memory mapped peripheral
	process(system_clock, reset, r_state_next, val_next)
	begin
		if (reset = '1') then
			r_state_reg <= state_a;
			val_reg <= X"AAAA";
		elsif (rising_edge(system_clock)) then
			val_reg <= val_next;
			r_state_reg <= r_state_next;
		end if;
	end process;


	
	process (
		r_state_reg, val_reg, previous_cpu_clock, cpu_clock, is_read_in_progress, addr_bus, reg_0, reg_1)
	begin
		r_state_next <= r_state_reg;
		val_next <= val_reg;

		case r_state_reg is
			when state_a =>
				if previous_cpu_clock = '1' AND cpu_clock = '0' then
					r_state_next <= state_b;
				end if;

			when state_b =>
				if previous_cpu_clock = '0' AND cpu_clock = '1' AND is_read_in_progress = '1'  then
					r_state_next <= state_c;
					val_next <= douta; -- Should val_next be set here or in state_c?
				end if;

			when state_c =>
				-- val_next <= douta;
				if cpu_clock = '0' then
					r_state_next <= state_b;
				end if;

			when others =>
				r_state_next <= r_state_reg;

	
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

end Behavioral;

