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
		make				: in std_logic;
		break				: in std_logic;
		kbd_data			: in std_logic_vector(8 downto 0);
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end player_logic;

architecture behav of player_logic is 

constant left_arrow  : std_logic_vector(8 downto 0) := "101101011"; -- 0x6B extended
constant right_arrow : std_logic_vector(8 downto 0) := "101110100"; -- 0x74 extended

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
			
			-- !!!!!!!!!!!!!!!!!!!!!!!!!
			-- change to make = '1'
				if (enable = '1' and make = '0') then
					
					case kbd_data is
						when left_arrow =>
							ObjectStartX_t := ObjectStartX_t - step_wid;
							if ObjectStartX_t < 0 then
								ObjectStartX_t := 0;
							end if;
						when right_arrow =>
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