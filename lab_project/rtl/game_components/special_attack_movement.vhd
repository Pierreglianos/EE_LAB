library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 
-- Dudy Nov 13 2017


entity special_attack_movement is
port 	(
		CLK				: in std_logic; --	50 MHz
		RESETn			: in std_logic;
		timer_done		: in std_logic;
		enable			: in std_logic; -- 			enable movement
		action			: in std_logic_vector(2 downto 0);
		valid				: in std_logic;
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
constant player_width	: integer :=	26;

constant	x_upper_frame	: integer :=	638;
constant	y_upper_frame	: integer :=	400;

constant fireball		: std_logic_vector(2 downto 0) := "101";
--constant special_attack_1		: action_t := "110";
--constant special_attack_2		: action_t := "111";

type state is (idle, ongoing);



begin

	process ( RESETn,CLK)
	variable present_state	: state := idle;

	variable ObjectStartX_t	: integer range 0 to 640;  --vga screen size 
	variable ObjectStartY_t	: integer range 0 to 480;
		
		begin
		if RESETn = '0' then
			ObjectStartX_t	:= PlayerPosX + player_width + 1;
			ObjectStartY_t	:= PlayerPosY;
			draw <= '0';
			present_state 	:=	idle;

		elsif rising_edge(CLK) then
			if enable = '1' then
				
				case present_state is
					when idle =>
						if (valid ='1' and action = fireball) then
							ObjectStartX_t	:= PlayerPosX + player_width + 1;
							ObjectStartY_t	:= PlayerPosY;
							draw <= '1';
							present_state := ongoing;
						end if;
					
					when ongoing =>
						if timer_done = '1' then
							ObjectStartX_t  := ObjectStartX_t + 6;
							
							if ObjectStartX_t >= 638 then
								draw <= '0';
								present_state := idle;
							end if;
						end if;
						
				end case;
				
			end if;
			
		end if;
		ObjectStartX	<= ObjectStartX_t;		-- copy to outputs 	
		ObjectStartY	<= ObjectStartY_t + hands_dist;	
	end process ;

end behav;