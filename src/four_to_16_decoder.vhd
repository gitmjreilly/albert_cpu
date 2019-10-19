library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity four_to_16_decoder is
    Port ( input : in std_logic_vector(3 downto 0);
           output : out std_logic_vector(15 downto 0));
end four_to_16_decoder;

architecture Behavioral of four_to_16_decoder is

begin

	output <= 	"0000000000000001" when (input = "0000") else
					"0000000000000010" when (input = "0001") else
					"0000000000000100" when (input = "0010") else
					"0000000000001000" when (input = "0011") else
					"0000000000010000" when (input = "0100") else
					"0000000000100000" when (input = "0101") else
					"0000000001000000" when (input = "0110") else
					"0000000010000000" when (input = "0111") else
					"0000000100000000" when (input = "1000") else
					"0000001000000000" when (input = "1001") else
					"0000010000000000" when (input = "1010") else
					"0000100000000000" when (input = "1011") else
					"0001000000000000" when (input = "1100") else
					"0010000000000000" when (input = "1101") else
					"0100000000000000" when (input = "1110") else
					"1000000000000000" when (input = "1111") else
					"0000000000000000";


end Behavioral;
