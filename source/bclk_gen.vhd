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
ENTITY bclk_gen IS
GENERIC (width		: positive  := 3 );
  PORT(
    reset_n     : IN    std_logic;
		clk_12M_i		: IN    std_logic;
		bclk_o      : OUT   std_logic
    	);
END bclk_gen;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF bclk_gen IS

-- Define Signals 
signal count, next_count: std_logic;

-- Begin Architecture
-------------------------------------------
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(count)
  BEGIN
      next_count <= not(count);
  END PROCESS comb_logic;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk_fast_i,next_count)
  BEGIN	
    if (reset_n = '0') then
    count <= 0;
    elsif rising_edge(clk_fast_i) then
		count <= next_count;
    end if;
  END PROCESS flip_flops;		
  
  --------------------------------------------------
  -- PROCESS FOR FINAL COMBINATORIAL LOGIC
  --------------------------------------------------
  final_logic: PROCESS(count)
  BEGIN	
	bclk_o = count;
  END PROCESS final_logic; 
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;