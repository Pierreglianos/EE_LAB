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

constant FireballFlipped_colors: FireballFlipped_color_array := (
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BB", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"37", x"57", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"37", x"5B", x"37", x"5B", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"FF", x"FF", x"FF", x"FF", x"97", x"73", x"DB", x"FF", x"DB", x"37", x"57", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"97", x"33", x"9B", x"FF", x"FF", x"97", x"73", x"97", x"73", x"DB", x"FF", x"BB", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"97", x"7B", x"5B", x"37", x"B7", x"DB", x"4F", x"BB", x"FF", x"73", x"93", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"97", x"9B", x"9F", x"BF", x"7B", x"37", x"97", x"53", x"3B", x"5B", x"53", x"77", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"7F", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"DF", x"5B", x"9F", x"9F", x"BF", x"BF", x"3B", x"1B", x"3B", x"9F", x"7B", x"3B", x"17", x"57", x"77", x"37", x"BF", x"DF", x"DF", x"DF", x"DF", x"5B", x"5B", x"7B", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"5B", x"7B", x"9F", x"9F", x"BF", x"DF", x"BF", x"9F", x"BF", x"BF", x"BF", x"9F", x"17", x"17", x"3B", x"3B", x"3B", x"3B", x"3B", x"37", x"7B", x"7B", x"7B", x"17", x"77", x"97", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"5B", x"5B", x"9B", x"9F", x"9F", x"BF", x"BF", x"BF", x"DF", x"DF", x"BF", x"DF", x"7B", x"3B", x"9F", x"9F", x"9F", x"BF", x"BF", x"9B", x"5B", x"5B", x"5B", x"77", x"BB", x"DF", x"DF", x"BF", x"9B", x"DF", x"FF", x"FF", x"FF"),
( x"FF", x"5B", x"1B", x"3B", x"5B", x"BF", x"DF", x"BF", x"BF", x"DF", x"DF", x"BF", x"DF", x"9F", x"3B", x"9F", x"9F", x"BF", x"DF", x"BF", x"BF", x"9F", x"9F", x"7B", x"9F", x"7B", x"3B", x"77", x"77", x"57", x"DF", x"FF", x"FF", x"FF"),
( x"FF", x"5B", x"1B", x"1B", x"1B", x"7B", x"BF", x"DF", x"BF", x"DF", x"DF", x"DF", x"DF", x"9F", x"1B", x"3B", x"3B", x"3B", x"3B", x"5B", x"3B", x"1B", x"3B", x"3B", x"3B", x"1B", x"17", x"17", x"17", x"3B", x"5B", x"5B", x"7B", x"FF"),
( x"FF", x"97", x"17", x"17", x"1B", x"1B", x"9F", x"BF", x"9F", x"BF", x"BF", x"9F", x"9F", x"7B", x"17", x"1B", x"17", x"17", x"1B", x"17", x"53", x"13", x"17", x"13", x"13", x"33", x"77", x"77", x"77", x"73", x"9B", x"DF", x"FF", x"FF"),
( x"FF", x"B7", x"53", x"17", x"1B", x"1B", x"9F", x"7B", x"1B", x"9F", x"BF", x"BF", x"7B", x"17", x"17", x"3B", x"77", x"77", x"57", x"57", x"57", x"57", x"37", x"97", x"97", x"97", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"BB", x"53", x"33", x"7B", x"9B", x"37", x"33", x"77", x"DB", x"FF", x"57", x"13", x"77", x"FF", x"BF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"B7", x"73", x"53", x"73", x"B7", x"B7", x"4F", x"B7", x"FF", x"73", x"73", x"DB", x"BF", x"7B", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"B7", x"73", x"BB", x"FF", x"DB", x"73", x"B7", x"FF", x"73", x"93", x"FF", x"DF", x"7B", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BB", x"72", x"73", x"93", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"37", x"BB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BB", x"93", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF")
);
constant FireballFlipped_bmp: FireballFlipped_bmp_array := (
("0000000000000000000000000000000000"),
("0000000000000001100000000000000000"),
("0000000000000011100000000000000000"),
("0000000000000111110000000000000000"),
("0000010000111011110000000000000000"),
("0000111001111101100000000000000000"),
("0001111111101100000000000000000000"),
("0011111111111100000000110000000000"),
("0111111111111111111111111000000000"),
("0111111111111111111111111110000000"),
("0111111111111111111111111111111000"),
("0111111111111111111111111111111000"),
("0111111111111111111111111111111110"),
("0111111111111111111111111111111100"),
("0111111111111111111111111110000000"),
("0011111111101110100000000000000000"),
("0001111111101111110000000000000000"),
("0000111011101101110000000000000000"),
("0000000001111000001110000000000000"),
("0000000000111000000000000000000000"),
("0000000000000000000000000000000000")
);

constant Fireball_X_size : integer := 34;
constant Fireball_Y_size : integer := 21;

type Fireball_color_array is array(0 to Fireball_Y_size - 1 , 0 to Fireball_X_size - 1) of std_logic_vector(7 downto 0);
type Fireball_bmp_array is array(0 to Fireball_Y_size - 1 , 0 to Fireball_X_size - 1) of std_logic;

constant Fireball_colors: Fireball_color_array := (
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"BB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"57", x"37", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"5B", x"3B", x"5B", x"37", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"77", x"37", x"DB", x"FF", x"DB", x"53", x"97", x"FF", x"FF", x"FF", x"FF", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"BB", x"FF", x"DB", x"73", x"97", x"73", x"97", x"FF", x"FF", x"9B", x"33", x"97", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"93", x"73", x"FF", x"BB", x"53", x"DB", x"B7", x"37", x"5B", x"7B", x"97", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"7B", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"77", x"53", x"5B", x"3B", x"53", x"97", x"37", x"7B", x"9F", x"9B", x"9B", x"97", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"7B", x"5B", x"5B", x"FF", x"DF", x"DF", x"DF", x"BF", x"37", x"77", x"57", x"17", x"3B", x"7B", x"9F", x"3B", x"1B", x"3B", x"BF", x"BF", x"9F", x"9F", x"5B", x"DF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"97", x"77", x"17", x"7B", x"7B", x"7B", x"37", x"3B", x"3B", x"3B", x"3B", x"3B", x"17", x"37", x"9F", x"BF", x"BF", x"BF", x"9F", x"BF", x"DF", x"BF", x"9F", x"9F", x"7B", x"5B", x"FF"),
( x"FF", x"FF", x"FF", x"DF", x"9B", x"BF", x"DF", x"DF", x"BB", x"77", x"5B", x"3B", x"5B", x"9F", x"BF", x"BF", x"9F", x"9F", x"9F", x"3B", x"7B", x"DF", x"BF", x"DF", x"DF", x"BF", x"BF", x"BF", x"9F", x"9F", x"9F", x"5B", x"5B", x"FF"),
( x"FF", x"FF", x"FF", x"DF", x"57", x"77", x"77", x"3B", x"7B", x"9F", x"7B", x"9F", x"9F", x"BF", x"DF", x"DF", x"BF", x"9F", x"9F", x"3B", x"9F", x"DF", x"BF", x"DF", x"DF", x"BF", x"BF", x"BF", x"BF", x"5B", x"3B", x"1B", x"5B", x"FF"),
( x"FF", x"7B", x"5B", x"5B", x"37", x"17", x"17", x"17", x"1B", x"3B", x"3B", x"3B", x"3B", x"3B", x"3B", x"3B", x"3B", x"3B", x"3B", x"1B", x"9F", x"DF", x"DF", x"DF", x"DF", x"BF", x"BF", x"BF", x"7B", x"1B", x"1B", x"1B", x"5B", x"FF"),
( x"FF", x"FF", x"DF", x"9B", x"73", x"77", x"77", x"77", x"33", x"13", x"17", x"17", x"13", x"53", x"17", x"1B", x"17", x"17", x"1B", x"17", x"7B", x"9F", x"9F", x"9F", x"BF", x"9F", x"BF", x"9F", x"1B", x"1B", x"17", x"17", x"97", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"93", x"93", x"77", x"57", x"57", x"57", x"57", x"57", x"77", x"77", x"3B", x"17", x"17", x"7B", x"BF", x"BF", x"9F", x"1B", x"7B", x"9F", x"3B", x"1B", x"17", x"53", x"B7", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BF", x"FF", x"77", x"13", x"57", x"FF", x"DB", x"57", x"33", x"37", x"9B", x"7B", x"33", x"53", x"B7", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BF", x"7B", x"BF", x"DB", x"73", x"73", x"FF", x"B7", x"4F", x"B7", x"BB", x"73", x"73", x"73", x"B7", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"7B", x"DF", x"FF", x"93", x"73", x"FF", x"B7", x"73", x"DB", x"FF", x"BB", x"73", x"B7", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BB", x"37", x"DF", x"FF", x"FF", x"FF", x"FF", x"FF", x"93", x"73", x"73", x"BB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DF", x"93", x"BB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF")
);
constant Fireball_bmp: Fireball_bmp_array := (
("0000000000000000000000000000000000"),
("0000000000000000011000000000000000"),
("0000000000000000011100000000000000"),
("0000000000000000111110000000000000"),
("0000000000000000111101110000100000"),
("0000000000000000011011111001110000"),
("0000000000000000000011011111111000"),
("0000000000110000000011111111111100"),
("0000000001110111111111111111111110"),
("0000000111111111111111111111111110"),
("0001111111111111111111111111111110"),
("0001111111111111111111111111111110"),
("0111111111111111111111111111111110"),
("0011111111111111111111111111111110"),
("0000000111111111111111111111111110"),
("0000000000000000010111011111111100"),
("0000000000000000111111011111111000"),
("0000000000000000111011011101110000"),
("0000000000000111000001111000000000"),
("0000000000000000000001110000000000"),
("0000000000000000000000000000000000")
);




begin

-- Calculate object end boundaries
	--objectEndX	<= Fireball_X_size + ObjectStartX;
	--objectEndY	<= Fireball_Y_size + ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 
	--drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectEndX) else '0';
   --drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) else '0';

-- calculate offset from start corner 
	--bCoord_X 	<= (oCoord_X - ObjectStartX) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	--bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 


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
	
		if(bCoord_X >= Fireball_X_size or bCoord_X < 0) then 
			mVGA_RGB	<= X"E0";
		else 
			mVGA_RGB	<= Fireball_colors(bCoord_Y, bCoord_X) ; 
		end if;
		drawing_request	<= enable and drawing_X and drawing_Y and Fireball_bmp(bCoord_Y, bCoord_X); -- get from mask table if inside rectangle  
	end if;

  end process;

		
end behav;		
		