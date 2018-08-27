library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity game_manager is
port 	(
		CLK				: in std_logic; --						//	50 MHz
		RESETn			: in std_logic; --
		timer_done		: in std_logic;
		
		valid				: in std_logic;
		action			: in std_logic_vector(2 downto 0);
		---
		
		player1_hit				: in std_logic;
		player1_fireball_hit	: in std_logic;
		player1_state			: in std_logic_vector(2 downto 0);
		
		player2_hit				: in std_logic;
		player2_fireball_hit	: in std_logic;
		player2_state			: in std_logic_vector(2 downto 0);		
		
		game_on 			: out std_logic;
		------
		player1_health	: out integer range 0 to 100;
		player2_health	: out	integer range 0 to 100
		-------
		
		-- A lot of enable/reset signals for different entities
	);
end game_manager;

architecture behav of game_manager is 

constant ps_idle			: std_logic_vector(2 downto 0) := "000";
constant ps_move_left	: std_logic_vector(2 downto 0) := "001";
constant ps_move_right	: std_logic_vector(2 downto 0) := "010";
constant ps_jump			: std_logic_vector(2 downto 0) := "011";
constant ps_duck			: std_logic_vector(2 downto 0) := "100";
constant ps_shoot			: std_logic_vector(2 downto 0) := "101";
constant ps_kick			: std_logic_vector(2 downto 0) := "110";
constant ps_punch			: std_logic_vector(2 downto 0) := "111";


type game_state is (idle, ongoing, paused, game_over);

begin

	process (RESETn, CLK)
	variable present_state : game_state;
	variable current_health1 : integer;
	variable current_health2 : integer;
	
	begin
	
		if (RESETn = '0') then
			current_health1 := 100;
			current_health2 := 100;
			present_state 	:= ongoing;
		
		elsif (rising_edge(CLK)) then
			
			case present_state is
			--when idle =>
			
			when ongoing =>
				if (player1_fireball_hit = '1') then
					current_health1 := current_health1 - 14;
				end if;
				
				if (player1_hit = '1') then
					case player2_state is
						when ps_kick =>
							current_health1 := current_health1 - 10;
						when ps_punch =>
							current_health1 := current_health1 - 8;
						when others =>
							current_health1 := current_health1;
					end case;
				end if;
				
				if (player2_fireball_hit = '1') then
					current_health2 := current_health2 - 14;
				end if;
				
				if (player2_hit = '1') then
					case player1_state is
						when ps_kick =>
							current_health2 := current_health1 - 10;
						when ps_punch =>
							current_health2 := current_health1 - 8;
						when others =>
							current_health2 := current_health1;
					end case;
				end if;
				
				if (current_health1 <=0) then
					current_health1 := 0;
					present_state   := game_over;
				end if;
				
				if (current_health2 <= 0) then
					current_health1 := 0;
					present_state   := game_over;
				end if;
						
			--when paused =>
			
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

			
			
			
			
			
			
			
			
	

