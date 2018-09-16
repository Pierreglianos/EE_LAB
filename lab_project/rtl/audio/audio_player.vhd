LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY audio_player IS
	PORT
	(
		CLK			: in std_logic;
		resetN		: in std_logic;
		one_sec		: in std_logic;
		
		game_state	: in std_logic_vector(2 downto 0);
		
		div1 			: in std_logic_vector(15 downto 0);
		div2 			: in std_logic_vector(15 downto 0);
		div3 			: in std_logic_vector(15 downto 0);
		div4 			: in std_logic_vector(15 downto 0);
		div5 			: in std_logic_vector(15 downto 0);
		div6 			: in std_logic_vector(15 downto 0);
		--player1/2 hit, win..

		play_sound	: out std_logic;
		divider		: out std_logic_vector (15 downto 0)
	);
END audio_player;


ARCHITECTURE behav OF audio_player IS
	
--	constant div1 : std_logic_vector(15 downto 0) := X"FF02";
--	constant div2 : std_logic_vector(15 downto 0) := X"FDE0";
--	constant div3 : std_logic_vector(15 downto 0) := X"FF08";
--	constant div4 : std_logic_vector(15 downto 0) := X"F800";
--	constant div5 : std_logic_vector(15 downto 0) := X"F900";
--	constant div6 : std_logic_vector(15 downto 0) := X"FAA0";
--	constant div7 : std_logic_vector(15 downto 0) := X"FDE1";


type state is (note1, note2, note3, note4, note5, note6, note7, note8);

	
begin
	
	process(CLK, resetN)
	variable present_state 	: state;
	variable curr_divider 	: std_logic_vector(15 downto 0);
	begin
		if resetN = '0' then
			curr_divider	:= div1;
			present_state	:= note1;
			play_sound		<= '1';
		elsif rising_edge(CLK) then
			play_sound	<= '1';
			if (one_sec = '1') then
				case present_state is
				when note1 =>
					present_state	:= note2;
					curr_divider 	:= div2;
				when note2 =>
					present_state	:= note3;
					curr_divider 	:= div3;
				when note3 =>
					present_state	:= note4;
					curr_divider	 := div4;
				when note4 =>
					present_state	:= note5;
					curr_divider 	:= div3;
				when note5 =>
					present_state	:= note6;
					curr_divider 	:= div4;
				when note6 =>
					present_state	:= note7;
					curr_divider	 := div5;
				when note7 =>
					present_state	:= note8;
					curr_divider	 := div6;
				when note8 =>
					present_state	:= note1;
					curr_divider	 := div1;
				end case;
			end if;
		end if;
		divider <= curr_divider;
	end process;
	

end behav;

--
--				if (curr_divider = div1) then
--					curr_divider := div2;
--				elsif (curr_divider = div2) then
--					curr_divider := div3;
--				elsif (curr_divider = div3) then
--					curr_divider := div4;
--				elsif (curr_divider = div4) then
--					curr_divider := div5;
--				elsif (curr_divider = div5) then
--					curr_divider := div6;
--				elsif (curr_divider = div6) then
--					curr_divider := div7;
--				elsif (curr_divider = div7) then
--					curr_divider := div1;
--				else
--					curr_divider := div1;
--				end if;
--			