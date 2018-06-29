-------------------------------------------
-- Block code:  DDS.vhd
-- History: 	20.Apr.2018 - 1st version (Felipe Tanios)
--                 
-- Function: Final State Machine that controls input registers to I2C Master.
-------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  LIBRARY work;
  USE work.tone_gen_pkg.all;


entity DDS is
	port(
		tone_on_i		: in    std_logic;
		phi_incr_i		: in    std_logic_vector(N_CUM-1 downto 0);
		strobe_in		: in    std_logic;
		clk, reset_n	: in	std_logic;
		wave_i			: in 	std_logic_vector(1 downto 0);
		dacdat_g_o		: out 	std_logic_vector(N_AUDIO - 1 downto 0)

	);
end entity;

architecture rtl of DDS is
	
	signal phi_cum, next_phi_cum	: unsigned(N_CUM-1 downto 0);
	signal addr						: integer range 0 to L-1;
	
begin
	
	phase_cumulator: process(phi_incr_i,phi_cum,strobe_in)
	begin
		if(strobe_in = '1') then
			next_phi_cum <= phi_cum + unsigned(phi_incr_i);
		else 
			next_phi_cum <= phi_cum;
		end if;
	end process;
	
	ff_process: process(clk,reset_n)
	begin
		if (reset_n = '0') then
			phi_cum <= (others =>'0');
		elsif rising_edge(clk) then
			phi_cum <= next_phi_cum;
		end if;
	end process;

	synth_tone: process (phi_cum, tone_on_i, addr)
	begin 


		addr <= to_integer(phi_cum(N_CUM - 1 downto N_CUM - N_ADDR_LUT_DDS));
		if (tone_on_i = '1') then
			case wave_i is
				when "00" =>
				dacdat_g_o <= std_logic_vector(to_signed(LUT(addr),N_AUDIO));
				when "01" =>
				dacdat_g_o <= std_logic_vector(to_signed(SAWTOOTH(addr),N_AUDIO));
				when "10" =>
				dacdat_g_o <= std_logic_vector(to_signed(TRIANGULAR(addr),N_AUDIO));
			end case;
		else 
			dacdat_g_o <= (others=>'0');
		end if;
	end process;

end architecture;

