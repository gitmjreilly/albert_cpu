library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

--
-- ALU CTL bits match those of the mic 1 alu, tanenbaum p 206
--  F0 F1 ENA ENB INVA INC
--
entity alu is
    Port ( A : in std_logic_vector(15 downto 0);
           B : in std_logic_vector(15 downto 0);
           CTL : in std_logic_vector(5 downto 0);
           Y   : out std_logic_vector(15 downto 0);
			  N   : out std_logic;
			  Z   : out std_logic;
			  C	: out std_logic);
end alu;

architecture Behavioral of alu is
	signal ATmp : std_logic_vector(16 downto 0);
	signal BTmp : std_logic_vector(16 downto 0);
	signal YTmp : std_logic_vector(16 downto 0);
	signal prod : std_logic_vector(33 downto 0);
	signal p2 : std_logic_vector(16 downto 0);

	signal pos_a : std_logic;
	signal pos_b : std_logic;
	signal u_a_less_than_u_b : std_logic;
	signal signed_less : std_logic;
	signal signed_less_out : std_logic_vector(16 downto 0);

begin

	ATmp <= '0' & A(15 downto 0);
	BTmp <= '0' & B(15 downto 0);
	prod <= ATmp * BTmp;
	p2 <= prod(16 downto 0);
													
	with CTL select							
		YTmp <=	ATmp				when "000000",
					BTmp				when "000001",
					NOT ATmp			when "000010",
					NOT BTmp			when "000011",

					ATmp + BTmp			when "000100",
					ATmp + BTmp +1		when "000101",
					ATmp + 1			when "000110",
					BTmp + 1			when "000111",

					BTmp - ATmp			when "001000",
					BTmp - 1			when "001001",	
					0 - ATmp			when "001010",
					ATmp AND BTmp		when "001011",
																					
					ATmp OR BTmp		when "001100",
					"00000000000000000"	when "001101",
					"00000000000000001"	when "001110",
					"11111111111111111" 	when "001111",
					ATmp - 1			when "010000",	
					ATmp XOR BTmp		when "010001",
					ATmp - BTmp			when "010010",
					p2			when "010011",
					"00" & ATmp(15 downto 1) when "010100",

					signed_less_out	when "010101",


					"00000000000000000"  when others;

		Y <= YTmp(15 downto 0);

		N <= '1' when (YTmp(15) = '1') else '0';
		Z <= '1' when (YTmp = "00000000000000000") else '0';
		C <= '1' when (YTmp(16) = '1') else '0';

		pos_a <= '1' when (ATmp(15) = '0') else '0';
		pos_b <= '1' when (BTmp(15) = '0') else '0';
		u_a_less_than_u_b <= '1' when (ATmp < BTmp) else '0';
		-- signed_less <= ( not(pos_a) AND not(pos_b) AND u_a_less_than_u_b) OR
						  -- ( pos_a AND not(pos_b));
		signed_less <= ( 
			(pos_a AND pos_b AND u_a_less_than_u_b) OR
			(not(pos_a) AND pos_b) OR
			(not(pos_a) AND not(pos_b) AND u_a_less_than_u_b)			
		);			  
						  
						  
		signed_less_out <= '1' & X"FFFF" when signed_less = '1' else (others => '0');

end Behavioral;
