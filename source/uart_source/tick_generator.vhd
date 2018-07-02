-------------------------------------------
-- Block code:  tick_generator.vhd
-- History: 	13.Mar.2018 - 1st version (nishiratavo)
--                 <date> - <changes>  (<author>)
-- Function: Generates baud rate. 
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
ENTITY tick_generator IS
GENERIC (width : positive := 12);
	PORT (  
		enable  : IN    std_logic;
		clk     : IN    std_logic;
		tick    : OUT   std_logic
	);
END tick_generator;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF tick_generator IS
	
SIGNAL 		half_count			: 	unsigned(width-1 downto 0);--:= to_unsigned(800,width);
SIGNAL		next_half_count	:	unsigned(width-1 downto 0);--:= to_unsigned(0,width);
SIGNAL 		count					: 	unsigned(width-1 downto 0);--:= to_unsigned(0,width);
SIGNAL		next_count			:	unsigned(width-1 downto 0);--:= to_unsigned(0,width);
SIGNAL		half_period			: 	std_logic:= '0';
SIGNAL		clk_out				: 	std_logic:= '0';


-- Begin Architecture
-------------------------------------------
BEGIN


  --------------------------------------------------
  -- PROCESS FOR HALF PERIOD
  --------------------------------------------------
  half_period_logic: PROCESS(enable,half_count, next_half_count, half_period)
  BEGIN	
	-- load	
	IF (enable = '1') AND (half_count > 0 ) AND (half_period = '0') THEN 
		next_half_count <= half_count - 1;
		half_period <= '0';

  	ELSIF (enable = '1') AND (half_count = 0) THEN
  		next_half_count <= to_unsigned(0,width);
  		half_period <= '1';

  	ELSE
  		next_half_count <= to_unsigned(0,width);
  		half_period <= '0';

  	END IF;
	
  END PROCESS half_period_logic;   

  --------------------------------------------------
  -- PROCESS FOR FULL PERIOD
  --------------------------------------------------
  full_period_logic: PROCESS(half_period, count, next_count, clk_out, enable)
  BEGIN

  	IF(half_period = '1') AND (count = 0) THEN
  		next_count <= count + 1;
  		clk_out <= '1';

  	ELSIF (count < 399) AND (half_period = '1') THEN
  		clk_out <= '0';
  		next_count <= count + 1;

  	--ELSIF (count > 3199) AND (half_period = '1') THEN
  	--	clk_out <= '0';
  	--	next_count <= to_unsigned(0,width);

  	ELSE
  		clk_out <= '0';
  		next_count <= to_unsigned(0,width);

  	END IF;

  END PROCESS full_period_logic;
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk, enable)
  BEGIN	
  	IF enable = '0' THEN
  		count <= to_unsigned(0,width);
  		half_count <= to_unsigned(200,width);

    ELSIF rising_edge(clk) THEN
		half_count <= next_half_count;
		count <= next_count;
    END IF;
  END PROCESS flip_flops;		
  
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
   tick <= clk_out;
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;
	