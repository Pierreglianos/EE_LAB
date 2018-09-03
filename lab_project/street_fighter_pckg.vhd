library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

package STREET_FIGHTER_PCKG is 

-- VGA defines------------------------------------------------------
	constant	x_frame	: integer :=	640;
	constant	y_frame	: integer :=	480;
--------------------------------------------------------------------
-- KBD constants----------------------------------------------------
	constant kbd_left_arrow  	: std_logic_vector(8 downto 0) := "101101011"; -- 0x6B extended
	constant kbd_right_arrow 	: std_logic_vector(8 downto 0) := "101110100"; -- 0x74 extended
	constant kbd_up_arrow 		: std_logic_vector(8 downto 0) := "101110101"; -- 0x75 extended
	constant kbd_down_arrow 	: std_logic_vector(8 downto 0) := "101110010"; -- 0x72 extended
	constant kbd_dot    			: std_logic_vector(8 downto 0) := "001001001"; -- 0x49
	
	constant kbd_A_key	: std_logic_vector(8 downto 0) := "000011100"; -- 0x1C
	constant kbd_D_key	: std_logic_vector(8 downto 0) := "000100011"; -- 0x23
	constant kbd_W_key	: std_logic_vector(8 downto 0) := "000011101"; -- 0x1D
	constant kbd_S_key 	: std_logic_vector(8 downto 0) := "000011011"; -- 0x1B
	constant kbd_V_key	: std_logic_vector(8 downto 0) := "000101010"; -- 0x2A
---------------------------------------------------------------------
-- Player logic defines --------------------------------------------
	constant player_action_none			: std_logic_vector(2 downto 0) := "000";
	constant player_action_move_left		: std_logic_vector(2 downto 0) := "001";
	constant player_action_move_right	: std_logic_vector(2 downto 0) := "010";
	constant player_action_jump			: std_logic_vector(2 downto 0) := "011";
	constant player_action_duck			: std_logic_vector(2 downto 0) := "100";
	constant player_action_fireball		: std_logic_vector(2 downto 0) := "101";

	constant player_direction_left_to_right : std_logic := '0';
	constant player_direction_right_to_left : std_logic := '1';
	
	--constant player_step_wid 	: integer := 6;
	--constant player_duck_size	: integer := 10;
	
	constant player_state_idle			: std_logic_vector(2 downto 0) := "000";
	constant player_state_move_left	: std_logic_vector(2 downto 0) := "001";
	constant player_state_move_right	: std_logic_vector(2 downto 0) := "010";
	constant player_state_jump			: std_logic_vector(2 downto 0) := "011";
	constant player_state_duck			: std_logic_vector(2 downto 0) := "100";
	constant player_state_shoot		: std_logic_vector(2 downto 0) := "101";

	constant player_length_t : integer := 26; -- most likely won't need when we'll start to work with bitmaps
	constant player_width_t  : integer := 26; -- most likely won't need when we'll start to work with bitmaps
	
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