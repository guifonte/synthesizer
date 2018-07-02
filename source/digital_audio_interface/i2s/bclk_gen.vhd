-------------------------------------------
-- Block code:  bclk_gen.vhd
-- History: 	14.Nov.2012 - 1st version (dqtm)
--            15.Mar.2018 - change duty cycle from 50% to 1/80. (guifonte)
--					  16.Apri.2018 - changed clcok two devide frenquency by 2
--               <date> - <changes>  (<author>)
-- Function: modulo divider with generic width. Output MSB with 1/80 duty cycle.
--		Can be used for clock-divider when no exact ratio required.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Entity Declaration
-------------------------------------------
ENTITY bclk_gen IS
	GENERIC (width : POSITIVE := 3);
	PORT (
		reset_n   : IN std_logic;
		clk_12M_i : IN std_logic;
		bclk_o    : OUT std_logic
	);
END bclk_gen;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF bclk_gen IS

	-- Define Signals and constants
	-------------------------------------------
	SIGNAL count, next_count : std_logic;

	-- Begin Architecture
	-------------------------------------------
BEGIN
	--------------------------------------------------
	-- PROCESS FOR COMBINATORIAL LOGIC
	--------------------------------------------------
	comb_logic : PROCESS (count)
	BEGIN
		next_count <= NOT(count);
	END PROCESS comb_logic; 
 
	--------------------------------------------------
	-- PROCESS FOR REGISTERS
	--------------------------------------------------
	flip_flops : PROCESS (clk_12M_i, reset_n)
	BEGIN
		IF (reset_n = '0') THEN
			count <= '0';
		ELSIF rising_edge(clk_12M_i) THEN
			count <= next_count;
		END IF;
	END PROCESS flip_flops; 
 
	--------------------------------------------------
	-- PROCESS FOR FINAL COMBINATORIAL LOGIC
	--------------------------------------------------
	final_logic : PROCESS (count)
	BEGIN
		bclk_o <= count;
	END PROCESS final_logic;
 
 
	-- End Architecture
	-------------------------------------------
END rtl;