-------------------------------------------
-- Block code:  p2s_register.vhd
-- History: 	27.Apr.2018 - first version (felipe tanios)
--				
-- Function: paralel 16 bits to serial interface.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
ENTITY p2s_register IS
GENERIC (width		: positive  := 3 );
  PORT(
    	clk_12M, reset_n    : IN    std_logic;
		enable				: IN    std_logic;
		shift				: IN	std_logic;
		load				: IN	std_logic;
		par_i				: IN	std_logic_vector(15 downto 0);
		ser_o	      		: OUT   std_logic
    	);
END p2s_register;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF p2s_register IS

-- Define Signals and constants
-------------------------------------------
signal shiftreg, next_shiftreg	: std_logic_vector(15 downto 0);

-- Begin Architecture
-------------------------------------------
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(load, enable, shift, shiftreg, par_i)
  
  BEGIN
		next_shiftreg <= shiftreg;
		if (load = '1') then
      		next_shiftreg <= par_i;
  		elsif (enable = '1' and shift = '1') then
  			next_shiftreg <= shiftreg(14 downto 0) & '1';
  		end if;

  END PROCESS comb_logic;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk_12M,reset_n)
  BEGIN	
    if (reset_n = '0') then
    	shiftreg <= (others => '1');
    elsif rising_edge(clk_12M) then
		shiftreg <= next_shiftreg;
    end if;
  END PROCESS flip_flops;		
 
  -- Concurrent Statement
  ser_o <= shiftreg(15);
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;