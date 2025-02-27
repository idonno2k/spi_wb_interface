library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--library work;
--use work.video_ctrl_top_pack.all ;
--use work.xdc_display_pack.all ;
--use work.flash_top_pack.all ;
--use work.logi_wishbone_pack.all ;
--use work.ddc_ctrl_pack.all;

entity touch_fsm is
port (
	--general FPGA
	FPGA_CLK_in			: in	std_logic;
	FPGA_RESET       	: in	std_logic
	
	);
end touch_fsm;

architecture struct of touch_fsm is

	TYPE machine IS(sync, payload, idle); --state machine data type
	SIGNAL state : machine; --current stat


	signal rst_n	: std_logic;
	signal clk_80M	: std_logic;

	signal	tx_wrfull	: STD_LOGIC; 
	signal	tx_wrreq	: STD_LOGIC ;
	signal	tx_data		: STD_LOGIC_VECTOR (7 DOWNTO 0);

	--signal	rdaddress	: STD_LOGIC_VECTOR (10 DOWNTO 0);
	signal	rdaddress	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal	q			: STD_LOGIC_VECTOR (7 DOWNTO 0);

	signal	tx_sync_cnt	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal	tx_period_cnt	: STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

rst_n <= FPGA_RESET;
clk_80M <= FPGA_CLK_in;

	process (clk_80M, rst_n)
	begin
		if rst_n = '0' then
			
			tx_wrreq <= '0';
			rdaddress <= (others => '0');	
			
			tx_data <= (others => '0');
			tx_sync_cnt <= (others => '0');
			state <= idle;
			
			tx_wrfull <= '0';
			
			tx_period_cnt <= (others => '0');
			
					
		elsif clk_80M'event and clk_80M = '1' then

			
			if	tx_wrfull = '0' then

				tx_wrreq <= '0';
			
				CASE state IS --state machine
					when idle => 
					
						tx_period_cnt <= tx_period_cnt + 1;
						if tx_period_cnt > 10 then
							state <= sync;
							tx_period_cnt <= (others => '0');
						end if;
					
					when sync =>
						tx_sync_cnt <= tx_sync_cnt + 1;
						tx_wrreq <= '1';
						
						   if tx_sync_cnt = 0 then	tx_data <= X"1B";
						elsif tx_sync_cnt = 1 then	tx_data <= X"5B";
						elsif tx_sync_cnt = 2 then	tx_data <= X"30";
						elsif tx_sync_cnt = 3 then	tx_data <= X"3B";
						elsif tx_sync_cnt = 4 then	tx_data <= X"30";
						elsif tx_sync_cnt = 5 then	tx_data <= X"48";
						else 
							tx_sync_cnt <= (others => '0');
							tx_wrreq <= '0';
							state <= payload;
						end if;
	
					when payload =>
						
						tx_wrreq <= '1';
						rdaddress <= rdaddress + 1;
						--tx_data <= q;
						tx_data <= X"AB";
						
						if rdaddress = X"F" then	
							state <= idle;
						end if;
					
					when others  => state <= idle;
				END CASE;
			end if;

		end if;      
	end process ;


end struct;