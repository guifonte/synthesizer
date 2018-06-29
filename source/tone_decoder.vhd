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
		phi_incr_o		: out 	std_logic_vector(N_CUM-1 downto 0);
		tone_on_o		: out	std_logic
	);
end entity;

architecture rtl of tone_decoder is


	begin
		
		--Process that controls the state machine

		decoder: process(tone_cmd_i)
		
		begin

			--Default statement
			phi_incr_o <= (others =>'0');
			tone_on_o <= '0';


			case tone_cmd_i is
				when "00" =>
					phi_incr_o <= (others =>'0');
					tone_on_o <= '0';

				when "01" =>
					tone_on_o 	<= '1';
					phi_incr_o	<= C3_DO;
				when "10" =>
					tone_on_o 	<= '1';
					phi_incr_o	<= D3_RE;
				when "11" =>
					tone_on_o 	<= '1';
					phi_incr_o	<= E3_MI;
				when others =>
					phi_incr_o <= (others =>'0');
					tone_on_o <= '0';
			end case;

		end process ; --decoder

end architecture;