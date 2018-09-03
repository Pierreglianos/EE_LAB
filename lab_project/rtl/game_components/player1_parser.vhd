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
		--make				: in std_logic;
		--break				: in std_logic;
		--kbd_data			: in std_logic_vector(8 downto 0);
		
		player_left_press 	: in std_logic;
		player_right_press 	: in std_logic;
		player_up_press 		: in std_logic;
		player_down_press 	: in std_logic;
		player_shoot_press 	: in std_logic;
		
		valid				: out std_logic;
		action			: out std_logic_vector(2 downto 0)
		--move_left_valid : out std_logic;
		--move_right_valid : out std_logic;
		--move_up_valid : out std_logic;
		--move_down_valid : out std_logic;
		--shoot_valid : out std_logic
		
	);
end player1_parser;

architecture behav of player1_parser is 

--constant special_attack_1		: std_logic_vector(2 downto 0) := "110";
--constant special_attack_2		: std_logic_vector(2 downto 0) := "111";


begin

		process ( RESETn,CLK)
		--variable tmp_action : std_logic_vector(2 downto 0) := player_action_none;
			variable move_left_valid_t 	: std_logic := '0';
			variable move_right_valid_t 	: std_logic := '0';
			variable move_up_valid_t 		: std_logic := '0';
			variable move_down_valid_t 	: std_logic := '0';
			variable shoot_valid_t 			: std_logic := '0';
		begin
			if RESETn = '0' then
				tmp_action 	:= player_action_none;
				valid 		<= '0';
			
			elsif rising_edge(CLK) then
				if enable = '1'	then
--					if(player_left_press = '1') then 
--						move_left_valid_t := '1';
--					else 
--						move_left_valid_t := '0';
--					end if;
--					
--					if(player_right_press = '1') then 
--						move_right_valid_t := '1';
--					else 
--						move_right_valid_t := '0';
--					end if;
--					
--					if(player_up_press = '1') then 
--						move_up_valid_t := '1';
--					else 
--						move_up_valid_t := '0';
--					end if;
--					
--					if(player_down_press = '1') then 
--						move_down_valid_t := '1';
--					else 
--						move_down_valid_t := '0';
--					end if;
--					
--					if(player_shoot_press = '1') then 
--						shoot_valid_t := '1';
--					else 
--						shoot_valid_t := '0';
--					end if;
					
					if(player_left_press = '1') then
						valid <= '1';
						tmp_action := player_action_move_left;
					elsif(player_right_press = '1')	 then 	
						valid <= '1';
						tmp_action := player_action_move_right;
					elsif(player_up_press = '1') then 
						valid <= '1';
						tmp_action := player_action_jump;	
					elsif(player_down_press = '1') then 	
						valid <= '1';					
						tmp_action := player_action_duck;
					elsif(player_shoot_press = '1') then	
						valid <= '1';
						tmp_action := player_action_fireball;
					else	
						valid <= '0';
						tmp_action := player_action_none;
					end if;		
				end if;
			end if;

			action <= tmp_action;
			--move_left_valid 	<= move_left_valid _t;
			--move_right_valid 	<= move_right_valid_t;
			--move_up_valid 		<= move_up_valid_t;
			--move_down_valid 	<= move_down_valid_t;
			--shoot_valid 		<= shoot_valid_t;
			
		end process ;
		

end behav;
