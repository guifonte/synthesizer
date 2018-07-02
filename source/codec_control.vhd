-------------------------------------------
-- Block code:  codec_control.vhd
-- History: 	20.Apr.2018 - 1st version (Felipe Tanios)
--                 
-- Function: Final State Machine that controls input registers to I2C Master.
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY work;
USE work.reg_table_pkg.ALL;
ENTITY codec_control IS
	PORT (
		clk 			: IN std_logic;
		reset_n 		: IN std_logic;
		write_done_i 	: IN std_logic;
		event_control_i : IN std_logic_vector(2 DOWNTO 0);
		initialize_n 	: IN std_logic;
		ack_error_i 	: IN std_logic;
		write_o 		: OUT std_logic;
		write_data_o 	: OUT std_logic_vector(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE rtl OF codec_control IS

	CONSTANT reg_size : NATURAL := 7;

	TYPE t_fsm_states IS (
	S_IDLE, 
	S_START_WRITE, 
	S_WAIT
	);

	SIGNAL fsm_state, next_fsm_state 	: t_fsm_states;
	SIGNAL reg, next_reg 				: INTEGER RANGE 0 TO 9;

	--Begining architecture

BEGIN
	--Process that controls the state machine

	fsm : PROCESS (event_control_i, initialize_n, write_done_i, reg, fsm_state, ack_error_i)
 
		VARIABLE last_reg : std_logic;
 
	BEGIN
		--Default statement
		next_fsm_state 	<= fsm_state;
		next_reg 		<= reg;
		--Changes states (moore machine)

		CASE fsm_state IS
			WHEN S_IDLE => 
				IF (initialize_n = '1') THEN
					next_fsm_state <= S_IDLE;
				END IF;
				IF (initialize_n = '0') THEN
					next_fsm_state <= S_START_WRITE;
				END IF;
 
			WHEN S_START_WRITE => 
				next_fsm_state <= S_WAIT;
				next_reg <= (reg + 1) MOD 10;
			WHEN S_WAIT => 
				IF ((write_done_i = '1') AND (reg /= 9)) THEN
					next_fsm_state <= S_START_WRITE;
				ELSIF ((write_done_i = '1' AND reg = 9) OR (ack_error_i = '1')) THEN
					next_fsm_state <= S_IDLE;
					--restart from register 0
					next_reg <= 0;
				END IF;
		END CASE;

	END PROCESS; --fsm

	--Flip-flops process

	ff_process : PROCESS (clk, reset_n)
	BEGIN
		IF (reset_n = '0') THEN
			fsm_state 	<= S_IDLE;
			reg 		<= 0;
		ELSIF rising_edge(clk) THEN
			fsm_state 	<= next_fsm_state;
			reg 		<= next_reg;
		END IF;

	END PROCESS; --ff_process(fsm_state, reg, event_control_i);

	-- Process that defines outputs

	outputs : PROCESS (fsm_state, reg, event_control_i)
	BEGIN
		--Default statement
		write_o 		<= '0';
		write_data_o 	<= (OTHERS => '0');

		CASE fsm_state IS
			WHEN S_IDLE => 
				write_o <= '0';

			WHEN S_START_WRITE => 

				IF (event_control_i = "000") THEN
					write_o 					<= '1';
					write_data_o(15 DOWNTO 9) 	<= std_logic_vector(to_unsigned(reg, reg_size));
					write_data_o(8 DOWNTO 0) 	<= C_W8731_ANALOG_BYPASS(reg);
				END IF;

				IF (event_control_i = "001") THEN
					write_o 					<= '1';
					write_data_o(15 DOWNTO 9) 	<= std_logic_vector(to_unsigned(reg, reg_size));
					write_data_o(8 DOWNTO 0) 	<= C_W8731_ANALOG_MUTE_LEFT(reg);
				END IF;
 
				IF (event_control_i = "010") THEN
					write_o 					<= '1';
					write_data_o(15 DOWNTO 9) 	<= std_logic_vector(to_unsigned(reg, reg_size));
					write_data_o(8 DOWNTO 0) 	<= C_W8731_ANALOG_MUTE_RIGHT(reg);
				END IF;

				IF (event_control_i = "011") THEN
					write_o 					<= '1';
					write_data_o(15 DOWNTO 9) 	<= std_logic_vector(to_unsigned(reg, reg_size));
					write_data_o(8 DOWNTO 0) 	<= C_W8731_ANALOG_MUTE_BOTH(reg);
				END IF;

				IF (event_control_i = "100") THEN
					write_o 					<= '1';
					write_data_o(15 DOWNTO 9) 	<= std_logic_vector(to_unsigned(reg, reg_size));
					write_data_o(8 DOWNTO 0) 	<= C_W8731_ADC_DAC_0DB_48K(reg);
				END IF;

			WHEN S_WAIT => 
				write_o <= '0';
		END CASE;

	END PROCESS; -- outputsssss

END ARCHITECTURE;

