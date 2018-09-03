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


entity player2_parser is
port 	(
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		enable			: in std_logic; -- 	//enable movement
		make				: in std_logic;
		break				: in std_logic;
		kbd_data			: in std_logic_vector(8 downto 0);
		valid				: out std_logic;
		action			: out std_logic_vector(2 downto 0)
	);
end player2_parser;

architecture behav of player2_parser is 

--constant none			: std_logic_vector(2 downto 0) := "000";
--constant move_left	: std_logic_vector(2 downto 0) := "001";
--constant move_right	: std_logic_vector(2 downto 0) := "010";
--constant jump			: std_logic_vector(2 downto 0) := "011";
--constant duck			: std_logic_vector(2 downto 0) := "100";
--constant fireball		: std_logic_vector(2 downto 0) := "101";

--constant special_attack_1		: std_logic_vector(2 downto 0) := "110";
--constant special_attack_2		: std_logic_vector(2 downto 0) := "111";


begin

		process ( RESETn,CLK)
		variable tmp_action : std_logic_vector(2 downto 0) := player_action_none;

		begin
			if RESETn = '0' then
				tmp_action 	:= player_action_none;
				valid 		<= '0';
			
			elsif rising_edge(CLK) then
				if enable = '1'	then
					-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					--change to make = '0' for DS10 keys
					if make = '1' then
						valid <= '1';
						case kbd_data is
							when kbd_D_key =>
								tmp_action := player_action_move_right;
							
							when kbd_A_key =>
								tmp_action := player_action_move_left;
							
							when kbd_W_key =>
								tmp_action := player_action_jump;	
							
							when kbd_S_key =>
								tmp_action := player_action_duck;
							
							when kbd_V_key =>
								tmp_action := player_action_fireball;
							
							when others =>
								tmp_action := player_action_none;
								
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
