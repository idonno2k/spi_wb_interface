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

entity ADC128S022_top is
Port ( 	
		CLK : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		
		txData : in  STD_LOGIC_VECTOR (15 downto 0);
		txData_valid : in STD_LOGIC;
		
		rxData : out STD_LOGIC_VECTOR (11 downto 0);
		rxData_valid : out STD_LOGIC;
		
		adcCLK : OUT STD_LOGIC;
		adcCS : out STD_LOGIC;
		adcMOSI : OUT STD_LOGIC;
		adcMISO : IN STD_LOGIC

	);
end ADC128S022_top;

architecture Behavioral of ADC128S022_top is

--	TYPE State_type IS (init, run);
--	SIGNAL State : State_Type; -- creating State signal

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

	signal s_adc_rx : STD_LOGIC_VECTOR (15 downto 0):=B"0000_0000_0000_0000";
	signal s_adc_tx : STD_LOGIC_VECTOR (15 downto 0):=B"0000_0000_0000_0000"; -- value transmitted to ADC
	
	signal adcCS_r : STD_LOGIC_VECTOR(0 DOWNTO 0); --slave select
--	signal samp_clk_cnt : STD_LOGIC_VECTOR(15 DOWNTO 0); --slave select
	
	begin

		s_adc_tx <= txData;
		
		rxData <= s_adc_rx(11 downto 0);

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
			d_width => 16) -- ADC deals in 32-bit SPI transactions
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
			rx_data => s_adc_rx, -- data received from ADC
			
			
			SPI_clk => adcCLK,
			SPI_nss => adcCS_r,
			SPI_mosi => adcMOSI,
			SPI_miso => adcMISO,
			
			busy => adcBusy -- indicator flags from ADC	
		);




end Behavioral;