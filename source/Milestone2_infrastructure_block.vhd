-------------------------------------------
-- Block code:  Milestone1_infrastructure_block.vhd
-- History: 	12.Apr.2018 - 1st version (guifonte)
--                 <date> - <changes>  (<author>)
-- Function: Top for an infrastructure block that has a clock divisor
--				buttons synchronizers, a Codec Controller and a I2C master.
--           
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY Milestone2_infrastructure_block IS
	PORT(
		CLOCK_50				: IN  std_logic;		-- DE2 clock from xtal 50MHz
		KEY						: IN  std_logic_vector( 3 downto 0);  -- DE2 low_active input buttons
		SW						: IN	std_logic_vector(9 downto 0);	-- DE2 input switches
		AUD_XCK					: OUT	std_logic;		-- master clock for Audio Codec
		I2C_SCLK				: OUT	std_logic;		-- clock from I2C master block
		I2C_SDAT				: INOUT std_logic;		-- data  from I2C master block
		AUD_DACDAT				: OUT	std_logic;	
		AUD_BCLK				: OUT	std_logic;	
		AUD_DACLRCK				: OUT	std_logic;	
		AUD_ADCLRCK				: OUT	std_logic;	
		AUD_ADCDAT				: IN  	std_logic
	);
END Milestone2_infrastructure_block ;

-- Architecture Declaration 
ARCHITECTURE struct OF Milestone2_infrastructure_block IS
	
	SIGNAL top_clk_12M			:	STD_LOGIC;
	SIGNAL top_button_1			:	STD_LOGIC;
	SIGNAL top_initialize_n		:	STD_LOGIC;
	SIGNAL write_done			:	STD_LOGIC;
	SIGNAL ack_error			: 	STD_LOGIC;
	SIGNAL write_buf			: 	STD_LOGIC;
	SIGNAL write_data			: 	std_logic_vector(15 downto 0);
	SIGNAL top_WS				: 	STD_LOGIC;
	
	COMPONENT infrastructure_block
	PORT(
		clk_50M  		:  IN			STD_LOGIC;
		button_1		:  IN			STD_LOGIC;
		button_2		:  IN			STD_LOGIC;
		clk_12M			:	OUT		STD_LOGIC;
		button_1sync	:	OUT		STD_LOGIC;
		button_2sync	:	OUT		STD_LOGIC
	);
	END COMPONENT;
	

	COMPONENT codec_control 
    PORT(
        clk         		: in    	std_logic;
        reset_n     		: in    	std_logic;

        write_done_i		: in    	std_logic;
		event_control_i		: in		std_logic_vector(2 downto 0);
			
		initialize_n 		: in		std_logic;
		ack_error_i			: in		std_logic;
		write_o 			: out 		std_logic;
		write_data_o		: out 		std_logic_vector(15 downto 0)
        );
	END COMPONENT;
	

	COMPONENT i2c_master
    PORT(
    	clk         		: in    	std_logic;
    	reset_n     		: in   		std_logic;
		
      	write_i     		: in    	std_logic;
		write_data_i		: in		std_logic_vector(15 downto 0);
				
		sda_io				: inout		std_logic;
		scl_o				: out   	std_logic;
				
		write_done_o		: out		std_logic;
		ack_error_o			: out		std_logic
    );
	END COMPONENT;
	
	COMPONENT digital_audio_interface_driver_top
	PORT(
		CLK_12M					: IN  std_logic;	
		RESET_N					: IN  std_logic;
		ADCDAT_s_in				: IN  std_logic;
		DACDAT_s_out			: OUT	std_logic;
		BCLK_out					: OUT	std_logic;
		WS_out					: OUT std_logic
	);
	END COMPONENT ;
	
	BEGIN
	
		AUD_XCK 			<= top_clk_12M;
		AUD_DACLRCK			<= top_WS;
		AUD_ADCLRCK			<= top_WS;
		
		inst_infrastructure_block: infrastructure_block
		PORT MAP(
			clk_50M  		=> CLOCK_50,
			button_1		=> KEY(0),
			button_2		=> KEY(1),
			clk_12M			=> top_clk_12M,
			button_1sync	=> top_button_1,--reset
			button_2sync	=>	top_initialize_n --initialize
		);
		
		inst_codec_control: codec_control
		PORT MAP (
		clk    				=> top_clk_12M,
	    reset_n     		=> top_button_1,

	    write_done_i		=> write_done,
		event_control_i	=> SW(2 downto 0),
	
		initialize_n		=> top_initialize_n,
		ack_error_i			=> ack_error,

		write_o 			=> write_buf,
		write_data_o		=> write_data

		);

		inst_i2c_master: i2c_master
		PORT MAP (
		clk    				=> top_clk_12M,
	    reset_n     		=> top_button_1,

	    write_i     		=> write_buf,
		write_data_i		=> write_data,
			
		sda_io				=> I2C_SDAT,
		scl_o				=> I2C_SCLK,
			
		write_done_o		=> write_done,
		ack_error_o			=> ack_error

		);
		
		inst_digital_audio_interface_driver_top: digital_audio_interface_driver_top
		PORT MAP(
		CLK_12M					=> top_clk_12M,		
		RESET_N					=> top_button_1,	
		ADCDAT_s_in				=> AUD_ADCDAT,	
		DACDAT_s_out			=> AUD_DACDAT,	
		BCLK_out					=> AUD_BCLK,	
		WS_out					=> top_WS	
		);

END struct;	
