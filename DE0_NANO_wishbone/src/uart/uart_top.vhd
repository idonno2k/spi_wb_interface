-------------------------------------------------------------------------------
-- Title         : POV Controller Top
-- Project       : POV Display, 2019
-------------------------------------------------------------------------------
-- File          : pov_ctrl_top.v
-- Author        :
-- Created       : 
-- Last modified : 
-------------------------------------------------------------------------------
-- Description   : 
-- [note] 
--
-------------------------------------------------------------------------------
-- Modification history :
-- 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library work;
--use work.video_ctrl_top_pack.all ;
--use work.xdc_display_pack.all ;
--use work.flash_top_pack.all ;
--use work.logi_wishbone_pack.all ;

entity UART_top is
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
		tx_data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		tx_wrfull		: OUT STD_LOGIC; 

		rx_rdclk		: IN STD_LOGIC ;
		rx_rdreq		: IN STD_LOGIC ;
		rx_q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		rx_rdempty		: OUT STD_LOGIC ;
		
		test		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)

	);
end UART_top;

architecture struct of UART_top is

--	component UART_RX is
--	port (
--		i_Clk       : in  std_logic;
--		i_RX_Serial : in  std_logic;
--		o_RX_DV     : out std_logic;
--		o_RX_Byte   : out std_logic_vector(7 downto 0)
--	);
--	end component;

	component UART_TX is
	port (
		i_Clk       : in  std_logic;
		i_TX_DV     : in  std_logic;
		i_TX_Byte   : in  std_logic_vector(7 downto 0);
		o_TX_Req	: out std_logic;
		o_TX_Active : out std_logic;
		o_TX_Serial : out std_logic;
		o_TX_Done   : out std_logic
	);
	end component;

	component uart_fifo IS
		PORT
		(
			aclr : IN STD_LOGIC ;
		
			wrclk		: IN STD_LOGIC ;
			wrreq		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			wrfull		: OUT STD_LOGIC ;

			rdclk		: IN STD_LOGIC ;
			rdreq		: IN STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			rdempty		: OUT STD_LOGIC 
			
		);
	END component;

	
	signal rst_n				: std_logic;
	signal clk_sys				: std_logic;	

	signal	tx_byte   : std_logic_vector(7 downto 0);
	signal	tx_buf_empty : std_logic;
	signal	tx_req : std_logic;

begin

	rst_n				<= reset_n;
	clk_sys				<= usrt_clk;

	u_tx_fifo : uart_fifo
	PORT MAP(
	
			aclr	=> tx_aclr,
	
			wrclk	=> tx_wrclk,
			wrreq	=> tx_wrreq,
			data	=> tx_data,
			wrfull	=> tx_wrfull,

			rdclk	=>	clk_sys,
			rdreq	=>	tx_req,
			q		=>	tx_byte,
			rdempty	=>	tx_buf_empty
	);


	u_uart_tx : UART_TX
	port map (
		i_Clk       => clk_sys,
		i_TX_DV     => not tx_buf_empty,
		i_TX_Byte   => tx_byte,
		o_TX_Req	=> tx_req,
		
		o_TX_Active => uart_tx_active,
		o_TX_Serial => uart_txd,
		o_TX_Done   => open
	);



test(0) <=  tx_req;
test(1) <=  tx_buf_empty;




end struct;

