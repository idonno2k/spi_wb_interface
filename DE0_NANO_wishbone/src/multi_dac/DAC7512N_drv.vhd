----------------------------------------------------------------------------------
-- Company: LGE
-- Engineer: byunghun.park
--
-- Create Date: 11/25/2021 
-- Design Name: DAC7512N_drv
-- Module Name: DAC7512N_drv - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--
-- Revision:
-- 
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity DAC7512N_drv is
Port ( 	
		CLK : IN STD_LOGIC;
		reset : IN STD_LOGIC;

		txData00 : in STD_LOGIC_VECTOR (11 downto 0);
		txData01 : in STD_LOGIC_VECTOR (11 downto 0);
		txData02 : in STD_LOGIC_VECTOR (11 downto 0);
		txData03 : in STD_LOGIC_VECTOR (11 downto 0);
		txData04 : in STD_LOGIC_VECTOR (11 downto 0);
		txData05 : in STD_LOGIC_VECTOR (11 downto 0);
		txData06 : in STD_LOGIC_VECTOR (11 downto 0);
		txData07 : in STD_LOGIC_VECTOR (11 downto 0);
		txData08 : in STD_LOGIC_VECTOR (11 downto 0);
		txData09 : in STD_LOGIC_VECTOR (11 downto 0);
		txData10 : in STD_LOGIC_VECTOR (11 downto 0);
		txData11 : in STD_LOGIC_VECTOR (11 downto 0);
		txData12 : in STD_LOGIC_VECTOR (11 downto 0);
		txData13 : in STD_LOGIC_VECTOR (11 downto 0);
		txData14 : in STD_LOGIC_VECTOR (11 downto 0);
		txData15 : in STD_LOGIC_VECTOR (11 downto 0);
		txData_valid : in STD_LOGIC;
		
		rxData : out  STD_LOGIC_VECTOR (18 downto 0);
		rxData_valid : out STD_LOGIC;
		
		dacCLK : OUT STD_LOGIC;
		dacCS : out STD_LOGIC;
		dacMOSI : OUT STD_LOGIC_VECTOR (15 downto 0);
		dacMISO : IN STD_LOGIC

	);
end DAC7512N_drv;

architecture Behavioral of DAC7512N_drv is

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

	signal dacBusy	: STD_LOGIC; --busy / data ready signal
	signal dacBusy_r : STD_LOGIC_VECTOR (7 downto 0);

	signal s_dac_tx00 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx01 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000"; -- received dac data word
	signal s_dac_tx02 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000"; 
	signal s_dac_tx03 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000"; 
	signal s_dac_tx04 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000"; 
	signal s_dac_tx05 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx06 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx07 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx08 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx09 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx10 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx11 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx12 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx13 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx14 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";
	signal s_dac_tx15 : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000";

	
	signal s_dac_tx : STD_LOGIC_VECTOR (18 downto 0):=B"000_0000_0000_0000_0000"; -- value transmitted to dac
	
	signal dacCS_r : STD_LOGIC_VECTOR(0 DOWNTO 0); --slave select
	signal samp_clk_cnt : STD_LOGIC_VECTOR(15 DOWNTO 0); --slave select
	
	begin

		--s_dac_tx <= txData;
		
		s_dac_tx00(11 downto 0) <= txData00;
		s_dac_tx01(11 downto 0) <= txData01;
		s_dac_tx02(11 downto 0) <= txData02;
		s_dac_tx03(11 downto 0) <= txData03;
		s_dac_tx04(11 downto 0) <= txData04;
		s_dac_tx05(11 downto 0) <= txData05;
		s_dac_tx06(11 downto 0) <= txData06;
		s_dac_tx07(11 downto 0) <= txData07;
		s_dac_tx08(11 downto 0) <= txData08;
		s_dac_tx09(11 downto 0) <= txData09;
		s_dac_tx10(11 downto 0) <= txData10;
		s_dac_tx11(11 downto 0) <= txData11;
		s_dac_tx12(11 downto 0) <= txData12;
		s_dac_tx13(11 downto 0) <= txData13;
		s_dac_tx14(11 downto 0) <= txData14;
		s_dac_tx15(11 downto 0) <= txData15;


		process(CLK, reset)
		begin
			if reset = '0' then
				dacBusy_r	<= (others => '0');
				rxData_valid <= '0';
			elsif CLK'event and CLK = '1' then
				dacBusy_r 	<= dacBusy_r(6 downto 0) & dacBusy;	
				rxData_valid <= '0';
				if dacBusy_r(1 downto 0) = "10" then
					rxData_valid <= '1';
				end if;
			end if;
		end process ;

		dacCS <= dacCS_r(0);

		u00_dac7512n : spi_master
		GENERIC MAP (
			slaves => 1, -- only one slave
			d_width => 19) -- dac deals in 32-bit SPI transactions
		PORT MAP (
			clock => CLK, -- system clock for high-speed serial clocks
			reset_n =>reset,
			enable => txData_valid,
			cpol => '0', -- standard SPI polarity
			cpha => '0', -- standard SPI phase
			cont => '0', -- not continuous mode, see developer's notes for details
			clk_div => 25, -- div50 = 2Mhz
			addr => 0, -- arbitrary address, see developer's notes for details

			tx_data => "0000000" & s_dac_tx00(11 downto 0), 
			rx_data => open, 
						
			SPI_clk => dacCLK,
			SPI_nss => dacCS_r,
			SPI_mosi => dacMOSI(0),
			SPI_miso => dacMISO,
			
			busy => dacBusy -- indicator flags from dac	
		);
		
		u01_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx01, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI( 1),	SPI_miso =>'0' , busy => open 	);
		u02_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx02, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI( 2),	SPI_miso =>'0' , busy => open 	);
		u03_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx03, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI( 3),	SPI_miso =>'0' , busy => open 	);
		u04_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx04, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI( 4),	SPI_miso =>'0' , busy => open 	);
		u05_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx05, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI( 5),	SPI_miso =>'0' , busy => open 	);
		u06_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx06, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI( 6),	SPI_miso =>'0' , busy => open 	);
		u07_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx07, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI( 7),	SPI_miso =>'0' , busy => open 	);
		u08_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx08, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI( 8),	SPI_miso =>'0' , busy => open 	);
		u09_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx09, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI( 9),	SPI_miso =>'0' , busy => open 	);
		u10_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx10, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI(10),	SPI_miso =>'0' , busy => open 	);
		u11_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx11, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI(11),	SPI_miso =>'0' , busy => open 	);
		u12_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx12, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI(12),	SPI_miso =>'0' , busy => open 	);
		u13_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx13, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI(13),	SPI_miso =>'0' , busy => open 	);
		u14_dac7512n: spi_master	GENERIC MAP ( slaves => 1, d_width => 19) PORT MAP ( clock => CLK, reset_n => reset,	enable => txData_valid, cpol => '0', cpha => '0', cont => '0', clk_div => 25, addr => 0,	tx_data => s_dac_tx14, rx_data => open, 		SPI_clk => open, SPI_nss => open, SPI_mosi => dacMOSI(14),	SPI_miso =>'0' , busy => open 	);





end Behavioral;