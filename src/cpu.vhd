library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu is
	Port ( 
		reset : in std_logic;																		
		my_clock : in std_logic;
		N_indicator : out std_logic;
		Z_indicator : out std_logic;
		RD_INDICATOR : out std_logic;
		WR_INDICATOR : out std_logic;
		FETCH_INDICATOR : out std_logic;
		four_digits : out std_logic_vector(15 downto 0);
		Address_Switches : in std_logic_vector(4 downto 0);
		Mem_Addr_bus : out std_logic_vector(19 downto 0);
		Mem_Data_bus : inout std_logic_vector(15 downto 0);
		N_WR : out std_logic;
		N_RD : out std_logic;
		INT : in std_logic
      -- TODO remove cpu_start, cpu_finish from cpu entity - DONE
	);
end cpu;

architecture structural of cpu is

signal alu_b_bus : std_logic_vector(15 downto 0);
signal c_bus     : std_logic_vector(15 downto 0);
signal b_bus     : std_logic_vector(15 downto 0);
signal alu_output: std_logic_vector(15 downto 0);

-- signal MAR_Mem_Addr_bus : std_logic_vector(15 downto 0);


signal mar_out		: std_logic_vector(15 downto 0);
signal mdr_out		: std_logic_vector(15 downto 0);
signal mbr_out		: std_logic_vector(15 downto 0);
signal sp_out     : std_logic_vector(15 downto 0);
signal lv_out     : std_logic_vector(15 downto 0);
signal cpp_out     : std_logic_vector(15 downto 0);
signal tos_out     : std_logic_vector(15 downto 0);
signal intctl_high_out     : std_logic_vector(7 downto 0);
signal intctl_low_out     : std_logic_vector(7 downto 0);
signal intctl_out : std_logic_vector(15 downto 0);
signal h_out     : std_logic_vector(15 downto 0);
signal pc_out : std_logic_vector(15 downto 0);
signal es_out : std_logic_vector(15 downto 0);
signal cs_out : std_logic_vector(15 downto 0);
signal ds_out : std_logic_vector(15 downto 0);


signal ctl_lines     : std_logic_vector(5 downto 0);

signal load_mar : std_logic;
signal load_mdr : std_logic;
signal load_pc : std_logic; 
signal load_sp  : std_logic;
signal load_lv  : std_logic;
signal load_cpp : std_logic;
signal load_tos : std_logic;
signal load_h : std_logic;

signal enable_mdr : std_logic;
signal enable_mbr1 : std_logic;
signal enable_pc : std_logic;
signal enable_sp  : std_logic;
signal enable_lv  : std_logic;
signal enable_cpp : std_logic;
signal enable_tos : std_logic;
signal enable_intctl : std_logic;

signal N : std_logic;
signal Z : std_logic;										  
signal C : std_logic;										  
-- signal reset : std_logic;
signal enable_h : std_logic;

signal INT_ENABLE : std_logic;
signal INT_OCCURRED : std_logic;
signal INT_POSSIBLE : std_logic;

signal ControlStoreOut : std_logic_vector(40 downto 0);

---------------------------------------------------------------------
-- Signal MIROut contains the internal microcode control bits
-- It is the output of register MIR_REG and is loaded from the 
-- ControlStore on each falling edge of the clock
--
signal MIROut : std_logic_vector(40 downto 0);
---------------------------------------------------------------------

signal mir_addr9 : std_logic_vector(15 downto 0);
signal mir_jam : std_logic_vector(15 downto 0);
signal mir_alu : std_logic_vector(15 downto 0);
signal mir_shift : std_logic_vector(15 downto 0);
signal mir_c : std_logic_vector(15 downto 0);
signal mir_m : std_logic_vector(15 downto 0);
signal mir_b : std_logic_vector(15 downto 0);

signal DecoderOut : std_logic_vector(15 downto 0);
signal N_FF_OUT : std_logic;
signal Z_FF_OUT : std_logic;
signal C_FF_OUT : std_logic;
signal RD_FF_OUT : std_logic;
signal FETCH_FF_OUT : std_logic;
signal WR_FF_OUT : std_logic;
signal ES_FF_OUT : std_logic;
signal mem_ff_out : std_logic;
signal HighBitOut : std_logic;
signal AddressSelectorOut : std_logic_vector(7 downto 0);
signal ControlStoreNextAddress : std_logic_vector(8 downto 0);
signal TmpAddress : std_logic_vector(15 downto 0);

signal Display_Selector_Output : std_logic_vector(15 downto 0);
signal ControlStoreAddressDebug : std_logic_vector(15 downto 0);
signal Junk : std_logic_vector(15 downto 0);
signal INT_HIGH_REG_IN : std_logic_vector(7 downto 0);
signal JMPC : std_logic;
signal LOAD_INTCTL : std_logic;


component alu is
    Port ( A : in std_logic_vector(15 downto 0);
           B : in std_logic_vector(15 downto 0);
           CTL : in std_logic_vector(5 downto 0);
           Y   : out std_logic_vector(15 downto 0);
			  N   : out std_logic;
			  Z   : out std_logic;
			  C	: out std_logic);
end component;

component shifter is
    Port ( input : in std_logic_vector(15 downto 0);
           ctl : in std_logic_vector(1 downto 0);
           output : out std_logic_vector(15 downto 0));
end component;

-- TODO remove enable from flip_flop - DONE
component flip_flop is
    Port ( input : in std_logic;
           output : out std_logic;
           clock : in std_logic);
end component;


component high_bit is
    Port ( N : in std_logic;
           Z : in std_logic;
			  CY : in std_logic;
           JAMN : in std_logic;
           JAMZ : in std_logic;
			  JAMY : in std_logic;
           ADDR_8 : in std_logic;
           OUTPUT : out std_logic);
end component;


component display_selector		is port (
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
end component;


component mem_addr_gen is
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
end component;


--
component address_selector is
    Port ( MBR : in std_logic_vector(7 downto 0);
           ADDR : in std_logic_vector(7 downto 0);
			  INT_VEC : in std_logic_vector(7 downto 0);
           JMPC : in std_logic;
			  INT_OCCURRED : in std_logic;
           OUTPUT : out std_logic_vector(7 downto 0));
end component;


component control_store is
    Port ( input : in std_logic_vector(8 downto 0);
           output : out std_logic_vector(40 downto 0));
end component;

component four_to_16_decoder is
    Port ( input : in std_logic_vector(3 downto 0);
           output : out std_logic_vector(15 downto 0));
end component;



constant one_way   : std_logic := '1';
constant other_way : std_logic := '0';
constant DummyReg : std_logic_vector := "0000000000000000";
constant WordAll0 : std_logic_vector := "0000000000000000";
constant INTERRUPT_VECTOR : std_logic_vector := "00100001";

begin	 

four_digits <= display_selector_output;

mir_addr9 <= 	"0000000" & MIROut(35 downto 27);
mir_jam <= 		"0000000000000" & MIROut(26 downto 24);
mir_shift <=	"00000000000000" & MIROut(23 downto 22);
mir_alu <= 		"0000000000" & MIROut(21 downto 16);
mir_c <= 		"0000000" & MIROut(15 downto 7);
mir_m <= 		"0000000000000" & MIROut(6 downto 4);
mir_b <= 		"000000000000" & MIROut(3 downto 0);

-- reset <= '0';

---
--- The MIR is the register with the micro code word produced by the
--- ControlStore.  It is loaded upon the falling edge of the clock.
---
-- TODO ensure MIR is set at beginning of AST uCode cycle (FE) by using not(my_clock)  - DONE
-- TODO remove enable (formerly set by cpu_start) - DONE
MIR_REG : entity work.compound_register  
	generic map(
		width => 41
	)
	port map (
		clk => not(my_clock) ,
		reset => reset ,
		in1   => ControlStoreOut,
		out1  => MIROUt ,
		output_enable  => '1' ,
		latch => '1'  
	);




load_mar <= MIROut(7);
load_mdr <= MIROut(8);
load_pc <= MIROut(9);

load_sp <= MIROut(10);
load_lv <= MIROut(11);
load_cpp <= MIROut(12);
load_tos <= MIROut(13);
load_intctl <= MIROut(14);
load_h <= MIROut(15);

JMPC <= MIROut(26);

--
-- The address selector chooses the lowest 8/9 address bits for the next
-- controlStore word.  If JMPC == 1, OUTPUT<=MBR else OUTPUT<=MIR(NextAddressField)
--
u_address_selector : address_selector port map (
	MBR => MBR_Out(7 downto 0),
	ADDR => MIROut(34 downto 27),		-- lower 8 bits of 9 bit "Next Address"
	JMPC => MIROut(26),
	INT_VEC => INTERRUPT_VECTOR,  -- microcode address for interrupt
	INT_OCCURRED => INT_OCCURRED,
	OUTPUT => AddressSelectorOut);

ControlStoreNextAddress <= HighBitOut & AddressSelectorOut;
u_control_store : control_store port map (ControlStoreNextAddress, ControlStoreOut);

-- TmpAddress <= 		"0000000" & ControlStoreNextAddress;
-- ControlStoreNextAddressDebug: entity work.compound_register -- adjusted for sync clock
	-- port map (
		-- my_clock,
		-- reset, --  reset 
		-- TmpAddress, -- TmpAddress <= "0000000" & ControlStoreNextAddress;
		-- ControlStoreAddressDebug,
		-- Junk,
		-- '1', 
		-- '1',
		-- cpu_finish
	-- );

	u_four_to_16_decoder : four_to_16_decoder port map (MIROut(3 downto 0), DecoderOut);
	-- DO NOT USE DecoderOut(0) !!!
	-- It will be selected when all inputs are 0
	--
	enable_pc <= DecoderOut(1);
	enable_mbr1 <= DecoderOut(2);

	enable_sp <= DecoderOut(4);
	enable_lv <= DecoderOut(5);
	enable_cpp <= DecoderOut(6);
	enable_tos <= DecoderOut(7);
	enable_intctl <= DecoderOut(10);
	enable_mdr <= DecoderOut(9);
--
-- Instantiate Regs which live on both C and B bus
-- and are not connected to memory interface.
--		sp, lv, cpp, tos, opc
-- reset is forced low.
-- Their input comes from the c_bus; output goes to the b_bus
-- XX_out is the (always on) output
-- enable_XX enables output onto the b_bus
-- load_XX loads XX from the c_bus on the rising edge of the clock
--

-- TODO remove cpu_finish from SP_REG - DONE
SP_REG: entity work.compound_register 
	port map (
		my_clock,  
		reset , 
		c_bus, 
		b_bus, 
		sp_out,  
		enable_sp,  
		load_sp
	);

-- TODO remove cpu_finish from LV_REG - DONE
LV_REG: entity work.compound_register 
	port map (
		my_clock,  
		reset , 
		c_bus, 
		b_bus, 
		lv_out,  
		enable_lv,  
		load_lv
	);

-- TODO remove cpu_finish from CPP_REG - DONE
CPP_REG: entity work.compound_register 
	port map (
		my_clock, 
		reset , 
		c_bus, 
		b_bus, 
		cpp_out, 
		enable_cpp, 
		load_cpp
	);

-- TODO remove cpu_finish from TOS_REG - DONE
TOS_REG: entity work.compound_register 
	port map (
		my_clock, 
		reset , 
		c_bus, 
		b_bus, 
		tos_out, 
		enable_tos, 
		load_tos
	);

-- This is the reg which gets single interrupt
-- TODO look into intctl_high_reg and how it captures interrupts and remove cpu_finish _ DONE
INTCTL_HIGH_REG : entity work.compound_register 
	generic map(
		width => 8
	)
	port map (
		clk => my_clock,
		reset => reset ,
		in1   => INT_HIGH_REG_IN ,
		out1  => b_bus(15 downto 8) ,
		out2  => INTCTL_HIGH_OUT,
		output_enable  => enable_intctl,
		latch => '1' 
	);


-- TODO remove cpu_finish from INTCTL_LOW_REG - DONE
INTCTL_LOW_REG : entity work.compound_register 
	generic map(
		width => 8
	)
	port map (
		clk => my_clock  ,
		reset => reset ,
		in1   => c_bus (7 downto 0),
		out1  => b_bus(7 downto 0) ,
		out2  => INTCTL_LOW_OUT,
		output_enable  => enable_intctl,
		latch => load_intctl 
	);



-- Segment registers on the datapath
-- TODO remove cpu_finish from ES_REG - DONE
ES_REG : entity work.compound_register 
	port map (
	    clk => my_clock  ,
		reset => reset ,
		in1   => c_bus ,
		out1  => b_bus ,
		out2  => es_out ,
		output_enable  => DecoderOut(3),
		latch => MIROut(37) 
	);

-- TODO remove cpu_finish from CS_REG - DONE
CS_REG : entity work.compound_register 
	port map (
		clk => my_clock  ,
		reset => reset ,
		in1   => c_bus ,
		out1  => b_bus ,
		out2  => cs_out ,
		output_enable  => DecoderOut(8),
		latch => MIROut(38) 
	);

-- TODO remove cpu_finish from DS_REG - DONE
DS_REG : entity work.compound_register 
	port map (
	    clk => my_clock  ,
		reset => reset ,
		in1   => c_bus ,
		out1  => b_bus ,
		out2  => ds_out ,
		output_enable  => DecoderOut(11),
		latch => MIROut(39) 
	);




--------------------------------------------------------------------------------------------------

INT_HIGH_REG_IN(0) <= INT;
INT_HIGH_REG_IN(7 downto 1) <= "0000000";

--
-- Instantiate H Reg.  Its A in put comes from the B Bus.  Its B input comes directly from H Reg.
-- reset is forced low.
-- Its input comes from the c_bus; output goes to the b_bus
-- load_sp loads sp from the c_bus on the rising edge of the clock
--
-- TODO remove cpu_finish from H_REG - DONE
enable_h <= '1';
H_REG: entity work.compound_register 
	port map (
		my_clock, 
		reset, 
		c_bus, 
		alu_b_bus, 
		h_out, 
		enable_h, 
		load_h
	);

-- TODO remove cpu_finish from MAR_REG - DONE
MAR_REG: entity work.compound_register 
	port map (
		my_clock,  
		reset , 
		c_bus, 
		b_bus, 
		mar_out,
		'0' ,  -- notice MAR is never enabled on b_bus
		load_mar
	);

-- TODO remove cpu_finish from MDR_REG - DONE
-- TODO fix mdr component - DONE
MDR_REG : entity work.mdr 
	port map (
		clock => my_clock,
		mem_data_bus => MEM_DATA_BUS,
		c_bus => c_bus,
		load_mem_data_bus => rd_ff_out,
		load_c_bus => load_mdr,
		out_mem_data_bus => wr_ff_out,
		out_b_bus => enable_mdr,
		b_bus => b_bus,
		always_out => mdr_out
	);

-- TODO remove cpu_finish from RD_FF - DONE
RD_FF : flip_flop port map (MIROut(5), RD_FF_OUT, my_clock);
-- TODO remove cpu_finish from FETCH_FF - DONE
FETCH_FF : flip_flop port map (MIROut(4), FETCH_FF_OUT, my_clock);
-- TODO remove cpu_finish from WR_FF - DONE
WR_FF : flip_flop port map (MIROut(6), WR_FF_OUT, my_clock);
-- TODO remove cpu_finish from ES_FF - DONE
ES_FF : flip_flop port map (MIROut(40), ES_FF_OUT, my_clock);
N_RD <= NOT (RD_FF_OUT OR FETCH_FF_OUT);
N_WR <= NOT WR_FF_OUT;
RD_INDICATOR <= RD_FF_OUT;
WR_INDICATOR <= WR_FF_OUT;
FETCH_INDICATOR <= FETCH_FF_OUT;


-- TODO remove cpu_finish from PC_REG - DONE
PC_REG:  entity work.compound_register  
	port map (
		my_clock, 
		reset , 
		c_bus, 
		b_bus, 
		pc_out,  
		enable_pc, 
		load_pc
	);

-- TODO remove cpu_finish from MBR_REG - DONE
MBR_REG: entity work.compound_register 
	port map (
		my_clock,  
		reset , 
		mem_data_bus, 
		b_bus, 
		mbr_out,  
		enable_mbr1, 
		FETCH_FF_OUT
	);

mem_ff_out <= RD_FF_OUT OR WR_FF_OUT;

--
-- This circuit generates the 20 bit address provided by 
-- the cpu to the outside world.  The address is based either
-- on the PC or the MAR.
-- This circuit adds one of the segment registers, either
--   cs (when selecting the PC)
--   ds (when selecting the MAR)
--   es (when explicitly selected)
--
u_mem_addr_gen : mem_addr_gen port map (
   pc_in => pc_out,
	mar_in => mar_out,
	es_in => es_out,
	cs_in => cs_out,
	ds_in => ds_out,
	addr_out => mem_addr_bus,
	use_pc => fetch_ff_out,
	use_mar => mem_ff_out,
	use_es => es_ff_out
);
 
 

intctl_out <= intctl_high_out & intctl_low_out;

u_display_selector : display_selector port map (
	ADDR => Address_Switches,
	OUTPUT => Display_Selector_Output,

	word0 => DummyReg,
	word1 => DummyReg,
	word2 => DummyReg,
	word3 => DummyReg,
	word4 => DummyReg,

	word5 => sp_out, -- psp_out
	word6 => lv_out, -- rsp_out
	word7 => cpp_out, -- rtos_out
	word8 => tos_out, -- ptos_out
	word9 => intctl_out,

	word10 => h_out,
	word11 => b_bus,
	word12 => c_bus,
	word13 => alu_b_bus,
	word14 => mir_addr9,
	word15 => mir_jam,
	word16 => mir_alu,
	word17 => mir_c,
	word18 => mir_m,
	word19 => mir_b,

	word20 => mir_shift,
	word21 => X"FFFF",  -- ControlStoreAddressDebug,
	word22 => mar_out,
	word23 => mdr_out,
	word24 => mbr_out,
	word25 => pc_out,
	word26 => es_out,
	word27 => cs_out,
	word28 => ds_out,
	word29 => DummyReg,

	word30 => DummyReg,
	word31 => DummyReg);

--
-- This is the ALU.
-- It gets its A input from the b_bus.
-- It gets its B input from the H register (connected to alu_b_bus).
-- Left port is ALU A; Right port is ALU B.
--
ctl_lines <= MIROut(21 downto 16);
u_alu: alu port map (b_bus, alu_b_bus, ctl_lines, alu_output, N, Z, C);

--
-- These flip flops store the last N & Z outputs from the ALU.
--
-- TODO remove cpu_finish from N_FF - DONE
N_FF : flip_flop port map (N, N_FF_OUT, my_clock);
-- TODO remove cpu_finish from Z_FF - DONE
Z_FF : flip_flop port map (Z, Z_FF_OUT, my_clock);
-- TODO remove cpu_finish from C_FF - DONE
C_FF : flip_flop port map (C, C_FF_OUT, my_clock);
--N_Indicator <= N_FF_OUT;
--Z_Indicator <= Z_FF_OUT;
N_Indicator <= '0';
Z_Indicator <= '0';

u_high_bit : high_bit port map (
	N => N_FF_OUT,
	Z => Z_FF_OUT,
	CY => C_FF_OUT,
	JAMN => MIROut(25),
	JAMZ => MIROut(24),
	JAMY => MIROut(36),
	ADDR_8 => MIROut(35),
	OUTPUT => HighBitOut);

u_shifter : shifter port map (
	input => alu_output, 
	ctl => MIROut(23 downto 22),
	output => c_bus
);

INT_POSSIBLE <= INTCTL_HIGH_OUT(0);
INT_ENABLE <= INTCTL_LOW_OUT(0);
INT_OCCURRED <= INT_POSSIBLE AND INT_ENABLE AND JMPC;

end structural;
