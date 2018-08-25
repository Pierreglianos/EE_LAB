library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun Apr 2017
-- Dudy Nov 13 2017

entity objects_mux is
port 	(
		CLK	: in std_logic; --						//	27 MHz
		
		background_drawing_request : in std_logic;
		background_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- background  input signal 
		
		player1_drawing_request : in std_logic;
		player1_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, player 1 input signal 
		
		player2_drawing_request : in std_logic;
		player2_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, player 1 input signal 
		
		fireball1_drawing_request : in std_logic;	 
		fireball1_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  fireball 1 input signal 
		
		fireball2_drawing_request : in std_logic;	 
		fireball2_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  fireball 2 input signal 
		
		m_mVGA_R 	: out std_logic_vector(7 downto 0); --	,  
		m_mVGA_G 	: out std_logic_vector(7 downto 0); --	, 
		m_mVGA_B 	: out std_logic_vector(7 downto 0); --	, 
		RESETn : in std_logic

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
			m_mVGA_t <= fireball2__mVGA_RGB;  
		elsif (fireball1_drawing_request = '1' ) then  
			m_mVGA_t <= fireball2__mVGA_RGB;  
		elsif (player2_drawing_request = '1' ) then  
			m_mVGA_t <= player2__mVGA_RGB;  
		elsif (player1_drawing_request = '1' ) then  
			m_mVGA_t <= player1__mVGA_RGB;
		elsif(background_drawing_request = '1' )
			m_mVGA_t <= background_mVGA_RGB ;
		else 
			m_mVGA_t	<=  (others => '0') ; 
		end if; 
	end if ; 

end process ;

m_mVGA_R	<= m_mVGA_t(7 downto 5) & "00000"; -- expand to 10 bits 
m_mVGA_G	<= m_mVGA_t(4 downto 2) & "00000";
m_mVGA_B	<= m_mVGA_t(1 downto 0) & "000000";


end behav;