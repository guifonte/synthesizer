-------------------------------------------
-- Block code:  sync_block.vhd
-- History: 	15.Nov.2017 - 1st version (dqtm)
--				15.Jan.2018 - adapt reset value for usage in mini-project (dqtm)
--				01.Mar.2018 - rename in English (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: edge detector with rise & fall outputs. 
--           Declaring FFs as a shift-register.
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY sync_block IS
  PORT( 
		async_i 	: IN    std_logic;
		clk		: IN    std_logic;
		syncd_o	: OUT		std_logic 
    	);
END sync_block;


ARCHITECTURE rtl OF sync_block IS
	-- Signals & Constants Declaration 
	SIGNAL shiftreg, next_shiftreg: std_logic_vector(2 downto 0);

BEGIN 
    -------------------------------------------
    -- Process for combinatorial logic
	-- OBs.: small logic, could be outside process, 
	--       but doing inside for didactical purposes!
    -------------------------------------------
	comb_proc : PROCESS(async_i, shiftreg)
	BEGIN	
		next_shiftreg <= data_in & shiftreg(2 downto 1) ;  -- shift direction towards LSB		
	END PROCESS comb_proc;		
	 
	-------------------------------------------
    -- Process for registers (flip-flops)
    -------------------------------------------
	reg_proc : PROCESS(clk)
	BEGIN	
		IF (rising_edge(clock)) THEN
			shiftreg <= next_shiftreg;
		END IF;
	END PROCESS reg_proc;	
	 
	-------------------------------------------
    -- Concurrent Assignments  
	-- OBs.: no logic after the 1st-FF (shiftreg(2)) because it was added for sync purposes
    -------------------------------------------
	data_out	<= 	   shiftreg(1) ; 	-- take serial_in at same period as fall/rise pulse
			
END rtl;	