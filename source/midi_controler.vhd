-------------------------------------------
-- Block code:  midi_fsm.vhd
-- History: 	15.Jun.2018 - 1st version (Guifonte)
--                 
-- Function: Midi controller that handles the midi signals and activate the notes and efects
-------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  LIBRARY work;
  USE work.tone_gen_pkg.all;
  
entity midi_fsm is
	port(
		rx_data_valid_in		: in    std_logic;
		rx_data_in				: in    std_logic_vector(7 downto 0);
		clk						: in	  std_logic;
		reset_n					: in	  std_logic;
		t_note_record_out		: out	  t_note_record
	);
end entity;

architecture rtl of midi_fsm is
	
	constant NOTE_OFF	: std_logic_vector(2 downto 0)	:= "000";
	constant NOTE_ON	: std_logic_vector(2 downto 0)	:= "001";
	
	type t_midi_fsm_states is (
    S_WAIT_STATUS,
    S_WAIT_DATA1,
    S_WAIT_DATA2
	);
	
	signal fsm_state, next_fsm_state					:	t_midi_fsm_states;
	signal note_action_reg, next_note_action_reg	:	std_logic_vector(7 downto 0);
	signal data1_reg, next_data1_reg					:	std_logic_vector(7 downto 0);
	signal data2_reg, next_data2_reg					:	std_logic_vector(7 downto 0);
	signal t_note_rec_reg, next_t_note_rec_reg	:	t_note_record;
	signal note_update									:	std_logic;
	
begin

		--Process that controls the state machine

	fsm: process(data2_reg,data1_reg,note_action_reg, rx_data_in, fsm_state, rx_data_valid_in)
	begin

		--Default statement
		next_fsm_state	<= fsm_state;
		next_note_action_reg	<= note_action_reg;
		next_data1_reg <= data1_reg;
		next_data2_reg <= data2_reg;
		note_update <= '0';
		
		--Changes states (moore machine)
		if (rx_data_valid_in = '1') then
			case fsm_state is
				when S_WAIT_STATUS =>
					if (rx_data_in(7) = '1') then
							next_fsm_state 		<= S_WAIT_DATA1;
							next_note_action_reg <= rx_data_in;
					--else --Running Status
					--	next_fsm_state	<= S_WAIT_DATA2;
					--	next_data1_reg <= rx_data_in;
					end if;
				when S_WAIT_DATA1 =>
					if (rx_data_in(7) = '0') then
						next_fsm_state 	<= S_WAIT_DATA2;
						next_data1_reg 	<= rx_data_in;
					end if;

				when S_WAIT_DATA2 =>
					if (rx_data_in(7) = '0') then
						next_fsm_state 	<= S_WAIT_STATUS;
						next_data2_reg 	<= rx_data_in;
						note_update 		<= '1';
					end if;
			end case;
		end if;
		
	end process ; --fsm

	
	--Flip-flops process
	
	ff_process: process(clk,reset_n)
	begin
	
		if (reset_n = '0') then
			fsm_state 	<= S_WAIT_STATUS;
			note_action_reg	<=	(OTHERS =>'0');
			data1_reg 	<= (OTHERS =>'0');
			data2_reg	<= (OTHERS =>'0');
			--midi_reqs <= (others=> NOTE_INIT_VALUE);
			t_note_rec_reg <= NOTE_INIT_VALUE;
		elsif rising_edge(clk) then
			fsm_state <= next_fsm_state;
			note_action_reg	<=	next_note_action_reg;
			data1_reg 	<= next_data1_reg;
			data2_reg	<= next_data2_reg;
			
			t_note_rec_reg <= next_t_note_rec_reg;
		end if;
		
	end process;
	
	midi_logic: process(note_action_reg, data1_reg, data2_reg, note_update, t_note_rec_reg)
	begin
		--Default statement
		next_t_note_rec_reg	<= t_note_rec_reg;
	
		if (note_update = '1') then
			if (t_note_rec_reg.valid = '0' AND note_action_reg(6 downto 4) = NOTE_ON) then
				next_t_note_rec_reg.valid <= '1';
				next_t_note_rec_reg.number <= data1_reg(6 downto 0);
				next_t_note_rec_reg.velocity <= data2_reg(6 downto 0);
			end if;
		end if;	
	end process;

	--output
	t_note_record_out <= t_note_rec_reg;
	
end architecture;