-------------------------------------------
-- Block code:  frame_decoder.vhd
-- History: 	14.Nov.2012 - 1st version (guifonte)
--
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
ENTITY frame_decoder IS
GENERIC (width		: positive  := 6 );
  PORT(
		bclk				: IN    std_logic;
		init_n			: IN    std_logic;
		shift_L			: OUT   std_logic;
		shift_R			: OUT   std_logic;
		strobe			: OUT   std_logic;
		WS_o				: OUT   std_logic
    	);
END frame_decoder;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF frame_decoder IS
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
	--Default statement
	WS_o <= '0';
	strobe <= '0';
	shift_L <= '0';
	shift_R <= '0';
	
	IF count = 0 THEN
		strobe <= '1';
	ElSIF count <= 63 THEN -- count between 1 and 63
		IF count <= 16 THEN -- count between 1 and 16
			shift_L <= '1';
		END IF;
	ELSE -- count between 64 and 127
		WS_o <= '1';
		IF count <= 80 AND count >= 65 THEN -- count between 64 and 80
			shift_R <= '1';
		END IF;	
	END IF;
  END PROCESS comb_logic;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(bclk,init_n,next_count)
  BEGIN	
	IF (init_n = '0') THEN
		count <= to_unsigned(0,width);
	ElSIF rising_edge(bclk) THEN
		count <= next_count;
	END IF;
  END PROCESS flip_flops;		
  
 -- End Architecture 
------------------------------------------- 
END rtl;
