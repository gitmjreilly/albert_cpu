--
-- This is a simple output port
-- It is meant to be memory mapped.
-- It supports 1 address:
--		Address 00 - word to be written
--
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mem_based_output_port is
    Port ( 
		clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		cpu_finish : in std_logic;
		addr_bus : in  STD_LOGIC_VECTOR (3 downto 0);
		data_bus : inout std_logic_vector(15 downto 0);
		int_occurred : out  STD_LOGIC;
		n_cs : in  STD_LOGIC;
		n_wr : in  STD_LOGIC;
		n_rd : in  STD_LOGIC
	;
end mem_based_output_port;



architecture Behavioral of mem_based_output_port is

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


	signal write_port : std_logic_vector(15 downto 0);
	signal write_port_next : std_logic_vector(15 downto 0);

	
begin
	int_occurred <= '0' when status_reg = X"0000" else '1';


	-----------------------------------------------------------------
	-- This signal indicates a write is in progress by the host.
	-- It is asserted during the entire microcode cycle.
	-- It is NOT edge based.
	-- Please note all reads and writes are from the host's perspective
	is_write_in_progress <= '1' when ((n_cs = '0') and (n_wr = '0')) else '0';
	-----------------------------------------------------------------
 

	
	-----------------------------------------------------------------
	process(clock, reset, w_state_next, write_port_next)
	begin
		if (reset = '1') then
			w_state_reg <= state_idle;
			write_port <= (others => '0');
		elsif (rising_edge(clock)) then
			w_state_reg <= w_state_next;
			write_port <= write_port_next;
		end if;
	end process;
	
	
	process (
		w_state_reg, write_port, cpu_finish, is_write_in_progress, addr_bus, data_bus)
	begin
		w_state_next <= w_state_reg;
		write_port_next <= write_port;

		case w_state_reg is
			when state_idle =>
				if (cpu_finish = '1') then
					w_state_next <= state_0;
				end if;
				
			when state_0 =>
				if (is_write_in_progress = '1') then
					case addr_bus is 
						when X"0" => 
							write_port_next <= data_bus;
							w_state_next <= state_idle;
						when others =>
							w_state_next <= state_idle;
					end case;
				end if;
		

		end case;
				
	end process;
	-----------------------------------------------------------------
	
	
	
end Behavioral;

