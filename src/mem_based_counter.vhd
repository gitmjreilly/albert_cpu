library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mem_based_counter is
    Port (
           clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  n_rd : in std_logic;
			  n_cs : in std_logic;
           x_edge : out  STD_LOGIC;
           x_delayed_out : out  STD_LOGIC;
           x_synced_out : out  STD_LOGIC;
			fast_counter_out : out std_logic_vector(20 downto 0);
			counter_is_zero_out : out std_logic;
			counter_out : out std_logic_vector(15 downto 0)
	);
end mem_based_counter;

architecture Behavioral of mem_based_counter is

signal x_delayed : std_logic;
signal x_synced : std_logic;

  -- signals used to fsm physical switch input
   -- Added attribute line below to remove XST warning 2677
   -- about FF trimming.  Apparently it is a bug in xst.
   -- Dont' actually know what "attribute" does...
   attribute KEEP : string;
   signal fast_counter : std_logic_vector(20 downto 0);
   attribute KEEP of fast_counter : signal is "TRUE";
	signal fsm_clock : std_logic;



signal counter : std_logic_vector(15 downto 0);
signal derived_clock : std_logic;
signal counter_is_zero : std_logic;
signal pulse_clock : std_logic;

begin

	-- fast_counter is driven by the underlying clock on the fpga board
	-- On Nexys 3 this is 100Mhz
	fast_count: process (clock, reset)
	begin
		if (reset = '1') then
			fast_counter <= (others => '0');
		elsif (falling_edge(clock)) then
			fast_counter <= fast_counter + 1;
		end if;
	end process;
	
	--
	-- Divisor = 2^(fast_counter_bit_num + 1)
	-- derived_clock <= fast_counter(0) means divisor = 2^(0+1) = 2
	--
	-- 25MHz / 64k / 32 = 10ms
	-- 10Mhz / 64k / 2^8 = 16 seconds?
--	derived_clock <= fast_counter(2);

	derived_clock <= fast_counter(2);

	count: process (derived_clock, reset)
	begin
		if (reset = '1') then
			counter <= (others => '0');
		elsif (falling_edge(derived_clock)) then
			counter <= counter + 1;
		end if;
	end process;
	
	
	
	process(reset, derived_clock)
	begin
		if (reset = '1') then
			x_synced <= '0';
			x_delayed <= '0';
		elsif (falling_edge(derived_clock)) then
--			x_synced <= x;
			x_synced <= counter_is_zero;
			x_delayed <= x_synced;
		end if;
	end process;
	
	x_delayed_out <= x_delayed;
	x_synced_out <= x_synced;
	fast_counter_out <= fast_counter;
	counter_out <= counter when (n_cs = '0') and (n_rd = '0') else (others => 'Z');
	counter_is_zero <= '1' when (counter = "0000000000000000") else '0';
	counter_is_zero_out <= counter_is_zero;


	process (x_synced, x_delayed)
	begin
		x_edge <= x_synced and not x_delayed;
	end process;
end Behavioral;

