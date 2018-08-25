library ieee ;
use ieee.std_logic_1164.all ;
entity one_sec_counter is port (
		clk				: in std_logic ; 
		resetN			: in std_logic ;
		turbo				: in std_logic ; 
		one_sec_pulse	: out std_logic;
		duty_50			: out std_logic
		);
end one_sec_counter ;
architecture arc_one_sec_counter of one_sec_counter is
	constant sec_real       : integer := 5000000 ; -- for Real operation
--    constant sec_real       : integer := 5 ; -- for simulation
    constant sec_turbo  : integer := sec_real /10 ;
	signal one_sec_flag	: std_logic ; 
	signal duty_50_tmp	: std_logic ; 
	signal one_sec			: integer ;
	signal sec				: integer;
begin

sec	<= sec_real when turbo = '0' else
			sec_turbo;

process(CLK,RESETN)
	

begin
	if resetN = '0' then
		one_sec <= 0 ;
		one_sec_flag	<= '0' ;
		duty_50_tmp		<= '0';
	elsif rising_edge(CLK) then
		if (one_sec >= sec) then
			one_sec_flag	<= '1' ;
			one_sec			<= 0 ;
			duty_50_tmp		<= not duty_50_tmp;
		else
			one_sec_flag	<= '0' ;
			one_sec			<= one_sec + 1 ;
		end if;
	end if;
end process;
one_sec_pulse	<= one_sec_flag;
duty_50			<= duty_50_tmp;
end arc_one_sec_counter;