LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Calc is
	PORT(A		:in std_logic_vector(3 downto 0);
		B		:in std_logic_vector(3 downto 0);
		reg_out	:out std_logic_vector(7 downto 0);
		add		:in STD_LOGIC;
		reset	:in std_logic;
		AC		:in std_logic;
		clock	:in std_logic);
end Calc;

architecture Behavioral of Calc is
	type state_type is (s1, s2, s3);
	signal y: state_type;
	signal A_8bit, B_8bit, sum: std_logic_vector(7 downto 0);
	signal clear, load: std_logic;
	
	component reg
		Port(clear	:in STD_logic;
			load	:in STD_LOGIC;
			clock	:in STD_logic;
			reset	:in std_logic;
			data_in	:in std_logic_vector(7 downto 0);
			data_out:out std_logic_vector(7 downto 0));
	end component;

	begin

	-- Part 1: control circuit --

	-- specify state transitions
	FSM_transitions:process(reset,clock)
	begin
		if reset = '1' then
			y <= s1;
		ELSIF(clock'EVENT AND clock = '1') then
			CASE y is
				WHEN s1 =>
					if ac = '1' then
						y <= s1;
					elsif ac = '0' and add = '1' then
						y <= s2;
					else
						y <= s3;
					end if;
				WHEN s2 =>
					if ac = '1' then
						y <= s1;
					elsif ac = '0' and add = '1' then 
						y <= s2;
					else
						y <= s3;
					end if;
				WHEN s3 =>
					if ac = '1' then
						y <= s1;
					elsif ac = '0' then
						if add = '1' then
							y <= s2;
						else
							y <= s3;
						end if;
					end if;
			end case;
		end if;
	end process;
	
	-- specify state actions
	FSM_actions: process(y)
	begin
		CASE y is
			WHEN s1 =>
				clear <= '1'; load <= '0';
			WHEN s2 =>
				clear <= '0'; load <= '1';
			WHEN s3 =>
				clear <= '0'; load <= '0';
		END CASE;
	end process;

	 -- Part 2: datapath circuit
	 
	 -- pad A and B to 8 bits
	 A_8bit <= "0000" & A;
	 B_8bit <= "0000" & B;
	 
	 -- adder
	 sum <= A_8bit + B_8bit;
	 
	 -- register
	 register1: reg PORT MAP (clear, load, clock, reset, sum, reg_out);
	 
end Behavioral;