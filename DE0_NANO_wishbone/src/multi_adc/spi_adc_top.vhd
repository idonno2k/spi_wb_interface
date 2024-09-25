-------------------------------------------------------------------------------
-- Title         : DFF_128x90signage_top                                     --
-- Project       : DFF_128x90signage_top                                     --
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

library work ;
use work.logi_wishbone_pack.all ;
use work.logi_wishbone_peripherals_pack.all ;

entity spi_adc_top is
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

	-- adc128 x8 --
	adcCLK1 : out	std_logic;
	adcCS1 	: out	std_logic;
	adcMOSI1: out	std_logic;
	adcMISO1: in	std_logic;

	tp	: out std_logic_vector(17 downto 0)
	);
end spi_adc_top;

architecture struct of spi_adc_top is

	constant SYS_FREQ_Hz : positive := 100_000_000;
	constant ADC_FREQ_Hz : positive := 2_000_000;

	constant ADC_BIT	: positive := 24;

	constant SPS_DIVIDE  : positive := (SYS_FREQ_Hz/ADC_FREQ_Hz * ADC_BIT );

	component sampling_clk_gen is
	Port ( 	
		clk : IN std_logic;
		reset : IN std_logic;
		div_ratio : IN INTEGER;
		clock_out : OUT std_logic
	);
	end component;

	component mcp3208_32ch_drv_top is
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
	end component;

	component ADC128S022_top is
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
	end component;

	component adc_data_buf IS
	PORT
	(
		wraddress	: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		wrclock		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		
		rdaddress	: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		q			: 	OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	END component;
	
	signal sps_clk	: std_logic;
	signal sps_clk_edge	: std_logic;

	signal samp_cnt				: std_logic_vector(15 downto 0);

	signal samp_cnt3_dly : std_logic_vector (1621 DOWNTO 0);
	signal samp_cnt4_dly : std_logic_vector (1621 DOWNTO 0);
	
	signal cs_dly : std_logic_vector (1 DOWNTO 0);

	signal vsync_reg : std_logic_vector (7 downto 0);
	signal hsync_reg : std_logic_vector (7 downto 0);
	signal samp_reg : std_logic_vector (7 downto 0);

	signal s_adc_tx : std_logic_vector (18 downto 0):=B"000_0000_0000_0000_0000"; -- received ADC data word
	signal s_adc_rx : std_logic_vector (15 downto 0):=X"0000"; -- value transmitted to DAC
	
	signal s_adc_en	: std_logic;

	signal adc_clk0 	: 	std_logic;
	signal adc_cs0 	: 	std_logic;
	signal adc_mosi0 : 	std_logic;
	signal adc_miso0 : 	std_logic_vector(31 downto 0);
	
	signal adc_clk1 : 	std_logic;
	signal adc_cs1 	: 	std_logic;
	signal adc_mosi1 : 	std_logic;
	signal adc_miso1 : 	std_logic;

	signal adc_waddr_r : std_logic_vector (10 DOWNTO 0);
	signal s_adc_en_r : std_logic_vector (1621 DOWNTO 0);

	signal rxData_arr : array_of_slv16(0 to 31);

	signal rxData_valid0 : std_logic;
	signal rxData_valid0_r : std_logic_vector (50 downto 0);
	
	signal rxData1_r   : std_logic_vector(15 downto 0);
	signal rxData_valid1 : std_logic;
	signal rxData_valid1_r : std_logic_vector (50 downto 0);
	
	signal adc_waddr : std_logic_vector (10 DOWNTO 0);
	signal adc_wdata : std_logic_vector(15 downto 0);
	signal adc_wen : std_logic;
	
	signal read_ack : std_logic ;
	signal write_ack : std_logic ;
	signal write_mem : std_logic ;
	
	signal adc128_arr : array_of_slv16(0 to 7);
	
	signal wbs_readdata_r : std_logic_vector(15 downto 0);

	signal test_mode	: std_logic := '1';

begin

------------------------------------------------------------------------------------------
--wishbone interface

	write_bloc : process(gls_clk,gls_reset)
	begin
		if gls_reset = '1' then 
			write_ack <= '0';
		elsif rising_edge(gls_clk) then
			if ((wbs_strobe and wbs_write and wbs_cycle) = '1' ) then
				write_ack <= '1';
			else
				write_ack <= '0';
			end if;
		end if;
	end process write_bloc;


	read_bloc : process(gls_clk, gls_reset)
	begin
		if gls_reset = '1' then
			
		elsif rising_edge(gls_clk) then
			if (wbs_strobe = '1' and wbs_write = '0'  and wbs_cycle = '1' ) then
				read_ack <= '1';
			else
				read_ack <= '0';
			end if;
		end if;
	end process read_bloc;
	wbs_ack <= read_ack or write_ack;
	write_mem  <= wbs_strobe and wbs_write and wbs_cycle  ;

------------------------------------------------------------------------------------------
--multi adc

	u_adc_data_buf : adc_data_buf
	PORT map
	(
		wrclock		=> 	clk,
		wraddress	=>	adc_waddr,		
		wren		=>	adc_wen,		
		data		=>	adc_wdata,	
		
		--loop back--
		--wrclock		=> 	gls_clk,
		--wraddress	=>	wbs_address(10 downto 0),		
		--wren		=>	write_mem,		
		--data		=>	wbs_writedata,
		 
		rdclock		=> gls_clk,			 
		rdaddress	=> wbs_address(10 downto 0),		
		q			=> wbs_readdata_r
		);

		wbs_readdata <= wbs_readdata_r when wbs_address(12) = '0' else 
		                adc128_arr(conv_integer(unsigned(wbs_address(2 downto 0)))) ;


	u_sampling_freq_gen: sampling_clk_gen
	PORT MAP (
		clk => clk, -- 100 MHz input clock
		reset => vsync,--rst_n, -- never reset
		div_ratio => SPS_DIVIDE,  
		clock_out => sps_clk 
	);

	process(clk, rst_n)
	begin
		if rst_n = '0' then
			vsync_reg	<= (others => '0');
			hsync_reg	<= (others => '0');
			samp_reg	<= (others => '0');
			
		elsif clk'event and clk = '1' then
		
			vsync_reg	<= vsync_reg(6 downto 0) & vsync;
			hsync_reg	<= hsync_reg(6 downto 0) & hsync;	
			samp_reg 	<=  samp_reg(6 downto 0) & sps_clk;	
			--samp_reg 	<=  samp_reg(6 downto 0) & hsync;	

		end if;
	end process ;
	

	sps_counter : process(clk, rst_n)
	begin
		if rst_n = '0' then

			samp_cnt <= (others => '0');

		elsif clk'event and clk = '1' then

			if vsync_reg(1 downto 0) = "01" then
				samp_cnt <= (others => '1');
			end if;

			--if samp_cnt8_r(1 downto 0) = "10" then 
				--samp_cnt(7 downto 0) <= conv_std_logic_vector( 170, 8);
			--	samp_cnt(7 downto 0) <= conv_std_logic_vector( 0, 8);
			--end if;

			if samp_reg (1 downto 0)= "01" then
				samp_cnt <= samp_cnt + 1;

			end if;


		end if;
	end process;

	s_adc_tx <= "11" & samp_cnt(2 downto 0) & B"00_0000_0000_0000"; 
	
	s_adc_en <= not sps_clk and  samp_cnt(5) 
							and not samp_cnt(6) 
							and not samp_cnt(7) 
							and not samp_cnt(8) 
							and not samp_cnt(9) 
							and not samp_cnt(10) ;

	tp(1) <= s_adc_en;

	s_adc_en_dly : process(clk, rst_n)
	begin
		if rst_n = '0' then

			s_adc_en_r <= (others => '0');
			
			samp_cnt3_dly <= (others => '0');
			samp_cnt4_dly <= (others => '0');
			

		elsif clk'event and clk = '1' then

			s_adc_en_r <= s_adc_en_r(1620 downto 0) & s_adc_en;

			samp_cnt3_dly <= samp_cnt3_dly(1620 downto 0) & samp_cnt(3);
			samp_cnt4_dly <= samp_cnt4_dly(1620 downto 0) & samp_cnt(4);

		end if;
	end process;

	ua_mcp3208_adc : mcp3208_32ch_drv_top
	Port map( 	
		CLK 	=> clk,	
		reset 	=> rst_n,
		
		txData			=> s_adc_tx,
		txData_valid	=> s_adc_en_r(60),

		rxData00 => rxData_arr( 0)(11 downto 0),
		rxData01 => rxData_arr( 1)(11 downto 0),
		rxData02 => rxData_arr( 2)(11 downto 0),
		rxData03 => rxData_arr( 3)(11 downto 0),
		rxData04 => rxData_arr( 4)(11 downto 0),
		rxData05 => rxData_arr( 5)(11 downto 0),
		rxData06 => rxData_arr( 6)(11 downto 0),
		rxData07 => rxData_arr( 7)(11 downto 0),
		rxData08 => rxData_arr( 8)(11 downto 0),
		rxData09 => rxData_arr( 9)(11 downto 0),
		rxData10 => rxData_arr(10)(11 downto 0),
		rxData11 => rxData_arr(11)(11 downto 0),
		rxData12 => rxData_arr(12)(11 downto 0),
		rxData13 => rxData_arr(13)(11 downto 0),
		rxData14 => rxData_arr(14)(11 downto 0),
		rxData15 => rxData_arr(15)(11 downto 0),
		rxData16 => rxData_arr(16)(11 downto 0),
		rxData17 => rxData_arr(17)(11 downto 0),
		rxData18 => rxData_arr(18)(11 downto 0),
		rxData19 => rxData_arr(19)(11 downto 0),
		rxData20 => rxData_arr(20)(11 downto 0),
		rxData21 => rxData_arr(21)(11 downto 0),
		rxData22 => rxData_arr(22)(11 downto 0),
		rxData23 => rxData_arr(23)(11 downto 0),
		rxData24 => rxData_arr(24)(11 downto 0),
		rxData25 => rxData_arr(25)(11 downto 0),
		rxData26 => rxData_arr(26)(11 downto 0),
		rxData27 => rxData_arr(27)(11 downto 0),
		rxData28 => rxData_arr(28)(11 downto 0),
		rxData29 => rxData_arr(29)(11 downto 0),
		rxData30 => rxData_arr(30)(11 downto 0),
		rxData31 => rxData_arr(31)(11 downto 0),
		rxData_valid	=> rxData_valid0,

		adcCLK 		=>	adc_clk0,
		adcCS 		=>	adc_cs0,
		adcMOSI 	=>	adc_mosi0,
		adcMISO		=>	adc_miso0

	);

	u_acd128S022 : ADC128S022_top
	Port map( 	
		CLK 	=> clk,	
		reset 	=> rst_n,
		
		txData			=> s_adc_tx(18 downto 3),
		txData_valid	=> s_adc_en_r(60),
			
		rxData => rxData1_r(11 downto 0),
		rxData_valid	=> rxData_valid1,
			
		adcCLK 		=>	adc_clk1,
		adcCS 		=>	adc_cs1,
		adcMOSI 	=>	adc_mosi1,
		adcMISO		=>	adc_miso1

		);


	--tp(2) <= adc_cs0;
	adcCLK0 	<= adc_clk0;
	adcMOSI0 <= adc_mosi0;
	adc_miso0 <= adcMISO0 ;

	cs_dly <= samp_cnt4_dly(450) & samp_cnt3_dly(450);
	cs_out : process(clk, rst_n)
	begin
		if rst_n = '0' then
	
			adcCS0 <= (others => '1');
			
		elsif clk'event and clk = '1' then
			case  cs_dly is 
				when   "00"	=> adcCS0 <= 	     adc_cs0 & "111";
				when   "01"	=> adcCS0 <=   '1' & adc_cs0 & "11";
				when   "10"	=> adcCS0 <=  "11" & adc_cs0 & '1';
				when   "11"	=> adcCS0 <= "111" & adc_cs0 ;

				when others =>	adcCS0 <= (others => '1');

			end case;		
		end if;
	end process;

	adcCLK1 	<= adc_clk1;
	adcMOSI1	<= adc_mosi1;
	adc_miso1 	<= adcMISO1 ;
	adcCS1 		<= adc_cs1;


	rxdata_rev : process(clk, rst_n)
	begin
		--if col_dly = '1' then
		if rst_n = '0' then
		
			adc_waddr <= (others => '0');	
			adc_wdata <= (others => '0');	
			
			adc_wen   <= '0';
		
		elsif clk'event and clk = '1' then

			rxData_valid0_r <= rxData_valid0_r(49 downto 0) & rxData_valid0;
			rxData_valid1_r <= rxData_valid1_r(49 downto 0) & rxData_valid1;

			if samp_reg (1 downto 0)= "10" then
				adc_waddr_r <= "000000" & samp_cnt(4 downto 3) & samp_cnt(2 downto 0);
			end if;

			adc_wen   <= '0';
			if rxData_valid0 = '1' 			then	adc_waddr <= '0' & conv_std_logic_vector(0, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(0, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr( 0);	adc_wen   <= '1';			end if;
			if rxData_valid0_r( 0) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(0, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(1, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr( 1);	adc_wen   <= '1';			end if;
			if rxData_valid0_r( 1) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(0, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(2, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr( 2);	adc_wen   <= '1';			end if;
			if rxData_valid0_r( 2) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(0, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(3, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr( 3);	adc_wen   <= '1';			end if;
			if rxData_valid0_r( 3) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(1, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(0, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr( 4);	adc_wen   <= '1';			end if;
			if rxData_valid0_r( 4) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(1, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(1, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr( 5);	adc_wen   <= '1';			end if;
			if rxData_valid0_r( 5) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(1, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(2, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr( 6);	adc_wen   <= '1';			end if;
			if rxData_valid0_r( 6) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(1, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(3, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr( 7);	adc_wen   <= '1';			end if;
			if rxData_valid0_r( 7) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(2, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(0, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr( 8);	adc_wen   <= '1';			end if;
			if rxData_valid0_r( 8) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(2, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(1, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr( 9);	adc_wen   <= '1';			end if;
			if rxData_valid0_r( 9) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(2, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(2, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(10);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(10) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(2, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(3, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(11);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(11) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(3, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(0, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(12);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(12) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(3, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(1, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(13);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(13) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(3, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(2, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(14);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(14) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(3, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(3, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(15);	adc_wen   <= '1';			end if;
		    if rxData_valid0_r(15) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(4, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(0, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(16);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(16) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(4, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(1, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(17);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(17) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(4, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(2, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(18);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(18) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(4, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(3, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(19);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(19) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(5, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(0, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(20);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(20) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(5, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(1, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(21);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(21) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(5, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(2, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(22);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(22) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(5, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(3, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(23);	adc_wen   <= '1';			end if;
		    if rxData_valid0_r(23) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(6, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(0, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(24);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(24) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(6, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(1, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(25);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(25) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(6, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(2, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(26);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(26) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(6, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(3, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(27);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(27) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(7, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(0, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(28);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(28) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(7, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(1, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(29);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(29) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(7, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(2, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(30);	adc_wen   <= '1';			end if;
			if rxData_valid0_r(30) = '1'	then	adc_waddr <= '0' & conv_std_logic_vector(7, 3) & not adc_waddr_r(4 downto 3) & conv_std_logic_vector(3, 2) & adc_waddr_r(2 downto 0);	adc_wdata <= not rxData_arr(31);	adc_wen   <= '1';			end if;


			if rxData_valid1 = '1' 		then
			
				case  adc_waddr_r(2 downto 0) is 
					when   "000"	=> adc128_arr( 0) <= rxData1_r;
					when   "001"	=> adc128_arr( 1) <= rxData1_r;
					when   "010"	=> adc128_arr( 2) <= rxData1_r;
					when   "011"	=> adc128_arr( 3) <= rxData1_r;
					when   "100"	=> adc128_arr( 4) <= rxData1_r;
					when   "101"	=> adc128_arr( 5) <= rxData1_r;
					when   "110"	=> adc128_arr( 6) <= rxData1_r;
					when   "111"	=> adc128_arr( 7) <= rxData1_r;
				
					when others =>	adc128_arr( 0) <= (others => '0');
									adc128_arr( 1) <= (others => '0');
									adc128_arr( 2) <= (others => '0');
									adc128_arr( 3) <= (others => '0');
									adc128_arr( 4) <= (others => '0');
									adc128_arr( 5) <= (others => '0');
									adc128_arr( 6) <= (others => '0');
									adc128_arr( 7) <= (others => '0');
				
				end case;	
				
			end if;


		end if;
	end process;



	


	
--	tp(0) <= vsync_reg(0);

--	tp(3) <= not samp_cnt(10) ;
--	tp(4) <= not sps_clk;--mux(2);
--	tp(5) <= col_oe(0);--mux(2);

		
end struct;
