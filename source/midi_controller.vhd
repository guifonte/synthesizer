-------------------------------------------
-- Block code:  midi_fsm.vhd
-- History:     15.Jun.2018 - 1st version (Guifonte)
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
        rx_data_valid_in            : in        std_logic;
        rx_data_in                  : in        std_logic_vector(7 downto 0);
        clk                         : in        std_logic;
        reset_n                     : in        std_logic;
        midi_cmds                   : out       t_midi_array;
        led_r_out                   : out       std_logic_vector(9 downto 0);
        led_g_out                   : out       std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of midi_controller is
    
    type t_midi_fsm_states is (
    wait_status,
    wait_data1,
    wait_data2
    );
    
    type t_note_action is (
        DEL_NOTE,
        SET_NOTE,
        NUL_NOTE
    );
    
   signal midi_state, next_midi_state                   :   t_midi_fsm_states;
    signal note_action, next_note_action                :   t_note_action;
    signal num_buf, next_num_buf                        :   std_logic_vector(6 downto 0);
    signal vel_buf, next_vel_buf                        :   std_logic_vector(6 downto 0);
    signal midi_regs, next_midi_regs                    :   t_midi_array;
    signal note_update, next_note_update                :   std_logic;
    signal led_r_reg, next_led_r_reg                    :   std_logic_vector(9 downto 0);
    signal led_g_reg, next_led_g_reg                    :   std_logic_vector(6 downto 0);
    
begin

    all_flipflops: PROCESS(clk, reset_n)
    begin
        if reset_n ='0' then
            midi_state  <=  wait_status;
            midi_regs   <=  (others=> NOTE_INIT_VALUE);
            note_update <=  '0';
            note_action <=  NUL_NOTE;
            num_buf     <=  (others=>'0');
            vel_buf     <=  (others=>'0');
            led_r_reg   <=  (others=>'0');
            led_g_reg   <=  (others=>'0');      
        elsif rising_edge(clk) then
            midi_state  <=  next_midi_state;
            midi_regs   <=  next_midi_regs;
            note_update <=  next_note_update;
            note_action <=  next_note_action;
            num_buf     <=  next_num_buf;
            vel_buf     <=  next_vel_buf;
            led_r_reg   <=  next_led_r_reg;
            led_g_reg   <=  next_led_g_reg;
        end if ;
    end process all_flipflops;

    fsm_comb_in: process(all)
    begin
        next_midi_state     <=  midi_state;
        next_note_update    <=  '0';
        next_note_action    <=  note_action;
        next_num_buf        <=  num_buf;
        next_vel_buf        <=  vel_buf;
        next_led_g_reg      <=  led_g_reg;
        next_led_r_reg      <=  led_r_reg;

        if rx_data_valid_in then
            case midi_state is
                when wait_status =>
                    next_led_r_reg(7 downto 0) <= rx_data_in(7 downto 0); 
                    if (rx_data_in(7)='1') then
                        next_led_g_reg(0)   <= '0';
                        next_led_g_reg(1)   <= '1';
                        next_led_g_reg(2)   <= '0';
                        next_led_g_reg(3)   <= '0'; 
                        next_midi_state <= wait_data1;
                        if (rx_data_in(6 downto 4) = "001") then
                            next_note_action <= SET_NOTE;
                        elsif (rx_data_in(6 downto 4) = "000")  then
                            next_note_action <= DEL_NOTE;
                        else
                            next_note_action <= NUL_NOTE;
                        end if ;
                    else -- running status
                        next_led_g_reg(0)   <= '0';                               
                        next_led_g_reg(1)   <= '0';
                        next_led_g_reg(2)   <= '1';
                        next_led_g_reg(3)   <= '0';
                        next_midi_state <= wait_data2;
                        next_num_buf    <= rx_data_in(6 downto 0);
                    end if ;    
                when wait_data1 =>           
                    if (rx_data_in(7)='0') then
                        next_led_g_reg(0)   <= '0';                               
                        next_led_g_reg(1)   <= '0';
                        next_led_g_reg(2)   <= '1';
                        next_led_g_reg(3)   <= '0';          
                        
                        next_midi_state <= wait_data2;
                        next_num_buf    <= rx_data_in(6 downto 0);
                    else
                        next_led_g_reg(0)   <= '1';
                        next_led_g_reg(1)   <= '0';
                        next_led_g_reg(2)   <= '0';
                        next_led_g_reg(3)   <= '0';
                        next_midi_state <= wait_status;
                        next_note_action <= NUL_NOTE;    
                    end if ;        
                when wait_data2 => 
                    if (rx_data_in(7)='0') then
                        next_midi_state     <= wait_status;
                        next_led_g_reg(0)   <= '1';
                        next_led_g_reg(1)   <= '0';
                        next_led_g_reg(2)   <= '0';
                        next_led_g_reg(3)   <= '0';
                        next_note_update    <=  '1';
                        next_vel_buf        <= rx_data_in(6 downto 0);
                        --if ((note_action = SET_NOTE) AND (unsigned(rx_data_in(6 downto 0)) = 0)) then
                        --    next_note_action <= DEL_NOTE;
                        --end if ;
                    else
                        next_midi_state <= wait_status;
                        next_note_action <= NUL_NOTE;
                    end if;
                when others =>
                    next_midi_state <= wait_status;
            end case ;
        end if;
    end process fsm_comb_in;

    fsm_comb_out : process(all)
        variable set_done : boolean;
    begin
        next_midi_regs  <=  midi_regs;
        --next_led_r_reg  <=  led_r_reg;

        if (note_update) then
            set_done := false;
            --next_led_r_reg(6 downto 0) <= num_buf;
            case (note_action) is
                when SET_NOTE =>
                    if not(unsigned(rx_data_in(6 downto 0)) = 0) then
                        set_loop : for i in 0 to 9 loop
                            if not(set_done) then
                                if ((midi_regs(i).valid = '0') OR (i = 9)) then
                                    next_midi_regs(i).valid     <=  '1';
                                    next_midi_regs(i).number    <= num_buf;
                                    
                                    
                                    next_midi_regs(i).velocity  <= vel_buf;
                                    --next_led_r_reg(i)           <=  '1';
                                    set_done := true;
                                end if ;
                            end if ;
                        end loop set_loop;
                    else
                        del_loop : for i in 0 to 9 loop
                            if ((midi_regs(i).valid = '1') AND (midi_regs(i).number = num_buf)) then
                                next_midi_regs(i).valid <= '0';
                                --next_led_r_reg(i)       <= '0';
                            end if ;
                        end loop ; -- del_loop    
                    end if;
                when DEL_NOTE =>
                    del_loop2 : for i in 0 to 9 loop
                        if ((midi_regs(i).valid = '1') AND (midi_regs(i).number = num_buf)) then
                            next_midi_regs(i).valid <= '0';
                            --next_led_r_reg(i)       <= '0';
                        end if ;
                    end loop ; -- del_loop
                when others => null;
            end case ;
        end if ;
    end process fsm_comb_out;

midi_cmds <= midi_regs;
led_r_out <= led_r_reg;
led_g_out <= led_g_reg;

end rtl;