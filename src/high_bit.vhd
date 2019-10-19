--------------------------------------------------------------------------------
-- This module implements the high bit logic found on p 214 of Tanenbaum
-- Modified on April 9th, 2006 to support "carry" in addition to Zero and Neg.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity high_bit is
    Port ( N : in std_logic;
           Z : in std_logic;
			  CY : in std_logic;
           JAMN : in std_logic;
           JAMZ : in std_logic;
			  JAMY : in std_logic;
           ADDR_8 : in std_logic;
           OUTPUT : out std_logic);
end high_bit;

architecture Behavioral of high_bit is

begin

	OUTPUT <= (JAMZ AND Z) OR (JAMN AND N) OR (JAMY AND CY) OR ADDR_8;

end Behavioral;
