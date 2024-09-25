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

entity spi_dac_top is
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
end spi_dac_top;

architecture struct of spi_dac_top is

	constant SYS_FREQ_Hz : positive := 100_000_000;
	constant DAC_FREQ_Hz : positive := 2_000_000;

	constant DAC_BIT	: positive := 24;

	constant SPS_DIVIDE  : positive := (SYS_FREQ_Hz/DAC_FREQ_Hz * DAC_BIT );

	component sampling_clk_gen is
	Port ( 	
		clk : IN std_logic;
		reset : IN std_logic;
		div_ratio : IN INTEGER;
		clock_out : OUT std_logic
	);
	end component;

	component DAC7512N_drv is
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
	end component;

	type array_of_reg16 is array(NATURAL range <>) of std_logic_vector(15 downto 0);
	signal reg_in_d, reg_out_d : array_of_reg16(0 to 15) ;
	signal reg16_arr1 : array_of_reg16(0 to 15);
	signal read_ack : std_logic ;
	signal write_ack : std_logic ;
	
	
	signal sps_clk	: std_logic;
	signal sps_clk_edge	: std_logic;

	signal samp_cnt				: std_logic_vector(15 downto 0);

	signal samp_cnt3_dly : std_logic_vector (1621 DOWNTO 0);
	signal samp_cnt4_dly : std_logic_vector (1621 DOWNTO 0);
	
	signal cs_dly : std_logic_vector (1 DOWNTO 0);

	signal vsync_reg : std_logic_vector (7 downto 0);
	signal hsync_reg : std_logic_vector (7 downto 0);
	signal samp_reg : std_logic_vector (7 downto 0);

	signal s_dac_en	: std_logic;
	signal s_dac_en_r : std_logic_vector (1621 DOWNTO 0);

	signal txData_00_r   : std_logic_vector(11 downto 0);
	signal txData_01_r   : std_logic_vector(11 downto 0);
	signal txData_02_r   : std_logic_vector(11 downto 0);
	signal txData_03_r   : std_logic_vector(11 downto 0);
	signal txData_04_r   : std_logic_vector(11 downto 0);
	signal txData_05_r   : std_logic_vector(11 downto 0);
	signal txData_06_r   : std_logic_vector(11 downto 0);
	signal txData_07_r   : std_logic_vector(11 downto 0);
	signal txData_08_r   : std_logic_vector(11 downto 0);
	signal txData_09_r   : std_logic_vector(11 downto 0);
	signal txData_10_r   : std_logic_vector(11 downto 0);
	signal txData_11_r   : std_logic_vector(11 downto 0);
	signal txData_12_r   : std_logic_vector(11 downto 0);
	signal txData_13_r   : std_logic_vector(11 downto 0);
	signal txData_14_r   : std_logic_vector(11 downto 0);
	signal txData_15_r   : std_logic_vector(11 downto 0);


	signal rxData_valid0 : std_logic;
	signal rxData_valid0_r : std_logic_vector (50 downto 0);
	
	signal rxData1_r   : std_logic_vector(11 downto 0);
	signal rxData_valid1 : std_logic;
	signal rxData_valid1_r : std_logic_vector (50 downto 0);

	signal test_mode	: std_logic := '1';

begin

------------------------------------------------------------------------------------------
--wishbone interface
	wbs_ack <= read_ack or write_ack;

	write_bloc : process(gls_clk,gls_reset)
	begin
		if gls_reset = '1' then 
			reg_out_d <= (others =>(others => '0'));
			write_ack <= '0';
		elsif rising_edge(gls_clk) then
			if ((wbs_strobe and wbs_write and wbs_cycle) = '1' ) then
				reg_out_d(conv_integer(wbs_address)) <= wbs_writedata;
				write_ack <= '1';
			else
				write_ack <= '0';
			end if;
		end if;
	end process write_bloc;
	reg16_arr1 <= reg_out_d ;


	read_bloc : process(gls_clk, gls_reset)
	begin
		if gls_reset = '1' then
			
		elsif rising_edge(gls_clk) then
			  reg_in_d <= reg16_arr1 ; -- latching inputs
			  wbs_readdata <= reg_in_d(conv_integer(wbs_address)) ; -- this is not clear if this should only happen in the read part
			if (wbs_strobe = '1' and wbs_write = '0'  and wbs_cycle = '1' ) then
				read_ack <= '1';
			else
				read_ack <= '0';
			end if;
			  
		end if;
	end process read_bloc;


------------------------------------------------------------------------------------------
--multi dac

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


	
	s_dac_en <= not sps_clk and  vsync_reg(6);

	tp(1) <= s_dac_en;

	s_dac_en_dly : process(clk, rst_n)
	begin
		if rst_n = '0' then

			s_dac_en_r <= (others => '0');


		elsif clk'event and clk = '1' then

			s_dac_en_r <= s_dac_en_r(1620 downto 0) & s_dac_en;

		end if;
	end process;

	u_dac7512n_drv : DAC7512N_drv
	Port map( 	
		CLK 	=> clk,	
		reset 	=> rst_n,

		txData00 => reg16_arr1( 0)(11 downto 0),
		txData01 => reg16_arr1( 1)(11 downto 0),
		txData02 => reg16_arr1( 2)(11 downto 0),
		txData03 => reg16_arr1( 3)(11 downto 0),
		txData04 => reg16_arr1( 4)(11 downto 0),
		txData05 => reg16_arr1( 5)(11 downto 0),
		txData06 => reg16_arr1( 6)(11 downto 0),
		txData07 => reg16_arr1( 7)(11 downto 0),
		txData08 => reg16_arr1( 8)(11 downto 0),
		txData09 => reg16_arr1( 9)(11 downto 0),
		txData10 => reg16_arr1(10)(11 downto 0),
		txData11 => reg16_arr1(11)(11 downto 0),
		txData12 => reg16_arr1(12)(11 downto 0),
		txData13 => reg16_arr1(13)(11 downto 0),
		txData14 => reg16_arr1(14)(11 downto 0),
		txData15 => reg16_arr1(15)(11 downto 0),
		txData_valid	=> s_dac_en_r(60),

		rxData			=> open,
		rxData_valid	=> open,

		dacCLK 		=>	dacCLK0, 
		dacCS 		=>	dacCS0,
		dacMOSI 	=>	dacMOSI0,
		dacMISO		=>	dacMISO0

	);

	
--	tp(0) <= vsync_reg(0);

--	tp(3) <= not samp_cnt(10) ;
--	tp(4) <= not sps_clk;--mux(2);
--	tp(5) <= col_oe(0);--mux(2);

		
end struct;
