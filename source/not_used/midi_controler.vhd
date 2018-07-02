-------------------------------------------
-- Block code:  midi_controller.vhd
-- History: 	15.Jun.2018 - 1st version (Guifonte)
--                 
-- Function: Midi controller that handles the midi signals and activate the notes and efects
-------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  LIBRARY work;
  USE work.tone_gen_pkg.all;
  
entity midi_controller is
	port(
		rx_data_valid_in		: in        std_logic;
		rx_data_in					: in        std_logic_vector(7 downto 0);
		clk							: in        std_logic;
		reset_n						: in        std_logic;
        midi_cmds       			: out       t_midi_array;
        led_r_out                   : out       std_logic_vector(9 downto 0);
        led_g_out                   : out       std_logic_vector(6 downto 0)
	);
end entity;

architecture rtl of midi_controller is
	
	constant NOTE_OFF	: std_logic_vector(2 downto 0)	:= "000";
	constant NOTE_ON	: std_logic_vector(2 downto 0)	:= "001";
	
	type t_midi_fsm_states is (
    S_WAIT_STATUS,
    S_WAIT_DATA1,
    S_WAIT_DATA2
	);

	type t_note_action is (
		DEL_NOTE,
		SET_NOTE,
		NUL_NOTE
	);
	
	
   	signal midi_state, next_midi_state					:	t_midi_fsm_states;
	signal note_action, next_note_action	            :	t_note_action;
	signal num_buf, next_num_buf					    :	std_logic_vector(6 downto 0);
	signal vel_buf, next_vel_buf				    	:	std_logic_vector(6 downto 0);
	signal midi_regs, next_midi_regs        	        :	t_midi_array;
	signal note_update, next_note_update				:	std_logic;
	signal led_r_reg, next_led_r_reg					:   std_logic_vector(9 downto 0);
	signal led_g_reg, next_led_g_reg                    :   std_logic_vector(6 downto 0);
	
begin

		--Process that controls the state machine

	all_flipflops: PROCESS(clk, reset_n)
    begin
        if reset_n ='0' then
            midi_state  <=  S_WAIT_STATUS;
            midi_regs   <=  (others=> NOTE_INIT_VALUE);
            note_update <=  '0';
            note_action <=  NUL_NOTE;
            num_buf     <=  (others=>'0');
            vel_buf     <=  (others=>'0');
            led_r_reg	<=  (others=>'0');
            led_g_reg	<=  (others=>'0');		
        elsif rising_edge(clk) then
            midi_state  <=  next_midi_state;
            midi_regs   <=  next_midi_regs;
            note_update <=  next_note_update;
            note_action <=  next_note_action;
            num_buf     <=  next_num_buf;
            vel_buf     <=  next_vel_buf;
            led_r_reg	<=  next_led_r_reg;
            led_g_reg	<=  next_led_g_reg;
        end if ;
    end process all_flipflops;



	fsm: process(all)
	begin

		--Default statement
		next_midi_state    <=  midi_state;
        next_note_update    <=  '0';
        next_led_g_reg(1)	<= '0';
        next_note_action    <=  note_action;
        next_num_buf        <=  num_buf;
        next_vel_buf        <=  vel_buf;
        next_led_g_reg      <=  led_g_reg;
		
		--Changes states (moore machine)
		if (rx_data_valid_in = '1') then
			case midi_state is
				when S_WAIT_STATUS =>
					if (rx_data_in(7) = '1') then

						next_midi_state <= S_WAIT_DATA1;
	                    
	                    if (rx_data_in(6 downto 4) = "001") then
	                        next_note_action <= SET_NOTE;
	                    elsif (rx_data_in(6 downto 4) = "000")  then
	                        next_note_action <= DEL_NOTE;
	                    else
	                    	next_note_action <= NUL_NOTE;
	                    end if;
					--else --Running Status
					--	next_fsm_state	<= S_WAIT_DATA2;
					--	next_data1_reg <= rx_data_in;
					end if;
				when S_WAIT_DATA1 =>
					if (rx_data_in(7) = '0') then
						next_midi_state 	<= S_WAIT_DATA2;
						next_num_buf    <= rx_data_in(6 downto 0);
					end if;

				when S_WAIT_DATA2 =>
					if (rx_data_in(7) = '0') then
						next_vel_buf        <= rx_data_in(6 downto 0);
	                    next_note_update    <= '1';
						next_led_g_reg(1)	<= '1';
	                    
	                    if ((note_action = SET_NOTE) AND (unsigned(rx_data_in(6 downto 0)) = 0)) then
	                        next_note_action <= DEL_NOTE;
	                    end if ;
						next_midi_state 	<= S_WAIT_STATUS;
						
					end if;
			end case;
		end if;
		
	end process ; --fsm

	
	--Flip-flops process
	
	
	
	fsm_comb_out : process(all)
        variable set_done : boolean;
    begin
        next_midi_regs  <=  midi_regs;
		next_led_r_reg  <=  led_r_reg;
		  
        if (note_update) then
            set_done := false;
            case (note_action) is
                when SET_NOTE =>
                    set_loop : for i in 0 to 9 loop
                        if NOT(set_done) then
                            if ((midi_regs(i).valid = '0') OR (i = 9)) then
                                next_midi_regs(i).valid     <=  '1';
                                next_midi_regs(i).number    <= num_buf;
                                next_midi_regs(i).velocity  <= vel_buf;
                                next_led_r_reg(i)           <=  '1';
                                set_done := true;
                            end if ;
                        end if ;
                    end loop set_loop;
                when DEL_NOTE =>
                    del_loop : for i in 0 to 9 loop
                        if ((midi_regs(i).valid = '1') AND (midi_regs(i).number = num_buf)) then
                            next_midi_regs(i).valid <= '0';
                            next_led_r_reg(i)       <= '0';
                        end if ;
                    end loop ; -- del_loop
                when others => null;
            end case ;
        end if ;
    end process fsm_comb_out;

	midi_cmds <= midi_regs;
	led_r_out <= led_r_reg;
	led_g_out <= led_g_reg;
	
end architecture;