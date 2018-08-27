library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity hit_manager is 
port (
		CLK	: in std_logic; --						//	27 MHz
		RESETn : in std_logic;
		
		background_drawing_request : in std_logic;
		player1_drawing_request : in std_logic;
		player2_drawing_request : in std_logic;
		fireball1_drawing_request : in std_logic;	 		
		fireball2_drawing_request : in std_logic;	 
		
		fireballs_hit : out std_logic;
		players_hit : out std_logic;
		
		player1_hit_by_fireball : out std_logic;
		player2_hit_by_fireball : out std_logic
);
end hit_manager;

architecture hit_manager_arch of hit_manager is 
-- signals
begin 

	process(CLK, RESETn)
	--variables
	begin 
		if(RESETn = '0') then 
			fireballs_hit <= '0';
			players_hit <= '0';
		
			player1_hit_by_fireball <= '0';
			player2_hit_by_fireball <= '0';
		
		elsif(rising_edge(CLK)) then 
		
			if ((fireball1_drawing_request = '1') and (fireball2_drawing_request = '1')) then
				fireballs_hit <= '1';
			else 
				fireballs_hit <= '0';
			end if;
			
			if ((player1_drawing_request = '1') and (player2_drawing_request = '1')) then
				players_hit <= '1';
			else 
				players_hit <= '0';
			end if;
			
			if ((player1_drawing_request = '1') and (fireball2_drawing_request = '1')) then
				player1_hit_by_fireball <= '1';
			else 
				player1_hit_by_fireball <= '0';
			end if;	
			
			if ((player2_drawing_request = '1') and (fireball1_drawing_request = '1')) then 
				player2_hit_by_fireball <= '1' ;
			else 
				player2_hit_by_fireball <= '0';
			end if;
			
			
		end if;
	end process;
end hit_manager_arch;