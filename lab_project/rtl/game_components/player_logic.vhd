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
constant jump_init_velocity : integer := 40;
constant jump_change_direction_time : integer := jump_init_velocity / g;
constant jump_change_direction_y : integer := StartY - jump_init_velocity * jump_change_direction_time + half_g * jump_change_direction_time * jump_change_direction_time;


begin


		process ( RESETn,CLK)
			variable ObjectStartX_t : integer;
			variable ObjectStartY_t : integer;
			variable jump_t : integer;
		
		begin
			if RESETn = '0' then
				ObjectStartX_t	:= StartX;
				ObjectStartY_t	:= StartY ;
				jump_t := 0;
			elsif rising_edge(CLK) then

				if (enable = '1' and valid = '1') then
					
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
							jump_t := jump_t + 1;
							if(jump_t < jump_change_direction_time) then -- moving upwards
								ObjectStartY_t := StartY - jump_init_velocity * jump_t + half_g *  jump_t * jump_t;	
							elsif (jump_t < 2 * jump_change_direction_time) then -- moving downwards
								ObjectStartY_t := jump_change_direction_y + half_g *  jump_t * jump_t;
							else  -- back to the ground
								jump_t := 0;
							end if; 
						
						when others =>
							ObjectStartX_t := ObjectStartX_t;
							ObjectStartY_t := ObjectStartY_t;
						end case;
						
				end if;
				
			end if;
			ObjectStartX	<= ObjectStartX_t;		-- copy to outputs 	
			ObjectStartY	<= ObjectStartY_t;	
		end process ;

end behav;
