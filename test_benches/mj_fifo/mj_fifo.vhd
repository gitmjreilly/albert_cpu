--
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity mj_fifo is
	Port ( 
		system_clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
        data_in : in std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(15 downto 0);
		clear_tick : in  STD_LOGIC;
		push_tick : in  STD_LOGIC;
		pop_tick : in  STD_LOGIC;
        is_empty : out std_logic
    );
end mj_fifo;

	

architecture Behavioral of mj_fifo is

	signal val_reg, val_next : std_logic_vector(15 downto 0);


    type t_fifo_memory  is array (0 to 3) of std_logic_vector(15 downto 0);
    signal fifo_memory : t_fifo_memory := (others => (others => '0'));
    signal push_address : unsigned(15 downto 0);
    signal pop_address : unsigned(15 downto 0);
 
	
begin


    process(system_clock, reset, push_tick, pop_tick, clear_tick)
    begin
		if (reset = '1') then
            pop_address <= (others => '0');
            push_address <= (others => '0');
		elsif (rising_edge(system_clock)) then
            if (clear_tick = '1') then
                pop_address <= (others => '0');
                push_address <= (others => '0');
            end if;

            if (push_tick = '1') then
                fifo_memory(to_integer(push_address)) <= data_in;
                push_address <= push_address + 1;
            end if;

            if (pop_tick = '1') then
                data_out <= fifo_memory(to_integer(pop_address));
                pop_address <= pop_address + 1;
            end if;
        end if;
    end process;

    is_empty <= '1' when (pop_address = push_address) else '0';
                
	
	

end Behavioral;

