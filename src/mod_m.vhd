library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod_m is
	generic (
		N : integer := 2; -- num bits
		M : integer := 10 -- MOD M
	);
	port (
		clk : in std_logic;
		reset : in std_logic;
		max_tick : out std_logic
	);
end mod_m;
	

architecture behavioural of mod_m is

	signal r_reg, r_next : unsigned(N - 1 downto 0);
	
begin

	process(clk, reset)
	begin
		if (reset = '1') then
			r_reg <= (others => '0');
		elsif (rising_edge(clk)) then
			r_reg <= r_next;
		end if;
	end process;
	
	-- Very Simple "Next State" logic
	r_next <= (others => '0') when r_reg = (M - 1) else r_reg + 1;
	
	-- max_tick output...
	max_tick <= '1' when r_reg = (M - 1) else '0';

end behavioural;
