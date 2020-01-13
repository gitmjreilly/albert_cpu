--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--Cathode segments are arranged as follows, bit mapping follows:
--         A
--       -----
--     F|     | B 
--      |  G  |
--      -------
--     E|     | C 
--      |  D  |
--      -------
--                * H
                
-- A B C D   E F G H                
-- - - - -   - - - -
 
-- e.g. 6 is drawn with

-- 0 1 0 0   0 0 0 1  
-- - - - -   - - - -
                 
                
      

entity SevenSegDriver is
    Port ( reset : in std_logic;
           Digit3 : in std_logic_vector(3 downto 0);
           Digit2 : in std_logic_vector(3 downto 0);
           Digit1 : in std_logic_vector(3 downto 0);
           Digit0 : in std_logic_vector(3 downto 0);
           clkin : in std_logic;
			  Segments : out std_logic_vector(7 downto 0);
			  Anodes : out std_logic_vector(3 downto 0));
end SevenSegDriver;



architecture Behavioral of SevenSegDriver is

signal InternalState : std_logic_vector(1 downto 0);
signal ReceivedVal : std_logic_vector(3 downto 0);



begin

	-- Create a simple 2 bit counter to drive the anodes  
	--(one anode for each of the 4 digits)
	--
	process (reset, clkin) 
	begin
	   if (reset = '1') then
	      InternalState <= (others => '0');
		elsif  clkin ='1' and clkin'event then
			InternalState <= InternalState + 1;
		end if;
	end process;
	
	
 
	-- Drive ONE anode based on counter value
	process (InternalState, Digit0, Digit1, Digit2, Digit3) 

	begin
	

		case InternalState is
			when "00" =>
   			Anodes <= "1110";
	     		ReceivedVal <= Digit0;
			
	

			when "01" =>
   			Anodes <= "1101";
	     		ReceivedVal <= Digit1;

			when "10" =>
   			Anodes <= "1011";
	     		ReceivedVal <= Digit2;

			when "11" =>
   			Anodes <= "0111";
	     		ReceivedVal <= Digit3;
	     		
	     		
         end case;
         
   end process;


	process (ReceivedVal) 
   begin
		if (ReceivedVal = "0000") then
			Segments <= "00000011";
		elsif (ReceivedVal = "0001") then
			Segments <= "10011111";
		elsif (ReceivedVal = "0010") then
			Segments <= "00100101";
		elsif (ReceivedVal = "0011") then
			Segments <= "00001101";
		elsif (ReceivedVal = "0100") then
			Segments <= "10011001";
		elsif (ReceivedVal = "0101") then
			Segments <= "01001001";
		elsif (ReceivedVal = "0110") then
			Segments <= "01000001";
		elsif (ReceivedVal = "0111") then
			Segments <= "00011111";
		elsif (ReceivedVal = "1000") then
			Segments <= "00000001";
		elsif (ReceivedVal = "1001") then
			Segments <= "00001001";
		elsif (ReceivedVal = "1010") then
			Segments <= "00010001";
		elsif (ReceivedVal = "1011") then
			Segments <= "11000001";
		elsif (ReceivedVal = "1100") then
			Segments <= "01100011";
		elsif (ReceivedVal = "1101") then
			Segments <= "10000101";
		elsif (ReceivedVal = "1110") then
			Segments <= "01100001";
		elsif (ReceivedVal = "1111") then
			Segments <= "01110001";
		else
         Segments <= (others => '1');
		end if;

	end process;


end Behavioral;
