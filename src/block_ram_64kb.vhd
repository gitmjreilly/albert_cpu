
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity block_ram_64kb is
	port (
		clk : in std_logic;
		reset : in std_logic;
		cpu_finish : in std_logic;
		addr_bus : in std_logic_vector(15 downto 0);
		data_bus : inout std_logic_vector(15 downto 0);
		n_cs : in std_logic;
		n_rd : in std_logic;
		n_wr : in std_logic
	);
end block_ram_64kb;

architecture Behavioral of block_ram_64kb is


	type r_state_type is (r_state_idle, r_state_0, r_state_1, r_state_2);
	type w_state_type is (w_state_idle, w_state_0, w_state_1);

	signal r_state_reg, r_state_next : r_state_type;
	signal w_state_reg, w_state_next : w_state_type;
	
	signal val_reg, val_next : std_logic_vector(15 downto 0);

	
	signal is_read_in_progress  : std_logic; 
	signal is_write_in_progress : std_logic;
	
	-- signal wea : std_logic_vector(0 downto 0);
	signal wea_next, wea_reg : std_logic_vector(0 downto 0);
	

	signal wea : std_logic_vector(0 downto 0);
	signal douta : std_logic_vector(15 downto 0);
	signal output_enable : std_logic;
	

	-- COMPONENT blk_64_KB
	  -- PORT (
		-- clka : IN STD_LOGIC;
		-- ena : IN STD_LOGIC;
		-- wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		-- addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		-- dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		-- douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	  -- );
	-- END COMPONENT;



	-- COMPONENT blk_mem_gen_64KW_2
	  -- PORT (
		-- clka : IN STD_LOGIC;
		-- rsta : IN STD_LOGIC;
		-- wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		-- addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		-- dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		-- douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	  -- );
	-- END COMPONENT;
			

--	COMPONENT blk_mem_gen_4
--	  PORT (
--		clka : IN STD_LOGIC;
--		wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--		addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
--		dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
--		douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
--	  );
--	END COMPONENT;		
	
			
begin

	-----------------------------------------------------------------
	-- These 2 signals indicate either a read or write is in 
	-- progress by the host.
	-- They are asserted during the entire microcode cycle.
	-- They are NOT edge based.
	-- Please note all reads and writes are from the host's perspective
	is_read_in_progress  <= '1' when ((n_cs = '0') and (n_rd = '0')) else '0';
	is_write_in_progress <= '1' when ((n_cs = '0') and (n_wr = '0')) else '0';
	-----------------------------------------------------------------

 
	-- This one didn't work
	-- u_blk_64KB : blk_64_KB
		-- port map (
			-- clka => clk,
			-- ena => '1',
			-- wea => wea_reg,
			-- addra => addr_bus,
			-- dina => data_bus,
			-- dina => X"0007",
			-- douta => douta
		-- );

	u_blk_64KW : entity work.block_ram_64_KW
	  PORT MAP (
		clka => clk,
		wea => wea_reg,
		addra => addr_bus,
		dina => data_bus,
		douta => douta
	  );
		

	
	-----------------------------------------------------------------
	-- Host Read/Write FSM Synchronous process 
	-- All that happens here is the state change
	-- AND assignment of any internal storage
	process(
		clk, reset, 
		w_state_next, 
		wea_next,
		val_next
	)
	begin
		if reset = '1' then
			w_state_reg <= w_state_idle;
			r_state_reg <= r_state_idle;
			wea_reg <= "0";
			val_reg <= (others => '0');
			
		elsif (rising_edge(clk)) then
			w_state_reg <= w_state_next;
			r_state_reg <= r_state_next;
			wea_reg <= wea_next;
			
			val_reg <= val_next;
		end if;	
	end process;
	-----------------------------------------------------------------

	
	-----------------------------------------------------------------
	-- Combinational State selection
	-- for memory write FSM
	-- This process handles read requests from a host
	process (
		w_state_reg, 
		is_write_in_progress, 
		cpu_finish, 
		data_bus
	)


	begin
		w_state_next <= w_state_reg;
		wea_next <= "0";
		
		case w_state_reg is 
			-- A memory cycle can't begin until cpu_finish is asserted
			-- so we wait for it in the idle state.
			when w_state_idle =>

				if (cpu_finish = '1') then
					w_state_next <= w_state_0;
				end if;			
				
			-- We know a memory cycle may be in progress;
			-- Is it addressed to us?
			when w_state_0 =>
				if (is_write_in_progress = '1') then
					w_state_next <= w_state_1;
					wea_next <= "1";
				else
					w_state_next <= w_state_1;
				end if;
		
			when w_state_1 =>
				w_state_next <= w_state_idle;
				
				
		end case;
	end process;
	-----------------------------------------------------------------


	
	-----------------------------------------------------------------
	-- Combinational State selection
	-- for memory read FSM
	-- This process handles read requests from a host
	process (
		r_state_reg, 
		val_reg,
		is_read_in_progress, 
		addr_bus, cpu_finish,
		douta
	)
	begin
		r_state_next <= r_state_reg;
		val_next <= val_reg;

		case r_state_reg is 
			-- A memory cycle can't begin until cpu_finish is asserted
			-- so we wait for it in the idle state.
			when r_state_idle =>

				if (cpu_finish = '1') then
					r_state_next <= r_state_0;
				end if;
				
			-- We know a memory cycle may be in progress;
			-- Is it addressed to us?
			when r_state_0 =>
				if (is_read_in_progress = '1') then
					r_state_next <= r_state_1;
				else
				 	r_state_next <= r_state_idle;
				end if;
				
			when r_state_1 =>
				r_state_next <= r_state_2;
				
			when r_state_2 =>
				r_state_next <= r_state_idle;
				val_next <= douta;
				
				
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
	-----------------------------------------------------------------
	
	
end Behavioral;
