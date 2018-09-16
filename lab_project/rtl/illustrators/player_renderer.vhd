library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;
--use lab_project.player_renderer_package.all;


entity player_renderer is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		ObjectStartX	: in integer;
		ObjectStartY 	: in integer;
		PlayerState		: in std_logic_vector(2 downto 0);
		player_direction : in std_logic;
		
		is_game_over	: in std_logic;
		player_won 		: in std_logic;
		enable		 	: in std_logic;

		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end player_renderer;

architecture behav of player_renderer is

begin
process ( RESETn, CLK)

  	variable current_color : std_logic_vector(7 downto 0);
	variable pixel_valid : std_logic;
	
	variable bCoord_X : integer := 0;-- offset from start position 
	variable bCoord_Y : integer := 0;

	variable drawing_X : std_logic := '0';
	variable drawing_Y : std_logic := '0';

	--		
	variable objectEndX : integer;
	variable objectEndY : integer;

   begin
	if RESETn = '0' then
	   mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		pixel_valid := '0';

	elsif rising_edge(CLK) then
	
--		if(is_game_over = '1' and player_won = '1') then 
--			objectEndX	:= 	ObjectStartX + PinkWon_X_size;
--		elsif(is_game_over = '1' ) then 
--			objectEndX	:= 	ObjectStartX + PinkDead_X_size;
--		elsif(PlayerState = player_state_idle or PlayerState = player_state_move_left or PlayerState = player_state_move_right) then 
--				objectEndX	:= 	ObjectStartX + PinkIdle_X_size;
--		elsif(PlayerState = player_state_kick) then
--				objectEndX := ObjectStartX + PinkKick_X_size;
--		elsif(PlayerState = player_state_duck) then 
--				objectEndX := ObjectStartX + PinkDucking_X_size;
--		elsif(PlayerState = player_state_punch) then 
--				objectEndX := ObjectStartX + PinkPunch_X_size;	
--		else -- PlayerState = player_state_shoot
--				objectEndX := ObjectStartX + PinkShoot_X_size;
--		end if;
--		
--		if(is_game_over = '1' and player_won = '1') then 
--			objectEndY	:= 	ObjectStartY + PinkWon_Y_size;
--		elsif(is_game_over = '1') then 
--			objectEndY	:= 	ObjectStartY + PinkDead_Y_size;
--		elsif(PlayerState = player_state_idle or PlayerState = player_state_move_left or PlayerState = player_state_move_right) then 
--				objectEndY	:= 	ObjectStartY + PinkIdle_Y_size;
--		elsif(PlayerState = player_state_kick) then
--				objectEndY := ObjectStartY + PinkKick_Y_size;
--		elsif(PlayerState = player_state_duck) then 
--				objectEndY := ObjectStartY + PinkDucking_Y_size;
--		elsif(PlayerState = player_state_punch) then 
--				objectEndY := ObjectStartY + PinkPunch_Y_size;	
--		else -- PlayerState = player_state_shoot
--				objectEndY := ObjectStartY + PinkShoot_Y_size;
--		end if;
		
		objectEndX	:= 	ObjectStartX + player_width_t;
		objectEndY	:= 	ObjectStartY + player_length_t;


		if((oCoord_X  >= ObjectStartX) and  (oCoord_X < objectEndX)) then
			drawing_X	:= '1';
		else 
			drawing_X	:= '0';
		end if;
		
		if((oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY)) then 
			drawing_Y	:= '1';
		else 
			drawing_Y	:= '0';
		end if;

		if(drawing_X = '1' and  drawing_Y = '1' and player_direction = player_direction_right_to_left) then
			bCoord_X 	:= (ObjectEndX - oCoord_X);
		elsif(drawing_X = '1' and  drawing_Y = '1') then 
			bCoord_X 	:= (oCoord_X - ObjectStartX);
		else
			bCoord_X 	:= 0;
		end if;
		
		if( drawing_X = '1' and  drawing_Y = '1') then 
			bCoord_Y 	:= (oCoord_Y - ObjectStartY);
		else
			bCoord_Y 	:= 0;
		end if;
		
--		if(is_game_over = '1' and player_won = '1') then 
--			current_color := PinkWon_colors(bCoord_Y , bCoord_X);
--			pixel_valid := PinkWon_bmp(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ;
--		elsif(is_game_over = '1' ) then 
--			current_color := PinkDead_colors(bCoord_Y , bCoord_X);
--			pixel_valid := PinkDead_bmp(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ;
--		else
			case PlayerState is
				when  player_state_idle | player_state_move_left | player_state_move_right =>
					current_color := X"66"; -- yellow
					pixel_valid := '1';
					--current_color := PinkIdle_colors(bCoord_Y , bCoord_X);
					--pixel_valid := PinkIdle_bmp(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ;
				when player_state_duck =>
					current_color := X"E0"; -- red
					pixel_valid := '1';
					--current_color := PinkDucking_colors(bCoord_Y , bCoord_X);
					--pixel_valid := PinkDucking_bmp(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ;
				when player_state_shoot =>
					current_color := X"07";
					pixel_valid := '1';
					--shoot_colors
					--current_color := PinkShoot_colors(bCoord_Y , bCoord_X);
				--	pixel_valid := PinkShoot_bmp(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ;
				--when player_state_punch =>
				--	current_color := PinkPunch_colors(bCoord_Y , bCoord_X);
				--	pixel_valid := PinkPunch_bmp(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ;
				--when player_state_kick =>
				--	current_color := PinkKick_colors(bCoord_Y , bCoord_X);
				--	pixel_valid := PinkKick_bmp(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ;
				when others =>
					current_color := X"FF";
					pixel_valid := '0';
			end case;
--		end if;
			
		mVGA_RGB				<=  current_color;	--get from colors table 
		drawing_request	<=  pixel_valid and drawing_X and drawing_Y and enable; -- get from mask table if inside rectangle  
	end if;

  end process;

		
end behav;		
		
