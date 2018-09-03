library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 
-- Dudy Nov 13 2017

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;


entity special_attack_movement is
port 	(
		CLK				: in std_logic; --	50 MHz
		RESETn			: in std_logic;
		timer_done		: in std_logic;
		enable			: in std_logic; -- 			enable movement
		action			: in std_logic_vector(2 downto 0);
		valid				: in std_logic;
		direction		: in std_logic; -- 0 left player, 1 right player
		PlayerPosX		: in integer;
		PlayerPosY		: in integer;
		hit				: in std_logic;
		ObjectStartX	: out integer;
		ObjectStartY	: out integer;
		draw				: out std_logic
		
	);
end special_attack_movement;

architecture behav of special_attack_movement is 


constant hands_dist		: integer :=	8;
constant speed 			: integer := 	8;
constant player_width	: integer :=	26; -- TODO: remove, take from package

constant	x_upper_frame	: integer :=	638; -- TODO: remove, take from package
constant	y_upper_frame	: integer :=	400; -- TODO: remove, take from package

--constant fireball		: std_logic_vector(2 downto 0) := "101"; -- TODO: remove, take from package

constant left_to_right_direction : std_logic := '0'; -- TODO: remove, take from package
constant right_to_left_direction : std_logic := '1'; -- TODO: remove, take from package

--constant special_attack_1		: action_t := "110";
--constant special_attack_2		: action_t := "111";

type state is (idle, ongoing);

begin

	process ( RESETn,CLK)
	variable present_state	: state := idle;

	variable ObjectStartX_t	: integer range 0 to 640;  --vga screen size 
	variable ObjectStartY_t	: integer range 0 to 480;
	
	variable movement_direction 	: std_logic;
	variable hit_occured				: std_logic;
		
		begin
		if RESETn = '0' then
			if(direction = left_to_right_direction) then 
				ObjectStartX_t	:= PlayerPosX + player_width + 1;
			else 
				ObjectStartX_t	:= PlayerPosX - 1;
			end if;
			
			ObjectStartY_t	:= PlayerPosY;
			draw <= '0';
			present_state 	:=	idle;
			hit_occured 	:= '0';

		elsif rising_edge(CLK) then
			if enable = '1' then
			
				if hit = '1' then -- stop attack
					hit_occured := '1';
				end if;
				
				case present_state is
					when idle =>
						if (valid ='1' and action = player_action_fireball) then
							movement_direction := direction;
							
							if(movement_direction = left_to_right_direction) then 
								ObjectStartX_t	:= PlayerPosX + player_width + 1;
							else 
								ObjectStartX_t	:= PlayerPosX - 1;
							end if;
							
							ObjectStartY_t	:= PlayerPosY;
							draw <= '1';
							present_state := ongoing;
						end if;
					
					when ongoing =>
	
						if timer_done = '1' then
							if hit_occured = '1' then
								draw <= '0';
								present_state := idle;
								hit_occured := '0';
								
							elsif (movement_direction = left_to_right_direction) then 
								ObjectStartX_t  := ObjectStartX_t + speed;
								if ObjectStartX_t >= 638 then
									draw <= '0';
									present_state := idle;
								end if;
							else 
								ObjectStartX_t  := ObjectStartX_t - speed;
								if ObjectStartX_t <= 10 then
									draw <= '0';
									present_state := idle;
								end if;
							end if;
						end if;
						
				end case;
				
			end if;
			
		end if;
		ObjectStartX	<= ObjectStartX_t;		-- copy to outputs 	
		ObjectStartY	<= ObjectStartY_t + hands_dist;	
	end process ;

end behav;
