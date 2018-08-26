library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


-- action encode
-- "000":	none
--	"001":	move left
-- "010":	move right
-- "011":	jump
--	"100":	duck
--	"101":	fireball
--	"110":	special attack 1
--	"111":	special attack 2


entity player1_parser is
port 	(
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		enable			: in std_logic; -- 	//enable movement
		make				: in std_logic;
		break				: in std_logic;
		kbd_data			: in std_logic_vector(8 downto 0);
		valid				: out std_logic;
		action			: out std_logic_vector(2 downto 0)
	);
end player1_parser;

architecture behav of player1_parser is 

constant left_arrow  : std_logic_vector(8 downto 0) := "101101011"; -- 0x6B extended
constant right_arrow : std_logic_vector(8 downto 0) := "101110100"; -- 0x74 extended
constant up_arrow 	: std_logic_vector(8 downto 0) := "101110101"; -- 0x75 extended
constant down_arrow 	: std_logic_vector(8 downto 0) := "101110010"; -- 0x72 extended
constant dot    		: std_logic_vector(8 downto 0) := "001001001"; -- 0x49


constant none			: std_logic_vector(2 downto 0) := "000";
constant move_left	: std_logic_vector(2 downto 0) := "001";
constant move_right	: std_logic_vector(2 downto 0) := "010";
constant jump			: std_logic_vector(2 downto 0) := "011";
constant duck			: std_logic_vector(2 downto 0) := "100";
constant fireball		: std_logic_vector(2 downto 0) := "101";
--constant special_attack_1		: std_logic_vector(2 downto 0) := "110";
--constant special_attack_2		: std_logic_vector(2 downto 0) := "111";


begin

		process ( RESETn,CLK)
		variable tmp_action : std_logic_vector(2 downto 0) := none;

		begin
			if RESETn = '0' then
				tmp_action 	:= none;
				valid 		<= '0';
			
			elsif rising_edge(CLK) then
				if enable = '1'	then
					if make = '1' then
						valid <= '1';
						case kbd_data is
							when left_arrow =>
								tmp_action := move_left;
							
							when right_arrow =>
								tmp_action := move_right;
							
							when up_arrow =>
								tmp_action := jump;	
							
							when down_arrow =>
								tmp_action := duck;
							
							when dot =>
								tmp_action := fireball;
							
							when others =>
								tmp_action := none;
								
							end case;
						
					-- TODO make sure about this
					elsif break = '1' then
						valid <= '0';	
					end if;
					
				end if;
			end if;

			action <= tmp_action;
		end process ;
		

end behav;