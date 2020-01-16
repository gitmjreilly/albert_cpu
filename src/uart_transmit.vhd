---------------------------------------------------------------------
--  uart based on pong chu and Xilinx Coregen Ram
---------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity uart_w_fifo is
	generic (
		DBIT : integer := 8;
		SB_TICK : integer := 16
		-- For simulation only
		-- SB_TICK : integer := 2
	);
    port ( 
      system_clock : in std_logic;
      cpu_clock : in std_logic;
		rx : in STD_LOGIC;
		tx : out STD_LOGIC;
		reset : in STD_LOGIC;
		n_cs : in STD_LOGIC;
		n_rd : in STD_LOGIC;
		n_wr : in STD_LOGIC;
		data_bus : inout STD_LOGIC_VECTOR(15 downto 0);
		fake_data_bus : out std_logic_vector(15 downto 0);
		addr_bus : in STD_LOGIC_VECTOR(3 downto 0);

		-- Bunch of individual status bits to trigger interrupts
		tx_fifo_is_empty  : inout std_logic;
		tx_fifo_is_half_empty : inout std_logic;
		tx_fifo_is_quarter_empty : inout std_logic;
		tx_fifo_is_full : inout std_logic;

		rx_fifo_has_char : inout std_logic;
		rx_fifo_is_empty : inout std_logic;
		rx_fifo_is_full : inout std_logic;
		rx_fifo_is_half_full : inout std_logic;
		rx_fifo_is_quarter_full : inout std_logic
		

	);
end uart_w_fifo;




architecture behavioral of uart_w_fifo is

	constant MAX_ADDR : integer    := 1023;


	-- uart RX fifo write states
	-- These are the states the fifo fsm can be in.
	type w_state_type is (w_state_idle, w_state_0);

	type read_state_type is (read_state_idle, read_state_0, read_state_1);

   signal previous_cpu_clock : std_logic;

	signal read_state_reg, read_state_next : read_state_type;
	signal w_state_reg, w_state_next : w_state_type;


	-- type state_type is (state_idle, state_0);
	type state_type is (state_idle, state_start_bit, state_data, state_stop_bit);
	signal state_reg, state_next : state_type;
	
	signal bit_pacing, bit_pacing_next : unsigned(3 downto 0);
	signal n_reg, n_next : unsigned(2 downto 0);
	signal b_reg, b_next : std_logic_vector(7 downto 0);
	-- rx_received_byte contains the received byte.
	signal rx_received_byte : std_logic_vector(7 downto 0);

	signal fsm_pacing_tick : std_logic;


	signal is_host_write_in_progress  : std_logic;
	signal is_rx_fifo_read_in_progress  : std_logic;
	
	signal val_reg, val_next : std_logic_vector(15 downto 0);
	signal rx_done_tick : std_logic;
	
	signal buf_reg, buf_next : std_logic_vector(7 downto 0); 
	signal flag_reg, flag_next : std_logic; 
	signal clr_flag, clr_next : std_logic; 
	
	signal buffer_out : std_logic_vector(15 downto 0); 
	signal flag_out : std_logic;
	
	
	signal rx_fifo_in_addr_next, rx_fifo_in_addr : std_logic_vector(9 downto 0);
	signal rx_fifo_out_addr_next, rx_fifo_out_addr : std_logic_vector(9 downto 0);
	signal wea_reg, wea_next, wea : std_logic_vector(0 downto 0);
	
	signal rx_fifo_data_out : std_logic_vector(7 downto 0);

	signal num_bytes_in_rx_fifo : std_logic_vector(10 downto 0);
	signal inc_num_bytes_in_rx_fifo_tick : std_logic;
	signal dec_num_bytes_in_rx_fifo_tick : std_logic;
	
	signal num_bytes_in_tx_fifo : std_logic_vector(10 downto 0);
	signal inc_num_bytes_in_tx_fifo_tick : std_logic;
	signal dec_num_bytes_in_tx_fifo_tick : std_logic;
	
	signal tx_fifo_wea, tx_fifo_wea_reg, tx_fifo_wea_next : std_logic_vector(0 downto 0);
	signal tx_fifo_in_addr, tx_fifo_in_addr_next : std_logic_vector(9 downto 0);
	signal tx_fifo_out_addr, tx_fifo_out_addr_next : std_logic_vector(9 downto 0);
	
	type tx_fsm_w_state_type is (tx_fsm_w_state_idle, tx_fsm_w_state_0, tx_fsm_w_state_1, tx_fsm_w_state_2);
	signal tx_fsm_w_state_reg, tx_fsm_w_state_next : tx_fsm_w_state_type;
	
	signal tx_fifo_data_out : std_logic_vector(7 downto 0);
	
	
	-- type state_type is (state_idle, state_0);
	type state_type is (state_idle, state_start_bit, state_data, state_stop_bit);
	signal state_reg, state_next : state_type;
	
	signal bit_pacing, bit_pacing_next : unsigned(3 downto 0);
	signal n_reg, n_next : unsigned(2 downto 0);
	signal b_reg, b_next : std_logic_vector(7 downto 0);
	signal tx_reg, tx_next : std_logic;
	
		
	
	
begin
	-- data_bus <= (others => 'Z');

	
	-----------------------------------------------------------------
	-- These 2 signals indicate either a memory read or write is in 
	-- progress by the host.
	-- They are asserted during the entire microcode cycle.
	-- They are NOT edge based.
	-- Please note all reads and writes are from the host's perspective
	is_rx_fifo_read_in_progress  <= '1' when ((n_cs = '0') and (n_rd = '0')) else '0';
	is_host_write_in_progress <= '1' when ((n_cs = '0') and (n_wr = '0')) else '0';
	-----------------------------------------------------------------

	
	
	-----------------------------------------------------------------
	ticker: entity work.mod_m 
		generic map(
			N => 9, -- num bits
			-- 50 * 10^6 / (16 * 19200)
			-- M => 163  -- MOD M (Should lead to 19200 bps w/50MHz clock)
			--M => 27  -- MOD M (27 Should lead to 115200 bps w/50MHz clock)
			-- M => 2 -- for simulation only
			M => 130 -- 9600 bps at 20MHz
		)
		port map(
			clk => system_clock, 
			reset => reset,
			max_tick => fsm_pacing_tick
		);
	-----------------------------------------------------------------
	

	-----------------------------------------------------------------
	-- This process captures the previous_cpu_clock
	-- so the FSM's below can detect cpu_clock_edges
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
	-- Synchronous FSM process used to retrieve values from fifo,
	-- advance out addr and do serial transmission
	process(
		system_clock, reset, 
		state_next,
		bit_pacing_next, n_next, b_next,
      tx_fifo_out_addr_next
	)
	begin
		if reset = '1' then
			state_reg <= state_idle;

			bit_pacing <= (others => '0');
			n_reg <= (others => '0');
			b_reg <= (others => '0');
			tx_fifo_out_addr <= (others => '0');
			
			tx_reg <= '1';
			
		elsif (rising_edge(system_clock)) then
			state_reg <= state_next;
			
			bit_pacing <= bit_pacing_next;
			n_reg <= n_next;
			b_reg <= b_next;
			tx_fifo_out_addr <= tx_fifo_out_addr_next;
			
			tx_reg <= tx_next;
			
		end if;	
	end process;
	-----------------------------------------------------------------

	
	-----------------------------------------------------------------
	-- Combinational State selection
	-- tx serial transmitter fsm state selection
	process (
		state_reg, 
		bit_pacing,
		n_reg,
		b_reg,
		fsm_pacing_tick,
		num_bytes_in_tx_fifo,
		tx_fifo_data_out,
		tx_fifo_out_addr,
		tx_reg
	)
	begin
		state_next <= state_reg;
		bit_pacing_next <= bit_pacing;
		n_next <= n_reg;
		b_next <= b_reg;
		tx_next <= tx_reg;
		dec_num_bytes_in_tx_fifo_tick <= '0';
		tx_fifo_out_addr_next <= tx_fifo_out_addr;
		

		case state_reg is 

			when state_idle =>
				if (num_bytes_in_tx_fifo > 0 ) then 
					state_next <= state_start_bit;
					-- The byte to be transmitted, tx_fifo_data_out, comes directly from block ram
					b_next <= tx_fifo_data_out;
					bit_pacing_next <= (others => '0');
					dec_num_bytes_in_tx_fifo_tick <= '1';
					if (tx_fifo_out_addr = MAX_ADDR) then
						tx_fifo_out_addr_next <= (others => '0');
					else
						tx_fifo_out_addr_next <= tx_fifo_out_addr + 1;
					end if;
					
				else
				 	state_next <= state_idle;
				end if;

			when state_start_bit =>
				-- Drive the start bit and 
				-- hold it for 16 cycles
				tx_next <= '0'; 
				if (fsm_pacing_tick = '1') then
					if (bit_pacing = (SB_TICK - 1)) then
						state_next <= state_data;
						bit_pacing_next <= (others => '0');
						n_next <= (others => '0');
					else
						bit_pacing_next <= bit_pacing + 1;
					end if;
				end if;

			when state_data =>
				tx_next <= b_reg(0);
				if (fsm_pacing_tick = '1') then
					if  (bit_pacing = (SB_TICK - 1)) then
						bit_pacing_next <= (others => '0');
						b_next <= '0' & b_reg(7 downto 1);
						if (n_reg = 7) then
							state_next <= state_stop_bit;
						else
							n_next <= n_reg + 1;
						end if;
					else
						bit_pacing_next <= bit_pacing + 1;
					end if;
				end if;
				
			when state_stop_bit =>
				tx_next <= '1';
				if (fsm_pacing_tick = '1') then
					if (bit_pacing = (SB_TICK - 1)) then 
						state_next <= state_idle;
						-- tx_done_tick <= '1';
					else
						bit_pacing_next <= bit_pacing + 1;
					end if;
				end if;
		end case;
	end process;
	
	tx <= tx_reg;
	


	-- Various transmitter and receiver status conditions
	tx_fifo_is_empty <= '1' when num_bytes_in_tx_fifo = 0 else '0';
	tx_fifo_is_half_empty <= '1' when (num_bytes_in_tx_fifo <= (MAX_ADDR + 1)  / 2) else '0';
	tx_fifo_is_quarter_empty <= '1' when (num_bytes_in_tx_fifo <= (MAX_ADDR + 1)  / 4) else '0';
	tx_fifo_is_full <= '1' when num_bytes_in_tx_fifo = (MAX_ADDR + 1) else '0';

	rx_fifo_has_char <= '1' when num_bytes_in_rx_fifo > 0 else '0';
	rx_fifo_is_empty <= '1' when num_bytes_in_rx_fifo = 0 else '0';
	rx_fifo_is_full <= '1' when num_bytes_in_rx_fifo = (MAX_ADDR + 1) else '0';
	rx_fifo_is_half_full <= '1' when num_bytes_in_rx_fifo >= (MAX_ADDR + 1) / 2 else '0';
	rx_fifo_is_quarter_full <= '1' when num_bytes_in_rx_fifo >= (MAX_ADDR + 1) / 4 else '0';
	
	
	
	
	
end behavioral;
