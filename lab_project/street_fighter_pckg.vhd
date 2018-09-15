library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

package STREET_FIGHTER_PCKG is 

-- VGA defines------------------------------------------------------
	constant	x_frame	: integer :=	640;
	constant	y_frame	: integer :=	480;
	
	constant life_bar_outline_RGB	: std_logic_vector(7 downto 0) := X"C7";
	constant life_bar_filling_RGB	: std_logic_vector(7 downto 0) := X"FF";
	constant p1_life_bar_x			: integer := 100;
	constant p2_life_bar_x			: integer := 338;
	constant life_bar_y				: integer := 50;
	constant life_bar_size_x		: integer := 152;
	constant life_bar_size_y		: integer := 22;
	constant initial_vel				: integer := 60;

--------------------------------------------------------------------
-- KBD constants----------------------------------------------------
	constant kbd_left_arrow  	: std_logic_vector(8 downto 0) := "101101011"; -- 0x6B extended
	constant kbd_right_arrow 	: std_logic_vector(8 downto 0) := "101110100"; -- 0x74 extended
	constant kbd_up_arrow 		: std_logic_vector(8 downto 0) := "101110101"; -- 0x75 extended
	constant kbd_down_arrow 	: std_logic_vector(8 downto 0) := "101110010"; -- 0x72 extended
	constant kbd_dot    			: std_logic_vector(8 downto 0) := "001001001"; -- 0x49
	constant kbd_comma 			: std_logic_vector(8 downto 0) := "001000001"; -- 0x41
	constant kbd_slash 			: std_logic_vector(8 downto 0) := "001001010"; -- 0x4A
	
	constant kbd_A_key	: std_logic_vector(8 downto 0) := "000011100"; -- 0x1C
	constant kbd_D_key	: std_logic_vector(8 downto 0) := "000100011"; -- 0x23
	constant kbd_W_key	: std_logic_vector(8 downto 0) := "000011101"; -- 0x1D
	constant kbd_S_key 	: std_logic_vector(8 downto 0) := "000011011"; -- 0x1B
	constant kbd_V_key	: std_logic_vector(8 downto 0) := "000101010"; -- 0x2A
	constant kbd_C_key	: std_logic_vector(8 downto 0) := "000100001"; -- 0x21
	constant kbd_B_key	: std_logic_vector(8 downto 0) := "000110010"; -- 0x32
	
	constant kbd_P_key 	: std_logic_vector(8 downto 0) := "001001101"; -- 0x4D
	constant kbd_R_key	: std_logic_vector(8 downto 0) := "000101101"; -- 0x2D
---------------------------------------------------------------------
-- Menu defines --------------------------------------------
	constant start_sel		: integer := 0;
	constant match_sel		: integer := 1;
	constant ctrls_sel		: integer := 2;
	constant show_ctrls_sel	: integer := 3;
	
	constant min_selection	: integer := 1;
	constant max_selection	: integer := 2;
	
	constant menu_background	: std_logic := '0';
	constant arena_background	: std_logic := '1';
	
---------------------------------------------------------------------
-- Player logic defines --------------------------------------------
	constant player_action_none			: std_logic_vector(2 downto 0) := "000";
	constant player_action_move_left		: std_logic_vector(2 downto 0) := "001";
	constant player_action_move_right	: std_logic_vector(2 downto 0) := "010";
	constant player_action_jump			: std_logic_vector(2 downto 0) := "011";
	constant player_action_duck			: std_logic_vector(2 downto 0) := "100";
	constant player_action_fireball		: std_logic_vector(2 downto 0) := "101";
	constant player_action_kick			: std_logic_vector(2 downto 0) := "110";
	constant player_action_punch			: std_logic_vector(2 downto 0) := "111";

	constant player_direction_left_to_right : std_logic := '0';
	constant player_direction_right_to_left : std_logic := '1';
	
	--constant player_step_wid 	: integer := 6;
	--constant player_duck_size	: integer := 10;
	
	constant player_state_idle			: std_logic_vector(2 downto 0) := "000";
	constant player_state_move_left	: std_logic_vector(2 downto 0) := "001";
	constant player_state_move_right	: std_logic_vector(2 downto 0) := "010";
	constant player_state_duck			: std_logic_vector(2 downto 0) := "100";
	constant player_state_shoot		: std_logic_vector(2 downto 0) := "101";
	constant player_state_kick			: std_logic_vector(2 downto 0) := "110";
	constant player_state_punch		: std_logic_vector(2 downto 0) := "111";

	constant player_length_t : integer := 100; -- most likely won't need when we'll start to work with bitmaps
	constant player_width_t  : integer := 40; -- most likely won't need when we'll start to work with bitmaps
	
	constant player_StartX : integer := player_width_t + 20;   -- starting point
	constant player_StartY : integer := y_frame - player_length_t;	
	
	--type player_state is (idle, jumping, ducking);
	--type player_action is (none, move_left, move_right, jump, duck, fireball);
	--type player_direction is (left_to_right, right_to_left); -- TODO: decide if needed and replace constants
-----------------------------------------------------------------------
-- Player renderer defines-------------------------------------------
	
	--constant object_X_size : integer := 26;
	--constant object_Y_size : integer := 26;
	--constant R_high		: integer := 7;
	--constant R_low		: integer := 5;
	--constant G_high		: integer := 4;
	--constant G_low		: integer := 2;
	--constant B_high		: integer := 1;
	--constant B_low		: integer := 0;

	--constant ps_idle			: std_logic_vector(2 downto 0) := "000";
	--constant ps_move_left	: std_logic_vector(2 downto 0) := "001";
	--constant ps_move_right	: std_logic_vector(2 downto 0) := "010";
	--constant ps_jump			: std_logic_vector(2 downto 0) := "011";
	--constant ps_duck			: std_logic_vector(2 downto 0) := "100";
	--constant ps_shoot			: std_logic_vector(2 downto 0) := "101";

-----------------------------------------------------------------------
-- Special attack movement defines-------------------------------------
	--type special_attack_state is (idle, ongoing);
-----------------------------------------------------------------------



end STREET_FIGHTER_PCKG;