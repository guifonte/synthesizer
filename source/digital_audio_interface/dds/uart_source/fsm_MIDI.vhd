-------------------------------------------
-- Block code:  fsm_example.vhd
-- History: 	23.Nov.2017 - 1st version (dqtm)
--                   <date> - <changes>  (<author>)
-- Function: fsm_example using enumerated type declaration. 
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY fsm_midi IS
	PORT (
		clk, reset         : IN   std_logic;
		data, tick  : IN   std_logic;
		enable      : OUT  std_logic
		--start_bit   :	OUT  std_logic
	);
END fsm_midi;


ARCHITECTURE rtl OF fsm_midi IS
	TYPE t_state IS (s_null, s_data0, s_data1, s_data2, s_data3, s_data4, s_data5, s_data6, s_data7, s_wait, s_end);		-- declaration of new datatype
	SIGNAL s_state, s_nextstate :  t_state; -- 2 signals of the new datatype
	SIGNAL count, next_count : unsigned (1 downto 0) := to_unsigned(0,2);

BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------
  fsm_drive : PROCESS (s_state, data, tick, count, next_count)
  BEGIN
  	-- Default Statement
  	s_nextstate <= s_state;
  
  	CASE s_state IS
  		WHEN s_null => 
  			IF (data = '0') AND (tick = '0') THEN
  				s_nextstate <= s_null;
  				enable <= '1';
  				next_count <= to_unsigned(0,2);
  				--start_bit <= '1';
  			ELSIF (tick = '1') THEN
  				s_nextstate <= s_data0;
  				enable <= '1';
  				next_count <= to_unsigned(0,2);
			ELSE
				s_nextstate <= s_null;
				enable <= '0';
				next_count <= to_unsigned(0,2);
  			END IF;
  		WHEN s_data0 => 
  			IF (tick = '1') THEN
  				s_nextstate <= s_data1;
  				enable <= '1';
  				next_count <= to_unsigned(0,2);
  				--start_bit <= '1';
			ELSE
				s_nextstate <= s_data0;
				enable <= '1';
				next_count <= to_unsigned(0,2);
  			END IF;
  		WHEN s_data1 => 
  			IF (tick = '1') THEN
  				s_nextstate <= s_data2;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			ELSE
				s_nextstate <= s_data1;
				enable <= '1';
				next_count <= to_unsigned(0,2);
  			END IF;
  		WHEN s_data2 => 
  			IF (tick = '1') THEN
  				s_nextstate <= s_data3;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			ELSE
				s_nextstate <= s_data2;
				enable <= '1';
				next_count <= to_unsigned(0,2);
  			END IF;
  		WHEN s_data3 => 
  			IF (tick = '1') THEN
  				s_nextstate <= s_data4;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			ELSE
				s_nextstate <= s_data3;
				enable <= '1';
				next_count <= to_unsigned(0,2);
  			END IF;
		WHEN s_data4 => 
			IF (tick = '1') THEN
				s_nextstate <= s_data5;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			ELSE
				s_nextstate <= s_data4;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			END IF;
		WHEN s_data5 => 
			IF (tick = '1') THEN
				s_nextstate <= s_data6;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			ELSE
				s_nextstate <= s_data5;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			END IF;
		WHEN s_data6 => 
			IF (tick = '1') THEN
				s_nextstate <= s_data7;
				enable <= '1';
				next_count <= to_unsigned(0,2);
				ELSE
				s_nextstate <= s_data6;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			END IF;
		WHEN s_data7 => 
			IF (tick = '1') THEN
				s_nextstate <= s_wait;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			ELSE
				s_nextstate <= s_data7;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			END IF;
		WHEN s_wait => 
			IF (count < 2) THEN
				s_nextstate <= s_wait;
				enable <= '1';
				next_count <= count + 1;
			ELSIF (count = 2) THEN
				s_nextstate <= s_end;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			ELSE
				s_nextstate <= s_wait;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			END IF;
		WHEN s_end => 
			IF (tick = '1') THEN
				next_count <= count + 1;
				enable <= '1';
				s_nextstate <= s_end;
			ELSIF (count = 1) AND (data = '1') THEN

			--IF (tick = '1') AND (data = '1') THEN
				s_nextstate <= s_null;
				enable <= '0';
				next_count <= to_unsigned(0,2);
			ELSE
				s_nextstate <= s_end;
				enable <= '1';
				next_count <= to_unsigned(0,2);
			END IF;
		WHEN OTHERS =>
			s_nextstate <= s_null;
			enable <= '0';
			next_count <= to_unsigned(0,2);
  	END CASE;

  	--if (start_bit = '1') THEN
  	--	start_bit <= '0';
  	--END IF;

  END PROCESS fsm_drive;
 
 
 
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  PROCESS (clk, reset)
  BEGIN
  	IF (reset = '0') THEN
  		s_state <= s_null;
  		count <= to_unsigned(0,2);
    ELSIF rising_edge(clk) THEN
  	 	s_state <= s_nextstate;
  	 	count <= next_count;
    END IF;
  END PROCESS;
  
  END rtl;
