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
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

--use work.pkg.all;

library work ;
use work.control_pack.all ;

entity pwm_center_aligned is
generic(
	SYS_FREQ_Hz 	: positive := 100_000_000;
	--PWM_FREQ_Hz	: positive := 100_000;
	NB_CHANNEL : positive := 3
	);
port(
	clk, rst_n : in std_logic ;
	--sys_freq : in std_logic_vector(31 downto 0);
	pwm_freq : in std_logic_vector(31 downto 0);
	pwm_resol : in std_logic_vector(31 downto 0);
	period : in slv16_array(0 to NB_CHANNEL-1);
	deadtime : in std_logic_vector(15 downto 0);
	pwm_p : out std_logic_vector(0 to NB_CHANNEL-1); 
	pwm_n : out std_logic_vector(0 to NB_CHANNEL-1) 
);
end pwm_center_aligned;


architecture struct of pwm_center_aligned is

	signal clk_divide		: std_logic_vector(15 downto 0);
	signal divider_counter : std_logic_vector(15 downto 0);
	
	signal PWM_clk	: std_logic;	
	
	signal updn_cnt			: std_logic_vector(15 downto 0);
	signal updn_dir			: std_logic;
	
	signal PWM_upper_ch1	: std_logic;	
	signal PWM_lower_ch1	: std_logic;
	signal PWM_target_ch1	: std_logic;	
	
	signal PWM_upper_ch2	: std_logic;	
	signal PWM_lower_ch2	: std_logic;
	signal PWM_target_ch2	: std_logic;	
	
	signal PWM_upper_ch3	: std_logic;	
	signal PWM_lower_ch3	: std_logic;
	signal PWM_target_ch3	: std_logic;	
	
	signal PWM_upper_ref_ch1	: std_logic_vector(15 downto 0);	
	signal PWM_lower_ref_ch1	: std_logic_vector(15 downto 0);
	signal PWM_target_ref_ch1	: std_logic_vector(15 downto 0);	
	
	signal PWM_upper_ref_ch2	: std_logic_vector(15 downto 0);	
	signal PWM_lower_ref_ch2	: std_logic_vector(15 downto 0);
	signal PWM_target_ref_ch2	: std_logic_vector(15 downto 0);
	
	signal PWM_upper_ref_ch3	: std_logic_vector(15 downto 0);	
	signal PWM_lower_ref_ch3	: std_logic_vector(15 downto 0);
	signal PWM_target_ref_ch3	: std_logic_vector(15 downto 0);

	signal PWM_target_reg_ch1_p		: std_logic;	
	signal PWM_target_reg_ch1_n		: std_logic;
	signal PWM_target_mask_ch1		: std_logic;
	
	signal PWM_target_reg_ch2_p		: std_logic;	
	signal PWM_target_reg_ch2_n		: std_logic;
	signal PWM_target_mask_ch2		: std_logic;
	
	signal PWM_target_reg_ch3_p		: std_logic;	
	signal PWM_target_reg_ch3_n		: std_logic;
	signal PWM_target_mask_ch3		: std_logic;
	
	signal PWM_out_reg_ch1_p		: std_logic;
	signal PWM_out_reg_ch1_n		: std_logic;
	
	signal PWM_out_reg_ch2_p		: std_logic;
	signal PWM_out_reg_ch2_n		: std_logic;
	
	signal PWM_out_reg_ch3_p		: std_logic;
	signal PWM_out_reg_ch3_n		: std_logic;
	
	signal int_pwm_freq		: integer;
	signal int_pwm_resol		: integer;
	
begin

	pwm_clk_gen : process (clk, rst_n)
	begin
		if rst_n = '0' then	
			clk_divide <= (others => '1');
			divider_counter <= (others => '0') ;
		elsif clk'event and clk = '1' then
		
			int_pwm_freq <= to_integer(unsigned(pwm_freq));
			int_pwm_resol <= to_integer(unsigned(pwm_resol));
			clk_divide	<= std_logic_vector(to_unsigned((SYS_FREQ_Hz / int_pwm_freq / int_pwm_resol / 2)-1,16));

			if divider_counter = 0 then
				divider_counter <= clk_divide ;
			else
				divider_counter <= divider_counter - 1 ;
			end if ;
		end if ;
	end process ;

	PWM_clk <= '1' when divider_counter = 0 else
						'0' ;

	updown_cnt : process (clk, rst_n)
	begin
		if rst_n = '0' then

			updn_cnt <= (others => '1');
			updn_dir <= '0';

		elsif clk'event and clk = '1' then
		
			if PWM_clk = '1' then
				if updn_dir = '0' then
					updn_cnt<= updn_cnt + 1;
				else
					updn_cnt<= updn_cnt - 1;
				end if;
				
				if updn_cnt = X"0000" then
				
					updn_cnt <= X"0001";
					updn_dir <= '0';
				
				elsif updn_cnt = pwm_resol(15 downto 0) then
				
					updn_cnt <= pwm_resol(15 downto 0) - X"0001";
					updn_dir <= '1';
				
				end if;
			end if ;
				
		end if;
	end process ;

	comprator_ch1 : process (clk, rst_n)
	begin
		if rst_n = '0' then

			PWM_target_ch1 <= '0';
			PWM_upper_ch1 <= '0';
			PWM_lower_ch1 <= '0';
			
			PWM_target_ref_ch1 <= (others => '0');
			PWM_upper_ref_ch1 <= (others => '0');
			PWM_lower_ref_ch1 <= (others => '0');
			
		elsif clk'event and clk = '1' then
		
			if int_pwm_resol < to_integer(unsigned(period(0))) then
				PWM_target_ref_ch1 <= pwm_resol(15 downto 0) - deadtime;
			elsif to_integer(unsigned(period(0))) <= 0 then
				PWM_target_ref_ch1 <= deadtime;
			else 
				PWM_target_ref_ch1 <= period(0);
			end if;
		
			PWM_upper_ref_ch1	<= PWM_target_ref_ch1 + deadtime;
			PWM_lower_ref_ch1	<= PWM_target_ref_ch1 - deadtime;
			
			if PWM_target_ref_ch1 <= updn_cnt then 
				PWM_target_ch1 <= '0';
			elsif PWM_target_ref_ch1 > updn_cnt  then
				PWM_target_ch1 <= '1';
			end if;
			
			if  PWM_upper_ref_ch1<= updn_cnt then
				PWM_upper_ch1 <= '0';
			elsif PWM_upper_ref_ch1 > updn_cnt  then
				PWM_upper_ch1 <= '1';
			end if;
			
			if PWM_lower_ref_ch1 <= updn_cnt then
				PWM_lower_ch1 <= '0';
			elsif PWM_lower_ref_ch1 > updn_cnt  then
				PWM_lower_ch1 <= '1';
			end if;
		
		end if;
	end process ;
	
	comprator_ch2 : process (clk, rst_n)
	begin
		if rst_n = '0' then

			PWM_target_ch2 <= '0';
			PWM_upper_ch2 <= '0';
			PWM_lower_ch2 <= '0';
			
			PWM_target_ref_ch2 <= (others => '0');
			PWM_upper_ref_ch2 <= (others => '0');
			PWM_lower_ref_ch2 <= (others => '0');
			
		elsif clk'event and clk = '1' then
		
			if int_pwm_resol < to_integer(unsigned(period(1))) then
				PWM_target_ref_ch2 <= pwm_resol(15 downto 0) - deadtime;
			elsif to_integer(unsigned(period(1))) <= 0 then
				PWM_target_ref_ch2 <= deadtime;
			else 
				PWM_target_ref_ch2 <= period(1);
			end if;
		
			PWM_upper_ref_ch2	<= PWM_target_ref_ch2 + deadtime;
			PWM_lower_ref_ch2	<= PWM_target_ref_ch2 - deadtime;
			
			if PWM_target_ref_ch2 <= updn_cnt then 
				PWM_target_ch2 <= '0';
			elsif PWM_target_ref_ch2 > updn_cnt  then
				PWM_target_ch2 <= '1';
			end if;
			
			if  PWM_upper_ref_ch2<= updn_cnt then
				PWM_upper_ch2 <= '0';
			elsif PWM_upper_ref_ch2 > updn_cnt  then
				PWM_upper_ch2 <= '1';
			end if;
			
			if PWM_lower_ref_ch2 <= updn_cnt then
				PWM_lower_ch2 <= '0';
			elsif PWM_lower_ref_ch2 > updn_cnt  then
				PWM_lower_ch2 <= '1';
			end if;
		
		end if;
	end process ;
	
	comprator_ch3 : process (clk, rst_n)
	begin
		if rst_n = '0' then

			PWM_target_ch3 <= '0';
			PWM_upper_ch3 <= '0';
			PWM_lower_ch3 <= '0';
			
			PWM_target_ref_ch3 <= (others => '0');
			PWM_upper_ref_ch3 <= (others => '0');
			PWM_lower_ref_ch3 <= (others => '0');
			
		elsif clk'event and clk = '1' then
		
			if int_pwm_resol < to_integer(unsigned(period(2))) then
				PWM_target_ref_ch3 <= pwm_resol(15 downto 0) - deadtime;
			elsif to_integer(unsigned(period(2))) <= 0 then
				PWM_target_ref_ch3 <= deadtime;
			else 
				PWM_target_ref_ch3 <= period(2);
			end if;
		
			PWM_upper_ref_ch3	<= PWM_target_ref_ch3 + deadtime;
			PWM_lower_ref_ch3	<= PWM_target_ref_ch3 - deadtime;
			
			if PWM_target_ref_ch3 <= updn_cnt then 
				PWM_target_ch3 <= '0';
			elsif PWM_target_ref_ch3 > updn_cnt  then
				PWM_target_ch3 <= '1';
			end if;
			
			if  PWM_upper_ref_ch3<= updn_cnt then
				PWM_upper_ch3 <= '0';
			elsif PWM_upper_ref_ch3 > updn_cnt  then
				PWM_upper_ch3 <= '1';
			end if;
			
			if PWM_lower_ref_ch3 <= updn_cnt then
				PWM_lower_ch3 <= '0';
			elsif PWM_lower_ref_ch3 > updn_cnt  then
				PWM_lower_ch3 <= '1';
			end if;
		
		end if;
	end process ;
	
	
	pwm_deadtime_mask : process (clk, rst_n)
	begin
		if rst_n = '0' then

			PWM_target_mask_ch1 <= '0';
			PWM_target_reg_ch1_p <= '0';
			PWM_target_reg_ch1_n <= '0';
			
			PWM_target_mask_ch2 <= '0';
			PWM_target_reg_ch2_p <= '0';
			PWM_target_reg_ch2_n <= '0';
			
			PWM_target_mask_ch3 <= '0';
			PWM_target_reg_ch3_p <= '0';
			PWM_target_reg_ch3_n <= '0';
			
		elsif clk'event and clk = '1' then
		
			PWM_target_mask_ch1 <= PWM_upper_ch1 xor PWM_lower_ch1;
			PWM_target_reg_ch1_p <= PWM_target_ch1;
			PWM_target_reg_ch1_n <= not PWM_target_ch1;
		
			PWM_target_mask_ch2 <= PWM_upper_ch2 xor PWM_lower_ch2;
			PWM_target_reg_ch2_p <= PWM_target_ch2;
			PWM_target_reg_ch2_n <= not PWM_target_ch2;
			
			PWM_target_mask_ch3 <= PWM_upper_ch3 xor PWM_lower_ch3;
			PWM_target_reg_ch3_p <= PWM_target_ch3;
			PWM_target_reg_ch3_n <= not PWM_target_ch3;
		end if;
	end process ;

	pwm_generator : process (clk, rst_n)
	begin
		if rst_n = '0' then

			PWM_out_reg_ch1_p <= '0';
			PWM_out_reg_ch1_n <= '0';
			
			PWM_out_reg_ch2_p <= '0';
			PWM_out_reg_ch2_n <= '0';
			
			PWM_out_reg_ch3_p <= '0';
			PWM_out_reg_ch3_n <= '0';
			
		elsif clk'event and clk = '1' then
		
			PWM_out_reg_ch1_p <=  (not PWM_target_mask_ch1) and PWM_target_reg_ch1_p;
			PWM_out_reg_ch1_n <=  (not PWM_target_mask_ch1) and PWM_target_reg_ch1_n;
			
			PWM_out_reg_ch2_p <=  (not PWM_target_mask_ch2) and PWM_target_reg_ch2_p;
			PWM_out_reg_ch2_n <=  (not PWM_target_mask_ch2) and PWM_target_reg_ch2_n;
			
			PWM_out_reg_ch3_p <=  (not PWM_target_mask_ch3) and PWM_target_reg_ch3_p;
			PWM_out_reg_ch3_n <=  (not PWM_target_mask_ch3) and PWM_target_reg_ch3_n;
		
		end if;
		
	end process ;
	
	pwm_out : process (clk, rst_n)
	begin
		if rst_n = '0' then

			pwm_p(0) <= '0';
			pwm_p(1) <= '0';
			pwm_p(2) <= '0';
			
			pwm_n(0) <= '0';
			pwm_n(1) <= '0';
			pwm_n(2) <= '0';
			
		elsif clk'event and clk = '1' then
		
			pwm_p(0) <= PWM_out_reg_ch1_p;
			pwm_n(0) <= PWM_out_reg_ch1_n;
			
			pwm_p(1) <= PWM_out_reg_ch2_p;
			pwm_n(1) <= PWM_out_reg_ch2_n;
			
			--pwm_p(2) <= PWM_out_reg_ch3_p;
			--pwm_n(2) <= PWM_out_reg_ch3_n;
			pwm_p(2) <= clk;
			pwm_n(2) <= PWM_clk;
		
		end if;
		
		

		
	end process ;
	
	
end struct;

