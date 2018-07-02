-------------------------------------------
-- Block code:  DDS.vhd
-- History: 	20.Apr.2018 - 1st version (Felipe Tanios)
--                 
-- Function: DDS that generates sawtooth, triangular and sinoidal waves
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY work;
USE work.tone_gen_pkg.ALL;
ENTITY DDS IS
	PORT (
		tone_on_i 		: IN std_logic;
		phi_incr_i 		: IN std_logic_vector(N_CUM - 1 DOWNTO 0);
		strobe_in 		: IN std_logic;
		clk, reset_n 	: IN std_logic;
		wave_i 			: IN std_logic_vector(1 DOWNTO 0);
		dacdat_g_o 		: OUT std_logic_vector(N_AUDIO - 1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE rtl OF DDS IS
 
	SIGNAL phi_cum, next_phi_cum : unsigned(N_CUM - 1 DOWNTO 0);
	SIGNAL addr : INTEGER RANGE 0 TO L - 1;
 
BEGIN
	phase_cumulator : PROCESS (phi_incr_i, phi_cum, strobe_in)
	BEGIN
		IF (strobe_in = '1') THEN
			next_phi_cum <= phi_cum + unsigned(phi_incr_i);
		ELSE
			next_phi_cum <= phi_cum;
		END IF;
	END PROCESS;
 
	ff_process : PROCESS (clk, reset_n)
	BEGIN
		IF (reset_n = '0') THEN
			phi_cum <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			phi_cum <= next_phi_cum;
		END IF;
	END PROCESS;

	synth_tone : PROCESS (phi_cum, tone_on_i, addr, wave_i)
	BEGIN
		addr <= to_integer(phi_cum(N_CUM - 1 DOWNTO N_CUM - N_ADDR_LUT_DDS));
		IF (tone_on_i = '1') THEN
			CASE wave_i IS
				WHEN "00" => 
					dacdat_g_o <= std_logic_vector(to_signed(LUT(addr), N_AUDIO));
				WHEN "01" => 
					dacdat_g_o <= std_logic_vector(to_signed(SAWTOOTH(addr), N_AUDIO));
				WHEN "10" => 
					dacdat_g_o <= std_logic_vector(to_signed(TRIANGULAR(addr), N_AUDIO));
				WHEN OTHERS => 
					dacdat_g_o <= std_logic_vector(to_signed(LUT(addr), N_AUDIO));
			END CASE;
		ELSE
			dacdat_g_o <= (OTHERS => '0');
		END IF;
	END PROCESS;

END ARCHITECTURE;