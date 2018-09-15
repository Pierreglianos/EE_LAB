library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lab_project;
use lab_project.STREET_FIGHTER_PCKG.all;


entity objects_mux is
port 	(
		CLK	: in std_logic; --						//	27 MHz
		RESETn : in std_logic;

		background_selector		: in std_logic;
		static_menu_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- background  input signal
		main_menu_mVGA_RGB 		: in std_logic_vector(7 downto 0);
		arena_mVGA_RGB		 		: in std_logic_vector(7 downto 0);
		
		
		player1_drawing_request : in std_logic;
		player1_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, player 1 input signal 
		
		player2_drawing_request : in std_logic;
		player2_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, player 1 input signal 
		
		fireball1_drawing_request : in std_logic;	 
		fireball1_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  fireball 1 input signal 
		
		fireball2_drawing_request : in std_logic;	 
		fireball2_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  fireball 2 input signal 
		
		life_bar_drawing_request : in std_logic;	 
		life_bar_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  life bar input signal 
		
		m_mVGA_R 	: out std_logic_vector(7 downto 0);  
		m_mVGA_G 	: out std_logic_vector(7 downto 0); 
		m_mVGA_B 	: out std_logic_vector(7 downto 0) 

	);
end objects_mux;

architecture behav of objects_mux is 
signal m_mVGA_t 	: std_logic_vector(7 downto 0); --	,  

begin

-- priority encoder process

process ( RESETn, CLK)
begin 
	if RESETn = '0' then
			m_mVGA_t	<=  (others => '0') ; 	

	elsif rising_edge(CLK) then
		if (fireball2_drawing_request = '1' ) then  
			m_mVGA_t <= fireball2_mVGA_RGB;  
		elsif (fireball1_drawing_request = '1' ) then  
			m_mVGA_t <= fireball1_mVGA_RGB;  
		elsif (player2_drawing_request = '1' ) then  
			m_mVGA_t <= player2_mVGA_RGB;  
		elsif (player1_drawing_request = '1' ) then  
			m_mVGA_t <= player1_mVGA_RGB;
		elsif (life_bar_drawing_request = '1') then
			m_mVGA_t <= life_bar_mVGA_RGB ;
		else
			case background_selector is
			when menu_background =>
				if (main_menu_mVGA_RGB = x"00") then
					m_mVGA_t <= static_menu_mVGA_RGB ;
				else
					m_mVGA_t <= main_menu_mVGA_RGB ;
				end if;
				
			when arena_background =>
				m_mVGA_t <= arena_mVGA_RGB ;
			when others =>
				m_mVGA_t <= (others => '0');
			end case;
		end if; 
	end if ; 

end process ;

m_mVGA_R	<= m_mVGA_t(7 downto 5) & "00000"; -- expand to 10 bits 
m_mVGA_G	<= m_mVGA_t(4 downto 2) & "00000";
m_mVGA_B	<= m_mVGA_t(1 downto 0) & "000000";


end behav;