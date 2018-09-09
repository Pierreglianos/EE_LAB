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
		
		pause_game		: in std_logic;
		resume_game		: in std_logic;
		
		player1_hit				: in std_logic;
		player1_fireball_hit	: in std_logic;
		player1_state			: in std_logic_vector(2 downto 0);
		
		player2_hit				: in std_logic;
		player2_fireball_hit	: in std_logic;
		player2_state			: in std_logic_vector(2 downto 0);		
		
		game_on 			: out std_logic;
		------
		player1_health	: out integer range 0 to 150;
		player2_health	: out	integer range 0 to 150;
		-------
		game_enable		: out std_logic;
		is_game_over	: out std_logic;
		reset_gameN		: out std_logic
		
		-- A lot of enable/reset signals for different entities
	);
end game_manager;

architecture behav of game_manager is 

type game_state is (idle, ongoing, paused, game_over);

begin

	process (RESETn, CLK)
	variable present_state		: game_state;
	variable current_health1	: integer;
	variable current_health2	: integer;
	variable p1_was_hit			: std_logic;
	variable p2_was_hit			: std_logic;

	
	begin
		
		reset_gameN		<= '1';

		if (RESETn = '0') then
			current_health1 := 150;
			current_health2 := 150;
			-- TODO init to idle
			present_state 	:= ongoing;
			game_enable 	<= '0';
			is_game_over 	<= '0';
			reset_gameN		<= '0';
			p1_was_hit		:= '0';
			p2_was_hit		:= '0';
			
		elsif (rising_edge(CLK)) then
			
			case present_state is
			--when idle =>
			
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
					
					if (current_health1 <=0) then
						current_health1 := 0;
						present_state   := game_over;
					end if;
				
					if (current_health2 <= 0) then
						current_health2 := 0;
						present_state   := game_over;
					end if;
				end if;	
				
			when paused =>
				if resume_game = '1' then
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
	end process;

end behav;

			
			
			
			
			
			
			
			
	

