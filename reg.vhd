LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY reg is
	PORT(clear	:IN STD_LOGIC;
		load	:IN STD_LOGIC;
		clock	:IN STD_LOGIC;
		reset	:IN STD_LOGIC;
		data_in	:IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_out:OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END reg;

ARCHITECTURE Behavioral OF reg is
begin
	PROCESS(clock, reset)
	begin
		IF reset = '1' then
			data_out <= (OTHERS => '0');
		ELSIF(Clock'EVENT AND Clock = '1') then
			IF clear = '1' then
				data_out <= (OTHERS => '0');
			ELSIF load = '1' then
				data_out <= data_in;
			END IF;
		END IF;
	END PROCESS;
END Behavioral;