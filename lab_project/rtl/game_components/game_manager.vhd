library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;

entity game_manager is
port 	(
		CLK				: in std_logic; --						//	50 MHz
		RESETn			: in std_logic; --
		timer_done		: in std_logic;
		
		---
		
		down_arrow		: in std_logic;
		up_arrow			: in std_logic;
		pause_game		: in std_logic;
		r_key				: in std_logic;
		select_item		: in std_logic;
		
		
		player1_hit				: in std_logic;
		player1_fireball_hit	: in std_logic;
		player1_state			: in std_logic_vector(2 downto 0);
		
		player2_hit				: in std_logic;
		player2_fireball_hit	: in std_logic;
		player2_state			: in std_logic_vector(2 downto 0);		
		
		game_on 			: out std_logic;
		------
		player1_health	: out integer;
		player2_health	: out	integer;
		-------
		game_enable		: out std_logic;
		is_game_over	: out std_logic;
		game_resetN		: out std_logic;
		-------
		p1_figure		: out std_logic_vector(1 downto 0);
		p2_figure		: out std_logic_vector(1 downto 0);
		arena				: out std_logic_vector(1 downto 0);
		-------
		
		background_mux	: out std_logic_vector(2 downto 0);
		selector_pos	: out integer;
		
		backgroud_sel	: out std_logic
		
		
		
		
		-- A lot of enable/reset signals for different entities
	);
end game_manager;

architecture behav of game_manager is 

type game_state is (main_menu, game_config, show_ctrls, options, ongoing, paused, game_over);

constant min_selection : integer := 1;
constant max_selection : integer := 3;

begin

	process (RESETn, CLK)
	variable present_state		: game_state;
	variable current_health1	: integer;
	variable current_health2	: integer;
	variable p1_was_hit			: std_logic;
	variable p2_was_hit			: std_logic;
	variable selector				: integer;
	variable	ctrl_renderer_en	: std_logic;
	variable reset_game			: std_logic;		


	
	begin
		

		if (RESETn = '0') then
			current_health1 := 150;
			current_health2 := 150;
			p1_was_hit		:= '0';
			p2_was_hit		:= '0';
			selector			:= 1;
			reset_game := '1';
			-- TODO init to main_menu
			present_state 	:= main_menu;
			
			game_enable 	<= '0';
			is_game_over 	<= '0';
			game_resetN		<= '0';
			p1_figure		<= "00";
			p2_figure		<= "00";
			arena				<= "00";
			
			background_mux	<= "001";
			selector_pos	<= 1;
			
		elsif (rising_edge(CLK)) then
			reset_game := '1';
			
			case present_state is
			when main_menu =>
				background_mux	<= "001";
				
				if down_arrow = '1' then
					selector := selector + 1;
					if selector > max_selection then
						selector := max_selection;
					end if;
				end if;
				
				if up_arrow = '1' then
					selector := selector - 1;
					if selector < min_selection then
						selector := min_selection;
					end if;
				end if;
				
				if select_item = '1' then
					case selector is
					when 1 =>
						-- TODO change to game config and move this logic to there
						present_state	:= ongoing;
						reset_game		:= '0';
						selector 		:= 0;
						game_enable		<= '1';
						background_mux	<= "010";
						
					when 2 =>
						present_state 	:= show_ctrls;
						selector			:= 0;
						
					when 3 =>
						present_state	:= options;
						selector			:= 1;
					
					when others =>
						null;
					end case;
				end if;
				
			when show_ctrls =>
				if r_key = '1' then
					present_state 		:= main_menu;
					selector				:= 2;
				end if;
				
			when options =>
				if r_key = '1' then
					present_state	:= main_menu;
					selector 		:= 3;
				end if;
			
			when ongoing =>	
			
				if pause_game = '1' then
					present_state 	:= paused;
					game_enable 	<= '0';
				
				else
				
					if timer_done = '1' then
							p1_was_hit := '0';
							p2_was_hit := '0';
					end if;		
				
					if p1_was_hit = '0' then
						if (player1_fireball_hit = '1') then
							current_health1 := current_health1 - 14;
							p1_was_hit := '1';
						end if;
						
						if (player1_hit = '1') then
							case player2_state is
								when player_state_kick =>
									current_health1 := current_health1 - 10;
									p1_was_hit := '1';
								when player_state_punch =>
									current_health1 := current_health1 - 8;
									p1_was_hit := '1';
								when others =>
									current_health1 := current_health1;
							end case;
						end if;
					end if;
					
					if p2_was_hit = '0' then
						if (player2_fireball_hit = '1') then
							current_health2 := current_health2 - 14;
							p2_was_hit := '1';
						end if;
				
						if (player2_hit = '1') then
							case player1_state is
								when player_state_kick =>
									current_health2 := current_health2 - 10;
									p2_was_hit := '1';
								when player_state_punch =>
									current_health2 := current_health2 - 8;
									p2_was_hit := '1';
								when others =>
									current_health2 := current_health2;
							end case;
						end if;
					end if;
					
				end if;
				
				if (current_health1 <= 0) then
					current_health1 := 0;
					present_state   := game_over;
					is_game_over <= '1';
				end if;
				
				if (current_health2 <= 0) then
					current_health2 := 0;
					present_state   := game_over;
					is_game_over <= '1';
				end if;
				
			when paused =>
				if r_key = '1' then
					present_state 	:= ongoing;
					game_enable		<= '1';
				end if;
				
			--when game_over =>
			
			when others =>
				current_health1 := current_health1;
				current_health2 := current_health2;
			end case;
			
		end if;
		
		player1_health <=	current_health1;
		player2_health <=	current_health2;
		game_resetN		<= reset_game;
	end process;

end behav;

			
			
			
			
			
			
			
			
	

