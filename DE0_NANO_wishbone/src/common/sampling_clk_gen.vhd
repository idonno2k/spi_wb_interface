----------------------------------------------------------------------------------
-- Company: Cal Poly
-- Engineer: Michael Cheng
--
-- Create Date: 05/14/2017 08:32:22 PM
-- Design Name: 1 MHz Clock Divider
-- Module Name: clock_divider - Behavioral
-- Project Name: General-Purpose Digital Filter Platform
-- Target Devices: Basys 3/ Xilinx XC7A35T-1CPG236C
-- Tool Versions: Vivado 2016.4, System Generator 2016.4, MATLAB R2016b
-- Description: This module divides the 100 MHz system clock down to 1 MHz.
-- Every 50 system clock cycles, the temporary signal inverts
-- to generate the 1 MHz square wave.
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity sampling_clk_gen is
Port ( 	clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		div_ratio : IN INTEGER;
		clock_out : OUT STD_LOGIC);
end sampling_clk_gen;

architecture Behavioral of sampling_clk_gen is
	signal count : INTEGER range 0 to 100000 :=0;
	signal tmp : STD_LOGIC :='0';
begin
	
	process(clk,reset)
	begin

		if(reset='0') then
			count <= 0;
			tmp <= '0';

		elsif(rising_edge(clk)) then

			count <= count + 1; -- increment delay
			
			if (count < div_ratio/2) then
				tmp <=  '1';
			elsif(count = div_ratio) then
				count <= 0; 
			else
				tmp <=  '0';
			end if;

		end if;
	end process;
	
	clock_out <= tmp; -- output divided value
	
end Behavioral;