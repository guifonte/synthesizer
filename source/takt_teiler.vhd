-------------------------------------------
-- Block code:  takt_teiler.vhd
-- History: 	14.Nov.2012 - 1st version (dqtm)
--             15.Mar.2018 - change duty cycle from 50% to 1/80. (guifonte)
--					04.Abr.2018	- remove reset button
--									- change duty cycle to 1/4
--               <date> - <changes>  (<author>)
-- Function: modulo divider with generic width. Output MSB with 1/80 duty cycle.
--		Can be used for clock-divider when no exact ratio required.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
ENTITY takt_teiler IS
GENERIC (width		: positive  := 3 );
  PORT(
		clk_fast_i		: IN    std_logic;
		clk_slow_o     : OUT   std_logic
    	);
END takt_teiler;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF takt_teiler IS
-- Signals & Constants Declaration?
-------------------------------------------
signal count, next_count: unsigned(width-1 downto 0):= (OTHERS =>'0');	 -- exception only for simu

-- Begin Architecture
-------------------------------------------
BEGIN


	
  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(count)
  BEGIN
	
	IF count = 0 THEN
		next_count <= to_unsigned(4,width);
	ElSE
		-- decrement
		next_count <= count - 1 ;
	END IF;
  END PROCESS comb_logic;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk_fast_i,next_count)
  BEGIN	
    IF rising_edge(clk_fast_i) THEN
		count <= next_count;
    END IF;
  END PROCESS flip_flops;		
  
  --------------------------------------------------
  -- PROCESS FOR FINAL COMBINATORIAL LOGIC
  --------------------------------------------------
  final_logic: PROCESS(count)
  BEGIN	
	IF count = 0 THEN
	clk_slow_o <= '1';
	ElSE
	clk_slow_o <= '0';
	END IF;
  END PROCESS final_logic; 
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;