----------------------------------------------------------------------------------
-- Company: LGE
-- Engineer: byunghun.park
--
-- Create Date: 11/25/2021 
-- Design Name: Mcp3208_TOP
-- Module Name: mcp3208_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Purpose Digital Filter Peripheral Board Rev. C. It uses SPI to
-- communicate with the TI ADS8681 ADC and TI DAC8830 DAC. The FIR
-- filter support logic used is imported through Vivado's IP
-- Integrator. See ADC and DAC datasheets for more information on
-- SPI transaction protocols.
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity mcp3208_32ch_drv_top is
Port ( 	
		CLK : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		
		txData : in  STD_LOGIC_VECTOR (18 downto 0);
		txData_valid : in STD_LOGIC;
		
		rxData00 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData01 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData02 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData03 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData04 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData05 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData06 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData07 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData08 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData09 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData10 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData11 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData12 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData13 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData14 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData15 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData16 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData17 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData18 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData19 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData20 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData21 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData22 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData23 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData24 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData25 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData26 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData27 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData28 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData29 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData30 : out STD_LOGIC_VECTOR (11 downto 0);
		rxData31 : out STD_LOGIC_VECTOR (11 downto 0);
		
		rxData_valid : out STD_LOGIC;
		
		adcCLK : OUT STD_LOGIC;
		adcCS : out STD_LOGIC;
		adcMOSI : OUT STD_LOGIC;
		adcMISO : IN STD_LOGIC_VECTOR (31 downto 0)

	);
end mcp3208_32ch_drv_top;

architecture Behavioral of mcp3208_32ch_drv_top is

	TYPE State_type IS (init, run);
	SIGNAL State : State_Type; -- creating State signal

	component spi_master is
	GENERIC(
		slaves : INTEGER; --number of spi slaves
		d_width : INTEGER); --data bus width
	PORT(
		clock		: IN STD_LOGIC; --system clock
		reset_n		: IN STD_LOGIC; --asynchronous reset
		enable		: IN STD_LOGIC; --initiate transaction
		cpol		: IN STD_LOGIC; --spi clock polarity
		cpha		: IN STD_LOGIC; --spi clock phase
		cont		: IN STD_LOGIC; --continuous mode command
		clk_div		: IN INTEGER; --system clock cycles per 1/2 period of sclk
		addr		: IN INTEGER; --address of slave
		tx_data		: IN STD_LOGIC_VECTOR(d_width-1 DOWNTO 0); --data to transmit
		SPI_miso	: IN STD_LOGIC; --master in, slave out
		SPI_clk		: OUT STD_LOGIC; --spi clock
		SPI_nss		: out STD_LOGIC_VECTOR(slaves-1 DOWNTO 0); --slave select
		SPI_mosi	: OUT STD_LOGIC; --master out, slave in
		busy		: OUT STD_LOGIC; --busy / data ready signal
		rx_data		: OUT STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
	end component;

	signal adcBusy	: STD_LOGIC; --busy / data ready signal
	signal adcBusy_r : STD_LOGIC_VECTOR (7 downto 0);

	signal s_adc_rx00 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx01 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000"; -- received ADC data word
	signal s_adc_rx02 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000"; 
	signal s_adc_rx03 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000"; 
	signal s_adc_rx04 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000"; 
	signal s_adc_rx05 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx06 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx07 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx08 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx09 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx10 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx11 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx12 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx13 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx14 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx15 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx16 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx17 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx18 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx19 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx20 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx21 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx22 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx23 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx24 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx25 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx26 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx27 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx28 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx29 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx30 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_adc_rx31 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	
	signal s_adc_tx : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000"; -- value transmitted to ADC
	
	signal adcCS_r : STD_LOGIC_VECTOR(0 DOWNTO 0); --slave select
	signal samp_clk_cnt : STD_LOGIC_VECTOR(15 DOWNTO 0); --slave select
	
	begin

		s_adc_tx <= txData;
		
		rxData00 <= s_adc_rx00(11 downto 0);
		rxData01 <= s_adc_rx01(11 downto 0);
		rxData02 <= s_adc_rx02(11 downto 0);
		rxData03 <= s_adc_rx03(11 downto 0);
		rxData04 <= s_adc_rx04(11 downto 0);
		rxData05 <= s_adc_rx05(11 downto 0);
		rxData06 <= s_adc_rx06(11 downto 0);
		rxData07 <= s_adc_rx07(11 downto 0);
		rxData08 <= s_adc_rx08(11 downto 0);
		rxData09 <= s_adc_rx09(11 downto 0);
		rxData10 <= s_adc_rx10(11 downto 0);
		rxData11 <= s_adc_rx11(11 downto 0);
		rxData12 <= s_adc_rx12(11 downto 0);
		rxData13 <= s_adc_rx13(11 downto 0);
		rxData14 <= s_adc_rx14(11 downto 0);
		rxData15 <= s_adc_rx15(11 downto 0);
		rxData16 <= s_adc_rx16(11 downto 0);
		rxData17 <= s_adc_rx17(11 downto 0);
		rxData18 <= s_adc_rx18(11 downto 0);
		rxData19 <= s_adc_rx19(11 downto 0);
		rxData20 <= s_adc_rx20(11 downto 0);
		rxData21 <= s_adc_rx21(11 downto 0);
		rxData22 <= s_adc_rx22(11 downto 0);
		rxData23 <= s_adc_rx23(11 downto 0);
		rxData24 <= s_adc_rx24(11 downto 0);
		rxData25 <= s_adc_rx25(11 downto 0);
		rxData26 <= s_adc_rx26(11 downto 0);
		rxData27 <= s_adc_rx27(11 downto 0);
		rxData28 <= s_adc_rx28(11 downto 0);
		rxData29 <= s_adc_rx29(11 downto 0);
		rxData30 <= s_adc_rx30(11 downto 0);
		rxData31 <= s_adc_rx31(11 downto 0);

		process(CLK, reset)
		begin
			if reset = '0' then
				adcBusy_r	<= (others => '0');
				rxData_valid <= '0';
			elsif CLK'event and CLK = '1' then
				adcBusy_r 	<= adcBusy_r(6 downto 0) & adcBusy;	
				rxData_valid <= '0';
				if adcBusy_r(1 downto 0) = "10" then
					rxData_valid <= '1';
				end if;
			end if;
		end process ;

		adcCS <= adcCS_r(0);

		u00_mcp3208: spi_master
		GENERIC MAP (
			slaves => 1, -- only one slave
			d_width => 19) -- ADC deals in 32-bit SPI transactions
		PORT MAP (
			clock => CLK, -- system clock for high-speed serial clocks
			reset_n =>reset,
			enable => txData_valid,
			cpol => '0', -- standard SPI polarity
			cpha => '0', -- standard SPI phase
			cont => '0', -- not continuous mode, see developer's notes for details
			clk_div => 25, -- div50 = 2Mhz
			addr => 0, -- arbitrary address, see developer's notes for details

			tx_data => s_adc_tx, -- data to transmit to ADC
			rx_data => s_adc_rx00, -- data received from ADC
			
			
			SPI_clk => adcCLK,
			SPI_nss => adcCS_r,
			SPI_mosi => adcMOSI,
			SPI_miso => adcMISO( 0),
			
			busy => adcBusy -- indicator flags from ADC	
		);
		
		u01_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx01, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO( 1), busy => open 	);
		u02_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx02, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO( 2), busy => open 	);
		u03_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx03, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO( 3), busy => open 	);
		u04_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx04, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO( 4), busy => open 	);
		u05_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx05, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO( 5), busy => open 	);
		u06_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx06, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO( 6), busy => open 	);
		u07_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx07, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO( 7), busy => open 	);
		u08_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx08, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO( 8), busy => open 	);
		u09_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx09, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO( 9), busy => open 	);
		u10_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx10, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(10), busy => open 	);
		u11_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx11, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(11), busy => open 	);
		u12_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx12, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(12), busy => open 	);
		u13_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx13, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(13), busy => open 	);
		u14_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx14, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(14), busy => open 	);
		u15_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx15, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(15), busy => open 	);
		u16_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx16, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(16), busy => open 	);
		u17_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx17, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(17), busy => open 	);
		u18_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx18, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(18), busy => open 	);
		u19_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx19, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(19), busy => open 	);
		u20_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx20, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(20), busy => open 	);
		u21_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx21, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(21), busy => open 	);
		u22_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx22, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(22), busy => open 	);
		u23_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx23, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(23), busy => open 	);
		u24_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx24, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(24), busy => open 	);
		u25_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx25, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(25), busy => open 	);
		u26_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx26, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(26), busy => open 	);
		u27_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx27, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(27), busy => open 	);
		u28_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx28, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(28), busy => open 	);
		u29_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx29, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(29), busy => open 	);
		u30_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx30, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(30), busy => open 	);
		u31_mcp3208: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_adc_tx, rx_data => s_adc_rx31, 		SPI_clk => open, SPI_nss => open, SPI_mosi => open,	SPI_miso => adcMISO(31), busy => open 	);
	




end Behavioral;