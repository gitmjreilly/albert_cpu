library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mdr is
    port (	
		clock : in std_logic;
		mem_data_bus : inout std_logic_vector(15 downto 0);
		c_bus : in std_logic_vector(15 downto 0);
		load_mem_data_bus : in std_logic;
		load_c_bus : in std_logic;
		out_mem_data_bus : in std_logic;
		out_b_bus : in std_logic;
		b_bus : out std_logic_vector(15 downto 0);
		always_out : out std_logic_vector(15 downto 0);
		enable : in std_logic
	);      
end mdr;



architecture behavioural of mdr is


signal stored_word : std_logic_vector(15 downto 0);


begin
	process(clock, load_mem_data_bus, load_c_bus)
	begin
		if (rising_edge(clock)) then
			if (enable = '1') then
				if (load_mem_data_bus = '1') then
					stored_word <= mem_data_bus;
				elsif (load_c_bus = '1') then
					stored_word <= c_bus;
				end if;
			end if;
		end if;
	end process;
	
	
	-- Level driven outputs
	b_bus <= stored_word when out_b_bus = '1' else (others => 'Z');
	mem_data_bus <= stored_word when out_mem_data_bus = '1' else (others => 'Z');
	always_out <= stored_word;

end behavioural;

