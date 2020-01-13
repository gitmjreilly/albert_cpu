-- TODO remove cpu_finish; add two clocks
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


---------------------------------------------------------------------
entity mem_based_output_port is port (
	reset : in std_logic;
	system_clock : in std_logic;
	cpu_clock : in std_logic;
	n_cs : in std_logic;
	n_wr : in std_logic;
	address_bus : in std_logic_vector(2 downto 0);
	in_bit : in std_logic;

	out_bit_0 : out std_logic;
	out_bit_1 : out std_logic;	out_bit_2 : out std_logic;
	out_bit_3 : out std_logic;
	out_bit_4 : out std_logic;
	out_bit_5 : out std_logic;
	out_bit_6 : out std_logic;
	out_bit_7 : out std_logic
);
end mem_based_output_port;
---------------------------------------------------------------------


---------------------------------------------------------------------
architecture behavioural of mem_based_output_port is

   signal previous_cpu_clock : std_logic;
   	
begin


 
	-----------------------------------------------------------------
	-- This process captures the previous_cpu_clock
	-- so the FSM's below can detect cpu_clock_edges
	-- and triggers and triggers a write to this thing
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
	
	



	-- process (clk, reset, in_bit)
	process (reset, system_clock, previous_cpu_clock, cpu_clock, in_bit, address_bus)
	begin
		if (reset = '1') then
			out_bit_0 <= '0';
			out_bit_1 <= '0';
			out_bit_2 <= '0';
			out_bit_3 <= '0';
			out_bit_4 <= '0';
			out_bit_5 <= '0';
			out_bit_6 <= '0';
			out_bit_7 <= '0';
		elsif (rising_edge(system_clock)) then
            if previous_cpu_clock = '0' AND cpu_clock = '1' AND n_wr = '0' AND n_cs = '0' then
			
                case address_bus is 
                    when "000" => 
                        out_bit_0 <= in_bit;
                    when "001" =>
                      out_bit_1 <= in_bit;
                    when "010" =>
                        out_bit_2 <= in_bit;
                    when "011" =>
                        out_bit_3 <= in_bit;
                    when "100" =>
                        out_bit_4 <= in_bit;
                    when "101" =>
                        out_bit_5 <= in_bit;
                    when "110" =>
                        out_bit_6 <= in_bit;
                    when "111" =>
                        out_bit_7 <= in_bit;
                end case;
                
                    
			end if;
		end if;
	end process;
	
end behavioural;
---------------------------------------------------------------------
