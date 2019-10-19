library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity compound_register is
	generic (
		width : integer := 16
	);

    port ( 
		clk           : in std_logic;
		reset         : in std_logic;
		
		in1           : in  std_logic_vector((width - 1) downto 0);
		
		out1          : out std_logic_vector((width - 1) downto 0);
		out2          : out std_logic_vector((width - 1) downto 0);
		
		output_enable : in  std_logic;
		
		latch        : in std_logic;
		enable       : in std_logic

	);
end compound_register;

--
-- This Simple Reg is a register because of the implied need 
-- to hold Q's state.
--
architecture behave of compound_register is
signal internal_state : std_logic_vector((width - 1) downto 0);

begin

	out1 <= internal_state when (output_enable = '1')  else  (others => 'Z') ;
	out2 <= internal_state;

	process (clk, reset)
	begin	
	   if reset = '1' then 
         internal_state <= (others => '0');
      elsif	clk'event and clk='1' then  
			if ( (enable = '1') and (latch = '1') )then
				internal_state <= in1;
			end if;
     	end if;
	end process;

	
end behave;

