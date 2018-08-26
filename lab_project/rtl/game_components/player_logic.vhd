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


begin


		process ( RESETn,CLK)
			variable ObjectStartX_t : integer;
			variable ObjectStartY_t : integer;
		
		begin
			if RESETn = '0' then
				ObjectStartX_t	:= StartX;
				ObjectStartY_t	:= StartY ;
			
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