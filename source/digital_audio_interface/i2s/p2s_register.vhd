-------------------------------------------
-- Block code:  p2s_register.vhd
-- History: 	27.Apr.2018 - first version (felipe tanios)
--				
-- Function: paralel 16 bits to serial interface.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Entity Declaration
-------------------------------------------
ENTITY p2s_register IS
	GENERIC (width : POSITIVE := 3);
	PORT (
		clk_12M, reset_n  : IN std_logic;
		enable            : IN std_logic;
		shift             : IN std_logic;
		load              : IN std_logic;
		par_i             : IN std_logic_vector(15 DOWNTO 0);
		ser_o             : OUT std_logic
	);
END p2s_register;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF p2s_register IS

	-- Define Signals and constants
	-------------------------------------------
	SIGNAL shiftreg, next_shiftreg : std_logic_vector(15 DOWNTO 0);

	-- Begin Architecture
	-------------------------------------------
BEGIN
	--------------------------------------------------
	-- PROCESS FOR COMBINATORIAL LOGIC
	--------------------------------------------------
	comb_logic : PROCESS (load, enable, shift, shiftreg, par_i)
 
	BEGIN
		next_shiftreg <= shiftreg;
		IF (load = '1') THEN
			next_shiftreg <= par_i;
		ELSIF (enable = '1' AND shift = '1') THEN
			next_shiftreg <= shiftreg(14 DOWNTO 0) & '1';
		END IF;

	END PROCESS comb_logic; 
 
	--------------------------------------------------
	-- PROCESS FOR REGISTERS
	--------------------------------------------------
	flip_flops : PROCESS (clk_12M, reset_n)
	BEGIN
		IF (reset_n = '0') THEN
			shiftreg <= (OTHERS => '1');
		ELSIF rising_edge(clk_12M) THEN
			shiftreg <= next_shiftreg;
		END IF;
	END PROCESS flip_flops; 

	-- Concurrent Statement
	ser_o <= shiftreg(15);
 
 
	-- End Architecture
	-------------------------------------------
END rtl;