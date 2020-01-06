library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mem_io_no_finish_tb is
end mem_io_no_finish_tb;

architecture behave of mem_io_no_finish_tb is


	
	signal reset : std_logic;
	signal addr_bus : std_logic_vector(15 downto 0);
	signal data_bus : std_logic_vector(15 downto 0);
	signal n_cs : std_logic := '1';
	signal n_wr : std_logic := '1';
	signal n_rd : std_logic := '1';


    signal system_clock : std_logic ;
    signal cpu_clock : std_logic ;


component mem_based_fsm_template is
	Port ( 
		cpu_clock : in  STD_LOGIC;
		system_clock : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		addr_bus : in  STD_LOGIC_VECTOR (3 downto 0);
		data_bus : inout std_logic_vector(15 downto 0);
		n_cs : in  STD_LOGIC;
		n_wr : in  STD_LOGIC;
		n_rd : in  STD_LOGIC)
	;
end component;



begin
	-- This is the thing we are testing
	fsm_template : mem_based_fsm_template port map(
		cpu_clock => cpu_clock,
		system_clock => system_clock,
		reset => reset,
		addr_bus => addr_bus(3 downto 0),
		data_bus => data_bus,
		n_cs => n_cs,
		n_wr => n_wr,
		n_rd => n_rd);



    process
        variable i : integer;
    begin
		reset <= '1';
		wait for 20 ns;
		reset <= '0';
        for i in 0 to 15 loop
	        cpu_clock <= '1'; system_clock <= '0'; wait for 10 ns;
	        cpu_clock <= '1'; system_clock <= '1'; wait for 10 ns;
	        cpu_clock <= '0'; system_clock <= '0'; wait for 10 ns;
	        cpu_clock <= '0'; system_clock <= '1'; wait for 10 ns;
        end loop;

        wait;
    end process;


    process

    begin
        wait until rising_edge(cpu_clock);
        wait for 1 ns;
        n_wr <= '0'; 
        n_cs <= '0'; 
        data_bus <= X"0017";
        addr_bus <= X"0001";

        wait until rising_edge(cpu_clock);
        wait for 1 ns;
        n_wr <= '1'; 
        n_cs <= '1'; 
        data_bus <= (others => 'Z');

        wait until rising_edge(cpu_clock);
        wait until rising_edge(cpu_clock);

        wait until rising_edge(cpu_clock);
        wait for 1 ns;
        n_rd <= '0'; 
        n_cs <= '0'; 

        wait until rising_edge(cpu_clock);
        wait for 1 ns;
        n_rd <= '1'; 
        n_cs <= '1'; 
        data_bus <= (others => 'Z');



        wait;


    end process;


end behave;

