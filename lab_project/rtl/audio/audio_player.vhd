LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY audio_player IS
	PORT
	(
		CLK			: in std_logic;
		resetN		: in std_logic;
		one_sec		: in std_logic;
		
		game_state	: in std_logic_vector(2 downto 0);
		
		--player1/2 hit, win..

		play_sound	: out std_logic;
		divider		: out std_logic_vector (15 downto 0)
	);
END audio_player;


ARCHITECTURE behav OF audio_player IS
	
	constant div1 : std_logic_vector(15 downto 0) := X"FF02";
	constant div2 : std_logic_vector(15 downto 0) := X"FDE0";
	constant div3 : std_logic_vector(15 downto 0) := X"FF08";
	constant div4 : std_logic_vector(15 downto 0) := X"F800";
	constant div5 : std_logic_vector(15 downto 0) := X"F900";
	constant div6 : std_logic_vector(15 downto 0) := X"FDE1";

	
begin
	
	process(CLK, resetN)
	
	variable curr_divider : std_logic_vector(15 downto 0);
	begin
		if resetN = '0' then
			curr_divider	:= (others => '0');
			play_sound		<= '0';
		elsif rising_edge(CLK) then
			play_sound	<= '1';
		
			case curr_divider is
			when div1 =>
				curr_divider := div2;
			when div2 =>
				curr_divider := div3;
			when div3 =>
				curr_divider := div4;
			when div4 =>
				curr_divider := div5;
			when div5 =>
				curr_divider := div6;
			when div6 =>
				curr_divider := div1;
			when others =>
				curr_divider := div1;
			end case;
		end if;
		divider <= curr_divider;
	end process;
	

end behav;