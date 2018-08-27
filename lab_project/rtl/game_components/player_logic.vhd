library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity player_logic is
port 	(
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		enable			: in std_logic; -- 	//enable movement
		valid				: in std_logic;
		action			: in std_logic_vector(2 downto 0);
		--- FOR DEBUG
		initial_vel : integer;		
		---
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end player_logic;

architecture behav of player_logic is 

constant none			: std_logic_vector(2 downto 0) := "000";
constant move_left	: std_logic_vector(2 downto 0) := "001";
constant move_right	: std_logic_vector(2 downto 0) := "010";
constant jump			: std_logic_vector(2 downto 0) := "011";
constant duck			: std_logic_vector(2 downto 0) := "100";
constant fireball		: std_logic_vector(2 downto 0) := "101";
--constant special_attack_1		: std_logic_vector(2 downto 0) := "110";
--constant special_attack_2		: std_logic_vector(2 downto 0) := "111";

constant step_wid : integer := 3;

constant length_t : integer := 26;
constant width_t  : integer := 26;

constant	x_frame	: integer :=	640;
constant	y_frame	: integer :=	480;

constant StartX : integer := width_t + 20;   -- starting point
constant StartY : integer := y_frame - length_t;

constant g : integer := 10;
constant half_g : integer := g / 2;
--constant jump_init_velocity : integer := 24;
--constant initial_vel : integer := 28;
--constant jump_change_direction_y : integer := StartY - 32;

type state is (idle, jumping, falling);



begin


		process ( RESETn,CLK)
			variable ObjectStartX_t : integer;
			variable ObjectStartY_t : integer;
			variable jump_t : integer;
			variable present_state : state := idle;
			
		begin
			
			if RESETn = '0' then
				ObjectStartX_t	:= StartX;
				ObjectStartY_t	:= StartY ;
				jump_t 			:= 0;
				present_state 	:= idle;
				
			elsif rising_edge(CLK) then

				if enable = '1' then
					if valid = '1' then
						case action is
							when move_left =>
								ObjectStartX_t := ObjectStartX_t - step_wid;
								if ObjectStartX_t < 0 then
									ObjectStartX_t := 0;
								end if;
							
							when move_right =>
								ObjectStartX_t := ObjectStartX_t + width_t + step_wid;
								if ObjectStartX_t > x_frame then
									ObjectStartX_t := x_frame;
								end if;
								ObjectStartX_t := ObjectStartX_t - width_t;
						
							when jump =>
								if (present_state = idle) then
									jump_t := 0;
									present_state := jumping;
								end if;

							when others =>
								ObjectStartX_t := ObjectStartX_t;
								ObjectStartY_t := ObjectStartY_t;
							end case;
					end if;
					
					-- make sure about the timer
					if (timer_done = '1' and present_state = jumping) then
						jump_t := jump_t + 1;
						ObjectStartY_t := StartY - (initial_vel * jump_t - jump_t * jump_t)/8;
						if (ObjectStartY_t > StartY)  then -- back to the ground
							ObjectStartY_t := StartY;
							present_state := idle;
							jump_t := 0;
						end if;
					end if;
					
				end if;
			end if;
			ObjectStartX	<= ObjectStartX_t;		-- copy to outputs 	
			ObjectStartY	<= ObjectStartY_t;	
		end process ;

end behav;
