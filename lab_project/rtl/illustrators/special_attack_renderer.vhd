library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;

entity special_attack_renderer is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		ObjectStartX	: in integer;
		ObjectStartY 	: in integer;
		enable			: in std_logic;
		direction 		: in std_logic;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end special_attack_renderer;

architecture behav of special_attack_renderer is 

constant FireballFlipped_X_size : integer := 34;
constant FireballFlipped_Y_size : integer := 21;

type FireballFlipped_color_array is array(0 to FireballFlipped_Y_size - 1 , 0 to FireballFlipped_X_size - 1) of std_logic_vector(7 downto 0);
type FireballFlipped_bmp_array is array(0 to FireballFlipped_Y_size - 1 , 0 to FireballFlipped_X_size - 1) of std_logic;

constant Fireball_X_size : integer := 20;
constant Fireball_Y_size : integer := 13;

type Fireball_color_array is array(0 to Fireball_Y_size - 1 , 0 to Fireball_X_size - 1) of std_logic_vector(7 downto 0);
type Fireball_bmp_array is array(0 to Fireball_Y_size - 1 , 0 to Fireball_X_size - 1) of std_logic;

constant Fireball_colors: Fireball_color_array := (
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"5B", x"BB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BF", x"37", x"9B", x"DF", x"B7", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"DF", x"97", x"97", x"B7", x"DF", x"57", x"9B", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"BF", x"FF", x"FF", x"FF", x"FF", x"DB", x"77", x"7B", x"53", x"57", x"7B", x"9B", x"BB", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"DB", x"5B", x"5B", x"9B", x"9B", x"7B", x"57", x"37", x"5B", x"9F", x"5B", x"7B", x"BF", x"9F", x"7B", x"DF"),
( x"FF", x"FF", x"BB", x"BF", x"BB", x"77", x"5B", x"7B", x"9F", x"9F", x"9F", x"5B", x"9F", x"DF", x"BF", x"DF", x"BF", x"9F", x"5B", x"BF"),
( x"DF", x"9F", x"57", x"17", x"37", x"5B", x"5B", x"5B", x"7F", x"7B", x"5B", x"3B", x"DF", x"DF", x"DF", x"BF", x"9F", x"3B", x"1B", x"BF"),
( x"FF", x"DF", x"9B", x"97", x"77", x"33", x"17", x"17", x"17", x"17", x"17", x"17", x"7B", x"BF", x"9F", x"9F", x"5B", x"17", x"33", x"DB"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"DF", x"DF", x"DF", x"DB", x"BF", x"77", x"57", x"DF", x"57", x"57", x"7B", x"33", x"97", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"9F", x"DB", x"73", x"DB", x"93", x"DB", x"73", x"97", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"9B", x"DF", x"FF", x"FF", x"B7", x"93", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF")
);

constant Fireball_bmp: Fireball_bmp_array := (
("00000000000000000000"),
("00000000011100000000"),
("00000000011111000000"),
("00000000001111111100"),
("00000110000111111110"),
("00001111111111111111"),
("00111111111111111111"),
("11111111111111111111"),
("01111111111111111111"),
("00000111111111111110"),
("00000000011111111100"),
("00000000110011100000"),
("00000000000001000000")
);



begin
process ( RESETn, CLK)
	
  	variable  bCoord_X : integer := 0;-- offset from start position 
	variable  bCoord_Y : integer := 0;

	variable  drawing_X : std_logic := '0';
	variable  drawing_Y : std_logic := '0';

--		
	variable  objectEndX : integer;
	variable  objectEndY : integer;	
   
	begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;

	elsif rising_edge(CLK) then
		
		objectEndX	:= Fireball_X_size + ObjectStartX;
		objectEndY	:= Fireball_Y_size + ObjectStartY;
		
		if((oCoord_X  >= ObjectStartX) and  (oCoord_X < objectEndX)) then
			drawing_X	:= '1';
		else 
			drawing_X	:= '0';
		end if;
		
		if((oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY)) then 
			drawing_Y	:= '1';
		else 
			drawing_Y	:= '0';
		end if;

		if(drawing_X = '1' and  drawing_Y = '1' and direction = player_direction_right_to_left) then
			bCoord_X 	:= (ObjectEndX - oCoord_X);
		elsif(drawing_X = '1' and  drawing_Y = '1') then 
			bCoord_X 	:= (oCoord_X - ObjectStartX);
		else
			bCoord_X 	:= 0;
		end if;
		
		if( drawing_X = '1' and  drawing_Y = '1') then 
			bCoord_Y 	:= (oCoord_Y - ObjectStartY);
		else
			bCoord_Y 	:= 0;
		end if;
	
--		if(bCoord_X >= Fireball_X_size or bCoord_X < 0) then 
--			mVGA_RGB	<= X"E0";
--		else 
		mVGA_RGB	<= Fireball_colors(bCoord_Y, bCoord_X) ; 
--		end if;
		drawing_request	<= enable and drawing_X and drawing_Y and Fireball_bmp(bCoord_Y, bCoord_X); -- get from mask table if inside rectangle  
	end if;

  end process;

		
end behav;		
		