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
		clk : in  STD_LOGIC; -- TODO For now, we assume 50MHz
		rx : in STD_LOGIC;
		tx : out STD_LOGIC;
		reset : in STD_LOGIC;
		cpu_finish : in  STD_LOGIC;
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


	signal read_state_reg, read_state_next : read_state_type;
	signal w_state_reg, w_state_next : w_state_type;


	-- type state_type is (state_idle, state_0);
	type state_type is (state_idle, state_start_bit, state_data, state_stop_bit);
	signal state_reg, state_next : state_type;
	
	signal s_reg, s_next : unsigned(3 downto 0);
	signal n_reg, n_next : unsigned(2 downto 0);
	signal b_reg, b_next : std_logic_vector(7 downto 0);
	-- rx_received_byte contains the received byte.
	signal rx_received_byte : std_logic_vector(7 downto 0);

	signal s_tick : std_logic;


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
	
	
	-- type tx_fsm2_state_type is (tx_fsm2_state_idle, tx_fsm2_state_0);
	type tx_fsm2_state_type is (tx_fsm2_state_idle, tx_fsm2_state_start_bit, tx_fsm2_state_data, tx_fsm2_state_stop_bit);
	signal tx_fsm2_state_reg, tx_fsm2_state_next : tx_fsm2_state_type;
	
	signal tx_fsm2_s_reg, tx_fsm2_s_next : unsigned(3 downto 0);
	signal tx_fsm2_n_reg, tx_fsm2_n_next : unsigned(2 downto 0);
	signal tx_fsm2_b_reg, tx_fsm2_b_next : std_logic_vector(7 downto 0);
	signal tx_reg, tx_next : std_logic;
	
		
--	COMPONENT blk_mem_dual_1KB
--	  PORT (
--		clka : IN STD_LOGIC;
--		wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--		addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
--		dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--		clkb : IN STD_LOGIC;
--		addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
--		doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
--	  );
--	END COMPONENT;	

	
	
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
			N => 5, -- num bits
			-- 50 * 10^6 / (16 * 19200)
			-- M => 163  -- MOD M (Should lead to 19200 bps w/50MHz clock)
			M => 27  -- MOD M (27 Should lead to 115200 bps w/50MHz clock)
			-- M => 2 -- for simulation only
		)
		port map(
			clk => clk, 
			reset => reset,
			max_tick => s_tick
		);
	-----------------------------------------------------------------
	
 
	-----------------------------------------------------------------
	-----------------------------------------------------------------
	-- Synchronous process associated with serial rx input
	-- All that happens here is the state change
	-- AND assignment of any internal storage
	process(
		clk, reset, 
		state_next,
		s_next, n_next, b_next
	)
	begin
		if reset = '1' then
			state_reg <= state_idle;

			s_reg <= (others => '0');
			n_reg <= (others => '0');
			b_reg <= (others => '0');
						
		elsif (rising_edge(clk)) then
			state_reg <= state_next;
			
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
			
		end if;	
	end process;
	-----------------------------------------------------------------

	
	-----------------------------------------------------------------
	-- Combinational State selection
	-- This process receives async char from serial port and 
	-- stores result in b_reg
	process (
		state_reg, 
		rx,
		s_reg,
		n_reg,
		b_reg,
		s_tick
	)
	begin
		state_next <= state_reg;
		s_next <= s_reg;
		n_next <= n_reg;
		b_next <= b_reg;
		rx_done_tick <= '0';

		case state_reg is 
			when state_idle =>
				if (rx = '0') then
					state_next <= state_start_bit;
					s_next <= (others => '0');
				end if;
				

			when state_start_bit =>
				-- We entered this state because we saw beginning
				-- of start bit; now we synchronize to the middle (s_reg = 7)
				if (s_tick = '1') then
					if (s_reg = 7) then
						state_next <= state_data;
						s_next <= (others => '0');
						n_next <= (others => '0');
					else
						s_next <= s_reg + 1;
					end if;
				end if;

			when state_data =>
				if (s_tick = '1') then
					if  (s_reg = (SB_TICK - 1)) then
						s_next <= (others => '0');
						b_next <= rx & b_reg(7 downto 1);
						if (n_reg = (DBIT - 1)) then
							state_next <= state_stop_bit;
						else
							n_next <= n_reg + 1;
						end if;
					else
						s_next <= s_reg + 1;
					end if;
				end if;
				
			when state_stop_bit =>
				if (s_tick = '1') then
					if (s_reg = (SB_TICK - 1)) then 
						state_next <= state_idle;
						-- rx_done_tick triggers loading of rx_fifo
						rx_done_tick <= '1';
					else
						s_next <= s_reg + 1;
					end if;
				end if;
		end case;
	end process;
	
	-- rx_received_byte is the continuously updated val from b_reg
	-- the serially received byte.
	-- rx_received_byte is the value to be captured by the one word buffer below.
	rx_received_byte <= b_reg;
	-----------------------------------------------------------------
	-----------------------------------------------------------------
	



	
	-----------------------------------------------------------------
	-----------------------------------------------------------------
	-- This is the FIFO for use with the uart receiver
	-- It makes use of a 1K * 8 block ram generated by wizard
	-- It uses an FSM for memory reads and writes
	-----------------------------------------------------------------
	-----------------------------------------------------------------

	-- 1K, 16 bit word ram generated by coregen
	wea <= wea_reg;
	
-- Was present on 16 October - not sure if it works	
--	u_1k_block : entity work.block_memory_dual_1_KB
--		PORT MAP (
--			clka => clk, -- clk from entity
--			wea => wea,
--			addra => rx_fifo_in_addr,
--			-- dina has hard-wired output from the serial rx fsm
--			dina => rx_received_byte,
--			clkb => clk,
--			addrb => rx_fifo_out_addr,
--			doutb => rx_fifo_data_out
--		);

	u_1k_block : entity work.uart_mem_1
		PORT MAP (
			clka => clk, -- clk from entity
			wea => wea,
			addra => rx_fifo_in_addr,
			-- dina has hard-wired output from the serial rx fsm
			dina => rx_received_byte,
			clkb => clk,
			addrb => rx_fifo_out_addr,
			doutb => rx_fifo_data_out
		);




	-----------------------------------------------------------------
	-- The RX fifo RAM is written on port A with an auto incrementing address
	-- Writes are triggered by the uart rx sub system above using rx_done_tick
	process(
		clk, reset, 
		w_state_next, 
		wea_next,
		val_next
	)
	begin
		if reset = '1' then
			w_state_reg <= w_state_idle;
			read_state_reg <= read_state_idle;
			wea_reg <= "0";
			rx_fifo_in_addr <= (others => '0');
			rx_fifo_out_addr <= (others => '0');
			val_reg <= (others => '0');
			
		elsif (rising_edge(clk)) then
			val_reg <= val_next;
			w_state_reg <= w_state_next;
			read_state_reg <= read_state_next;
			wea_reg <= wea_next;
			rx_fifo_in_addr <= rx_fifo_in_addr_next;
			rx_fifo_out_addr <= rx_fifo_out_addr_next;
		end if;	
	end process;
	-----------------------------------------------------------------


	
	-----------------------------------------------------------------
	-- FSM State Selector for RX FIFO writes
	-- An RX FIFO write is triggered by the uart rcvr rx_done_tick
	-- This FSM loads the byte from the uart rx and updates the ram address
	process (
		w_state_reg, 
		is_host_write_in_progress, 
		rx_done_tick,
		rx_fifo_in_addr
	)
	begin
		w_state_next <= w_state_reg;
		wea_next <= "0";
		rx_fifo_in_addr_next <= rx_fifo_in_addr;
		inc_num_bytes_in_rx_fifo_tick <= '0';
		
		case w_state_reg is 
			when w_state_idle =>
				if (rx_done_tick = '1') then
					wea_next <= "1";
					w_state_next <= w_state_0;
				end if;
				
			-- We know a memory cycle may be in progress;
			-- Is it addressed to us?
			when w_state_0 =>
				w_state_next <= w_state_idle;
				if (rx_fifo_in_addr = MAX_ADDR) then
					rx_fifo_in_addr_next <= (others => '0');
				else
					rx_fifo_in_addr_next <= rx_fifo_in_addr + 1;
				end if;
				inc_num_bytes_in_rx_fifo_tick <= '1';
				
		end case;
	end process;
	-----------------------------------------------------------------


	
	
	-----------------------------------------------------------------
	-- Combinational State selection
	-- for HOST memory read FSM
	-- This process handles read requests (of the RX FIFO) from a host
	process (
		read_state_reg, 
		val_reg,
		is_rx_fifo_read_in_progress,
		rx_fifo_data_out,
		rx_fifo_out_addr,
		cpu_finish,
		addr_bus,
		num_bytes_in_rx_fifo,
		num_bytes_in_tx_fifo,
		dec_num_bytes_in_rx_fifo_tick,
		tx_fifo_is_empty,
		tx_fifo_is_half_empty,
		tx_fifo_is_quarter_empty,
		tx_fifo_is_full,
		rx_fifo_has_char,
		rx_fifo_is_empty,
		rx_fifo_is_quarter_full,
		rx_fifo_is_half_full,
		rx_fifo_is_full
	)
	begin
		read_state_next <= read_state_reg;
		val_next <= val_reg;
		rx_fifo_out_addr_next <= rx_fifo_out_addr;
		dec_num_bytes_in_rx_fifo_tick <= '0';
		
		case read_state_reg is 
			-- A memory cycle can't begin until cpu_finish is asserted
			-- so we wait for it in the idle state.
			when read_state_idle =>

				if (cpu_finish = '1') then
					read_state_next <= read_state_0;
				end if;
				
			-- We know a memory cycle may be in progress;
			-- Is it addressed to us?
			when read_state_0 =>
				read_state_next <= read_state_1;
			
			when read_state_1 =>
				if (is_rx_fifo_read_in_progress = '1') then

					case addr_bus is 
					
					
						when X"0" =>
							read_state_next <= read_state_idle;
							val_next <= X"00" & rx_fifo_data_out;
							if (rx_fifo_out_addr = MAX_ADDR) then
								rx_fifo_out_addr_next <= (others => '0');
							else
								rx_fifo_out_addr_next <= rx_fifo_out_addr + 1;
							end if;
							dec_num_bytes_in_rx_fifo_tick <= '1';
						


						when X"1" =>
							val_next <= X"000" & "00" & rx_fifo_has_char & not(tx_fifo_is_full);
						

						when X"2" =>
							val_next <= X"000" & "000" & tx_fifo_is_empty;

						when X"3" =>
							val_next <= X"000" & "000" & tx_fifo_is_half_empty;

						when X"4" =>
							val_next <= X"000" & "000"  & tx_fifo_is_quarter_empty;

						when  X"5" =>
							val_next <= X"000" & "000"  & tx_fifo_is_full;

						when X"6" => 
							val_next <= X"000" & "000" & rx_fifo_is_empty;

						when X"7" =>
							val_next <= X"000" & "000" & rx_fifo_is_half_full;

						when X"8" =>
							val_next <= X"000" & "000"  & rx_fifo_is_quarter_full;

						when X"9" => 
							val_next <= X"000" & "000"  & rx_fifo_is_full;




							
						when X"E" =>
							val_next <= "00000" & num_bytes_in_rx_fifo;
						when X"F" => 
							val_next <= "00000" & num_bytes_in_tx_fifo;

						when others =>
							val_next <= X"4321";
							
					end case;


				else
				 	read_state_next <= read_state_idle;
				end if;
				
				
		end case;
	end process;
	-----------------------------------------------------------------

	
	
	
	
	
	
	
	
	
	-----------------------------------------------------------------
	-- Keep track of inc_num_bytes_in_rx_fifo.
	-- The count is driven by inc and dec signals.
	-- The inc tick is asserted when a new char is serially recvd.
	-- The dec signal is asserted when the host reads from the fifo.
	process (
		clk, 
		reset, 
		inc_num_bytes_in_rx_fifo_tick, 
		dec_num_bytes_in_rx_fifo_tick
	)
	begin
		if (reset = '1') then
			num_bytes_in_rx_fifo <= (others => '0');
		elsif (rising_edge(clk)) then
			if (inc_num_bytes_in_rx_fifo_tick= '1' and dec_num_bytes_in_rx_fifo_tick = '0') then
				if (num_bytes_in_rx_fifo < 1024) then 
					num_bytes_in_rx_fifo <= num_bytes_in_rx_fifo + 1; 
				end if;
			elsif (inc_num_bytes_in_rx_fifo_tick = '0' and dec_num_bytes_in_rx_fifo_tick= '1') then
				if (num_bytes_in_rx_fifo > 0) then 
					num_bytes_in_rx_fifo <= num_bytes_in_rx_fifo - 1; 
				end if;
			end if;
		end if;		
	end process;
	-----------------------------------------------------------------
	
	
	

	-----------------------------------------------------------------
	-- If a HOST read is in progress (determined combinatorially),
	-- we drive the data bus with the register containing the 
	-- the requested value val_reg.  val_reg was populated
	-- by the FSM above.
	
	fake_data_bus <= data_bus;

	process (is_rx_fifo_read_in_progress, val_reg)
	begin
		if (is_rx_fifo_read_in_progress = '1') then
			data_bus <= val_reg;
		else
			data_bus <= (others => 'Z');
		end if;	
	end process;
	-----------------------------------------------------------------
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	-- 1K, 16 bit word ram generated by coregen
	tx_fifo_wea <= tx_fifo_wea_reg;
	
--	u_tx_fifo_1KB : entity work.block_memory_dual_1_KB
--		PORT MAP (
--			clka => clk, -- clk from entity - OK
--			wea => tx_fifo_wea, -- OK 
--			addra =>  tx_fifo_in_addr, -- auto generated address for host host writes - OK
--			dina => data_bus(7 downto 0),  -- OK
--			-- dina => X"42",
--			clkb => clk, --
--			addrb => tx_fifo_out_addr,
--			doutb => tx_fifo_data_out
--		);



	u_tx_fifo_1KB : entity work.uart_mem_1
		PORT MAP (
			clka => clk, -- clk from entity - OK
			wea => tx_fifo_wea, -- OK 
			addra =>  tx_fifo_in_addr, -- auto generated address for host host writes - OK
			dina => data_bus(7 downto 0),  -- OK
			-- dina => X"42",
			clkb => clk, --
			addrb => tx_fifo_out_addr,
			doutb => tx_fifo_data_out
		);




	
	-----------------------------------------------------------------
	-- Keep track of inc_num_bytes_in_tx_fifo.
	-- The count is driven by inc and dec signals.
	-- The inc tick is asserted when a new char is serially recvd.
	-- The dec signal is asserted when the host reads from the fifo.
	process (
		clk, 
		reset, 
		inc_num_bytes_in_tx_fifo_tick, 
		dec_num_bytes_in_tx_fifo_tick
	)
	begin
		if (reset = '1') then
			num_bytes_in_tx_fifo <= (others => '0');
		elsif (rising_edge(clk)) then
			if (inc_num_bytes_in_tx_fifo_tick= '1' and dec_num_bytes_in_tx_fifo_tick = '0') then
				if (num_bytes_in_tx_fifo < 1024) then
					num_bytes_in_tx_fifo <= num_bytes_in_tx_fifo + 1; 
				end if;
			elsif (inc_num_bytes_in_tx_fifo_tick = '0' and dec_num_bytes_in_tx_fifo_tick= '1') then
				if (num_bytes_in_tx_fifo > 0) then
					num_bytes_in_tx_fifo <= num_bytes_in_tx_fifo - 1; 
				end if;
			end if;
		end if;		
	end process;
	-----------------------------------------------------------------



		-----------------------------------------------------------------
	-- Host Write FSM Synchronous process 
	-- All that happens here is the state change
	-- AND assignment of any internal storage
	process(
		clk, reset, 
		w_state_next, 
		tx_fifo_wea_next,
		val_next
	)
	begin
		if reset = '1' then
			tx_fsm_w_state_reg <= tx_fsm_w_state_idle;
			tx_fifo_wea_reg <= "0";
			tx_fifo_in_addr <= (others => '0');
			
		elsif (rising_edge(clk)) then
			tx_fsm_w_state_reg <= tx_fsm_w_state_next;
			tx_fifo_wea_reg <= tx_fifo_wea_next;
			tx_fifo_in_addr <= tx_fifo_in_addr_next;
		end if;	
	end process;
	-----------------------------------------------------------------
	
	-----------------------------------------------------------------
	-- This is the state selection process of the 
	-- FSM activated by a host write to the TX FIFO.
	--
	process (
		tx_fsm_w_state_reg, 
		is_host_write_in_progress, 
		tx_fifo_in_addr,
		cpu_finish
	)
	begin
		tx_fsm_w_state_next <= tx_fsm_w_state_reg;
		tx_fifo_wea_next <= "0";
		inc_num_bytes_in_tx_fifo_tick <= '0';
		tx_fifo_in_addr_next <= tx_fifo_in_addr;
		
		case tx_fsm_w_state_reg is 
			-- A memory cycle can't begin until cpu_finish is asserted
			-- so we wait for it in the idle state.
			when tx_fsm_w_state_idle =>

				if (cpu_finish = '1') then
					tx_fsm_w_state_next <= tx_fsm_w_state_0;
				end if;
				
				
			-- We know a memory cycle may be in progress;
			-- Is it addressed to us?
			when tx_fsm_w_state_0 =>
				if (is_host_write_in_progress = '1') then
					tx_fsm_w_state_next <= tx_fsm_w_state_1;
					tx_fifo_wea_next <= "1";
				else
					tx_fsm_w_state_next <= tx_fsm_w_state_idle;
				end if;
		
			when tx_fsm_w_state_1 =>
				tx_fsm_w_state_next <= tx_fsm_w_state_2;
				if (tx_fifo_in_addr = MAX_ADDR) then
					tx_fifo_in_addr_next <= (others => '0');
				else
					tx_fifo_in_addr_next <= tx_fifo_in_addr + 1;
				end if;
						
			when tx_fsm_w_state_2 =>
				tx_fsm_w_state_next <= tx_fsm_w_state_idle;
				inc_num_bytes_in_tx_fifo_tick <= '1';
						
				
		end case;
	end process;
	-----------------------------------------------------------------


	-----------------------------------------------------------------
	-- Synchronous FSM process used to retrieve values from fifo,
	-- advance out addr and do serial transmission
	process(
		clk, reset, 
		tx_fsm2_state_next,
		tx_fsm2_s_next, tx_fsm2_n_next, tx_fsm2_b_next, tx_next
	)
	begin
		if reset = '1' then
			tx_fsm2_state_reg <= tx_fsm2_state_idle;

			tx_fsm2_s_reg <= (others => '0');
			tx_fsm2_n_reg <= (others => '0');
			tx_fsm2_b_reg <= (others => '0');
			tx_fifo_out_addr <= (others => '0');
			
			tx_reg <= '1';
			
		elsif (rising_edge(clk)) then
			tx_fsm2_state_reg <= tx_fsm2_state_next;
			
			tx_fsm2_s_reg <= tx_fsm2_s_next;
			tx_fsm2_n_reg <= tx_fsm2_n_next;
			tx_fsm2_b_reg <= tx_fsm2_b_next;
			tx_fifo_out_addr <= tx_fifo_out_addr_next;
			
			tx_reg <= tx_next;
			
		end if;	
	end process;
	-----------------------------------------------------------------

	
	-----------------------------------------------------------------
	-- Combinational State selection
	-- tx serial transmitter fsm state selection
	process (
		tx_fsm2_state_reg, 
		tx_fsm2_s_reg,
		tx_fsm2_n_reg,
		tx_fsm2_b_reg,
		s_tick,
		num_bytes_in_tx_fifo,
		tx_fifo_data_out,
		tx_fifo_out_addr,
		tx_reg
	)
	begin
		tx_fsm2_state_next <= tx_fsm2_state_reg;
		tx_fsm2_s_next <= tx_fsm2_s_reg;
		tx_fsm2_n_next <= tx_fsm2_n_reg;
		tx_fsm2_b_next <= tx_fsm2_b_reg;
		tx_next <= tx_reg;
		dec_num_bytes_in_tx_fifo_tick <= '0';
		tx_fifo_out_addr_next <= tx_fifo_out_addr;
		

		case tx_fsm2_state_reg is 

			when tx_fsm2_state_idle =>
				if (num_bytes_in_tx_fifo > 0 ) then 
					tx_fsm2_state_next <= tx_fsm2_state_start_bit;
					-- The byte to be transmitted, tx_fifo_data_out, comes directly from block ram
					tx_fsm2_b_next <= tx_fifo_data_out;
					tx_fsm2_s_next <= (others => '0');
					dec_num_bytes_in_tx_fifo_tick <= '1';
					if (tx_fifo_out_addr = MAX_ADDR) then
						tx_fifo_out_addr_next <= (others => '0');
					else
						tx_fifo_out_addr_next <= tx_fifo_out_addr + 1;
					end if;
					
				else
				 	tx_fsm2_state_next <= tx_fsm2_state_idle;
				end if;

			when tx_fsm2_state_start_bit =>
				-- Drive the start bit and 
				-- hold it for 16 cycles
				tx_next <= '0'; 
				if (s_tick = '1') then
					if (tx_fsm2_s_reg = (SB_TICK - 1)) then
						tx_fsm2_state_next <= tx_fsm2_state_data;
						tx_fsm2_s_next <= (others => '0');
						tx_fsm2_n_next <= (others => '0');
					else
						tx_fsm2_s_next <= tx_fsm2_s_reg + 1;
					end if;
				end if;

			when tx_fsm2_state_data =>
				tx_next <= tx_fsm2_b_reg(0);
				if (s_tick = '1') then
					if  (tx_fsm2_s_reg = (SB_TICK - 1)) then
						tx_fsm2_s_next <= (others => '0');
						tx_fsm2_b_next <= '0' & tx_fsm2_b_reg(7 downto 1);
						if (tx_fsm2_n_reg = 7) then
							tx_fsm2_state_next <= tx_fsm2_state_stop_bit;
						else
							tx_fsm2_n_next <= tx_fsm2_n_reg + 1;
						end if;
					else
						tx_fsm2_s_next <= tx_fsm2_s_reg + 1;
					end if;
				end if;
				
			when tx_fsm2_state_stop_bit =>
				tx_next <= '1';
				if (s_tick = '1') then
					if (tx_fsm2_s_reg = (SB_TICK - 1)) then 
						tx_fsm2_state_next <= tx_fsm2_state_idle;
						-- tx_done_tick <= '1';
					else
						tx_fsm2_s_next <= tx_fsm2_s_reg + 1;
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
