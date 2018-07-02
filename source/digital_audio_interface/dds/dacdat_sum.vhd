-------------------------------------------
-- Block code:  dacdat_sum.vhd
-- History: 	15.Jun.2018 - 1st version (Guifonte)
--                 
-- Function: Sums the exits of the dds
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY work;
USE work.tone_gen_pkg.ALL;
 

ENTITY dacdat_sum IS
	PORT (
		dacdat_in       : IN NAUDIO_array_type;
		dacdat_sum_out  : OUT std_logic_vector(N_AUDIO - 1 DOWNTO 0);
		strobe_in       : IN std_logic;
		clk             : IN std_logic;
		reset_n         : IN std_logic
	);
END ENTITY;

ARCHITECTURE rtl OF dacdat_sum IS
 
	SIGNAL sum, next_sum : std_logic_vector(N_AUDIO - 1 DOWNTO 0);
BEGIN
	sum_ff : PROCESS (clk, reset_n)
	BEGIN
		IF reset_n = '0' THEN
			sum <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			sum <= next_sum;
		END IF;
	END PROCESS sum_ff;

	fsm_comb : PROCESS (ALL)
	BEGIN
		next_sum <= sum;
		IF (strobe_in) THEN
			next_sum <= std_logic_vector(signed(dacdat_in(0)) + signed(dacdat_in(1)) + signed(dacdat_in(2)) + signed(dacdat_in(3)) + signed(dacdat_in(4)) + signed(dacdat_in(5)) + signed(dacdat_in(6)) + signed(dacdat_in(7)) + signed(dacdat_in(8)) + signed(dacdat_in(9)));
		END IF;
	END PROCESS fsm_comb;

	dacdat_sum_out <= sum;

END rtl;