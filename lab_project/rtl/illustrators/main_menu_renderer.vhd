library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;
use lab_project.main_menu_frames.all;

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
begin
	
	process ( RESETn, CLK)
	   
	begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ;

	elsif rising_edge(CLK) then
		
		case selector_pos is
		
--			when 1 =>
--				mVGA_RGB <= quick_match_colors(oCoordY, oCoordX);
--				
--			when 2 =>
--				mVGA_RGB <= controls_colors(oCoordY, oCoordX);
--			
			when 3 =>
				mVGA_RGB <= credits_colors(oCoordY, oCoordX);
--			
--			when 4 =>
--				mVGA_RGB <= menu_controls_colors(oCoordY, oCoordX);
--			
--			when 5 =>
--				mVGA_RGB <= credits_menu_colors(oCoordY, oCoordX);
				
			when others	=>
				mVGA_RGB <= credits_colors(oCoordY, oCoordX);
		end case;
		
	end if;

  end process;

end behav;
