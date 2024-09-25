-------------------------------------------------------------------------------
-- Title         : FLED Controller Top
-- Project       : FLED Controller for PM driving
-------------------------------------------------------------------------------
-- File          : fled_ctrl_top.v
-- Author        : Jaewoon LEE <jaewoon77.lee@lge.com>
-- Created       : 20.02.2014
-- Last modified : 20.02.2014
-------------------------------------------------------------------------------
-- Description   : 
-- [note] pulse_width should be less than scan_period
--
-------------------------------------------------------------------------------
-- Modification history :
-- 20.02.2014 : created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use work.pkg.all;

library work ;
use work.logi_wishbone_pack.all ;
use work.logi_wishbone_peripherals_pack.all ;

entity DE0_NANO_TOP is
	port (

	------------ CLOCK ------------
	CLOCK_50			: in	std_logic;

	------------ KEY ------------
	KEY				: in	std_logic_vector( 1 downto 0);

	------------ SW ------------
	SW					: in	std_logic_vector( 3 downto 0);
	------------ SDRAM ------------
	DRAM_ADDR		: out	std_logic_vector( 12 downto 0);
	DRAM_BA			: out	std_logic_vector( 1 downto 0);
	DRAM_CAS_N		: out	std_logic;
	DRAM_CKE			: out	std_logic;
	DRAM_CLK			: out	std_logic;
	DRAM_CS_N		: out	std_logic;
	DRAM_DQ			: inout	std_logic_vector( 15 downto 0);
	DRAM_DQM			: out	std_logic_vector( 1 downto 0);
	DRAM_RAS_N		: out	std_logic;
	DRAM_WE_N		: out	std_logic;

	------------ EPCS ------------
	EPCS_ASDO		: out	std_logic;
	EPCS_DATA0		: in	std_logic;
	EPCS_DCLK		: out	std_logic;
	EPCS_NCSO		: out	std_logic;

	------------ Accelerometer and EEPROM ------------
	G_SENSOR_CS_N	: out	std_logic;
	G_SENSOR_INT	: in	std_logic;
	I2C_SCLK		: out	std_logic;
	I2C_SDAT		: in	std_logic;

	------------ ADC ------------
	ADC_CS_N		: out	std_logic;
	ADC_SADDR		: out	std_logic;
	ADC_SCLK			: out	std_logic;
	ADC_SDAT			: in	std_logic;

--	------------ 2x13 GPIO Header ------------
--	GPIO_2			: inout	std_logic_vector( 12 downto 0);
--	GPIO_2_IN		: in	std_logic_vector( 2 downto 0);
--
--	------------ GPIO_0, GPIO_0 connect to GPIO Default ------------
--	GPIO_0_D				: inout	std_logic_vector( 33 downto 0);
--	GPIO_0_IN    	: in	std_logic_vector( 1 downto 0);
--
--	------------ GPIO_1, GPIO_1 connect to GPIO Default ------------
--	GPIO_1_D			 	: inout	std_logic_vector( 33 downto 0);
--	GPIO_1_IN       : in	std_logic_vector( 1 downto 0)

	SPI_M_SCLK	: in std_logic;
	SPI_M_MOSI	: in std_logic;
	SPI_M_MISO	: out std_logic;
	SPI_M_NSS	: in std_logic;
		
	ADC_A_CLK  : out std_logic;
	ADC_A_CS	: out std_logic_vector (3 downto 0);
	ADC_A_MOSI : out std_logic;
	ADC_A_MISO : in std_logic_vector (7 downto 0);	

	ADC_B_CLK  : out std_logic;
	ADC_B_CS	: out std_logic_vector (3 downto 0);
	ADC_B_MOSI : out std_logic;
	ADC_B_MISO : in std_logic_vector (7 downto 0);	

	ADC_C_CLK  : out std_logic;
	ADC_C_CS	: out std_logic_vector (3 downto 0);
	ADC_C_MOSI : out std_logic;
	ADC_C_MISO : in std_logic_vector (7 downto 0);	

	ADC_D_CLK  : out std_logic;
	ADC_D_CS	: out std_logic_vector (3 downto 0);
	ADC_D_MOSI : out std_logic;
	ADC_D_MISO : in std_logic_vector (7 downto 0);	

	------------ LED ------------
	LED				: out	std_logic_vector( 7 downto 0)
	);
end DE0_NANO_TOP;


architecture struct of DE0_NANO_TOP is

	component pll_sys		-- MAX : 4 clk out c0~c3
	port (
		inclk0				: in  std_logic  := '0';
		c0					: out std_logic ;
		c1					: out std_logic ;
		c2					: out std_logic ;
		c3					: out std_logic ;
		c4					: out std_logic ;
		locked				: out std_logic 
	);
	end component;
	
	component DVI_DEMO is
	port (
		------------ CLOCK //////////
		pll_100M: in std_logic ;
		--pll_100K: in std_logic ;
		reset_n: in std_logic ;

		------------ BUTTON x 4, EXT_IO and CPU_RESET_n ------------
		BUTTON: in std_logic_vector (3 downto 0);

		------------ Hsmc-b ------------
		DVI_RX_CLK: in std_logic ;
		DVI_RX_VS: in std_logic ;
		DVI_RX_HS: in std_logic ;
		DVI_RX_DE: in std_logic ;
		DVI_RX_D: in std_logic_vector (23 downto 0);

		DVI_EDID_WP: out std_logic ;
		DVI_RX_DDCSCL: inout std_logic;           
		DVI_RX_DDCSDA: inout std_logic;           

		DVI_TX_CLK: out std_logic ;
		DVI_TX_VS: out std_logic ;
		DVI_TX_HS: out std_logic ;
		DVI_TX_DE: out std_logic ;
		DVI_TX_D: out std_logic_vector (23 downto 0);

		tp	   : out std_logic_vector(17 downto 0)
	);
	end component;

	component spi_adc_top is
	port (
		rst_n		: in std_logic;
		clk		: in std_logic;

		vsync 		: in std_logic;
		hsync 		: in std_logic;

		-- Syscon signals
		gls_reset    : in std_logic ;
		gls_clk      : in std_logic ;
		
		-- Wishbone signals
		wbs_address       : in std_logic_vector(15 downto 0) ;
		wbs_writedata : in std_logic_vector( 15 downto 0);
		wbs_readdata  : out std_logic_vector( 15 downto 0);
		wbs_strobe    : in std_logic ;
		wbs_cycle      : in std_logic ;
		wbs_write     : in std_logic ;
		wbs_ack       : out std_logic;

		-- mcp3208 x32 --
		adcCLK0 	: out	std_logic;
		adcCS0 	: out	std_logic_vector(3 downto 0);
		adcMOSI0 : out	std_logic;
		adcMISO0 : in	std_logic_vector(31 downto 0);

		-- adc128 x32 --
		adcCLK1 : out	std_logic;
		adcCS1 	: out	std_logic;
		adcMOSI1: out	std_logic;
		adcMISO1: in	std_logic;

		tp	: out std_logic_vector(17 downto 0)
		);
	end component;

	
	component UART_top is
	port (
		reset_n		: in	std_logic;	-- reset
		usrt_clk	: in	std_logic;	-- clock
		
		-- serial interface-----
		uart_rxd		: in	STD_LOGIC;
		uart_txd		: out	STD_LOGIC;
		
		uart_tx_active		: out	STD_LOGIC;
		
		---- internal fifo ----
		tx_aclr		: IN STD_LOGIC ;
		tx_wrclk		: IN STD_LOGIC ;
		tx_wrreq		: IN STD_LOGIC ;
		tx_data			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		tx_wrfull		: OUT STD_LOGIC; 

		rx_rdclk		: IN STD_LOGIC ;
		rx_rdreq		: IN STD_LOGIC ;
		rx_q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		rx_rdempty		: OUT STD_LOGIC ;
		
		test		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)

	);
	end component;

	component spi_dac_top is
	port (
			rst_n		: in std_logic;
			clk		: in std_logic;
			
			vsync 		: in std_logic;
			hsync 		: in std_logic;
			
			-- Syscon signals
			gls_reset    : in std_logic ;
			gls_clk      : in std_logic ;
			
			-- Wishbone signals
			wbs_address       : in std_logic_vector(15 downto 0) ;
			wbs_writedata : in std_logic_vector( 15 downto 0);
			wbs_readdata  : out std_logic_vector( 15 downto 0);
			wbs_strobe    : in std_logic ;
			wbs_cycle      : in std_logic ;
			wbs_write     : in std_logic ;
			wbs_ack       : out std_logic;
			
			-- mcp3208 x32 --
			dacCLK0 	: out	std_logic;
			dacCS0 	: out	std_logic;
			dacMOSI0 : out	std_logic_vector(15 downto 0);
			dacMISO0 : in	std_logic;

			tp	: out std_logic_vector(17 downto 0)
		);
	end component;
	

--	type wishbone_bus is
--	record
--		address : std_logic_vector(15 downto 0);
--		writedata : std_logic_vector(15 downto 0);
--		readdata : std_logic_vector(15 downto 0);
--		cycle: std_logic;
--		write : std_logic;
--		strobe : std_logic;
--		ack : std_logic;
--	end record;

	type RGBsignal is --s
	record
		pclk	: std_logic;
		vsync	: std_logic;
		hsync	: std_logic;
		blank	: std_logic;
		pix24bit : std_logic_vector(23 downto 0);
		pix48bit : std_logic_vector(47 downto 0);

	end record;

	type array_of_reg16 is array(NATURAL range <>) of std_logic_vector(15 downto 0);
	signal reg16_arr0 : array_of_reg16(15 downto 0);
	
	signal gls_clk, gls_reset  : std_logic ;
	
	signal mspi_sck ,mspi_mosi, mspi_miso, mspi_nss : std_logic;

	signal Master_0_wbm_Intercon_0_wbs_0 : wishbone_bus;
	signal Intercon_0_wbm_reg_0_wbs_0 : wishbone_bus;
	signal Intercon_0_wbm_dac_1_wbs_0 : wishbone_bus;
	signal Intercon_0_wbm_adc_1_wbs_0 : wishbone_bus;
	
	signal led_out : std_logic_vector(17 downto 0);

	-- clk
	signal rst_n			: std_logic;
	signal pll_locked		: std_logic;

	signal clk_100M			: std_logic;	
	signal clk_150M			: std_logic;
	signal clk_200M			: std_logic;	
	signal clk_50M			: std_logic;
	signal clk_2M			: std_logic;
	
	signal video_loopback 	: RGBsignal;
	signal video_out 		: RGBsignal;
	
	TYPE machine IS(sync, payload, idle); --state machine data type
	SIGNAL state : machine; --current stat
	signal	state_cnt		: STD_LOGIC_VECTOR (3 DOWNTO 0);
		
	signal	wraddress	: STD_LOGIC_VECTOR (10 DOWNTO 0);
	signal	wrclock		: STD_LOGIC  := '1';
	signal	wren		: STD_LOGIC  := '0';
	signal	data_a		: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal	rdaddress	: STD_LOGIC_VECTOR (10 DOWNTO 0);
	signal	rdclock		: STD_LOGIC ;
	signal	q			: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal	adc_clk  : STD_LOGIC;
	signal	adc_cs 	 : STD_LOGIC_VECTOR (3 downto 0);
	signal	adc_mosi : STD_LOGIC;
	signal	adc_miso : STD_LOGIC_VECTOR (31 downto 0);
	
	signal	adc_data : STD_LOGIC_VECTOR (11 downto 0);
	
	signal	tx_aclr	: STD_LOGIC;
	signal	tx_wrfull	: STD_LOGIC; 
	signal	tx_wrreq	: STD_LOGIC ;
	signal	tx_wrreq_r	: STD_LOGIC ;
	signal	tx_data		: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal	tx_data_r		: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal	tx_valid_cnt	: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal	tx_valid_num	: STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal	tx_threshold	: STD_LOGIC_VECTOR (15 DOWNTO 0) := X"000A";
	
	signal	tx_period_cnt	: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal	tx_sync_cnt	: STD_LOGIC_VECTOR (4 DOWNTO 0);
	
	signal	UART_RX		: std_logic;
	signal	UART_TX		: std_logic;

	signal	test_reg	: STD_LOGIC_VECTOR (15 DOWNTO 0);

begin

----------------------------------------------------------------------------------------------
-- port align
mspi_sck   <= '0' 	  when SW(0) = '0' else	 SPI_M_SCLK ;
mspi_mosi  <= UART_RX when SW(0) = '0' else	 SPI_M_MOSI ;
SPI_M_MISO <= UART_TX when SW(0) = '0' else	 mspi_miso ;
mspi_nss   <= '0'	  when SW(0) = '0' else	 SPI_M_NSS ;

------------ GPIO_0, GPIO_0 connect to GPIO Default ------------
--	GPIO_0_D				: inout	std_logic_vector( 33 downto 0);

                                            --SPI_M_SCLK;
                                            --SPI_M_MOSI <=  UART_TX;
                                                
ADC_A_CLK  <=  adc_clk;                     ADC_B_CLK <= adc_clk;
ADC_A_MOSI <=  adc_mosi;                    ADC_B_MOSI <= adc_mosi;
-- +5V                                      -- GND
adc_miso(0) <=  ADC_A_MISO(0);              adc_miso( 8) <=  ADC_B_MISO(0);
adc_miso(1) <=  ADC_A_MISO(1);              adc_miso( 9) <=  ADC_B_MISO(1);
adc_miso(2) <=  ADC_A_MISO(2);              adc_miso(10) <=  ADC_B_MISO(2);
adc_miso(3) <=  ADC_A_MISO(3);              adc_miso(11) <=  ADC_B_MISO(3);
adc_miso(4) <=  ADC_A_MISO(4);              adc_miso(12) <=  ADC_B_MISO(4);
adc_miso(5) <=  ADC_A_MISO(5);              adc_miso(13) <=  ADC_B_MISO(5);
adc_miso(6) <=  ADC_A_MISO(6);              adc_miso(14) <=  ADC_B_MISO(6);
adc_miso(7) <=  ADC_A_MISO(7);              adc_miso(15) <=  ADC_B_MISO(7);
-- +3.3V                                    -- GND                                                  
ADC_A_CS(0) <=  adc_cs(0);                  ADC_B_CS(0) <=  adc_cs(0);
ADC_A_CS(1) <=  adc_cs(1);                  ADC_B_CS(1) <=  adc_cs(1);
ADC_A_CS(2) <=  adc_cs(2);                  ADC_B_CS(2) <=  adc_cs(2);
ADC_A_CS(3) <=  adc_cs(3);                  ADC_B_CS(3) <=  adc_cs(3);

------------ GPIO_1, GPIO_1 connect to GPIO Default ------------
--	GPIO_1_D			 	: inout	std_logic_vector( 33 downto 0);

                                            --SPI_M_MISO <= UART_TX;
                                            --SPI_M_NSS <= led_out(2); 
                                                        
ADC_C_CLK  <=  adc_clk;                     ADC_D_CLK  <=  adc_clk;
ADC_C_MOSI <=  adc_mosi;                    ADC_D_MOSI <=  adc_mosi;
 -- +5V                                     -- GND                                                   
adc_miso(16) <= ADC_C_MISO(0);              adc_miso(24) <= ADC_D_MISO(0);
adc_miso(17) <= ADC_C_MISO(1);              adc_miso(25) <= ADC_D_MISO(1);
adc_miso(18) <= ADC_C_MISO(2);              adc_miso(26) <= ADC_D_MISO(2);
adc_miso(19) <= ADC_C_MISO(3);              adc_miso(27) <= ADC_D_MISO(3);
adc_miso(20) <= ADC_C_MISO(4);              adc_miso(28) <= ADC_D_MISO(4);
adc_miso(21) <= ADC_C_MISO(5);              adc_miso(29) <= ADC_D_MISO(5);
adc_miso(22) <= ADC_C_MISO(6);              adc_miso(30) <= ADC_D_MISO(6);
adc_miso(23) <= ADC_C_MISO(7);              adc_miso(31) <= ADC_D_MISO(7);
-- +3.3V                                    -- GND                                                    
ADC_C_CS(0) <=  adc_cs(0);                  ADC_D_CS(0) <=  adc_cs(0);
ADC_C_CS(1) <=  adc_cs(1);                  ADC_D_CS(1) <=  adc_cs(1);
ADC_C_CS(2) <=  adc_cs(2);                  ADC_D_CS(2) <=  adc_cs(2);
ADC_C_CS(3) <=  adc_cs(3);                  ADC_D_CS(3) <=  adc_cs(3);



------------ GPIO_0, GPIO_0 connect to GPIO Default ------------
--	GPIO_0_D				: inout	std_logic_vector( 33 downto 0);
--
--                                                        GPIO_0_D( 0) <=  UART_RX;
--                                                        GPIO_0_D( 1) <=  UART_TX;
--                                                        
--GPIO_0_D( 4) <=  adc_clk;                               GPIO_0_D( 5) <= adc_clk;
--GPIO_0_D( 6) <=  adc_mosi;                              GPIO_0_D( 7) <= adc_mosi;
---- +5V                                                  -- GND
--GPIO_0_D( 8) <=  adc_miso(0);                           GPIO_0_D( 9) <=  adc_miso(8);
--GPIO_0_D(10) <=  adc_miso(1);                           GPIO_0_D(11) <=  adc_miso(9);
--GPIO_0_D(12) <=  adc_miso(2);                           GPIO_0_D(13) <=  adc_miso(10);
--GPIO_0_D(14) <=  adc_miso(3);                           GPIO_0_D(15) <=  adc_miso(11);
--GPIO_0_D(16) <=  adc_miso(4);                           GPIO_0_D(17) <=  adc_miso(12);
--GPIO_0_D(18) <=  adc_miso(5);                           GPIO_0_D(19) <=  adc_miso(13);
--GPIO_0_D(20) <=  adc_miso(6);                           GPIO_0_D(21) <=  adc_miso(14);
--GPIO_0_D(22) <=  adc_miso(7);                           GPIO_0_D(23) <=  adc_miso(15);
---- +3.3V                                                -- GND                                                      
--GPIO_0_D(24) <=  adc_cs(0);                             GPIO_0_D(25) <=  adc_cs(0);
--GPIO_0_D(26) <=  adc_cs(1);                             GPIO_0_D(27) <=  adc_cs(1);
--GPIO_0_D(28) <=  adc_cs(2);                             GPIO_0_D(29) <=  adc_cs(2);
--GPIO_0_D(30) <=  adc_cs(3);                             GPIO_0_D(31) <=  adc_cs(3);
--
--
--
-------------- GPIO_1, GPIO_1 connect to GPIO Default ------------
----	GPIO_1_D			 	: inout	std_logic_vector( 33 downto 0);
--
--                                                        GPIO_1_D( 0) <= video_out.vsync;
--                                                        GPIO_1_D( 1) <= led_out(2); 
--                                                        
--GPIO_1_D( 4) <=  adc_clk;                               GPIO_1_D( 5) <=  adc_clk;
--GPIO_1_D( 6) <=  adc_mosi;                              GPIO_1_D( 7) <=  adc_mosi;
-- -- +5V                                                 -- GND                                                       
--GPIO_1_D( 8) <=  adc_miso(16);                          GPIO_1_D( 9) <=  adc_miso(24);
--GPIO_1_D(10) <=  adc_miso(17);                          GPIO_1_D(11) <=  adc_miso(25);
--GPIO_1_D(12) <=  adc_miso(18);                          GPIO_1_D(13) <=  adc_miso(26);
--GPIO_1_D(14) <=  adc_miso(19);                          GPIO_1_D(15) <=  adc_miso(27);
--GPIO_1_D(16) <=  adc_miso(20);                          GPIO_1_D(17) <=  adc_miso(28);
--GPIO_1_D(18) <=  adc_miso(21);                          GPIO_1_D(19) <=  adc_miso(29);
--GPIO_1_D(20) <=  adc_miso(22);                          GPIO_1_D(21) <=  adc_miso(30);
--GPIO_1_D(22) <=  adc_miso(23);                          GPIO_1_D(23) <=  adc_miso(31);
---- +3.3V                                                -- GND                                                        
--GPIO_1_D(24) <=  adc_cs(0);                             GPIO_1_D(25) <=  adc_cs(0);
--GPIO_1_D(26) <=  adc_cs(1);                             GPIO_1_D(27) <=  adc_cs(1);
--GPIO_1_D(28) <=  adc_cs(2);                             GPIO_1_D(29) <=  adc_cs(2);
--GPIO_1_D(30) <=  adc_cs(3);                             GPIO_1_D(31) <=  adc_cs(3);




	u_pll_sys : pll_sys		-- MAX : 4 clk out c0~c3
	port map (
		inclk0			=> CLOCK_50,
		c0				=> clk_50M,		-- clk_50mb,
		c1				=> clk_100M,	--100
		c2				=> clk_200M,	--200
		c3				=> clk_2M,		--2
		c4				=> clk_150M,	--150
		locked			=> pll_locked
	);

	rst_n	<= KEY(0) and pll_locked;

	-- video signal gen
	u_video_src : DVI_DEMO
	port map(
		------------ CLOCK //////////
		pll_100M	=> clk_100M,

		reset_n		=> rst_n,

		------------ BUTTON x 4, EXT_IO and CPU_RESET_n ------------
		BUTTON		=> "0000",

		DVI_RX_CLK	=> video_loopback.pclk,
		DVI_RX_VS	=> video_loopback.vsync,
		DVI_RX_HS	=> video_loopback.hsync,
		DVI_RX_DE	=> video_loopback.blank,
		DVI_RX_D	=> video_loopback.pix24bit,

		DVI_EDID_WP		=> open,
		DVI_RX_DDCSCL	=> open,
		DVI_RX_DDCSDA	=> open,

		DVI_TX_CLK	=> video_out.pclk,
		DVI_TX_VS	=> video_out.vsync,
		DVI_TX_HS	=> video_out.hsync,
		DVI_TX_DE	=> video_out.blank,
		DVI_TX_D	=> video_out.pix24bit,

		tp	   => open
	);
	
	--LED(0) <= not video_out.vsync;
	
	u_multi_dac_top : spi_dac_top
	port map(
		rst_n	=> rst_n,
		clk		=> clk_100M,
		
		vsync 	=> video_out.vsync,
		hsync 	=> video_out.hsync,
		
		-- Syscon signals
		gls_reset   => gls_reset ,
		gls_clk     => gls_clk ,
		
		-- Wishbone signals
		wbs_address   => Intercon_0_wbm_dac_1_wbs_0.address,
		wbs_writedata => Intercon_0_wbm_dac_1_wbs_0.writedata,
		wbs_readdata  => Intercon_0_wbm_dac_1_wbs_0.readdata,
		wbs_strobe    => Intercon_0_wbm_dac_1_wbs_0.cycle,
		wbs_cycle     => Intercon_0_wbm_dac_1_wbs_0.strobe,
		wbs_write     => Intercon_0_wbm_dac_1_wbs_0.write,
		wbs_ack       => Intercon_0_wbm_dac_1_wbs_0.ack	,
		
		-- mcp3208 x32 --
		dacCLK0  => open,
		dacCS0 	 => open,
		dacMOSI0  => open,
		dacMISO0  => '0',

		tp	 => open
	);
	
	u_multi_adc_drv : spi_adc_top
	port map(
		rst_n		=> rst_n,
		clk			=> clk_100M,

		vsync		=> video_out.vsync,					
		hsync		=> video_out.hsync,               
		  
		  
		-- Syscon signals
		gls_reset   => gls_reset ,
		gls_clk     => gls_clk ,
		
		-- Wishbone signals
		wbs_address   => Intercon_0_wbm_adc_1_wbs_0.address,
		wbs_writedata => Intercon_0_wbm_adc_1_wbs_0.writedata,
		wbs_readdata  => Intercon_0_wbm_adc_1_wbs_0.readdata,
		wbs_strobe    => Intercon_0_wbm_adc_1_wbs_0.cycle,
		wbs_cycle     => Intercon_0_wbm_adc_1_wbs_0.strobe,
		wbs_write     => Intercon_0_wbm_adc_1_wbs_0.write,
		wbs_ack       => Intercon_0_wbm_adc_1_wbs_0.ack	,
			   
		adcCLK0 	=>	adc_clk ,                      
		adcCS0 		=>	adc_cs 	,                       
		adcMOSI0 	=>	adc_mosi,
		adcMISO0	=>	adc_miso, 
			                        
		adcCLK1 	=>	ADC_SCLK ,                      
		adcCS1 		=>	ADC_CS_N 	,                       
		adcMOSI1 	=>	ADC_SADDR,
		adcMISO1	=>	ADC_SDAT, 
		
		tp			=> open
	);
	

	
------------------------------------------------------------------------------------/
-- PC interface
------------------------------------------------------------------------------------/
  
--	
--	u_uart_top : UART_top                                                                     
--	port map(                                                                                 
--		reset_n		=> rst_n,                                                                 
--		usrt_clk	=> clk_100M,                                                              
--
--		uart_rxd	=> UART_RX,  --in                                                         
--		uart_txd	=> UART_TX,    --out                                                         
--                     
--		uart_tx_active => open,
--
--		tx_aclr		=> '0',
--		tx_wrclk	=> clk_50M,                                                               
--		tx_wrreq	=> tx_wrreq,                                                              
--		tx_data		=> tx_data,                                                               
--		tx_wrfull	=> tx_wrfull,                                                             
--
--		rx_rdclk	=> clk_50M,                                                               
--		rx_rdreq	=> '0',                                                                   
--		rx_q		=> open,                                                                  
--		rx_rdempty	=> open,
--
--		test => open
--	); 

---------------------------------------------------------------------------------------------------
-- wishbone interface
---------------------------------------------------------------------------------------------------

	gls_clk <= clk_50M;
	gls_reset <= (NOT pll_locked); -- system reset while clock not locked

	Master_0 : spi_wishbone_wrapper
	-- no generics
	port map(
		gls_clk => gls_clk,
		gls_reset => gls_reset,

		mosi => mspi_mosi,
		miso =>	mspi_miso,
		ss   => mspi_nss,
		sck  => mspi_sck,

		wbm_address		=>  Master_0_wbm_Intercon_0_wbs_0.address,
		wbm_writedata	=>  Master_0_wbm_Intercon_0_wbs_0.writedata,
		wbm_readdata	=>  Master_0_wbm_Intercon_0_wbs_0.readdata,
		wbm_cycle		=>  Master_0_wbm_Intercon_0_wbs_0.cycle,
		wbm_strobe		=>  Master_0_wbm_Intercon_0_wbs_0.strobe,
		wbm_write		=>  Master_0_wbm_Intercon_0_wbs_0.write,
		wbm_ack			=>  Master_0_wbm_Intercon_0_wbs_0.ack,

		test		=> open
	);
	
	Intercon_0 : wishbone_intercon
	generic map(
	memory_map =>  (0 => B"0000_0000_0000_XXXX",
					1 => B"0000_0000_0001_XXXX",
					2 => B"001X_XXXX_XXXX_XXXX"
					)
	)
	port map(
		gls_clk => gls_clk, gls_reset => gls_reset,

		wbs_address		=>  Master_0_wbm_Intercon_0_wbs_0.address,
		wbs_writedata	=>  Master_0_wbm_Intercon_0_wbs_0.writedata,
		wbs_readdata	=>  Master_0_wbm_Intercon_0_wbs_0.readdata,
		wbs_cycle		=>  Master_0_wbm_Intercon_0_wbs_0.cycle,
		wbs_strobe		=>  Master_0_wbm_Intercon_0_wbs_0.strobe,
		wbs_write		=>  Master_0_wbm_Intercon_0_wbs_0.write,
		wbs_ack			=>  Master_0_wbm_Intercon_0_wbs_0.ack,

		------------------------------------------------------------

		wbm_address(0)	=>  Intercon_0_wbm_reg_0_wbs_0.address,
		wbm_writedata(0)=>  Intercon_0_wbm_reg_0_wbs_0.writedata,
		wbm_readdata(0) =>  Intercon_0_wbm_reg_0_wbs_0.readdata,
		wbm_cycle(0) 	=>  Intercon_0_wbm_reg_0_wbs_0.cycle,
		wbm_strobe(0) 	=>  Intercon_0_wbm_reg_0_wbs_0.strobe,
		wbm_write(0) 	=>  Intercon_0_wbm_reg_0_wbs_0.write,
		wbm_ack(0) 		=>  Intercon_0_wbm_reg_0_wbs_0.ack,		

		wbm_address(1)	=>  Intercon_0_wbm_dac_1_wbs_0.address,
		wbm_writedata(1)=>  Intercon_0_wbm_dac_1_wbs_0.writedata,
		wbm_readdata(1) =>  Intercon_0_wbm_dac_1_wbs_0.readdata,
		wbm_cycle(1) 	=>  Intercon_0_wbm_dac_1_wbs_0.cycle,
		wbm_strobe(1) 	=>  Intercon_0_wbm_dac_1_wbs_0.strobe,
		wbm_write(1) 	=>  Intercon_0_wbm_dac_1_wbs_0.write,
		wbm_ack(1) 		=>  Intercon_0_wbm_dac_1_wbs_0.ack,
		
		wbm_address(2)	=>  Intercon_0_wbm_adc_1_wbs_0.address,
		wbm_writedata(2)=>  Intercon_0_wbm_adc_1_wbs_0.writedata,
		wbm_readdata(2) =>  Intercon_0_wbm_adc_1_wbs_0.readdata,
		wbm_cycle(2) 	=>  Intercon_0_wbm_adc_1_wbs_0.cycle,
		wbm_strobe(2) 	=>  Intercon_0_wbm_adc_1_wbs_0.strobe,
		wbm_write(2) 	=>  Intercon_0_wbm_adc_1_wbs_0.write,
		wbm_ack(2) 		=>  Intercon_0_wbm_adc_1_wbs_0.ack

	);

	register0 : wishbone_register
	generic map(nb_regs => 16)
	 port map
	 (
		  -- Syscon signals
		  gls_reset   => gls_reset ,
		  gls_clk     => gls_clk ,
		  
		  -- Wishbone signals
		  wbs_address   => Intercon_0_wbm_reg_0_wbs_0.address,
		  wbs_writedata => Intercon_0_wbm_reg_0_wbs_0.writedata,
		  wbs_readdata  => Intercon_0_wbm_reg_0_wbs_0.readdata,
		  wbs_strobe    => Intercon_0_wbm_reg_0_wbs_0.cycle,
		  wbs_cycle     => Intercon_0_wbm_reg_0_wbs_0.strobe,
		  wbs_write     => Intercon_0_wbm_reg_0_wbs_0.write,
		  wbs_ack       => Intercon_0_wbm_reg_0_wbs_0.ack	,
		 
		  -- out signals
		  reg_out( 0) => reg16_arr0( 0),	reg_in( 0) => reg16_arr0( 0),
		  reg_out( 1) => reg16_arr0( 1),    reg_in( 1) => reg16_arr0( 1),
		  reg_out( 2) => reg16_arr0( 2),    reg_in( 2) => reg16_arr0( 2),
		  reg_out( 3) => reg16_arr0( 3),    reg_in( 3) => reg16_arr0( 3),
		  reg_out( 4) => reg16_arr0( 4),	reg_in( 4) => reg16_arr0( 4),
		  reg_out( 5) => reg16_arr0( 5),	reg_in( 5) => reg16_arr0( 5),
		  reg_out( 6) => reg16_arr0( 6),	reg_in( 6) => reg16_arr0( 6),
		  reg_out( 7) => reg16_arr0( 7),	reg_in( 7) => reg16_arr0( 7),
		  reg_out( 8) => reg16_arr0( 8),	reg_in( 8) => reg16_arr0( 8),
		  reg_out( 9) => reg16_arr0( 9),	reg_in( 9) => reg16_arr0( 9),
		  reg_out(10) => reg16_arr0(10),	reg_in(10) => reg16_arr0(10),
		  reg_out(11) => reg16_arr0(11),	reg_in(11) => reg16_arr0(11),
		  reg_out(12) => reg16_arr0(12),	reg_in(12) => reg16_arr0(12),
		  reg_out(13) => reg16_arr0(13),	reg_in(13) => reg16_arr0(13),
		  reg_out(14) => reg16_arr0(14),	reg_in(14) => reg16_arr0(14),
		  reg_out(15) => reg16_arr0(15),	reg_in(15) => reg16_arr0(15)
	 );
--LED <= Intercon_0_wbm_reg_0_wbs_0.readdata(7 downto 0);
--LED <= Master_0_wbm_Intercon_0_wbs_0.readdata(7 downto 0);
LED <= reg16_arr( 0)(7 downto 0);

----------------------------------------------------------------------------------------------

	process (clk_50M, rst_n)                                                                  
	begin                                                                                     
		if rst_n = '0' then                                                                   
                                             

			--LED <=(others => '0');  

		elsif clk_50M'event and clk_50M = '1' then     
		
		--LED(0) <= mspi_sck;
		--LED(1) <= mspi_mosi;
		--LED(2) <= mspi_miso;
		--LED(3) <= mspi_nss;
		
		end if;                                                                               
	end process ;  


--u_ADC8003 : ADC_CTRL
--port map(
--	iRST	=> gls_reset,
--	iCLK	=> clk_2M,
--	iCLK_n	=> not clk_2M,
--	iGO		=> '1',
--	iCH		=> "000",
--	oLED	=> open,
--	
--	oDIN	=> ADC_SADDR,
--	oCS_n	=> ADC_CS_N,
--	oSCLK	=> ADC_SCLK,
--	iDOUT	=> ADC_SDAT
--);


end struct;

