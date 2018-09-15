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
		oCoordX			: in integer;
		oCoordY			: in integer;
	
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
		
		
		if selcetor_pos = start_sel then
			if	(oCoord_X >= press_Start_X and oCoord_X <= press_End_X 
					and oCoord_Y >= press_Start_Y	and oCoord_Y <= press_End_Y) then
				bCoordX	:= oCoord_X - press_Start_X;
				bCoordY	:= oCoord_Y - press_Start_Y;
				if (press_S_colors(bCoordY , bCoordX) = x"00") then
					mVGA_RGB <= (others => '0');
				else
					mVGA_RGB <= press_S_colors(bCoordY , bCoordX) + current_color;
				end if;

			else
				mVGA_RGB <= (others => '0');
			end if;
		
		-- draw the controlers instructions
		elsif selector_pos = show_ctrls_sel then
		
		-- draw the options to select
		else
			
			-- draw the selector in the appropriate position
			if selector_pos = match_sel then
			
			elsif selector_pos = ctrls_sel then
			
			else
				mVGA_RGB <= (others => '0');
				
		end if;
		
		--case selector_pos is
		
--			when 1 =>
--				mVGA_RGB <= quick_match_colors(oCoordY, oCoordX);
--				
--			when 2 =>
--				mVGA_RGB <= controls_colors(oCoordY, oCoordX);
--			
			--when 3 =>
			--	mVGA_RGB <= credits_colors(oCoordY, oCoordX);
--			
--			when 4 =>
--				mVGA_RGB <= menu_controls_colors(oCoordY, oCoordX);
--			
--			when 5 =>
--				mVGA_RGB <= credits_menu_colors(oCoordY, oCoordX);
				
			--when others	=>
			
			--	mVGA_RGB <= credits_colors(oCoordY, oCoordX);	
	end if;

  end process;

end behav;
