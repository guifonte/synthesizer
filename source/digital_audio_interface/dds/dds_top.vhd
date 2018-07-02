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
		strobe_i		: in 	std_logic;
		rst_n			: in    std_logic;
		dacdat_g_out	: out 	std_logic_vector(N_AUDIO - 1 downto 0);
		led_green_out   : out 	std_logic_vector(7 downto 0);
		led_red_out		: out	std_logic_vector(9 downto 0)
	);
end dds_top;

ARCHITECTURE struct OF dds_top IS

	SIGNAL top_tone_on  		: std_logic;
	SIGNAL top_midi_data		: std_logic_vector(7 downto 0);
	SIGNAL top_midi_signal 		: std_logic;
	SIGNAL top_t_note_record	: t_note_record;
	SIGNAL dacdata_array		: NAUDIO_array_type;
	SIGNAL top_midi_note_o		: t_midi_array;
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

	-- Uart obtida com o Gustavo e com o Thiago
	component uart 
		PORT
		(
		CLOCK_12M5  :  IN  STD_LOGIC;
		DATA_IN     :  IN  STD_LOGIC;
		RESET_N     :  IN  STD_LOGIC;
		NEW_DATA    :  OUT STD_LOGIC;
		DATA_OUT    :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
  	END component;
	

	-- Nossa uart que infelizmente não funcionou
	--COMPONENT uart_rx_only_top IS
	--	PORT(
	--		CLOCK_12 :  	IN   STD_LOGIC;
	--		RESET_N :		IN 	 STD_LOGIC;
	--		GPIO_1 :  		IN   STD_LOGIC;
	--		LED_O 	:		OUT  STD_LOGIC;
	--		DATA_VALID_O :	OUT  STD_LOGIC;
	--		DATA_O :		OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	--	);
	--END COMPONENT;

	COMPONENT midi_controller is
		port(
			rx_data_valid_in			: in        std_logic;
			rx_data_in					: in        std_logic_vector(7 downto 0);
			clk							: in        std_logic;
			reset_n						: in        std_logic;
	        midi_note_o       			: out       t_midi_array;
	        led_r_out                   : out       std_logic_vector(9 downto 0);
	        led_g_out                   : out       std_logic_vector(6 downto 0)
		);
	end COMPONENT;
	
	COMPONENT dacdat_sum is
		port(
			dacdat_in       		    : in        NAUDIO_array_type;
			dacdat_sum_out              : out       std_logic_vector(N_AUDIO - 1 downto 0);
			strobe_in                   : in        std_logic;
			clk							: in        std_logic;
			reset_n                     : in        std_logic
		);
	end COMPONENT;

	BEGIN

        --inst_uart_rx_only_top: uart_rx_only_top
        --port map(
        --	CLOCK_12 		=> clock,
		--	RESET_N			=> rst_n,
		--	GPIO_1   		=> midi_serial_i,
		--	LED_O			=> led_green_out(0),
		--	DATA_VALID_O 	=> top_midi_signal,
		--	DATA_O 			=> top_midi_data
        --);

		uart_receiver : uart
		port map(
			CLOCK_12M5  => clock,
			DATA_IN     => midi_serial_i,
			RESET_N     => rst_n,
			NEW_DATA    => top_midi_signal,
			DATA_OUT    => top_midi_data

			);

        inst_midi_controller: midi_controller
        port map(
        	rx_data_valid_in	=> top_midi_signal,
			rx_data_in			=> top_midi_data,
			clk					=> clock,
			reset_n				=> rst_n,
			midi_note_o			=> top_midi_note_o,
			led_r_out			=> led_red_out,
			led_g_out			=> led_green_out(7 downto 1)
    	);
		
		dds_inst_gen : FOR i IN 0 to 9 GENERATE
			inst_dds:	DDS
			PORT MAP(
				clk         =>  clock,
				reset_n     =>  rst_n,
				phi_incr_i	=>  LUT_midi2dds(to_integer(unsigned(top_midi_note_o(i).number))),       -- phi increase referente á nota em midi obtida
				tone_on_i	=>  top_midi_note_o(i).valid,	        
				strobe_in	=>  strobe_i,		                
				--attenu_i	=>  note_attenu(i),	 				-- não utilizado no nosso projeto
				wave_i		=> 	wave_ctrl,               
				dacdat_g_o =>  dacdata_array(i)
			);
		END GENERATE dds_inst_gen;

		inst_dacdat_sum: dacdat_sum
		port map(
			dacdat_in       		    => dacdata_array,
			dacdat_sum_out              => dacdat_g_out,
			strobe_in                   => strobe_i,
			clk							=> clock,
			reset_n                     => rst_n
		);

END struct;	