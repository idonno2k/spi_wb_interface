----------------------------------------------------------------------------------
-- Company: Cal Poly
-- Engineer: Michael Cheng
--
-- Create Date: 05/14/2017 08:32:22 PM
-- Design Name: Digital Filter System Wrapper
-- Module Name: filter_system_wrapper - Behavioral
-- Project Name: General-Purpose Digital Filter Platform
-- Target Devices: Basys 3/ Xilinx XC7A35T-1CPG236C
-- Tool Versions: Vivado 2016.4, System Generator 2016.4, MATLAB R2016b
-- Description: This module is the system wrapper to communicate with the General-
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

entity filter_system_wrapper is
Port ( 	adcCS : BUFFER STD_LOGIC_VECTOR (0 downto 0);
		adcMISO : IN STD_LOGIC;
		CLK : IN STD_LOGIC;
		adcCLK : BUFFER STD_LOGIC;
		LED : OUT STD_LOGIC_VECTOR (15 downto 0);
		dacCS : BUFFER STD_LOGIC_VECTOR (0 downto 0);
		dacMOSI : OUT STD_LOGIC;
		adcMOSI : OUT STD_LOGIC;
		reset : IN STD_LOGIC;
		dacCLK : BUFFER STD_LOGIC;
		SWITCHES : IN STD_LOGIC_VECTOR (15 downto 0)
		);
end filter_system_wrapper;

architecture Behavioral of filter_system_wrapper is
	-- There are three states:
	-- initialization - init
	-- filtering - filt
	-- diagnostic - diag
	TYPE State_type IS (init, filt, diag);
	SIGNAL State : State_Type; -- creating State signal
	
	-- This module contains all digital filtering support logic.
	-- It is generated using the Simulink GUI through
	-- Vivado System Generator. This block always must have a 1 MHz
	-- input clock. The gateway_in input connects to the received ADC
	-- value, and the gateway_out block connects to the transmitted
	-- DAC value.

	component FIR_block_wrapper is
	port (
	clk : IN STD_LOGIC;
	gateway_in : IN STD_LOGIC_VECTOR ( 15 downto 0 );
	gateway_out : OUT STD_LOGIC_VECTOR ( 15 downto 0 )
	);
	end component;

	component spi_master is
	GENERIC(
	slaves : INTEGER; --number of spi slaves
	d_width : INTEGER); --data bus width
	PORT(
	clock : IN STD_LOGIC; --system clock
	reset_n : IN STD_LOGIC; --asynchronous reset
	enable : IN STD_LOGIC; --initiate transaction
	cpol : IN STD_LOGIC; --spi clock polarity
	cpha : IN STD_LOGIC; --spi clock phase
	cont : IN STD_LOGIC; --continuous mode command
	clk_div : IN INTEGER; --system clock cycles per 1/2 period of sclk
	addr : IN INTEGER; --address of slave
	tx_data : IN STD_LOGIC_VECTOR(d_width-1 DOWNTO 0); --data to transmit
	miso : IN STD_LOGIC; --master in, slave out
	sclk : BUFFER STD_LOGIC; --spi clock
	ss_n : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0); --slave select
	mosi : OUT STD_LOGIC; --master out, slave in
	busy : OUT STD_LOGIC; --busy / data ready signal
	rx_data : OUT STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
	end component;

	component clock_divider is
	PORT (
	clk : IN STD_LOGIC; -- system clock
	reset : IN STD_LOGIC; -- asynchronous reset
	clock_out : OUT STD_LOGIC); -- divided clock
	end component;

	signal adcBusy : STD_LOGIC; --busy / data ready signal
	signal dacBusy : STD_LOGIC; --busy / data ready signal
	signal s_adc_rx : STD_LOGIC_VECTOR (31 downto 0):=x"00000000"; -- received ADC data word
	signal s_dac_tx : STD_LOGIC_VECTOR (15 downto 0):=x"0000"; -- value transmitted to DAC
	signal sclk : STD_LOGIC; -- divided clock
	signal dac_conversion : STD_LOGIC_VECTOR(15 downto 0); -- output value from filter
	signal s_adc_tx : STD_LOGIC_VECTOR (31 downto 0) := x"00000000"; -- value transmitted to ADC
	
	begin
	
		filter: FIR_block_wrapper 
		PORT MAP (
		clk => sclk, -- 1 MHz clock
		gateway_in => s_adc_rx(30 downto 15), -- ignore the first bit received due to
		-- synchronization issues. Quantized value
		gateway_out => dac_conversion -- filtered value to output to DAC
		);
		
		adcspi: spi_master
		GENERIC MAP (
			slaves => 1, -- only one slave
			d_width => 32) -- ADC deals in 32-bit SPI transactions
		PORT MAP (
			clock => CLK, -- system clock for high-speed serial clocks
			reset_n => '1', -- never reset
			enable => sclk, -- 1 MSPS
			cpol => '0', -- standard SPI polarity
			cpha => '0', -- standard SPI phase
			cont => '0', -- not continuous mode, see developer's notes for details
			clk_div => 1, -- 50 MHz serial clock
			addr => 0, -- arbitrary address, see developer's notes for details
			tx_data => s_adc_tx, -- data to transmit to ADC
			miso => adcMISO,
			sclk => adcCLK,
			ss_n => adcCS,
			mosi => adcMOSI,
			busy => adcBusy, -- indicator flags from ADC
			rx_data => s_adc_rx -- data received from ADC
		);
		
		dacspi: spi_master
		GENERIC MAP (
		slaves => 1, -- only one slave
		d_width => 16) -- DAC deals in 16-bit SPI transactions
		PORT MAP (
		clock => CLK, -- system clock for high-speed serial clocks
		reset_n => '1', -- never reset
		enable => sclk, -- complements 1 MSPS from ADC
		cpol => '0', -- standard SPI polarity
		cpha => '0', -- standard SPI phase
		cont => '0', -- not continuous mode, see developer's notes for details
		clk_div => 1, -- 50 MHz serial clock
		addr => 0, -- arbitrary address, see developer's notes for details
		tx_data => s_dac_tx, -- data to transmit to DAC
		miso => '0', -- DAC does not return data
		sclk => dacCLK,
		ss_n => dacCS,
		mosi => dacMOSI,
		busy => dacBusy, -- DAC indicator flag
		rx_data => open -- no data received from DAC
		);
		
		clkdiv: clock_divider
		PORT MAP (
		clk => CLK, -- 100 MHz input clock
		reset => '1', -- never reset
		clock_out => sclk -- 1 MHz output clock
		);
		
		-- Finite State Machine - System Controller
		PROCESS (sCLK, reset) -- each state transitions at 1 MHz with an optional reset
		BEGIN
			If (reset = '1') THEN -- Upon asynchronous reset, set the state to init
				State <= init;
			ELSIF rising_edge(sCLK) THEN -- else if there is a rising edge of the
				-- clock, then do the stuff below
				-- The CASE statement checks the value of the State variable,
				-- and based on the value and any other control signals, changes
				-- to a new state.
				CASE State IS
					-- The initialization state configures the appropriate input range
					-- for the ADS8681 ADC. This makes the input range from 0 to 5.12 V.
					-- The state unconditionally transitions to the filtering state.
					WHEN init =>
						s_adc_tx <= x"D014000B"; -- write 0x0B to address 0x14
						State <= filt;
						-- If the current state is filt, and the first switch is set, then
						-- the next state is a diagnostic state. If the switch is not set,
						-- then the next state is another filtering state.
					WHEN filt =>
						s_adc_tx <= x"00000000"; -- No-operation instruction to read ADC
						s_dac_tx <= dac_conversion; -- send filtered value to DAC
						if (SWITCHES = x"0001") then
						State <= diag;
						elsif (SWITCHES = x"0000") then
						State <= filt;
						end if;
					-- If the current state is diag, and the first switch is set, then
					-- the next state is another diagnostic state. If the switch is
					-- not set, then the next state is the filtering state.
					WHEN diag =>
					s_adc_tx <= x"00000000"; -- No-operation instruction to read ADC
					s_dac_tx <= s_adc_rx(30 downto 15); -- direct passthrough to DAC
					if (SWITCHES = x"0001") then
					State <= diag;
					elsif (SWITCHES = x"0000") then
					State <= filt;
					end if;
					-- if trapped in unknown state, loop initialization protocols
					WHEN others =>
					State <= init;
				END CASE;
			END IF;
		END PROCESS;
		LED <= SWITCHES; -- LED to indicate if a switch is flipped
end Behavioral;