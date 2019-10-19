library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mem_addr_gen is
    Port ( pc_in : in std_logic_vector(15 downto 0);
           mar_in : in std_logic_vector(15 downto 0);
           es_in : in std_logic_vector(15 downto 0);
           cs_in : in std_logic_vector(15 downto 0);
           ds_in : in std_logic_vector(15 downto 0);
           addr_out : out std_logic_vector(19 downto 0);
           use_pc : in std_logic;
           use_mar : in std_logic;
           use_es : in std_logic			  
);
end mem_addr_gen;

architecture Behavioral of mem_addr_gen is

signal input_selector : std_logic_vector(2 downto 0);
signal cs_sum : std_logic_vector(19 downto 0);
signal ds_sum : std_logic_vector(19 downto 0);
signal es_sum : std_logic_vector(19 downto 0);

begin
	input_selector(0) <= use_pc;
	input_selector(1) <= use_mar;
	input_selector(2) <= use_es;

	with input_selector select
		addr_out <=
			cs_sum when "001",
			ds_sum when "010",
			es_sum when "110",
			"ZZZZZZZZZZZZZZZZZZZZ" when others;

   cs_sum <= (cs_in & "0000") + ("0000" & pc_in);
   ds_sum <= (ds_in & "0000") + ("0000" & mar_in);
   es_sum <= (es_in & "0000") + ("0000" & mar_in);

end Behavioral;
