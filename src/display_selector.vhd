--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity display_selector		is port (
				word0 : in std_logic_vector(15 downto 0);
				word1 : in std_logic_vector(15 downto 0);
				word2 : in std_logic_vector(15 downto 0);
				word3 : in std_logic_vector(15 downto 0);
				word4 : in std_logic_vector(15 downto 0);
				word5 : in std_logic_vector(15 downto 0);
				word6 : in std_logic_vector(15 downto 0);
				word7 : in std_logic_vector(15 downto 0);
				word8 : in std_logic_vector(15 downto 0);
				word9 : in std_logic_vector(15 downto 0);
				word10 : in std_logic_vector(15 downto 0);
				word11 : in std_logic_vector(15 downto 0);
				word12 : in std_logic_vector(15 downto 0);
				word13 : in std_logic_vector(15 downto 0);
				word14 : in std_logic_vector(15 downto 0);
				word15 : in std_logic_vector(15 downto 0);

				word16 : in std_logic_vector(15 downto 0);
				word17 : in std_logic_vector(15 downto 0);
				word18 : in std_logic_vector(15 downto 0);
				word19: in std_logic_vector(15 downto 0);
				word20 : in std_logic_vector(15 downto 0);
				word21 : in std_logic_vector(15 downto 0);
				word22 : in std_logic_vector(15 downto 0);
				word23 : in std_logic_vector(15 downto 0);
				word24 : in std_logic_vector(15 downto 0);
				word25 : in std_logic_vector(15 downto 0);
				word26 : in std_logic_vector(15 downto 0);
				word27 : in std_logic_vector(15 downto 0);
				word28 : in std_logic_vector(15 downto 0);
				word29 : in std_logic_vector(15 downto 0);
				word30 : in std_logic_vector(15 downto 0);
				word31 : in std_logic_vector(15 downto 0);

           ADDR : in std_logic_vector(4 downto 0);

           OUTPUT : out std_logic_vector(15 downto 0));
end display_selector;

architecture Behavioral of display_selector is

begin
	with ADDR select
		OUTPUT <=
			word0 when "00000",
			word1 when "00001",
			word2 when "00010",
			word3 when "00011",
			word4 when "00100",
			word5 when "00101",
			word6 when "00110",
			word7 when "00111",
			word8 when "01000",
			word9 when "01001",
			word10 when "01010",
			word11 when "01011",
			word12 when "01100",
			word13 when "01101",
			word14 when "01110",
			word15 when "01111",

			word16 when "10000",
			word17 when "10001",
			word18 when "10010",
			word19 when "10011",
			word20 when "10100",
			word21 when "10101",
			word22 when "10110",
			word23 when "10111",
			word24 when "11000",
			word25 when "11001",
			word26 when "11010",
			word27 when "11011",
			word28 when "11100",
			word29 when "11101",
			word30 when "11110",
			word31 when "11111",
			
			word0 when others;
	
end Behavioral;
