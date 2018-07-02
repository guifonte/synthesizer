-------------------------------------------
-- Block code:  midi_controller.vhd
-- History:     02.Jul.2018 - 1st version (Guifonte)
--                 
-- Function:    Midi controller that handles the midi signals and activates
--              the correct note in 10 dds. It also shows in the red led array
--              which dds is active, and in the green led array, which state
--              is the fsm of the controller in.
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY work;
USE work.tone_gen_pkg.ALL;
 
ENTITY midi_controller IS
	PORT (
		rx_data_valid_in    : IN std_logic;
		rx_data_in          : IN std_logic_vector(7 DOWNTO 0);
		clk                 : IN std_logic;
		reset_n             : IN std_logic;
		midi_note_o         : OUT t_midi_array;
		led_r_out           : OUT std_logic_vector(9 DOWNTO 0);
		led_g_out           : OUT std_logic_vector(6 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE rtl OF midi_controller IS
 
	TYPE t_fsm_states IS (
	wait_status, 
	wait_data1, 
	wait_data2
	);
 
	TYPE t_note_action IS (
	DEL_NOTE, 
	SET_NOTE, 
	NUL_NOTE
	);
 
	SIGNAL fsm_state, next_fsm_state            : t_fsm_states;
	SIGNAL note_action, next_note_action        : t_note_action;
	SIGNAL note_num, next_note_num              : std_logic_vector(6 DOWNTO 0);
	SIGNAL note_speed, next_note_speed          : std_logic_vector(6 DOWNTO 0);
	SIGNAL midi_out_regs, next_midi_out_regs    : t_midi_array;
	SIGNAL note_update, next_note_update        : std_logic;
	SIGNAL led_r_reg, next_led_r_reg            : std_logic_vector(9 DOWNTO 0); -- points if the 10 dds are valid
	SIGNAL led_g_reg, next_led_g_reg            : std_logic_vector(6 DOWNTO 0); -- points if is wait_status, wait_data1 or wait_data2
 
BEGIN
	ffs : PROCESS (clk, reset_n)
	BEGIN
		IF reset_n = '0' THEN
			fsm_state       <= wait_status;
			midi_out_regs   <= (OTHERS => NOTE_INIT_VALUE);
			note_update     <= '0';
			note_action     <= NUL_NOTE;
			note_num        <= (OTHERS => '0');
			note_speed      <= (OTHERS => '0');
			led_r_reg       <= (OTHERS => '0');
			led_g_reg       <= (OTHERS => '0'); 
		ELSIF rising_edge(clk) THEN
			fsm_state       <= next_fsm_state;
			midi_out_regs   <= next_midi_out_regs;
			note_update     <= next_note_update;
			note_action     <= next_note_action;
			note_num        <= next_note_num;
			note_speed      <= next_note_speed;
			led_r_reg       <= next_led_r_reg;
			led_g_reg       <= next_led_g_reg;
		END IF;
	END PROCESS ffs;

	in_comb : PROCESS (ALL)
	BEGIN
		next_fsm_state      <= fsm_state;
		next_note_update    <= '0';
		next_note_action    <= note_action;
		next_note_num       <= note_num;
		next_note_speed     <= note_speed;
		next_led_g_reg      <= led_g_reg;

		IF rx_data_valid_in THEN
            CASE fsm_state IS

				WHEN wait_status => 
					IF (rx_data_in(7) = '1') THEN
						next_led_g_reg(0)   <= '0';
						next_led_g_reg(1)   <= '1';
						next_led_g_reg(2)   <= '0';
                        next_led_g_reg(3)   <= '0';
                        
                        next_fsm_state     <= wait_data1;
                        
						IF (rx_data_in(6 DOWNTO 4) = "001") THEN
							next_note_action <= SET_NOTE;
						ELSIF (rx_data_in(6 DOWNTO 4) = "000") THEN
							next_note_action <= DEL_NOTE;
						ELSE
							next_note_action <= NUL_NOTE;
						END IF;
					ELSE -- running status
						next_led_g_reg(0)   <= '0'; 
						next_led_g_reg(1)   <= '0';
						next_led_g_reg(2)   <= '1';
						next_led_g_reg(3)   <= '0';
						next_fsm_state      <= wait_data2;
						next_note_num       <= rx_data_in(6 DOWNTO 0);
                    END IF; 
                    
				WHEN wait_data1 => 
					IF (rx_data_in(7) = '0') THEN
						next_led_g_reg(0)   <= '0'; 
						next_led_g_reg(1)   <= '0';
						next_led_g_reg(2)   <= '1';
						next_led_g_reg(3)   <= '0'; 
 
						next_fsm_state      <= wait_data2;
                        next_note_num       <= rx_data_in(6 DOWNTO 0);
                        
					ELSE
						next_led_g_reg(0)   <= '1';
						next_led_g_reg(1)   <= '0';
						next_led_g_reg(2)   <= '0';
                        next_led_g_reg(3)   <= '0';
                        
						next_fsm_state      <= wait_status;
                        next_note_action    <= NUL_NOTE;                     
                    END IF; 
                    
				WHEN wait_data2 => 
                    IF (rx_data_in(7) = '0') THEN
                        
						next_led_g_reg(0)   <= '1';
						next_led_g_reg(1)   <= '0';
						next_led_g_reg(2)   <= '0';
                        next_led_g_reg(3)   <= '0';
                        
                        next_fsm_state      <= wait_status;
						next_note_update    <= '1';
						next_note_speed     <= rx_data_in(6 DOWNTO 0);
					ELSE
						next_fsm_state      <= wait_status;
						next_note_action    <= NUL_NOTE;
                    END IF;
                    
                WHEN OTHERS =>          
                    next_fsm_state <= wait_status;
                    
			END CASE;
		END IF;
	END PROCESS in_comb;

	out_comb : PROCESS (ALL)
		VARIABLE set_done : BOOLEAN;
	BEGIN
		next_midi_out_regs  <= midi_out_regs;
		next_led_r_reg      <= led_r_reg;

		IF (note_update) THEN
			set_done := false;
			CASE (note_action) IS
				WHEN SET_NOTE => 
					IF NOT(unsigned(rx_data_in(6 DOWNTO 0)) = 0) THEN
						set_loop : FOR i IN 0 TO 9 LOOP
							IF NOT(set_done) THEN
								IF ((midi_out_regs(i).valid = '0') OR (i = 9)) THEN
									next_midi_out_regs(i).valid         <= '1';
									next_midi_out_regs(i).number        <= note_num; 
									next_midi_out_regs(i).velocity      <= note_speed;
									next_led_r_reg(i)                   <= '1';
									set_done := true;
								END IF;
							END IF;
						END LOOP set_loop;
					ELSE
						del_loop : FOR i IN 0 TO 9 LOOP
							IF ((midi_out_regs(i).valid = '1') AND (midi_out_regs(i).number = note_num)) THEN
								next_midi_out_regs(i).valid <= '0';
								next_led_r_reg(i)           <= '0';
							END IF;
						END LOOP; -- del_loop 
					END IF;
				WHEN DEL_NOTE => 
					del_loop2 : FOR i IN 0 TO 9 LOOP
						IF ((midi_out_regs(i).valid = '1') AND (midi_out_regs(i).number = note_num)) THEN
							next_midi_out_regs(i).valid <= '0';
							next_led_r_reg(i)           <= '0';
						END IF;
					END LOOP; -- del_loop
				WHEN OTHERS => NULL;
			END CASE;
		END IF;
	END PROCESS out_comb;

	midi_note_o <= midi_out_regs;
	led_r_out   <= led_r_reg;
	led_g_out   <= led_g_reg;

END rtl;