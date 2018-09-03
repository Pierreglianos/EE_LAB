-- keyboard to parser interface 
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;

entity kbd2parser is
	port(
		CLK				: in std_logic; --						//	50 MHz
		RESETn			: in std_logic; --
		
		make 	: in std_logic;
		break : in std_logic;
		data 	: in std_logic_vector(8 downto 0) 
		
		player1_left_press 	: out std_logic;
		player1_right_press 	: out std_logic;
		player1_up_press 		: out std_logic;
		player1_down_press 	: out std_logic;
		player1_shoot_press 	: out std_logic;
		
		player2_left_press 	: out std_logic;
		player2_right_press 	: out std_logic;
		player2_up_press 		: out std_logic;
		player2_down_press 	: out std_logic;
		player2_shoot_press 	: out std_logic;
		
	);
end kbd2parser;

architecture kbd2parser_arch of kbd2parser is 
	
	begin 		
		process(CLK, RESETn)
		
		variable left_press : std_logic := '0';
		variable right_press : std_logic := '0';
		variable up_press : std_logic := '0';
		variable down_press : std_logic := '0';
		variable dot_press : std_logic := '0';
		
		variable A_press : std_logic := '0';
		variable D_press : std_logic := '0';
		variable W_press :  std_logic := '0';
		variable S_press : std_logic := '0';
		variable V_press : std_logic := '0';
		
		begin
			if(RESETn = '0') then 
				left_press 	:= '0';
				right_press	:= '0';
				up_press 	:= '0';
				down_press 	:= '0';
				dot_press 	:= '0';
		
				A_press 		:= '0';
				D_press 		:= '0';
				W_press 		:= '0';
				S_press 		:= '0';
				V_press 		:= '0';

			elsif(rising_edge(CLK)) then 
				if(make = '1') then 
					case data is
						when kbd_left_arrow =>
							left_press := '1';
						when kbd_right_arrow =>
							right_press := '1';
						when kbd_up_arrow =>
							up_press := '1';	
						when kbd_down_arrow =>
							down_press := '1';
						when kbd_dot =>
							dot_press := '1';
						when kbd_D_key =>
							D_press := '1';	
						when kbd_A_key =>
							A_press := '1';
						when kbd_W_key =>
							W_press := '1';								
						when kbd_S_key =>
							S_press := '1';
						when kbd_V_key =>
							V_press := '1';
						when others =>
							null;
					end case;
				elsif(break = '1') then -- make sure make and break can't be 1 simultaniously
					case data is
						when kbd_left_arrow =>
							left_press := '0';
						when kbd_right_arrow =>
							right_press := '0';
						when kbd_up_arrow =>
							up_press := '0';	
						when kbd_down_arrow =>
							down_press := '0';
						when kbd_dot =>
							dot_press := '0';
						when kbd_D_key =>
							D_press := '0';	
						when kbd_A_key =>
							A_press := '0';
						when kbd_W_key =>
							W_press := '0';								
						when kbd_S_key =>
							S_press := '0';
						when kbd_V_key =>
							V_press := '0';
						when others =>
							null;
					end case;
				end if;
			end if;
			
			player1_left_press 	<= left_press;
			player1_right_press 	<= right_press;
			player1_up_press 		<= up_press;
			player1_down_press 	<= down_press;
			player1_shoot_press 	<= dot_press;
		
			player2_left_press 	<= A_press;
			player2_right_press 	<= D_press;
			player2_up_press 		<= W_press;
			player2_down_press 	<= S_press;
			player2_shoot_press 	<= V_press;
		end process;
		
end kbd2parser_arch;		
				