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
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Entity Declaration
-------------------------------------------
ENTITY frame_decoder IS
	GENERIC (width : POSITIVE := 7);
	PORT (
		clk12M 	: IN std_logic;
		bclk 	: IN std_logic;
		init_n 	: IN std_logic;
		shift_L : OUT std_logic;
		shift_R : OUT std_logic;
		strobe 	: OUT std_logic;
		WS_o 	: OUT std_logic
	);
END frame_decoder;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF frame_decoder IS
	-- Signals & Constants Declaration?
	-------------------------------------------
	SIGNAL count, next_count : unsigned(width - 1 DOWNTO 0) := (OTHERS => '0'); -- exception only for simu

	-- Begin Architecture
	-------------------------------------------
BEGIN
	--------------------------------------------------
	-- PROCESS FOR COMBINATORIAL LOGIC
	--------------------------------------------------
	comb_logic : PROCESS (count, bclk)
	BEGIN
		IF bclk = '1' THEN
			next_count <= count + 1;
		ELSE
			next_count <= count;
		END IF;
	END PROCESS comb_logic; 
 
	--------------------------------------------------
	-- PROCESS FOR COMBINATORIAL LOGIC
	--------------------------------------------------
	final_logic : PROCESS (count)
	BEGIN
		--Default statement
		WS_o 	<= '0';
		strobe 	<= '0';
		shift_L <= '0';
		shift_R <= '0';
 
		IF count = 0 THEN
			strobe <= '1';
		ELSIF count <= 63 THEN -- count between 1 and 63
			IF count <= 16 THEN -- count between 1 and 16
				shift_L <= '1';
			END IF;
		ELSE -- count between 64 and 127
			WS_o <= '1';
			IF count <= 80 AND count >= 65 THEN -- count between 64 and 80
				shift_R <= '1';
			END IF; 
		END IF;
	END PROCESS final_logic; 
 
	--------------------------------------------------
	-- PROCESS FOR REGISTERS
	--------------------------------------------------
	flip_flops : PROCESS (clk12M, init_n, next_count)
	BEGIN
		IF (init_n = '0') THEN
			count <= to_unsigned(127, width);
		ELSIF rising_edge(clk12M) THEN
			count <= next_count;
		END IF;
	END PROCESS flip_flops; 
 
	-- End Architecture
	-------------------------------------------
END rtl;
