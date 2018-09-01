library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;

-- action encode
-- "000":	none
--	"001":	move left
-- "010":	move right
-- "011":	jump
--	"100":	duck
--	"101":	fireball
--	"110":	special attack 1
--	"111":	special attack 2


entity player1_parser is
port 	(
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		enable			: in std_logic; -- 	//enable movement
		make				: in std_logic;
		break				: in std_logic;
		kbd_data			: in std_logic_vector(8 downto 0);
		valid				: out std_logic;
		action			: out player_action
	);
end player1_parser;

architecture behav of player1_parser is 

--constant none			: std_logic_vector(2 downto 0) := "000"; -- TODO: remove, take from package?
--constant move_left	: std_logic_vector(2 downto 0) := "001"; -- TODO: remove, take from package?
--constant move_right	: std_logic_vector(2 downto 0) := "010"; -- TODO: remove, take from package?
--constant jump			: std_logic_vector(2 downto 0) := "011"; -- TODO: remove, take from package?
--constant duck			: std_logic_vector(2 downto 0) := "100"; -- TODO: remove, take from package?
--constant fireball		: std_logic_vector(2 downto 0) := "101"; -- TODO: remove, take from package?

--constant special_attack_1		: std_logic_vector(2 downto 0) := "110";
--constant special_attack_2		: std_logic_vector(2 downto 0) := "111";


begin

		process ( RESETn,CLK)
		variable tmp_action : player_action := none;

		begin
			if RESETn = '0' then
				tmp_action 	:= none;
				valid 		<= '0';
			
			elsif rising_edge(CLK) then
				if enable = '1'	then
					-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					--change to make = '0' for DS10 keys
					if make = '1' then
						valid <= '1';
						case kbd_data is
							when kbd_left_arrow =>
								tmp_action := move_left;
							
							when kbd_right_arrow =>
								tmp_action := move_right;
							
							when kbd_up_arrow =>
								tmp_action := jump;	
							
							when kbd_down_arrow =>
								tmp_action := duck;
							
							when kbd_dot =>
								tmp_action := fireball;
							
							when others =>
								tmp_action := none;
								
							end case;
						
					-- TODO make sure about this
					elsif make = '0' or break = '1' then
						valid <= '0';	
					end if;
					
				end if;
			end if;

			action <= tmp_action;
		end process ;
		

end behav;
