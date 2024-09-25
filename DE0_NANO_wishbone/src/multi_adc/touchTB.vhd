-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity touchTB is
end;

architecture bench of touchTB is

  component touch_fsm
  port (
  	FPGA_CLK_in			: in	std_logic;
  	FPGA_RESET       	: in	std_logic
  	);
  end component;

  signal rst_n: std_logic;
  signal clk_80M: std_logic;

  constant clock_period: time := 1 ns;
  signal stop_the_clock: boolean;

begin

  uut: touch_fsm port map ( FPGA_CLK_in => clk_80M,
                            FPGA_RESET  => rst_n );


  stimulus: process
  begin
  
    -- Put initialisation code here

    rst_n <= '0';
    wait for 5 ns;
    rst_n <= '1';
    wait for 5 ns;

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    loop
      clk_80M <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  