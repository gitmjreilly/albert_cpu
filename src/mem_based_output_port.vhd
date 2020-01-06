-- TODO remove cpu_finish; add two clocks
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


---------------------------------------------------------------------
entity mem_based_output_port is port (
	reset : in std_logic;
	clk : in std_logic;
	cpu_finish : in std_logic;
	n_cs : in std_logic;
	n_wr : in std_logic;
	address_bus : in std_logic_vector(2 downto 0);
	in_bit : in std_logic;

	out_bit_0 : out std_logic;
	out_bit_1 : out std_logic;
	out_bit_2 : out std_logic;
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
	
begin
	-- process (clk, reset, in_bit)
	process (reset, cpu_finish, clk, in_bit, address_bus)
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
		elsif (rising_edge(clk)) then
			if (cpu_finish = '1' and n_wr = '0' and n_cs = '0')  then
			
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
