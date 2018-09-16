library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;
use lab_project.STATIC_MENU_PCKG.all;

entity static_menu_renderer is
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
end static_menu_renderer;

architecture behav of static_menu_renderer is 

constant SFRAME_Size_X	: integer := 65;
constant SFRAME_size_Y 	: integer := 300;

constant RFRAME_Start_X	: integer := 65;
constant LFRAME_Start_X	: integer := 474;
constant SFRAME_Start_Y : integer := 300;	

constant RFRAME_End_X	: integer := RFRAME_Start_X + SFRAME_Size_X;
constant LFRAME_End_X	: integer := LFRAME_Start_X + SFRAME_Size_X;
constant SFRAME_End_Y 	: integer := SFRAME_Start_Y + SFRAME_size_Y;

begin
	
	process ( RESETn, CLK)
	
	variable bCoord_X		: integer;
	variable bCoord_Y		: integer;
	variable curr_space	: integer;
	variable line_amnt	: integer;
	begin
	if RESETn = '0' then
	   mVGA_RGB	<=  (others => '0') ;

	elsif rising_edge(CLK) then
		
		if(oCoord_X >= TECH_Start_X and oCoord_X <= TECH_End_X and oCoord_Y >= TECH_Start_Y and oCoord_Y <= TECH_End_Y) then 
			if(oCoord_X >= TECH_Start_X and oCoord_X < TECH_Start_X + TECH_T_X_size) then 
				bCoord_X 	:= (oCoord_X - TECH_Start_X);
				bCoord_Y 	:= (oCoord_Y - TECH_Start_Y);
				mVGA_RGB <= TECH_T_colors(bCoord_Y , bCoord_X);
			elsif(oCoord_X >= TECH_Start_X + TECH_T_X_size and oCoord_X < TECH_Start_X + TECH_T_X_size + TECH_E_X_size ) then
				bCoord_X 	:= (oCoord_X - (TECH_Start_X + TECH_T_X_size));
				bCoord_Y 	:= (oCoord_Y - TECH_Start_Y);
				mVGA_RGB <= TECH_E_colors(bCoord_Y , bCoord_X);
			elsif(oCoord_X >= TECH_Start_X + TECH_T_X_size + TECH_E_X_size  and oCoord_X < TECH_Start_X + TECH_T_X_size + TECH_E_X_size + TECH_C_X_size) then 
				bCoord_X 	:= (oCoord_X - (TECH_Start_X + TECH_T_X_size + TECH_E_X_size));
				bCoord_Y 	:= (oCoord_Y - TECH_Start_Y);
				mVGA_RGB <= TECH_C_colors(bCoord_Y , bCoord_X);
			elsif(oCoord_X >= TECH_Start_X + TECH_T_X_size + TECH_E_X_size + TECH_C_X_size and oCoord_X < TECH_End_X) then 
				bCoord_X 	:= (oCoord_X - (TECH_Start_X + TECH_T_X_size + TECH_E_X_size + TECH_C_X_size));
				bCoord_Y 	:= (oCoord_Y - TECH_Start_Y);
				mVGA_RGB <= TECH_H_colors(bCoord_Y , bCoord_X);
			else
				mVGA_RGB <= (others => '0');
			end if;
		elsif(oCoord_X >= FIGHTER_Start_X and oCoord_X <= FIGHTER_End_X and oCoord_Y >= FIGHTER_Start_Y and oCoord_Y <= FIGHTER_End_Y) then
			if(oCoord_X >= FIGHTER_Start_X and oCoord_X < FIGHTER_Start_X + FIGHTER_F_X_size) then 
				bCoord_X 	:= (oCoord_X - FIGHTER_Start_X);
				bCoord_Y 	:= (oCoord_Y - FIGHTER_Start_Y);
				mVGA_RGB <= FIGHTER_F_colors(bCoord_Y , bCoord_X);
			elsif(oCoord_X >= FIGHTER_Start_X + FIGHTER_F_X_size and oCoord_X < FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size) then 
				bCoord_X 	:= (oCoord_X - (FIGHTER_Start_X + FIGHTER_F_X_size));
				bCoord_Y 	:= (oCoord_Y - FIGHTER_Start_Y);
				mVGA_RGB <= FIGHTER_I_colors(bCoord_Y , bCoord_X);
			elsif(oCoord_X >= FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size and oCoord_X < FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size) then 
				bCoord_X 	:= (oCoord_X - (FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size));
				bCoord_Y 	:= (oCoord_Y - FIGHTER_Start_Y);
				mVGA_RGB <= FIGHTER_G_colors(bCoord_Y , bCoord_X);
			elsif(oCoord_X >= FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size and oCoord_X < FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size + FIGHTER_H_X_size) then 
				bCoord_X 	:= (oCoord_X - (FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size));
				bCoord_Y 	:= (oCoord_Y - FIGHTER_Start_Y);
				mVGA_RGB <= FIGHTER_H_colors(bCoord_Y , bCoord_X);
			elsif(oCoord_X >= FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size + FIGHTER_H_X_size  and oCoord_X < FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size + FIGHTER_H_X_size + FIGHTER_T_X_size ) then 
				bCoord_X 	:= (oCoord_X - (FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size + FIGHTER_H_X_size));
				bCoord_Y 	:= (oCoord_Y - FIGHTER_Start_Y);
				mVGA_RGB <= FIGHTER_T_colors(bCoord_Y , bCoord_X);
			elsif(oCoord_X >= FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size + FIGHTER_H_X_size + FIGHTER_T_X_size  and oCoord_X < FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size + FIGHTER_H_X_size + FIGHTER_T_X_size + FIGHTER_E_X_size) then 
				bCoord_X 	:= (oCoord_X - (FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size + FIGHTER_H_X_size + FIGHTER_T_X_size));
				bCoord_Y 	:= (oCoord_Y - FIGHTER_Start_Y);
				mVGA_RGB <= FIGHTER_E_colors(bCoord_Y , bCoord_X);
			elsif(oCoord_X >= FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size + FIGHTER_H_X_size + FIGHTER_T_X_size + FIGHTER_E_X_size and oCoord_X < FIGHTER_End_X) then 
				bCoord_X 	:= (oCoord_X - (FIGHTER_Start_X + FIGHTER_F_X_size + FIGHTER_I_X_size + FIGHTER_G_X_size + FIGHTER_H_X_size + FIGHTER_T_X_size + FIGHTER_E_X_size));
				bCoord_Y 	:= (oCoord_Y - FIGHTER_Start_Y);
				mVGA_RGB <= FIGHTER_R_colors(bCoord_Y , bCoord_X);
			else
				mVGA_RGB <= (others => '0');
			end if;
		elsif (oCoord_X >= UFRAME_Start_X and oCoord_X <= UFRAME_End_X and oCoord_Y >= UFRAME_Start_Y and oCoord_Y < UFRAME_End_Y) then
			bCoord_X		:= (oCoord_X - UFRAME_Start_X) mod 4;
			bCoord_Y		:= (oCoord_Y - UFRAME_Start_Y);
			if (UFRAME_bmp(bCoord_Y, bCoord_X) = '1') then
				mVGA_RGB <= UFRAME_color;
			else
				mVGA_RGB <= (others => '0');
			end if;
		elsif (oCoord_Y >= SFRAME_Start_Y and oCoord_Y < SFRAME_End_Y) then
			
			bCoord_Y		:= (oCoord_Y - SFRAME_Start_Y) mod 16;
			if (oCoord_X >= LFRAME_Start_X and oCoord_X <= LFRAME_End_X) then
				bCoord_X		:= (oCoord_X - LFRAME_Start_X) mod 4;
				if (UFRAME_bmp(bCoord_Y, bCoord_X) = '1') then
					mVGA_RGB <= UFRAME_color;
				else 
					mVGA_RGB <= (others => '0');
				end if;
			elsif (oCoord_X >= RFRAME_Start_X and oCoord_X <= RFRAME_End_X) then
				bCoord_X		:= (oCoord_X - RFRAME_Start_X) mod 4;
				if (UFRAME_bmp(bCoord_Y, bCoord_X) = '1') then
					mVGA_RGB <= UFRAME_color;
				else 
					mVGA_RGB <= (others => '0');
				end if;
			else
				mVGA_RGB <= (others => '0');
			end if;			
		else
			mVGA_RGB <= (others => '0');
		end if;		
	end if;

  end process;

end behav;
