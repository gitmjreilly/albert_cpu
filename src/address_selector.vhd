library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity address_selector is
    Port ( MBR : in std_logic_vector(7 downto 0);
           ADDR : in std_logic_vector(7 downto 0);
			  INT_VEC : in std_logic_vector(7 downto 0);
           JMPC : in std_logic;
			  INT_OCCURRED : in std_logic;
           OUTPUT : out std_logic_vector(7 downto 0));
end address_selector;

architecture Behavioral of address_selector is

begin
--	OUTPUT <= (MBR OR ADDR) when (JMPC = '1') else (ADDR);
	
	OUTPUT <= 
		INT_VEC when (INT_OCCURRED = '1') else 
		(MBR OR ADDR) when (JMPC = '1') else
		ADDR;
					
end Behavioral;
