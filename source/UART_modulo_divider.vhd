-------------------------------------------
-- Block code:  modulo_divider.vhd
-- History: 	14.Nov.2012 - 1st version (dqtm)
--              15.Mar.2018 - change duty cycle from 50% to 1/80. (guifonte)
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
ENTITY modulo_divider IS
GENERIC (width		: positive  := 7 );
  PORT( clk,reset_n	: IN    std_logic;
    	clk_div     : OUT   std_logic
    	);
END modulo_divider;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF modulo_divider IS
-- Signals & Constants Declaration?
-------------------------------------------
signal count, next_count: unsigned(width-1 downto 0);	 

-- Begin Architecture
-------------------------------------------
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(count)
  BEGIN	
	IF count = 80 THEN
	next_count <= to_unsigned(0,width);
	ElSE	
	next_count <= count + 1 ;
	END IF;
  END PROCESS comb_logic;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk, reset_n)
  BEGIN	
  	IF reset_n = '0' THEN
		count <= to_unsigned(0,width);
    ELSIF rising_edge(clk) THEN
		count <= next_count ;
    END IF;
  END PROCESS flip_flops;		
   
	
  final_logic: PROCESS(count)
  BEGIN	
	IF (count >40) THEN
	clk_div <= '1';
	ElSE
	clk_div <= '0';
	END IF;
  END PROCESS final_logic;
	
 -- End Architecture 
------------------------------------------- 
END rtl;

