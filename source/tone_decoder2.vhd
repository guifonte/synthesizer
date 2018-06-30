-------------------------------------------
-- Block code:  tone_decoder.vhd
-- History: 	25.May.2018 - 1st version (Felipe Tanios)
--                 
-- Function:Tone decoder to feed synthesizer.
-------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  LIBRARY work;
  USE work.tone_gen_pkg.all;


entity tone_decoder is
	port(
		tone_cmd_i		: in	std_logic_vector(1 downto 0);
		note_on_off_i	: in 	std_logic;
		clk, reset_n	: in 	std_logic;
		phi_incr_o		: out 	std_logic_vector(N_CUM-1 downto 0);
		tone_on_o		: out	std_logic
	);
end entity;

architecture rtl of tone_decoder is
	
	signal on_off_state, next_on_off_state: std_logic;
	
	begin
		
		--Process that controls the state machine

		decoder: process(tone_cmd_i,on_off_state)
		
		begin

			--Default statement
			phi_incr_o <= (others =>'0');
			next_on_off_state <= on_off_state;
			
			IF (note_on_off_i = '1')
				IF (on_off_state = '0') THEN
					next_on_off_state <= '1';
				ELSE 
					next_on_off_state <= '0';
				END IF;
			END IF;
			
			case tone_cmd_i is
				when "00" =>
					phi_incr_o <= C3_DO;
				when "01" =>
					phi_incr_o	<= D3_DO;
				when "10" =>
					phi_incr_o	<= E3_RE;
				when "11" =>
					phi_incr_o	<= F3_MI;
			end case;

		end process ; --decoder

		flip_flop: process(next_on_off_state, reset_n, clk)
		begin
			if (reset_n = '0') then
				on_off_state 	<= '0';
			elsif rising_edge(clk) then
				on_off_state <= next_on_off_state;
			end if;
		end process;
		
		end_comb: process(on_off_state)
		begin
			IF (on_off_state = '0') THEN
				tone_on_o <= '0';
			ELSE 
				tone_on_o <= '1';
			END IF;
		end process;
		
end architecture;