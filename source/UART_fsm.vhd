-------------------------------------------
-- Block code:  fsm_example.vhd
-- History: 	23.Nov.2017 - 1st version (dqtm)
--                   <date> - <changes>  (<author>)
-- Function: fsm_example using enumerated type declaration. 
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY fsm IS
	PORT (
		clk,reset_n : 	   	IN std_logic;
		tick, fall :        IN std_logic;
		tick_halfsize :       OUT std_logic;
		tick_activator:			OUT std_logic
	);
END fsm;


ARCHITECTURE rtl OF fsm IS
	TYPE t_state IS (begining, not_begining, receiving);		-- declaration of new datatype
	SIGNAL s_state :  t_state; -- 2 signals of the new datatype
	SIGNAL s_nextstate :  t_state := not_begining;
	SIGNAL count, next_count : unsigned(3 downto 0); -- bitcounter (message = 10 bits)

BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------
  --State machine devided in 2 states: bening and not beginin
  --when bening tells the counter to count only 10 counts
  --else tells the counter to count 20 counts
  --count tells in which bit the message is 
  --if count = 0 no message has been sent, if count = 11, the message is over
  fsm_drive : PROCESS (s_state, tick, fall, count)
  BEGIN
	s_nextstate <= s_state;
	next_count <= count;
  	
	CASE s_state IS

  		WHEN not_begining => 
		
        -- to begin a message
  			IF (fall='1') THEN
    			s_nextstate <= begining ;
    			next_count <= to_unsigned(0,4);
			
			END IF;
			
		WHEN begining => 
			
			IF (tick='1') THEN
				s_nextstate <= receiving ;
    			next_count <= count + 1;
			END IF;
		

  		WHEN receiving =>
		
			--receiving the message
			IF (tick = '1') AND (count <= 10) THEN
				next_count <= count + 1;
				
			--if the message is already sent
			ELSIF (tick = '1') AND (count > 10) THEN 
				s_nextstate <= not_begining;
			
			END IF;

  		WHEN OTHERS => 
			s_nextstate <= s_state;
			next_count <= count;
  	END CASE;
  END PROCESS fsm_drive;
 
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops :PROCESS (clk, reset_n)
  BEGIN
  	
	IF (reset_n = '0') THEN
  		s_state <= not_begining;
		count <= to_unsigned(0,4);
  	
	ELSIF rising_edge(clk) THEN
		s_state <= s_nextstate;
		count <= next_count;
  	END IF;
  END PROCESS flip_flops;
  
  --------------------------------------------------
  -- PROCESS FOR OUTPUTS
  --------------------------------------------------
  outputs : PROCESS (s_state)
  BEGIN
  
  	CASE s_state IS

  		WHEN not_begining => 
		
			tick_activator <= '0';
			tick_halfsize <= '0';
		
			
		WHEN begining => 
			tick_activator <= '1';
			tick_halfsize <= '1';
			

  		WHEN receiving =>
			tick_activator <= '1';
			tick_halfsize <= '0';
			

  		WHEN OTHERS => 
			tick_activator <= '0';
			tick_halfsize <= '0';
  	END CASE;
  END PROCESS outputs;
  
END rtl;