library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;
use lab_project.opening_menu_frames.all;

entity start_menu_renderer is
port 	(
		CLK				: in std_logic;
		RESETn			: in std_logic;
		timer_done		: in std_logic;
		enable			: in std_logic;
		oCoordX			: in integer;
		oCoordY			: in integer;
		
		mVGA_RGB 		: out std_logic_vector(7 downto 0) 

	);
end start_menu_renderer;

architecture behav of start_menu_renderer is 
begin
	
	process ( RESETn, CLK)
	
  	variable counter : integer range 0 to 7 := 0;
   
	begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ;
		 counter		:=  0;

	elsif rising_edge(CLK) then
		if timer_done = '1' then
			counter:= counter + 1;
		end if;
		
		mVGA_RGB <= frame1_colors(oCoordY, oCoordX);

--		case counter is
--			when 0 =>
--				mVGA_RGB <= frame1_colors(oCoordY, oCoordX);
--		
--			when 1 =>
--				mVGA_RGB <= frame2_colors(oCoordY, oCoordX);
--				
--			when 2 =>
--				mVGA_RGB <= frame3_colors(oCoordY, oCoordX);
--			
--			when 3 =>
--				mVGA_RGB <= frame4_colors(oCoordY, oCoordX);
--			
--			when 4 =>
--				mVGA_RGB <= frame5_colors(oCoordY, oCoordX);
--			
--			when 5 =>
--				mVGA_RGB <= frame6_colors(oCoordY, oCoordX);
--				
--			when 6 =>
--				mVGA_RGB <= frame7_colors(oCoordY, oCoordX);
--				
--			when 7 =>
--				mVGA_RGB <= frame8_colors(oCoordY, oCoordX);
--		end case;
		
	end if;

  end process;

end behav;
