-------------------------------------------
-- Block code:  s2p_register.vhd
-- History: 	27.Apr.2018 - first version (felipe tanios)
--				
-- Function: paralel 16 bits to serial interface.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.naumeric_std.all;

-- Entity Declaration 
-------------------------------------------
ENTITY s2p_register IS
GENERIC (width		: positive  := 3 );
  PORT(
    clk_12M, reset_n      : IN    std_logic;
		enable			   	      : IN    std_logic;
		shift				          : IN	  std_logic;
		ser_i                 : IN	  std_logic;
		par_o	      		      : OUT   std_logic_vector(15 downto 0)
    	);
END s2p_register;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF s2p_register IS

-- Define Signals and constants
-------------------------------------------
signal shiftreg, next_shiftreg	: std_logic_vector(15 downto 0);
Signal counter, next_counter    : unsigned (width - 1 downto 0);

-- Begin Architecture
-------------------------------------------
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(load, enable, shift, shiftreg, counter)
  
  BEGIN
		next_shiftreg <= shiftreg;
    next_counter <= counter;
  		if (enable = '1' and shift = '1') then
  			next_shiftreg <= ser_i & shiftreg(15 downto 1);
        next_counter <= counter + 1;
  		end if;

  END PROCESS comb_logic;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk_12M,reset_n)
  BEGIN	
    if (reset_n = '0') then
    	shiftreg <= (others => '1');
      counter <= 0;
    elsif rising_edge(clk_12M) then
  		shiftreg <= next_shiftreg;
      counter <= next_counter;
    end if;
  END PROCESS flip_flops;		
  
  --------------------------------------------------
  -- PROCESS FOR FINAL COMBINATORIAL LOGIC
  --------------------------------------------------
  final_logic: PROCESS(shiftreg, counter)
  BEGIN	
	
  if (counter = 15) then
      par_o = shiftreg;
  end if ;

  END PROCESS final_logic; 
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;