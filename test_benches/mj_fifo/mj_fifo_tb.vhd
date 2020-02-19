library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mj_fifo_tb is
end mj_fifo_tb;

architecture behave of mj_fifo_tb is
	
	signal reset : std_logic;
	signal data_in : std_logic_vector(15 downto 0);
    signal push_tick : std_logic;
    signal pop_tick : std_logic;
    signal clear_tick : std_logic;

    signal system_clock : std_logic ;




component mj_fifo is
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
end component;



begin
	-- This is the thing we are testing
	u_mj_fifo: mj_fifo port map(
		system_clock => system_clock,
		reset => reset,
        data_in => data_in,
        clear_tick => clear_tick,
        push_tick => push_tick,
        pop_tick => pop_tick);



    process
    begin
		reset <= '1';
		wait for 20 ns;
		reset <= '0';
        for i in 0 to 15 loop
	        system_clock <= '1'; system_clock <= '0'; wait for 10 ns;
	        system_clock <= '1'; system_clock <= '1'; wait for 10 ns;
	        system_clock <= '0'; system_clock <= '0'; wait for 10 ns;
	        system_clock <= '0'; system_clock <= '1'; wait for 10 ns;
        end loop;

        wait;
    end process;


    process

    begin

        push_tick <= '0';
        wait until rising_edge(system_clock);

        push_tick <= '1';
        data_in <= X"0017";
        wait until rising_edge(system_clock);
        wait for 1 ns;


        push_tick <= '0';
        wait until rising_edge(system_clock);

        push_tick <= '0';
        wait until rising_edge(system_clock);

        push_tick <= '0';
        wait until rising_edge(system_clock);


        push_tick <= '1';
        data_in <= X"00AB";
        wait until rising_edge(system_clock);


        push_tick <= '0';
        wait until rising_edge(system_clock);


        pop_tick <= '1';
        wait until rising_edge(system_clock);

        pop_tick <= '0';
        wait until rising_edge(system_clock);
        wait until rising_edge(system_clock);

        pop_tick <= '1';
        wait until rising_edge(system_clock);

        pop_tick <= '0';
        wait until rising_edge(system_clock);



        wait;


    end process;


end behave;

