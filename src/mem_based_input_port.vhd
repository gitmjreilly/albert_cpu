library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


---------------------------------------------------------------------
entity mem_based_input_port is port (
	n_cs : in std_logic;
	n_rd : in std_logic;
	in_bit_0 : in std_logic;
	in_bit_1 : in std_logic;
	in_bit_2 : in std_logic;
	in_bit_3 : in std_logic;
	in_bit_4 : in std_logic;
	in_bit_5 : in std_logic;
	in_bit_6 : in std_logic;
	in_bit_7 : in std_logic;
	address_bus : in std_logic_vector(2 downto 0);
	data_bus : out std_logic_vector(15 downto 0)
);
end mem_based_input_port;
---------------------------------------------------------------------


---------------------------------------------------------------------
architecture behavioural of mem_based_input_port is

signal b0 : std_logic;
	
begin
	process (n_rd, n_cs, b0, in_bit_0, in_bit_1, in_bit_2, in_bit_3, in_bit_4, in_bit_5, in_bit_6, in_bit_7,  address_bus)
	begin
		if (n_rd = '0' and n_cs = '0')  then
                case address_bus is 
                    when "000" => 
                        b0 <= in_bit_0;
                    when "001" =>
                        b0 <= in_bit_1;
                    when "010" =>
                        b0 <= in_bit_2;
                    when "011" =>
                        b0 <= in_bit_3;
                    when "100" =>
                        b0 <= in_bit_4;
                    when "101" =>
                        b0 <= in_bit_5;
                    when "110" =>
                        b0 <= in_bit_6;
                    when "111" =>
                        b0 <= in_bit_7;
                end case;
			    data_bus <= X"000" & "000" & b0;
		else
		      -- set b0 to avoid inferring a latch
		      b0 <= '0';					 	
				data_bus <= (others => 'Z');
		end if;

	end process;
	
end behavioural;
---------------------------------------------------------------------
