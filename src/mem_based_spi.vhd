-- TODO remove reference to cpu_finish and start FSM after confirming cpu_clock is low
-- TODO add both system_clock and cpu_clock.  Drive FSM with system_clock
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem_based_spi is
	Port ( 
		clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		cpu_finish : in std_logic;
		addr_bus : in  STD_LOGIC_VECTOR (3 downto 0);
		data_bus : inout std_logic_vector(15 downto 0);
		n_cs : in  STD_LOGIC;
		n_wr : in  STD_LOGIC;
		n_rd : in  STD_LOGIC;
		SCLK : out STD_LOGIC;
		MOSI : out STD_LOGIC;
		MISO : in  STD_LOGIC;
		ss : out STD_LOGIC)
	;
end mem_based_spi;

	

architecture Behavioral of mem_based_spi is

	type state_type is (state_idle, state_checking_for_write,  state_0, state_2, 
		state_8, state_9, state_10, state_12, state_14, state_1, state_15, state_16);

	signal state_reg, state_next : state_type;
	
	type r_state_type is (state_idle, state_0, state_1);
	signal r_state_reg, r_state_next : r_state_type;
	
	signal is_read_in_progress  : std_logic; 
	signal is_write_in_progress : std_logic;
	signal is_busy, is_busy_next : std_logic;

	signal sclk_reg : std_logic;
	signal sclk_next : std_logic;

	signal num_clocks : unsigned(3 downto 0);
	signal num_clocks_next : unsigned(3 downto 0);

	signal spi_in : std_logic_vector(7 downto 0);
	signal spi_in_next : std_logic_vector(7 downto 0);

	signal val_reg, val_next : std_logic_vector(15 downto 0);

	signal spi_out : std_logic_vector(7 downto 0);
	signal spi_out_next : std_logic_vector(7 downto 0);

	signal tick : std_logic;
	signal rollover_next : unsigned(15 downto 0);
	signal rollover_count : unsigned(15 downto 0);

	signal ss_reg, ss_next : std_logic_vector(15 downto 0);

	component fsm_tick is
	Port ( 
		clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		tick : out STD_LOGIC;
		rollover_count : in unsigned(15 downto 0)
	);
	end component;
	

begin

	tick_0 : fsm_tick port map(
		clock => clock,
		reset => reset,
		tick => tick,
		rollover_count => rollover_count);

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
	-- This is the FSM Thing which responds to host writes  
	-- and triggers and SPI (bidirectional) transmission
	-- the mask or clear regs.
	-- 
	-- Writing to the clear_reg address ALSO triggers clear_tick
	-- which causes the process that "owns" the status register
	-- to clear it (on a bit basis).
	process(clock, reset, state_next, spi_out, spi_out_next, sclk_next, is_busy_next, ss_next, ss_reg)
	begin
		if (reset = '1') then
			state_reg <= state_idle;
			spi_out <= (others => '0');
			spi_in <= (others => '0');
			num_clocks <= (others => '0');
			is_busy <= '0';
			sclk_reg <= '0';
			ss_reg <= X"0001";
			rollover_count <= X"00FA";
			-- small rollover for test bench testing
			-- rollover_count <= X"0003";
		elsif (rising_edge(clock)) then
			state_reg <= state_next;
			spi_out <= spi_out_next;
			spi_in <= spi_in_next;
			sclk_reg <= sclk_next;
			is_busy <= is_busy_next;
			rollover_count <= rollover_next;
			ss_reg <= ss_next;
			num_clocks <= num_clocks_next;
		end if;
	end process;
	
	
	process (
		state_reg, cpu_finish, is_write_in_progress, is_busy, addr_bus, data_bus, tick, num_clocks, num_clocks_next, spi_out, ss_reg)
	begin
		state_next <= state_reg;
		spi_out_next <= spi_out;
		spi_in_next <= spi_in;
		sclk_next <= sclk_reg;
		is_busy_next <= is_busy;
		num_clocks_next <= num_clocks;
		rollover_next <= rollover_count;
		ss_next <= ss_reg;


		case state_reg is
			when state_idle =>
				if (cpu_finish = '1') then
					is_busy_next <= '0';
					state_next <= state_checking_for_write;
				end if;



			when state_checking_for_write =>
				if (is_write_in_progress = '1') then
					num_clocks_next <= "0000";
					case addr_bus is 
						-- addr 0 byte to be transmitted by this (the Master)
						when X"0" =>  
							spi_out_next <= data_bus(7 downto 0);
							is_busy_next <= '1';
							state_next <= state_1;
							is_busy_next <= '1';
						-- addr 2 word to be used to gate the spi state machine
						-- through the fsm_tick component
						when X"2" =>
							rollover_next <= unsigned(data_bus);
							state_next <= state_idle;
						when X"3" =>
							ss_next <= data_bus;
							state_next <= state_idle;
						when others =>
							state_next <= state_idle;
					end case;
				end if;



		
			when state_1 => 
				if (tick = '1') then
    				if (num_clocks = 8) then
    					sclk_next <= '0';
    					is_busy_next <= '0';
    					state_next <= state_idle;
    				else
    					sclk_next <= '1';
    					spi_in_next <= spi_in(6 downto 0) & MISO;
    					state_next <= state_2;
    				end if;
            end if;


			when state_2 => 
				if (tick = '1') then
					sclk_next <= '0';
					spi_out_next <= spi_out(6 downto 0) & '0';
					num_clocks_next <= num_clocks + 1;
					state_next <= state_1;
            end if;


			when others =>
				state_next <= state_idle;



		end case;

	end process;
	-----------------------------------------------------------------
	
	
	MOSI <= spi_out(7);
	SCLK <= sclk_reg;
   ss <= ss_reg(0);
	



	
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
		r_state_reg, val_reg, is_busy, rollover_count,  cpu_finish, is_read_in_progress, addr_bus)
	begin
		r_state_next <= r_state_reg;
		val_next <= val_reg;

		case r_state_reg is
			when state_idle =>
				if (cpu_finish = '1') then
					r_state_next <= state_0;
				end if;
				
			-- Necessary Pause?
			-- I (Jamet) don't know...  Never explored in enough detail
			when state_0 =>
				r_state_next <= state_1;
				
			when state_1 =>
				r_state_next <= state_idle;
				if (is_read_in_progress = '1') then
					case addr_bus is 
						when X"0" =>
							val_next <= X"00" & spi_in;
						when X"1" =>
							val_next <= X"000" & "000" &  is_busy;
						when X"2" =>
							val_next <= std_logic_vector(rollover_count);
						when X"3" =>
							val_next <= std_logic_vector(ss_reg);
						when others =>
							val_next <= X"1234";
					end case;
				else
					r_state_next <= state_idle;
				end if;
	
	
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
