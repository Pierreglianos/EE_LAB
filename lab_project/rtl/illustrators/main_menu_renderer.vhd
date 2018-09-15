library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;
use lab_project.MAIN_MENU_PCKG.all;

entity main_menu_renderer is
port 	(
		CLK				: in std_logic;
		RESETn			: in std_logic;
		timer_done		: in std_logic;
		enable			: in std_logic;
		selector_pos	: in integer;
		oCoord_X			: in integer;
		oCoord_Y			: in integer;
	
		mVGA_RGB 		: out std_logic_vector(7 downto 0)

	);
end main_menu_renderer;


architecture behav of main_menu_renderer is

constant base_color 	: std_logic_vector(7 downto 0) := X"1A";
constant max_color	: std_logic_vector(7 downto 0) := X"B6";

begin
	
	process ( RESETn, CLK)
	   variable bCoord_X : integer := 0;-- offset from start position 
		variable bCoord_Y : integer := 0;
		variable counter	: std_logic_vector(2 downto 0);
		variable current_color : std_logic_vector(7 downto 0) := base_color;
		
	begin
	if RESETn = '0' then
	   mVGA_RGB	<=  (others => '0') ;
		current_color := base_color;
		counter := "000";
	elsif rising_edge(CLK) then
		
		if (timer_done = '1') then
			counter := counter + 1;
			if (counter = "000") then
				current_color := current_color + base_color;
			end if;
			if (current_color > max_color) then
				current_color := base_color;
			end if;
		end if;
		
		
		if selector_pos = start_sel then
			if	(oCoord_X >= press_Start_X and oCoord_X <= press_End_X 
					and oCoord_Y >= press_Start_Y	and oCoord_Y <= press_End_Y) then
				bCoord_X	:= oCoord_X - press_Start_X;
				bCoord_Y	:= oCoord_Y - press_Start_Y;
				if (press_S_colors(bCoord_Y , bCoord_X) = x"00") then
					mVGA_RGB <= (others => '0');
				else
					mVGA_RGB <= press_S_colors(bCoord_Y , bCoord_X) + current_color;
				end if;

			else
				mVGA_RGB <= (others => '0');
			end if;
		
		-- draw the controlers instructions
		elsif selector_pos = show_ctrls_sel then
			if(oCoord_X >= CONTROLS_MENU_Start_X and oCoord_X < CONTROLS_MENU_End_X 
			and oCoord_Y >= CONTROLS_MENU_Start_Y and oCoord_Y < CONTROLS_MENU_End_Y) then
				if(oCoord_X >= CONTROLS_MENU_Start_X and oCoord_X < CONTROLS_MENU_Start_X + CONTROLS_PLAYER1_X_size and 
					oCoord_Y < CONTROLS_MENU_Start_Y + CONTROLS_PLAYER1_Y_size ) then 
						bCoord_X 	:= (oCoord_X - CONTROLS_MENU_Start_X);
						bCoord_Y 	:= (oCoord_Y - CONTROLS_MENU_Start_Y);
						mVGA_RGB 	<= CONTROLS_PLAYER1_colors(bCoord_Y , bCoord_X);
				elsif(oCoord_X >= CONTROLS_MENU_Start_X + CONTROLS_PLAYER1_X_size + 125 and 
					oCoord_Y < CONTROLS_MENU_Start_Y + CONTROLS_PLAYER2_Y_size ) then 
						bCoord_X 	:= (oCoord_X - (CONTROLS_MENU_Start_X + CONTROLS_PLAYER1_X_size + 125));
						bCoord_Y 	:= (oCoord_Y - CONTROLS_MENU_Start_Y);
						mVGA_RGB 	<= CONTROLS_PLAYER2_colors(bCoord_Y , bCoord_X);
				elsif(oCoord_X >= CONTROLS_MENU_MOVEMENT_KEYS1_Start_X and oCoord_X < CONTROLS_MENU_MOVEMENT_KEYS1_End_X and 
					oCoord_Y >= CONTROLS_MENU_MOVEMENT_KEYS1_Start_Y and oCoord_Y < CONTROLS_MENU_MOVEMENT_KEYS1_End_Y) then 
						bCoord_X 	:= (oCoord_X - CONTROLS_MENU_MOVEMENT_KEYS1_Start_X);
						bCoord_Y 	:= (oCoord_Y - CONTROLS_MENU_MOVEMENT_KEYS1_Start_Y);
						mVGA_RGB 	<= CONTROLS_MOVEMENT_KEYS_colors(bCoord_Y , bCoord_X);
				elsif(oCoord_X >= CONTROLS_MENU_MOVEMENT_KEYS1_End_X + 10 and oCoord_X < CONTROLS_MENU_MOVEMENT_KEYS1_End_X + 10 + CONTROLS_MOVEMENT_X_size and 
				oCoord_Y >= CONTROLS_MENU_MOVEMENT_KEYS1_Start_Y + 15 and oCoord_Y < CONTROLS_MENU_MOVEMENT_KEYS1_Start_Y + 23) then
						bCoord_X 	:= (oCoord_X - (CONTROLS_MENU_MOVEMENT_KEYS1_End_X + 10));
						bCoord_Y 	:= (oCoord_Y - (CONTROLS_MENU_MOVEMENT_KEYS1_Start_Y + 15));
						mVGA_RGB 	<= CONTROLS_MOVEMENT_colors(bCoord_Y , bCoord_X);
				elsif(oCoord_X >= CONTROLS_MENU_ATTACK_KEYS1_Start_X + 80 and oCoord_X < CONTROLS_MENU_ATTACK_KEYS1_Start_X + 127 and 
					oCoord_Y >= CONTROLS_MENU_ATTACK_KEYS1_Start_Y + 5 and oCoord_Y < CONTROLS_MENU_ATTACK_KEYS1_Start_Y + 5 + CONTROLS_KICK_Y_size) then
						bCoord_X 	:= (oCoord_X - (CONTROLS_MENU_ATTACK_KEYS1_Start_X + 80));
						bCoord_Y 	:= (oCoord_Y - (CONTROLS_MENU_ATTACK_KEYS1_Start_Y + 5));
						mVGA_RGB 	<= CONTROLS_KICK_colors(bCoord_Y , bCoord_X);
				elsif(oCoord_X >= CONTROLS_MENU_ATTACK_KEYS1_Start_X + 63 and oCoord_X < CONTROLS_MENU_ATTACK_KEYS1_Start_X + 133 and 
					oCoord_Y >= CONTROLS_MENU_ATTACK_KEYS1_Start_Y + 35  and oCoord_Y < CONTROLS_MENU_ATTACK_KEYS1_Start_Y + 35 + CONTROLS_SHOOT_Y_size) then
						bCoord_X 	:= (oCoord_X - (CONTROLS_MENU_ATTACK_KEYS1_Start_X + 63));
						bCoord_Y 	:= (oCoord_Y - (CONTROLS_MENU_ATTACK_KEYS1_Start_Y+ 35));
						mVGA_RGB 	<= CONTROLS_SHOOT_colors(bCoord_Y , bCoord_X);
				elsif(oCoord_X >= CONTROLS_MENU_ATTACK_KEYS1_Start_X + 63 and oCoord_X < CONTROLS_MENU_ATTACK_KEYS1_Start_X + 133 and 
					oCoord_Y >= CONTROLS_MENU_ATTACK_KEYS1_Start_Y + 70  and oCoord_Y < CONTROLS_MENU_ATTACK_KEYS1_Start_Y + 70 + CONTROLS_PUNCH_Y_size) then
						bCoord_X 	:= (oCoord_X - (CONTROLS_MENU_ATTACK_KEYS1_Start_X + 63));
						bCoord_Y 	:= (oCoord_Y - (CONTROLS_MENU_ATTACK_KEYS1_Start_Y+ 70));
						mVGA_RGB 	<= CONTROLS_PUNCH_colors(bCoord_Y , bCoord_X);
				elsif(oCoord_X >= CONTROLS_MENU_MOVEMENT_KEYS2_Start_X and oCoord_X < CONTROLS_MENU_MOVEMENT_KEYS2_End_X and 
					oCoord_Y >= CONTROLS_MENU_MOVEMENT_KEYS2_Start_Y and oCoord_Y < CONTROLS_MENU_MOVEMENT_KEYS2_End_Y) then 
						bCoord_X 	:= (oCoord_X - CONTROLS_MENU_MOVEMENT_KEYS2_Start_X);
						bCoord_Y 	:= (oCoord_Y - CONTROLS_MENU_MOVEMENT_KEYS2_Start_Y);
						mVGA_RGB 	<= CONTROLS_MOVEMENT_KEYS2_colors(bCoord_Y , bCoord_X);
				elsif(oCoord_X >= CONTROLS_MENU_ATTACK_KEYS1_Start_X and oCoord_X < CONTROLS_MENU_ATTACK_KEYS1_End_X and 
					oCoord_Y >= CONTROLS_MENU_ATTACK_KEYS1_Start_Y and oCoord_Y < CONTROLS_MENU_ATTACK_KEYS1_End_Y) then 
						bCoord_X 	:= (oCoord_X - CONTROLS_MENU_ATTACK_KEYS1_Start_X);
						bCoord_Y 	:= (oCoord_Y - CONTROLS_MENU_ATTACK_KEYS1_Start_Y);
						mVGA_RGB 	<= CONTROLS_ATTACKS_KEYS_colors(bCoord_Y , bCoord_X);
				elsif(oCoord_X >= CONTROLS_MENU_ATTACK_KEYS2_Start_X and oCoord_X < CONTROLS_MENU_ATTACK_KEYS2_End_X and 
					oCoord_Y >= CONTROLS_MENU_ATTACK_KEYS2_Start_Y and oCoord_Y < CONTROLS_MENU_ATTACK_KEYS2_End_Y) then
						bCoord_X 	:= (oCoord_X - CONTROLS_MENU_ATTACK_KEYS2_Start_X);
						bCoord_Y 	:= (oCoord_Y - CONTROLS_MENU_ATTACK_KEYS2_Start_Y);
						mVGA_RGB 	<= CONTROLS_ATTACKS_KEYS2_colors(bCoord_Y , bCoord_X);
				else 
						mVGA_RGB 	<= (others => '0');
				end if;
			else 
				mVGA_RGB 	<= (others => '0');
			end if;
		-- draw the options to select
		else
		
			if(oCoord_X >= OPTIONS_Start_X and oCoord_X <= OPTIONS_End_X 
			and oCoord_Y >= OPTIONS_Start_Y and oCoord_Y <= OPTIONS_End_Y) then
				bCoord_X 	:= (oCoord_X - OPTIONS_Start_X);
				bCoord_Y 	:= (oCoord_Y - OPTIONS_Start_Y);
            mVGA_RGB 	<= OPTIONS_colors(bCoord_Y , bCoord_X);
         
			elsif(oCoord_X >= OPTIONS_Start_X - SELECTOR_X_size and oCoord_X < OPTIONS_Start_X
			and oCoord_Y >= OPTIONS_Start_Y and oCoord_Y < OPTIONS_End_Y + SELECTOR_Y_size) then
				if(selector_pos = match_sel and oCoord_Y >= OPTIONS_Start_Y - 3 
				and oCoord_Y < OPTIONS_Start_Y + SELECTOR_Y_size) then
					bCoord_X 	:= (oCoord_X - (OPTIONS_Start_X - SELECTOR_X_size));
					bCoord_Y 	:= (oCoord_Y - OPTIONS_Start_Y);
					mVGA_RGB 	<= SELECTOR_colors(bCoord_Y , bCoord_X);
            elsif(selector_pos = ctrls_sel and oCoord_Y >= OPTIONS_Start_Y + 25
				and oCoord_Y < OPTIONS_Start_Y + 25 + SELECTOR_Y_size) then
					bCoord_X 	:= (oCoord_X - (OPTIONS_Start_X - SELECTOR_X_size));
					bCoord_Y 	:= (oCoord_Y - (OPTIONS_Start_Y + 25));
					mVGA_RGB 	<= SELECTOR_colors(bCoord_Y , bCoord_X);
            else
					mVGA_RGB <= (others => '0');
				end if;
			else 
				mVGA_RGB <= (others => '0');
			end if;	
		end if;
		
		--case selector_pos is
		
--			when 1 =>
--				mVGA_RGB <= quick_match_colors(oCoord_Y, oCoord_X);
--				
--			when 2 =>
--				mVGA_RGB <= controls_colors(oCoord_Y, oCoord_X);
--			
			--when 3 =>
			--	mVGA_RGB <= credits_colors(oCoord_Y, oCoord_X);
--			
--			when 4 =>
--				mVGA_RGB <= menu_controls_colors(oCoord_Y, oCoord_X);
--			
--			when 5 =>
--				mVGA_RGB <= credits_menu_colors(oCoord_Y, oCoord_X);
				
			--when others	=>
			
			--	mVGA_RGB <= credits_colors(oCoord_Y, oCoord_X);	
	end if;

end process;

end behav;
