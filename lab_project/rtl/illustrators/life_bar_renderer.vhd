library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;


entity life_bar_renderer is
port 	(
		CLK					: in std_logic; --			//	50 MHz
		RESETn				: in std_logic;
		enable				: in std_logic;
		timer_done			: in std_logic;
		
		oCoordX				: in integer;
		oCoordY				: in integer;
		
		health1				: in integer range 0 to 150;
		health2				: in integer range 0 to 150;

		drawing_request	: out std_logic ;
		mVGA_RGB 			: out std_logic_vector(7 downto 0) 
	);
end life_bar_renderer;



architecture behav of life_bar_renderer is 
	signal draw_outline	: std_logic;

begin
	
	draw_outline <= '1' when (oCoordX = p1_life_bar_x or oCoordX = p1_life_bar_x + life_bar_size_x 
										or oCoordY = life_bar_y or oCoordY = life_bar_y + life_bar_size_y
										or oCoordX = p2_life_bar_x or oCoordX = p2_life_bar_x + life_bar_size_x) else '0';
										
	process ( RESETn,CLK)

		begin
			if RESETn = '0' then
				drawing_request	<= '0';
				mVGA_RGB 			<= x"FF";
			
			elsif rising_edge(CLK) then
				if enable = '1' and timer_done = '1' then
					if (oCoordY >= life_bar_y and oCoordY <= life_bar_y + life_bar_size_y) then --vertical coordinates are good

						if (oCoordX >= p1_life_bar_x and oCoordX <= p1_life_bar_x + life_bar_size_x) then
							if draw_outline = '1' then
								drawing_request <= '1';
								mVGA_RGB			 <= life_bar_outline_RGB;
							elsif (oCoordX <= p1_life_bar_x + health1) then
								drawing_request <= '1';
								mVGA_RGB			 <= life_bar_filling_RGB;
							end if;
							
						elsif (oCoordX >= p2_life_bar_x and oCoordX <= p2_life_bar_x + life_bar_size_x) then
							if draw_outline = '1' then
								drawing_request <= '1';
								mVGA_RGB			 <= life_bar_outline_RGB;	
							elsif (oCoordX >= p2_life_bar_x + life_bar_size_x - health2) then
								drawing_request <= '1';
								mVGA_RGB			 <= life_bar_filling_RGB;
							end if;
						
						else
								drawing_request <= '0';
						end if;
						
					else
								drawing_request <= '0';
					end if;
					
				end if;
			end if;
		end process ;
		

end behav;
