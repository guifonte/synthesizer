-------------------------------------------
-- Block code:  dds_top.vhd
-- History: 	20.Apr.2018 - 1st version (Felipe Tanios)
--                 
-- Function: Top for direct digital synthesis block
------------------------------------------- 

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
LIBRARY work;
USE work.tone_gen_pkg.all;

entity dds_top is
	port(
		midi_serial_i	: in    std_logic;
		wave_ctrl		: in 	std_logic_vector(1 downto 0);
		clock			: in    std_logic;
		strobe_i		: in 	  std_logic;
		rst_n			: in    std_logic;
		dacdat_g_out	: out 	std_logic_vector(N_AUDIO - 1 downto 0);
		led_out			: out 	std_logic
	);
end dds_top;

ARCHITECTURE struct OF dds_top IS

	TYPE   NAUDIO_array_type  IS ARRAY (0 TO 9) OF std_logic_vector(N_AUDIO - 1 downto 0);
	SIGNAL top_phi_incr 		: std_logic_vector(N_CUM-1 downto 0);
	SIGNAL top_tone_on  		: std_logic;
	SIGNAL top_midi_data		: std_logic_vector(7 downto 0);
	SIGNAL top_midi_signal 		: std_logic;
	SIGNAL top_t_note_record	: t_note_record;
	SIGNAL dacdata_array		: NAUDIO_array_type;
	SIGNAL top_midi_cmds		: t_midi_array;
	SIGNAL top_dacdat_g_out		: std_logic_vector(N_AUDIO - 1 downto 0);

	COMPONENT DDS is
		port(
			tone_on_i		: in    std_logic;
			phi_incr_i		: in    std_logic_vector(N_CUM-1 downto 0);
			strobe_in		: in    std_logic;
			clk, reset_n	: in	std_logic;
			wave_i			: in 	std_logic_vector(1 downto 0);
			dacdat_g_o		: out 	std_logic_vector(N_AUDIO - 1 downto 0)
		);
	end COMPONENT;

	COMPONENT uart_rx_only_top IS
		PORT(
			CLOCK_50 :  	IN   STD_LOGIC;
			RESET_N :		IN 	 STD_LOGIC;
			GPIO_1 :  		IN   STD_LOGIC;
			LED_O 	:		OUT  STD_LOGIC;
			DATA_VALID_O :	OUT  STD_LOGIC;
			DATA_O :		OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT midi_controler is
		port(
			rx_data_valid_in		: in    std_logic;
			rx_data_in				: in    std_logic_vector(7 downto 0);
			clk						: in	  std_logic;
			reset_n					: in	  std_logic;
			t_note_record_out		: out	  t_note_record
		);
	end COMPONENT;
	
	BEGIN

        inst_uart_rx_only_top: uart_rx_only_top
        port map(
        	CLOCK_50 		=> clock,
			RESET_N			=> rst_n,
			GPIO_1   		=> midi_serial_i,
			LED_O			=> led_out,
			DATA_VALID_O 	=> top_midi_signal,
			DATA_O 			=> top_midi_data
        );

        inst_midi_controler: midi_controler
        port map(
        	rx_data_valid_in	=>top_midi_signal,
			rx_data_in			=>top_midi_data,
			clk					=>clock,
			reset_n				=>rst_n,
			t_note_record_out	=> top_t_note_record
    	);
		
		inst_dds:	DDS
		PORT MAP(
			clk         =>  clock,
			reset_n     =>  rst_n,
			phi_incr_i	=>  LUT_midi2dds(to_integer(unsigned(top_t_note_record.number))),       -- Pick corresponding phi_incr in LUT
			tone_on_i	=>  top_t_note_record.valid,	                -- Note on/off
			strobe_in	=>  strobe_i,		                -- pulse with 1clk-cycle width
			wave_i		=> 	wave_ctrl,               
			dacdat_g_o 	=>  top_dacdat_g_out            -- collect output of each DDS to sum afterwards
		);

		--inst_dds: DDS
		--port map(
		--	tone_on_i		=> top_t_note_record.valid,
		--	phi_incr_i		=> LUT_midi2dds(to_integer(unsigned(top_t_note_record.number))),
		--	strobe_in		=> strobe_i,
		--	clk				=> clock,
		--	reset_n			=> rst_n,
		--	wave_i			=> wave_ctrl,
		--	dacdat_g_o		=> dacdat_g_out
		--);
		
		
END struct;	