library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity system is port (
	reset : in std_logic;
	clk : in std_logic;

	-- Write & Read control signals for ext memory
	-- n_wr : out std_logic;
	-- n_rd : out std_logic;
	
	-- External data & address buses 
	-- data_bus : inout std_logic_vector(15 downto 0);
	-- addr_bus : out std_logic_vector(25 downto 0);
	-- external_ram_cs : out std_logic;
	

	-- Indicators to show cpu is doing something...
	-- n_ind : out std_logic;
	-- z_ind : out std_logic;
	 rd_ind : out std_logic;
	 wr_ind : out std_logic;
	 fetch_ind : out std_logic;


	-- Debugging features from lacombe cpu
	-- SevenSegAnodes : out std_logic_vector(3 downto 0);
	-- SevenSegSegments : out std_logic_vector(7 downto 0);
	-- address_switches : in std_logic_vector(7 downto 0);
	

	uart_tx_to_usb : out std_logic;
	uart_rx_from_usb : in std_logic;
		
	-- On PMOD A, use JA1 as lvttl terminal connections
	-- We'll use one uart and a switch to select either
	-- the Serial-USB interface or the LV TTL interface
	JA1 : out std_logic;
	JA7 : in std_logic;

    -- use sw0 to select connection to uart
    -- either USB-SERIAL or LVTTL
    sw_0 : in std_logic;

--	disk_uart_tx : out std_logic;
--	disk_uart_rx : in std_logic;
	
--	ptc_uart_tx : out std_logic;
--	ptc_uart_rx : in std_logic;
	

	
	-- Connect SPI to PMOD B
	JB1 : out std_logic; -- SS -- out_bit_3
	JB2 : out std_logic; -- MOSI
	JB3 : in  std_logic; -- MISO
	JB4 : out std_logic; -- SCLK
	
	out_bit_0 : out std_logic;
	out_bit_1 : out std_logic;
	out_bit_2 : out std_logic;
	-- out_bit_3 : out std_logic;
	-- out_bit_4 : out std_logic;
	-- sclk : out std_logic; -- was out_bit_3
	-- mosi : out std_logic; -- was out_bit_4
	
	out_bit_6 : out std_logic;
	out_bit_7 : out std_logic;

	in_bit_1 : in std_logic;
	in_bit_3 : in std_logic;
	in_bit_4 : in std_logic;
	in_bit_5 : in std_logic;
	in_bit_6 : in std_logic;
	in_bit_7 : in std_logic

);
end system;


architecture structural of system is
	-- constant RAM_CS            : std_logic_vector(15 downto 0)  := "1111111111111110";
	-- constant ROM_CS            : std_logic_vector(15 downto 0)  := "1111111111111101";
	-- constant CONSOLE_UART_CS   : std_logic_vector(15 downto 0)  := "1111111111111011";
	-- constant COUNTER_0_CS      : std_logic_vector(15 downto 0)  := "1111111111110111";
	-- constant DISK_UART_CS      : std_logic_vector(15 downto 0)  := "1111111111101111"; 
	-- constant INT_CONTROLLER_CS : std_logic_vector(15 downto 0)  := "1111111111011111";
	-- constant BLANK_20_CS       : std_logic_vector(15 downto 0)  := "1111111110111111"; 
	-- constant PTC_UART_CS       : std_logic_vector(15 downto 0)  := "1111111101111111";
	-- constant BLANK_40_CS       : std_logic_vector(15 downto 0)  := "1111111011111111"; 
	-- constant BLANK_50_CS       : std_logic_vector(15 downto 0)  := "1111110111111111";
	-- constant BLANK_70_CS       : std_logic_vector(15 downto 0)  := "1111101111111111"; 
	-- constant BLANK_80_CS       : std_logic_vector(15 downto 0)  := "1111011111111111"; 
	-- constant NO_CS             : std_logic_vector(15 downto 0)  := "1111111111111111";
	
	constant RAM_CS            : integer  := 0;
	constant ROM_CS            : integer  := 1;
	constant CONSOLE_UART_CS   : integer  := 2;
	constant COUNTER_0_CS      : integer  := 3;	 
	constant DISK_UART_CS      : integer  := 4;
	constant INT_CONTROLLER_CS : integer  := 5;
	constant BLANK_20_CS       : integer  := 6;
	constant PTC_UART_CS       : integer  := 7;
	constant BLANK_40_CS       : integer  := 8;
	constant BLANK_50_CS       : integer  := 9;
	constant BLANK_70_CS       : integer  := 10;
	constant BLANK_80_CS       : integer  := 11;
	constant NO_CS             : integer  := 12;
	

	---------------------------------------------------------------------
	signal my_clock : std_logic; -- derived clock to be deprecated
	signal four_digits : std_logic_vector(15 downto 0);
	-- signal clk_counter : std_logic_vector(23 downto 0); -- OK Driven by clk

	signal cs_bus : std_logic_vector(15 downto 0);

	signal local_addr_bus : std_logic_vector(19 downto 0);
	signal multiple_int_sources : std_logic_vector(15 downto 0);

	signal reset_n : std_logic;
	signal uart_0_tx : std_logic;
	signal uart_0_rx : std_logic;
	signal n_wr_bus : std_logic;
	signal n_rd_bus : std_logic;

	signal INT_SW_OUT : std_logic;
	signal RX_FULL : std_logic;
	signal tx_busy_n : std_logic;
	signal disk_uart_rx_fifo_is_half_full : std_logic;
	signal ptc_uart_rx_fifo_is_quarter_full : std_logic;
	signal cpu_int : std_logic;
	signal counter_is_zero : std_logic;
	signal	cpu_start  : std_logic;
	signal	cpu_finish : std_logic;
	
	signal out_bit_3, out_bit_4, out_bit_5 : std_logic;
	signal MISO : std_logic;
	signal sclk : std_logic;
	signal mosi : std_logic;
	signal ss_0 : std_logic;
	
	signal in_bit_0 : std_logic;
	signal in_bit_2 : std_logic;
	
	
	
	---------------------------------------------------------------------

	-- todo either add to entity or remove from cpu
	signal n_ind : std_logic;
	signal z_ind : std_logic;
	-- signal fetch_ind :  std_logic;
	signal address_switches : std_logic_vector(4 downto 0);
	signal data_bus : std_logic_vector(15 downto 0);
	signal addr_bus : std_logic_vector(25 downto 0);
	
	signal test_counter : std_logic_vector(23 downto 0);
	
begin


	u_my_clock : entity work.clk_wiz_100_50
		port map (
			clk_in1=> clk,
			clk_out1 => my_clock,
			reset  => reset
		);	


	
--	u_my_clock : entity work.clk_wiz_100_100
--		port map (
--			clk_in1=> clk,
--			clk_out1 => my_clock,
--			reset  => reset
--		);	
	
	

	---------------------------------------------------------------------
	-- Notice the timing generator which generates cpu_start and cpu_finish
	-- pulses uses my_clock as the fundamental clock for the system.
	the_cpu_timing_generator  : entity work.cpu_timing_generator 
		port map( 
		clk => my_clock,
		reset => reset,
		cpu_start => cpu_start,
		cpu_finish => cpu_finish
	);
	---------------------------------------------------------------------
	
	
	---------------------------------------------------------------------
	u_cpu : entity work.cpu
		port map (
			reset => reset,
			my_clock => my_clock, 
			cpu_start => cpu_start,
			cpu_finish => cpu_finish,
			n_indicator => n_ind,
			z_indicator => z_ind,
			rd_indicator => rd_ind,
			wr_indicator => wr_ind,
			fetch_indicator => fetch_ind,
			four_digits => four_digits,
			address_switches => address_switches(4 downto 0),
			Mem_Addr_bus => local_addr_bus,
			Mem_Data_bus => data_bus,
			N_WR => n_wr_bus,
			N_RD => n_rd_bus,
			INT => cpu_int
		);	
	---------------------------------------------------------------------


   addr_bus <= "000000" & local_addr_bus(19 downto 0);


	---------------------------------------------------------------------
	--
	-- This is the ganged (4) Seven Segment Driver.
	-- It takes four bcd digits output from the cpu
	-- and produces the appropriate signals to drive
	-- the 4 seven segment LED display on the Digilent spartan 3 board.
	--
	-- DigitDriver : entity work.SevenSegDriver 	
		-- port map (	
			-- four_digits (15 downto 12),			-- High Digit
			-- four_digits (11 downto 8),
			-- four_digits (7 downto 4),
			-- four_digits (3 downto 0),
			-- clk_counter(15), -- This is OK as - is for digit driver
			-- my_clock, -- This is probably wrong - used to get build to work after switch to DCM
			-- SevenSegSegments, 
			-- SevenSegAnodes
		-- );
	---------------------------------------------------------------------


	---------------------------------------------------------------------
	-- This component provides the chip selects for 
	-- devices on the address and data buses.
	--
	glue_chip : entity work.CS_Glue 
		port map (
			addr => local_addr_bus(19 downto 0),
			CS => cs_bus
		);
	---------------------------------------------------------------------


	-- todo restore ram cs
	-- external_ram_cs <= cs_bus(RAM_CS);
 
	---------------------------------------------------------------------
	u_rom : entity work.rom  -- no sync clock issues - This is combinatorial
		port map (
			addr => local_addr_bus(15 downto 0),
			data => data_bus,
			cs => cs_bus(ROM_CS)
		);
	---------------------------------------------------------------------


	---------------------------------------------------------------------
	u_block_ram_64kb : entity work.block_ram_64kb
		port map (
			clk => my_clock,
			reset => reset,
			cpu_finish => cpu_finish,
			addr_bus => local_addr_bus(15 downto 0),
			data_bus => data_bus,
			n_cs => cs_bus(RAM_CS),
			n_rd => n_rd_bus,
			n_wr => n_wr_bus
		);
	---------------------------------------------------------------------


	---------------------------------------------------------------------
	counter_0: entity work.mem_based_counter 
		port map (
			clock => my_clock,  -- counter clock MAY be OK - Confirm!!!
			reset => reset,
			n_rd => n_rd_bus,
			n_cs => cs_bus(COUNTER_0_CS),
			x_edge => counter_is_zero,
			counter_out => data_bus
		);
	-------------------------------------------------------------------


   ---
	--- Set up interrupt sources.  Those not connected to a device are
	--- tied to 0
	---
	multiple_int_sources(0) <= rx_full;
	multiple_int_sources(1) <= counter_is_zero;
	multiple_int_sources(2) <= NOT tx_busy_n;
	multiple_int_sources(3) <= int_sw_out;
	multiple_int_sources(4) <= disk_uart_rx_fifo_is_half_full;
	multiple_int_sources(5) <= ptc_uart_rx_fifo_is_quarter_full;
	  
	multiple_int_sources(15 downto 6) <= (others => disk_uart_rx_fifo_is_half_full);
   



	int_controller : entity work.mem_based_int_controller 
		port map ( 
			clock => my_clock, 
			reset => reset,
			cpu_finish => cpu_finish,
			addr_bus => local_addr_bus(3 downto 0),
			data_bus => data_bus,
			int_occurred => cpu_int,
			n_cs => cs_bus(INT_CONTROLLER_CS),
			n_wr => n_wr_bus,
			n_rd => n_rd_bus,
			raw_interrupt_word => multiple_int_sources
		);
	
	

    ---------------------------------------------------------------------
    u_output_port_0: entity work.mem_based_output_port 
        port map (
            reset => reset,
            clk => my_clock,
            cpu_finish => cpu_finish,
            n_cs => cs_bus(BLANK_20_CS),
            n_wr => n_wr_bus,
            address_bus => local_addr_bus(2 downto 0),
            in_bit => data_bus(0),
            
            out_bit_0 => out_bit_0,
            out_bit_1 => out_bit_1,
            out_bit_2 => out_bit_2,
            out_bit_3 => out_bit_3,
            out_bit_4 => out_bit_4,
            out_bit_5 => out_bit_5,
            out_bit_6 => out_bit_6,
            out_bit_7 => out_bit_7
    );

    ---------------------------------------------------------------------


    u_input_port_0: entity work.mem_based_input_port 
    port map(
        n_cs => cs_bus(BLANK_40_CS),
        n_rd => n_rd_bus,
        in_bit_0 => in_bit_0,
        in_bit_1 => in_bit_1, 
        in_bit_2 => in_bit_2, 
        in_bit_3 => in_bit_3, 
        in_bit_4 => in_bit_4,
        in_bit_5 => in_bit_5,
        in_bit_6 => in_bit_6,
        in_bit_7 => in_bit_7,
        address_bus => local_addr_bus(2 downto 0),
        data_bus => data_bus
    );
  



	-- ---------------------------------------------------------------------
	-- mem_mapped_peripheral : entity work.mem_mapped_fsm
		-- port map (
			-- clk => my_clock,
			-- reset => reset,
			-- cpu_start => cpu_start,
			-- cpu_finish => cpu_finish,
			-- n_cs => cs_bus(SPI_0_CS),
			-- n_rd => n_rd_bus,
			-- n_wr => n_wr_bus,
			-- data_bus => data_bus,
			-- addr_bus => local_addr_bus(3 downto 0)
		-- );
	-- ---------------------------------------------------------------------



	console_uart: entity work.uart_w_fifo
		port map ( 
			clk  => my_clock,
			rx => uart_0_rx,
			tx => uart_0_tx,
			reset => reset,
			cpu_finish => cpu_finish,
			n_cs => cs_bus(CONSOLE_UART_CS),
			n_rd => n_rd_bus,
			n_wr => n_wr_bus,
			data_bus => data_bus,
			addr_bus => local_addr_bus(3 downto 0)
		);


    process (sw_0, uart_rx_from_usb, uart_0_tx, JA7)
    begin
        if (sw_0 = '0') then
            uart_0_rx <= uart_rx_from_usb;
            uart_tx_to_usb <= uart_0_tx;
            JA1 <= '1';
        else
            uart_0_rx <= JA7;
            JA1 <= uart_0_tx;
            uart_tx_to_usb <= '1';
        end if;  
    end process;




	spi_0:  entity work.mem_based_spi 
	    port map ( 
			clock => my_clock,
			reset => reset,
			cpu_finish => cpu_finish,
			addr_bus => local_addr_bus(3 downto 0),
			data_bus => data_bus,
			n_cs => cs_bus(BLANK_50_CS),
			n_wr => n_wr_bus,
			n_rd => n_rd_bus,
			MOSI => MOSI,
			MISO => MISO,
			SCLK => SCLK,
			ss => ss_0
		);


	JB1 <= ss_0;
	JB2 <= MOSI;
	MISO <= JB3;
	JB4 <= SCLK;
	




--	disk_uart: entity work.uart_w_fifo
--		port map ( 
--			clk  => my_clock,
--			rx => disk_uart_rx,
--			tx => disk_uart_tx,
--			reset => reset,
--			cpu_finish => cpu_finish,
--			n_cs => cs_bus(DISK_UART_CS),
--			n_rd => n_rd_bus,
--			n_wr => n_wr_bus,
--			data_bus => data_bus,
--			addr_bus => local_addr_bus(3 downto 0),
--			rx_fifo_is_half_full => disk_uart_rx_fifo_is_half_full
--		);
	
--	ptc_uart: entity work.uart_w_fifo
--		port map ( 
--			clk  => my_clock,
--			rx => ptc_uart_rx,
--			tx => ptc_uart_tx,
--			reset => reset,
--			cpu_finish => cpu_finish,
--			n_cs => cs_bus(PTC_UART_CS),
--			n_rd => n_rd_bus,
--			n_wr => n_wr_bus,
--			data_bus => data_bus,
--			addr_bus => local_addr_bus(3 downto 0),
--			rx_fifo_is_quarter_full => ptc_uart_rx_fifo_is_quarter_full
--		);
	


	
	
end structural;
