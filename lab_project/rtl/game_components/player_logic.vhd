library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;

entity player_logic is
port 	(
		CLK				: in std_logic; --						//	50 MHz
		RESETn			: in std_logic; --
		timer_done		: in std_logic;
		enable			: in std_logic; -- 	//enable movement
		valid				: in std_logic;
		action			: in std_logic_vector(2 downto 0);
		initial_direction : in std_logic;
		--- FOR DEBUG
		initial_vel : in integer;	
		---
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer;
		PlayerState		: out std_logic_vector(2 downto 0);
		movement_direction : out std_logic
	);
end player_logic;

architecture behav of player_logic is 



constant step_wid 	: integer := 6;
constant duck_size	: integer := 10;

begin


		process ( RESETn,CLK)
			variable ObjectStartX_t : integer;
			variable ObjectStartY_t : integer;
			variable jump_t : integer;
			variable present_state : std_logic_vector(2 downto 0) := player_state_idle;
			variable present_state_out : std_logic_vector(2 downto 0) := player_state_idle;
			
			variable player_direction_tmp : std_logic; --changed 
			variable player_direction 		: std_logic; -- changed only when timer is done
			variable jumping 					: std_logic;
			
		begin
			
			if RESETn = '0' then
				ObjectStartX_t	:= player_StartX;
				ObjectStartY_t	:= player_StartY ;
				jump_t 			:= 0;
				present_state 	:= player_state_idle;
				present_state_out := player_state_idle;
				
				player_direction_tmp := initial_direction;
				player_direction 		:= initial_direction;
				jumping 					:= '0';
				
			elsif rising_edge(CLK) then

				if enable = '1' then
					if valid = '1' then
						case action is
						-- TODO: maybe move the following code to 
						-- if (timer_done = '1')
							when player_action_move_left =>
								present_state := player_state_move_left;
								player_direction_tmp  := player_direction_right_to_left;
								
								--ObjectStartX_t := ObjectStartX_t - step_wid;
								--if ObjectStartX_t < 0 then
								--	ObjectStartX_t := 0;
								--end if;
							
							when player_action_move_right =>
								present_state := player_state_move_right;
								player_direction_tmp  := player_direction_left_to_right;
								
								--ObjectStartX_t := ObjectStartX_t + step_wid;
								--if ObjectStartX_t > x_frame then
								--	ObjectStartX_t := x_frame;
								--end if;
						
							when player_action_jump =>
								if (jumping = '0') then
									jumping := '1';
									jump_t := 0;
								end if;
							when player_action_duck =>
								present_state := player_state_duck;
								
								--ObjectStartX_t := ObjectStartX_t;
								--ObjectStartY_t := ObjectStartY_t;
							
							when player_action_fireball =>
								present_state := player_state_shoot;
								
								--ObjectStartX_t := ObjectStartX_t;
								--ObjectStartY_t := ObjectStartY_t;

							when others =>
								present_state := player_state_idle;
								--ObjectStartX_t := ObjectStartX_t;
								--ObjectStartY_t := ObjectStartY_t;
							end case;
					end if; -- valid = '1'
					
					
					-- make sure about the timer
					if (timer_done = '1') then
						if jumping = '1' then -- player_state_jump =>
								jump_t := jump_t + 1;
								ObjectStartY_t := player_StartY - (initial_vel * jump_t - jump_t * jump_t)/8;
								if (ObjectStartY_t > player_StartY)  then -- back to the ground
									ObjectStartY_t := player_StartY;
									jumping := '0';
									jump_t := 0;
								end if;
						end if;
						case present_state is

							when player_state_move_left =>
								ObjectStartX_t := ObjectStartX_t - step_wid;
								if (ObjectStartX_t < 0) then
									ObjectStartX_t := 0;
								end if;
							when player_state_move_right =>
								ObjectStartX_t := ObjectStartX_t + step_wid;
								if (ObjectStartX_t >= x_frame - player_width_t) then
									ObjectStartX_t := x_frame - player_width_t;
								end if;
							when others => -- redundant?
								ObjectStartX_t := ObjectStartX_t;
								ObjectStartY_t := ObjectStartY_t;
							end case;
								
						--when others =>
						--	present_state_out := present_state;
						--end case;
						--player_direction := player_direction_tmp;
						
						----------------------------------------------------------
						
						--if(present_state = player_state_jump) then 
						--	jump_t := jump_t + 1;
						--	ObjectStartY_t := player_StartY - (initial_vel * jump_t - jump_t * jump_t)/8;
						--	if (ObjectStartY_t > player_StartY)  then -- back to the ground
						--		ObjectStartY_t := player_StartY;
						--		present_state := player_state_idle;
						--		jump_t := 0;
						--	end if;
						--end if;
						
						present_state_out := present_state;
						player_direction := player_direction_tmp;
						
						if(valid = '0') then 
							present_state := player_state_idle;
						end if;	
						
					end if;
					
				end if;
			end if;
			ObjectStartX	<= ObjectStartX_t;		-- copy to outputs 	
			ObjectStartY	<= ObjectStartY_t;
			PlayerState		<= present_state_out; -- TODO: change only when timer is done?
			movement_direction <= player_direction;
		end process ;

end behav;
